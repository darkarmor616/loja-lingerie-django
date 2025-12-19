"""
ASGI config for loja_lingerie project.
"""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'loja_lingerie.settings')

application = get_asgi_application()
