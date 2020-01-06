#!/bin/bash

curl -XPUT 'http://localhost:9200/opmon-*/_mapping/_doc?pretty' -H 'Content-Type: application/json' -d'
{
  "properties" : {
    "requestInTs" : {
      "type" : "date",
      "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
    },
    "consumerMember" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "consumerSystem" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "producerMember" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "producerSystem" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "service" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "serviceCode" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "clientSecurityServerAddress" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "serviceSecurityServerAddress" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "succeeded" : {
      "type" : "boolean"
    },
    "valid" : {
      "type" : "boolean"
    },
    "messageUserId" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "client" : {
      "properties" : {
        "_id" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientMemberClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientMemberCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientSecurityServerAddress" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientSubsystemCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientXRoadInstance" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "insertTime" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss||epoch_second"
        },
        "messageId" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageIssue" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageProtocolVersion" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageUserId" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "monitoringDataTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss||epoch_second"
        },
        "representedPartyClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "representedPartyCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "requestAttachmentCount" : {
          "type" : "long"
        },
        "requestInTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "requestMimeSize" : {
          "type" : "long"
        },
        "requestOutTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "requestSoapSize" : {
          "type" : "long"
        },
        "responseAttachmentCount" : {
          "type" : "long"
        },
        "responseInTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "responseMimeSize" : {
          "type" : "long"
        },
        "responseOutTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "responseSoapSize" : {
          "type" : "long"
        },
        "securityServerInternalIp" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "securityServerType" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceMemberClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceMemberCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceSecurityServerAddress" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceSubsystemCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceVersion" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceXRoadInstance" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "soapFaultCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "soapFaultString" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "succeeded" : {
          "type" : "boolean"
        }
      }
    },
    "clientHash" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "clientRequestSize" : {
      "type" : "long"
    },
    "clientResponseSize" : {
      "type" : "long"
    },
    "clientSsRequestDuration" : {
      "type" : "long"
    },
    "clientSsResponseDuration" : {
      "type" : "long"
    },
    "correctorStatus" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "correctorTime" : {
      "type" : "date",
      "format" : "yyyy-MM-dd HH:mm:ss||epoch_second"
    },
    "matchingType" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "messageId" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "producer" : {
      "properties" : {
        "_id" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientMemberClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientMemberCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientSecurityServerAddress" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientSubsystemCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "clientXRoadInstance" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "insertTime" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss||epoch_second"
        },
        "messageId" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageIssue" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageProtocolVersion" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "messageUserId" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "monitoringDataTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss||epoch_second"
        },
        "representedPartyClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "representedPartyCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "requestAttachmentCount" : {
          "type" : "long"
        },
        "requestInTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "requestMimeSize" : {
          "type" : "long"
        },
        "requestOutTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "requestSoapSize" : {
          "type" : "long"
        },
        "responseAttachmentCount" : {
          "type" : "long"
        },
        "responseInTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "responseMimeSize" : {
          "type" : "long"
        },
        "responseOutTs" : {
          "type" : "date",
          "format" : "yyyy-MM-dd HH:mm:ss.SSS||epoch_millis"
        },
        "responseSoapSize" : {
          "type" : "long"
        },
        "securityServerInternalIp" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "securityServerType" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceMemberClass" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceMemberCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceSecurityServerAddress" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceSubsystemCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceVersion" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "serviceXRoadInstance" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "soapFaultCode" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "soapFaultString" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "succeeded" : {
          "type" : "boolean"
        }
      }
    },
    "producerDurationClientView" : {
      "type" : "long"
    },
    "producerDurationProducerView" : {
      "type" : "long"
    },
    "producerHash" : {
      "type" : "text",
      "fields" : {
        "keyword" : {
          "type" : "keyword",
          "ignore_above" : 256
        }
      }
    },
    "producerIsDuration" : {
      "type" : "long"
    },
    "producerRequestSize" : {
      "type" : "long"
    },
    "producerResponseSize" : {
      "type" : "long"
    },
    "producerSsRequestDuration" : {
      "type" : "long"
    },
    "producerSsResponseDuration" : {
      "type" : "long"
    },
    "requestNwDuration" : {
      "type" : "long"
    },
    "responseNwDuration" : {
      "type" : "long"
    },
    "totalDuration" : {
      "type" : "long"
    }
  }
}
'