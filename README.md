# DataCite subject analysis

First download a public DataCite Dump. It's a `.tar` file containing compressed JSON files. Then reduce it to fields relevant for subject analysis:

~~~sh
tar -O -xf datacite2024.tar --wildcards 'dois/*/*.jsonl.gz' | zcat \
| jq -c '.attributes|{doi,subjects,geoLocations,dates}' | gzip > datacite2024-subjects.gz
~~~

This will likely take several hours (it's possible to speed up with parallel processing but not worth the effort as you will only need to run this once). The relevant fields are:

- [subjects](https://datacite-metadata-schema.readthedocs.io/en/4.6/properties/subject/)
- [geoLocations](https://datacite-metadata-schema.readthedocs.io/en/4.6/properties/geolocation/)
- [date](https://datacite-metadata-schema.readthedocs.io/en/4.6/properties/date/) with dateType [Coverage](https://datacite-metadata-schema.readthedocs.io/en/4.6/appendices/appendix-1/dateType/#coverage) (introduced in end of 2024 so not used before)

## Analysis

See `stats.sh` for commands to calculate several basic statistics. Results for 2024:

Records | Percent | property
-------:|--------:|----
72019577 | 100% | total
40306334 | 56% | any subjects
11630476 | 16% | subjects with any identifiers
20130117 | 28% | subjects with schemeUri
22443940 | 31% | any geolocation
19413099 | 27% | geolocation with coordinates
118 | 0% | have temporal coverage 

Most common terminologies (scheme/schemeUri) are LCSH and Fields of Science and Technology (FOS)

