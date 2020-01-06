# Monstache paranduste testimine

Antud juhendi eesmärk on monstache viimase versiooni testimine, ning kontrollimine kas kõik
teadaolevad probleemid on leidnud lahendust.

Töö sisu on MongoDB query_db_ee-test.clean_data andmete laadimine Elasticsearch
opmon-bugtest-ee-test-* partitsioneeritud indeksi alla. See indeks on ajutise iseloomuga, ning
on vajalik vaid selleks, et kontrollida, et andmed on edukalt ja täismahus ülekantud.

## Kompileerimine

Kui golang pole veel paigaldatud siis paigaldada `golang-1.10`:
```
sudo apt install golang-1.10
```

Ja kirjeldada go PATH `~/.profile` failis, ning logida välja ning taaskord sisse:
```
PATH="/usr/lib/go-1.10/bin:$PATH"
```

Kloneerida antud repositoorium, ning käivitada repositooriumi kaustas käsud:
```
go get -u github.com/rwynn/monstache
go build -buildmode=plugin -o opmon_bugtest_plugin.so opmon_bugtest_plugin.go
```

## Ettevalmistus

Luua uus kaust monstache failide jaoks:
```
mkdir /opt/riajenk/bugtest
```

Kopeerida sinna vajalikud failid (olles repositooriumi kaustas):
```
cp ~/go/bin/monstache /opt/riajenk/bugtest/
cp opmon_bugtest_plugin.so /opt/riajenk/bugtest/
cp RIA_conf/config_ee-test_bugtest.toml /opt/riajenk/bugtest/
cp RIA_conf/first_run_config_ee-test_bugtest.toml /opt/riajenk/bugtest/
```

Muuta `config_ee-test_bugtest.toml` ja `first_run_config_ee-test_bugtest.toml` konfiguratsiooni
failid:
 * Panna õige MongoDB kasutajanimi ja parool "mongo-url" konfiguratisiooni parameetri sisse;
 * Kontrollida, et "mapper-plugin-path" viitaks õigele `opmon_bugtest_plugin.so` plugini asukohale.

## Testi käivitamine

Esimene samm on monstache teenuse käivitamine mis kannab üle jooksvad muutused oplog'ist.
Avada `screen` selleks, et protsess töötaks taustal ka siis, kui kaob interneti ühendus serveriga.
Käivitada `/opt/riajenk/bugtest/` kaustas:
```
./monstache -f config_ee-test_bugtest.toml 2>&1 | tee -a bugtest_service.log
```

Antud teenus peab töötama kuni test on lõpuni viidud, ning ülekantud andmed on kontrollitud.
Teenuse seisu saab jälgida http://opmonela.tt.kit:8082/stats lehel.

Teiseks sammuks tuleks käivitada MongoDB andmete ülekandmise protsessi. Avada veel üks `screen`
ja käivitada `/opt/riajenk/bugtest/` kaustas:
```
./monstache -f first_run_config_ee-test_bugtest.toml 2>&1 | tee -a bugtest_first_run.log
```

Antud protsess lõpetab oma töö automaatselt kui kannab üle kõik andmed. Kui protsess veel töötab,
siis selle seisu saab jälgida http://opmonela.tt.kit:8083/stats lehel.

**NB!** Kuna nii monstache teenus kui ka andmete ülekandmise protsessid mõlemad üritavad
indekseerida jooksvad muutused, siis logides ilmuvad vead "version conflict" kohta, ning see on
täiesti normaalne, ning ei häiri testi. Jälgida tuleks, et `bugtest_first_run.log` logis ei oleks
"i/o timeout" vigu.
