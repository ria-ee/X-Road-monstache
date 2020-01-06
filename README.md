# Visualization of X-Road Operational monitoring data with Kibana

This tutorial can be used to configure replication of operational monitoring data from MongoDB to
Elasticsearch so that the data would be accessible with Kibana.

It is assumed in that tutorial that MongoDB is installed on one server, and Elasticsearch, Kibana
and Monstache (https://rwynn.github.io/monstache-site/) are installed on the second server. Both
servers are assumed to be Ubuntu 16.04 LTS.

## MongoDB installation and configuration

All the following steps are performed in MongoDB server.

The detailed configuration of MongoDB is not within scope of this tutorial.

For testing purposes MongoDB can be installed with the following commands:

```bash
sudo apt-get install -y apt-transport-https
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

Next it is required to allow MongoDB to listen for network connections and to enable replication.
Edit MongoDB configuration file `sudo vi /etc/mongod.conf`:
```
net:
  port: 27017
  bindIp: 127.0.0.1,<replace with IP of MongoDB server>
replication:
  replSetName: rs0
  oplogSizeMB: 10000
```

The size of `oplogSizeMB` must be sufficient to contain at least week long changes to all MongoDB
databases (including these that are not being replicated to Elasticsearch). If oplog starts
wrapping too fast there will not be enough time to fix replication issues, and it would be required
to repeat initial data synchronization or to perform partial synchronization using MongoDB views.

Later on, if you need to check, reduce or increase the size of `oplogSizeMb`, follow the steps
provided in manual https://docs.mongodb.com/manual/tutorial/change-oplog-size/:

```
$ mongo --username root --password --authenticationDatabase admin
# check the current situation
rs0:PRIMARY> rs.printReplicationInfo()
configured oplog size:   10000MB
log length start to end: 25960secs (7.21hrs)
oplog first event time:  Tue May 07 2019 12:16:29 GMT+0300 (EEST)
oplog last event time:   Tue May 07 2019 19:29:09 GMT+0300 (EEST)
now:                     Tue May 07 2019 19:29:16 GMT+0300 (EEST)

rs0:PRIMARY> use local
switched to db local

# Check the current size again
rs0:PRIMARY> db.oplog.rs.stats().maxSize
NumberLong("10485760000")
# Increase the size to 50G
rs0:PRIMARY> db.adminCommand({replSetResizeOplog: 1, size: 50000})
{ "ok" : 1 }

# Check the current size again
rs0:PRIMARY> db.oplog.rs.stats().maxSize
NumberLong("52428800000")

# Check the size in use at the moment
rs0:PRIMARY> db.oplog.rs.stats().size
10402499577

# check the current situation
rs0:PRIMARY> rs.printReplicationInfo()
configured oplog size:   50000MB
```

Start MongoDB service:
```bash
sudo service mongod start
```

Next initialize replication in MongoDB:
```bash
mongo --eval 'rs.initiate()'
mongo --eval 'rs.printReplicationInfo()'
```

Or in case mongodb is already configured to use authentication:
```bash
mongo admin --username root --password --eval 'rs.initiate()'
mongo admin --username root --password --eval 'rs.printReplicationInfo()'
```

Additionally if MongoDB is using authentication it is necessary to create a user that must be able
to read "local" database to read MongoDB replication data, read databases of all instances that
are being synchronized for initial data replication, and to be able to both read and write to a
special database named "monstache" to store a pointer to replication data already synchronized.
For example (please replace `user`, `pwd` and `query_db_sample` with actual values):
```bash
mongo admin --username root --password \
    --eval 'db.createUser({user: "<replicaUser>", pwd: "<replicaPassword>", \
    roles: [{role: "read", db: "local"}, {role: "readWrite", db: "monstache"}, \
    {role: "read", db: "query_db_sample1"}, {role: "read", db: "query_db_sample2"}]});'
```

## Elasticsearch and Kibana installation and configuration

All the following steps are performed in Elasticsearch server.

The detailed configuration of Elasticsearch and Kibana is not within scope of this tutorial.

For testing purposes Elasticsearch and Kibana can be installed with the following commands:

```bash
sudo apt install -y apt-transport-https openjdk-8-jre
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | \
    sudo tee /etc/apt/sources.list.d/elastic-6.x.list
sudo apt update
sudo apt install -y kibana elasticsearch
```

Next it is required to allow Kibana to listen for network connections.
Edit Kibana configuration file `sudo vi /etc/kibana/kibana.yml`:
```
server.host: "0.0.0.0"
```

Start Elasticsearch and Kibana services:
```bash
sudo systemctl enable elasticsearch.service
sudo systemctl enable kibana.service
sudo service elasticsearch start
sudo service kibana start
```

## Monstache and plugin compilation

The compilation step may be performed on other machine (possibly with some limitations). But in
this tutorial it is assumed that Elasticsearch server is used.

Install newer version of Golang, because the default Golang version in Ubuntu 16.04 (v1.6) does not
meet the minimum requirements of Monstache (v1.8+):
```bash
sudo apt install golang-1.10
```

Edit `~/.profile` and add go executable to the PATH:
```
PATH="/usr/lib/go-1.10/bin:$PATH"
```

Download and compile latest version of monstache:
```bash
go get -u github.com/rwynn/monstache
```

The compiled binary can be found at `~/go/bin/monstache`.

Next go inside repository directory (`git clone ...` command is out of scope of this tutorial),
download library needed for plugin and compile that:
```bash
go build -buildmode=plugin -o opmon_plugin.so opmon_plugin.go
```

Note that prefix of Elasticsearch indexes to be used can be changed by altering the following line
in `opmon_plugin.go`:
```
const indexPrefix = "opmon-"
```

## Monstache installation and configuration

All the following steps are performed in Elasticsearch server.

Latest release of Monstache can be found here: https://github.com/rwynn/monstache

Monstache is a single binary application that can be installed in any desired directory. In this
tutorial it is assumed that Monstache will run as user `sample` with a home directory
`/opt/sample/` and all executable and configuration files are installed into
`/opt/sample/monstache`.

Checkout this repository and while inside repository directory create a template in Elasticsearch
for Operational monitoring data:
```bash
bash opmon_template.sh
```

Create a directory for executable and configuration files, copy required files and go inside that
new directory:
```bash
mkdir -p /opt/sample/monstache
cp config_sample.toml /opt/sample/monstache/config.toml
cp first_run_config_sample.toml /opt/sample/monstache/first_run_config.toml
```

If you have compiled Monstache and plugin on a separate server then copy them to
`/opt/sample/monstache` in Elasticsearch server.

If compilation was made in Elasticsearch server then execute in repository directory:
```bash
cp opmon_plugin.so /opt/sample/monstache/
cp /opt/sample/go/bin/monstache /opt/sample/monstache/
```

Update credentials for MongoDB replication user and replicated database names in both "config.toml"
for replication and "first_run_config.toml" for initial synchronization. Note that you can
simultaneously specify multiple databases containing data from different X-Road instances in
`namespace-regex` and `direct-read-namespaces`. Configuration item `namespace-regex` must be
configured for both configurations, and `direct-read-namespaces` must not be present in
"config.toml".

Create a service for Monstache:
```bash
 sudo bash -c "cat > /lib/systemd/system/monstache.service" <<EOF
[Unit]
Description=Monstache service for MongoDB->Elasticsearch replication
After=multi-user.target elasticsearch.service

[Service]
User=sample
Restart=always
RestartSec=10
WorkingDirectory=/opt/sample/monstache
ExecStart=/opt/sample/monstache/monstache -f /opt/sample/monstache/config.toml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
```

During initial synchronization Monstache is also transferring all newer changes to MongoDB
collections (tailing oplog). Therefore it is possible to avoid data loss if no new data is added
to synchronized collection between "first run" process is stopped and Monstace service is started.
One way to achieve that is to stop "Corrector" processes before "first run" job is terminated and
start "Corrector" processes once Monstache service is already running and listening for changes in
MongoDB oplog.

But the best way is to start Monstache service before "first run" process is started. In that case
some errors cencerning "version conflict" may appear in Mostache log, but these errors can be
ignored as they do not cause any data loss.

Start Monstache service:
```bash
sudo systemctl enable monstache.service
sudo service monstache start
```

Perform initial synchronization from MongoDB to Elasticsearch:
```bash
/opt/sample/monstache/monstache -f /opt/sample/monstache/first_run_config.toml
```  

Initial synchronization process will exit once all data is transferred.

Output of `monstache` service is saved to syslog.

It is advised to check if Monstache is able to save its state in MongoDB "monstache.monstache"
collection, but Monstache will not write anything until Corrector produces new changes in
clean_data collection. One way would be to collect some new data and let Corrector update
clean_data collection.

Also it is advised to check if the synchronized data is visible to Kibana. For that open Kibana
url (by default [http://\<kibana-server>:5601](http://\<kibana-server>:5601)). Go to Management ->
Elasticsearch -> Index Management and check that index query_db_sample.clean_data exists
and not empty. After that configure Kibana Index Patterns for these indexes using "correctorTime"
for Time Filter (out of scope of this tutorial).

Next create Index Pattern for partitioned index (for example "opmon-sample-*") using
"requestInTs" for "Time Filter" (out of scope of this tutorial).

## Partial synchronization 

Starting from monstache v4.11.0 it is possible to partially synchronize data from MongoDB using
views.

First of all it is necessary to correctly create a view that will be used for synchronization.

If there was a temporary downtime in Elasticsearch or Monstache services, then it is possible to
create a view in `mongo` console using "correctorTime" field:
```
use query_db_sample1
db.createView(
  "clean_data_part",
  "clean_data",
  [ { $match: { $and: [ { "correctorTime": {$gte: 1507875194} }, { "correctorTime": {$lt: 1507875196} } ] } } ]
)
``` 

Here `1507875194` and `1507875196` are UNIX timestamps that must be replaced with times before and
after downtime respectively.

It is also possible to synchronize data from a certain time period using "requestInTs" time.
Because of the fact that "requestInTs" is calculated based on two values "client.requestInTs" and
"producer.requestInTs", the view definition is slightly more complicated:
```
use query_db_sample1
db.createView(
  "clean_data_part",
  "clean_data",
  [ { $match: {
    $or: [
      { $and: [ { "client.requestInTs": {$exists: true} }, { "client.requestInTs": {$gte: 1506000000000} }, { "client.requestInTs": {$lt: 1506200000000} } ] },
      { $and: [ { "client.requestInTs": {$exists: false} }, { "producer.requestInTs": {$gte: 1506000000000} }, { "producer.requestInTs": {$lt: 1506200000000} } ] }
    ]
  } } ]
)
```

Here `1506000000000` and `1506200000000` are UNIX timestamps with millisecond precision, and should
be replaced with proper values for required time interval.

Once view is created it is required to create a copy of monstache "first run" configuration for
synchronization of view data. In this configuration "direct-read-namespaces" parameter value should
be updated and collection name replaced with view name. Parameter "namespace-regex" does not need
to be updated.

For example configuration file `first_run_config_exaple1.toml` containing:
```
namespace-regex = '^query_db_example1\.clean_data$'
direct-read-namespaces = ["query_db_example1.clean_data"]
```

Should be copied to `first_run_config_exaple1_part.toml` and updated to contain:
```
namespace-regex = '^query_db_example1\.clean_data$'
direct-read-namespaces = ["query_db_example1.clean_data_part"]
```

After that partial synchronization can be executed with:
```bash
/opt/sample/monstache/monstache -f /opt/sample/monstache/first_run_config_example1_part.toml
```  

Once synchronization is completed MongoDB view can be deleted with the `mongo` console command:
```
use query_db_sample1
db.clean_data_part.drop()
```

## Debugging

The following one-liner converts MongoDB BSON timestamp to a readable form:
```bash
python3 -c "import datetime, sys; t=int(sys.argv[1]); \
    print('{}, {}, {}'.format(t>>32, t & 0xffffffff, \
    datetime.datetime.fromtimestamp(t>>32).strftime('%Y-%m-%d %H:%M:%S')))" \
    6579850946413592584
1531990931, 8, 2018-07-19 12:02:11
```

And this oplog item can be found in MongoDB with the following command:
```
db.oplog.rs.find({"ts": Timestamp(1531990931, 8)}).pretty()
```

Additionally if you encounter a synchronization error concerning document with
"_id":"5b505393612d5259caeb253b" then you can find changes to that document in mongo oplog with the
command:
```
db.oplog.rs.find({"o._id": ObjectId("5b505393612d5259caeb253b")}).pretty()
```

## Possible faults and solutions

**Monstache log shows Failed > 0 and error details contain "version conflict" error.**

```
Conflict request line #0 details: {"_index":"query_db_sample.clean_data","_type":"_doc",
"_id":"5b505393612d5259caeb253b","status":409,"error":{"type":"version_conflict_engine_exception",
"reason":"[_doc][5b505393612d5259caeb253b]: version conflict, current version [6579850946413592584] 
is higher or equal to the one provided [6579850946413592578]","index":"query_db_sample.clean_data"}}
```

Monstache is using multiple simultaneous connections to Elasticsearch. This error possibly means
that a later update to the document was applied before former. Monstache configuration item
"elasticsearch-max-conns" can be changed to "1" to avoid parallel additions. Also most likely this
problem can be ignored.
