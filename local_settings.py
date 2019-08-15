from os import environ

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'fileformat': {
            'format': '%(asctime)s %(levelname)s %(message)s'
        },
        'raw': {
            'format': '%(message)s'
        },
    },
    'handlers': {
        'elasticsearch': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'es.log',
            'formatter': 'fileformat',
        },
        'humio': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'humio.log',
            'formatter': 'fileformat',
        },
    },
    'loggers': {
        'elasticsearch': {
            'handlers': ['elasticsearch'],
            'level': 'INFO',
            'propagate': True,
        },
        'humio': {
            'handlers': ['humio'],
            'level': 'INFO',
            'propagate': True,
        },
    }
}

import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
STATIC_ROOT = os.path.join(BASE_DIR, 'static')
USE_SURICATA_STATS = True
