package main
import (
    "github.com/globalsign/mgo/bson"
    "github.com/olivere/elastic"
    "github.com/rwynn/monstache/monstachemap"
    "fmt"
    "regexp"
    "strings"
    "time"
)

const debug = false
const indexPrefix = "opmon-bugtest-"

// A mapper to add opmon values needed for Kibana
func Map(input *monstachemap.MapperPluginInput) (output *monstachemap.MapperPluginOutput, err error) {
    var instance string
    re := regexp.MustCompile("^query_db_(.+)$")
    match := re.FindStringSubmatch(input.Database)
    if len(match) == 2 {
        instance = strings.ToLower(match[1])
    } else {
        if debug {
            fmt.Println("plugin#Map: not processing documents from database with unknown pattern", input.Database)
        }
        output = &monstachemap.MapperPluginOutput{Drop: true}
        return
    }

    doc := input.Document
    //fmt.Println("%#v", doc)
    data, ok := doc["client"].(map[string]interface {})
    if !ok {
        data = doc["producer"].(map[string]interface {})
    }

    // Cast to string (empty if nil)
    clientXRoadInstance, _ := data["clientXRoadInstance"].(string)
    clientMemberClass, _ := data["clientMemberClass"].(string)
    clientMemberCode, _ := data["clientMemberCode"].(string)
    clientSubsystemCode, _ := data["clientSubsystemCode"].(string)
    serviceXRoadInstance, _ := data["serviceXRoadInstance"].(string)
    serviceMemberClass, _ := data["serviceMemberClass"].(string)
    serviceMemberCode, _ := data["serviceMemberCode"].(string)
    serviceSubsystemCode, _ := data["serviceSubsystemCode"].(string)
    serviceCode, _ := data["serviceCode"].(string)
    serviceVersion, _ := data["serviceVersion"].(string)

    doc["requestInTs"] = data["requestInTs"]
    doc["consumerMember"] = clientXRoadInstance + "/" + clientMemberClass + "/" + clientMemberCode
    doc["consumerSystem"] = clientXRoadInstance + "/" + clientMemberClass + "/" + clientMemberCode + "/" + clientSubsystemCode
    doc["producerMember"] = serviceXRoadInstance + "/" + serviceMemberClass + "/" + serviceMemberCode
    doc["producerSystem"] = serviceXRoadInstance + "/" + serviceMemberClass + "/" + serviceMemberCode + "/" + serviceSubsystemCode
    doc["service"] = serviceXRoadInstance + "/" + serviceMemberClass + "/" + serviceMemberCode + "/" + serviceSubsystemCode + "/" + serviceCode + "/" + serviceVersion
    doc["serviceCode"] = serviceCode
    doc["succeeded"] = data["succeeded"]
    doc["messageUserId"] = data["messageUserId"]
    doc["clientSecurityServerAddress"] = data["clientSecurityServerAddress"]
    doc["serviceSecurityServerAddress"] = data["serviceSecurityServerAddress"]
    doc["valid"] = true
    if data["serviceXRoadInstance"] == nil {
        doc["valid"] = false
    }

    t := time.Unix(0, data["requestInTs"].(int64) * 1000000).UTC()
    timeSuffix := t.Format("2006-01")

    output = &monstachemap.MapperPluginOutput{Document: doc, Index: indexPrefix + instance + "-" + timeSuffix}
    return
}

// Searching for document migrations between indexes and deleting old version
func Process(input *monstachemap.ProcessPluginInput) (err error) {
    // Processing only update operations
    if input.Operation == "u" {
        doc := input.Document
        client, okC := doc["client"].(map[string]interface {});
        producer, okP := doc["producer"].(map[string]interface {})
        if !okC || !okP {
            return
        }

        tC := time.Unix(0, client["requestInTs"].(int64) * 1000000).UTC()
        timeSuffixClient := tC.Format("2006-01")
        tP := time.Unix(0, producer["requestInTs"].(int64) * 1000000).UTC()
        timeSuffixProducer := tP.Format("2006-01")

        if timeSuffixClient == timeSuffixProducer {
            // No migration of document needed
            return
        }

        var instance string
        re := regexp.MustCompile("^query_db_(.+)$")
        match := re.FindStringSubmatch(input.Database)
        if len(match) == 2 {
            instance = strings.ToLower(match[1])
        } else {
            if debug {
                fmt.Println("plugin#Process: not processing documents from database with unknown pattern", input.Database)
            }
            return
        }

        id := doc["_id"].(bson.ObjectId).Hex()
        if debug {
            fmt.Println("plugin#Process: Deleting _id=" + id + " from index=" + indexPrefix + instance + "-" + timeSuffixProducer)
        }

        bulk := input.ElasticBulkProcessor
        req := elastic.NewBulkDeleteRequest()
        req.Id(id)
        req.Index(indexPrefix + instance + "-" + timeSuffixProducer)
        req.Type("_doc")
        bulk.Add(req)
    }

    return
}
