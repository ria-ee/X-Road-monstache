#!/usr/bin/python3

import sys
from elasticsearch import Elasticsearch
from elasticsearch import helpers

INDEX = ''
SCROLL = '2m'
SIZE = 5000

if len(sys.argv) == 2 and sys.argv[1]:
    INDEX = sys.argv[1]
    print('Processing index: {}'.format(sys.argv[1]))
else:
    print(
        'Usage: python3 {prog_name} INDEX_NAME_OR_PATTERN\n'
        'Example: python3 {prog_name} "opmon-*"'.format(prog_name=sys.argv[0]))
    exit(0)

es = Elasticsearch()

# Searching for non existence of "serviceCode", which is one on the newest fields
page = es.search(index=INDEX, size=SIZE, scroll='2m', q='!(_exists_:serviceCode)', version=True)

sid = page['_scroll_id']
scroll_size = len(page['hits']['hits'])
print('Total items to process: {}'.format(page['hits']['total']))

while scroll_size > 0:
    actions = []
    del_actions = []

    print('Processing {} items'.format(scroll_size))

    for hit in page['hits']['hits']:
        if 'client' in hit['_source'] and hit['_source']['client'] is not None \
                and 'requestInTs' in hit['_source']['client']:
            data = hit['_source']['client']
        elif 'producer' in hit['_source'] and hit['_source']['producer'] is not None \
                and 'requestInTs' in hit['_source']['producer']:
            data = hit['_source']['producer']
        else:
            print('Both client.requestInTs and producer.requestInTs are missing! ID={}'.format(
                hit['_id']))
            continue

        doc = hit['_source']
        # NB!!! Setting "serviceCode" to empty value while go plugin would set it to None
        doc['serviceCode'] = data['serviceCode'] or ''
        doc['clientSecurityServerAddress'] = data['clientSecurityServerAddress'] or ''
        doc['serviceSecurityServerAddress'] = data['serviceSecurityServerAddress'] or ''

        action = {
            '_op_type': 'index',
            '_version_type': 'external_gte',
            '_version': hit['_version'],
            '_index': hit['_index'],
            '_type': '_doc',
            '_id': hit['_id'],
            '_source': doc
        }
        actions.append(action)

    bulk_res = helpers.bulk(es, actions, stats_only=True)
    if bulk_res[1] != 0:
        print('Failed to add/update: {}'.format(bulk_res[1]))

    page = es.scroll(scroll_id=sid, scroll='2m')
    sid = page['_scroll_id']
    scroll_size = len(page['hits']['hits'])
