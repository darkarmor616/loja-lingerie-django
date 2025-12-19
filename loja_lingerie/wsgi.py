"""
WSGI config for loja_lingerie project.
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'loja_lingerie.settings')

application = get_wsgi_application()
