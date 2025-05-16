#!/usr/bin/bash

dump=datacite2024-subjects.gz
year=2024

mkdir -p $year

# geoLocations
zcat $dump | jq -c '.geoLocations|select(. and length>0)' | gzip > $year/geolocations.ndjson.gz
zcat $year/geolocations.ndjson.gz | jq -c 'map(del(.geoLocationPlace)|select(length>0))|select(length>0)' > $year/geolocation-data.ndjson

# dates
zcat ../datacite2024-subjects.gz | jq -c '.dates//[]|map(select(.dateType=="Coverage"))|select(length>0)' > date-coverage.ndjson

# subjects
zcat $dump | jq -c '.subjects|select(. and length>0)' | gzip > $year/subjects.ndjson.gz
zcat subjects.ndjson.gz | jq -c 'map(select(.valueUri,.classificationCode))|select(length>0)' > subject-ids.ndjson
zcat subjects.ndjson.gz | jq -c 'map(select(.schemeUri))|select(length>0)' > subject-scheme-uri.ndjson
zcat subjects.ndjson.gz | jq -c 'map(select(.subjectScheme))|select(length>0)' > subject-scheme.ndjson

jq -r '.[]|.schemeUri' subject-scheme-uri.ndjson | sort | uniq -c | sort -nrk1 > unique-subject-scheme-uris.txt
jq -r '.[]|.subjectScheme' subject-scheme.ndjson | sort | uniq -c | sort -nrk1 > unique-subject-schemes.txt

