# Superset specific config
import os
from datetime import timedelta
from flask_caching.backends.filesystemcache import FileSystemCache

# ---------------------------------------------------------
# Superset specific config
# ---------------------------------------------------------
ROW_LIMIT = 5000

# Flask App Builder configuration
# Your App secret key will be used for securely signing the session cookie
# and encrypting sensitive information on the database
# Make sure you are changing this key for your deployment with a strong key.
# Alternatively you can set it with `SUPERSET_SECRET_KEY` environment variable.
# You MUST set this for production environments or the server will not refuse
# to start and you will see an error in the logs accordingly.
SECRET_KEY = os.environ.get('SECRET_KEY', 'thisISaSECRET_1234')

# The SQLAlchemy connection string to your database backend
# This connection defines the path to the database that stores your
# Superset metadata (slices, connections, tables, dashboards, ...).
# Note that the connection information to connect to the datasources
# you want to explore are managed directly in the web UI
# The check_same_thread=false property ensures the sqlite client does not attempt
# to enforce single-threaded access, which may be problematic in some edge cases
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True
# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = []
# A CSRF token that expires in 1 year
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365

# Set this API key to enable Mapbox visualizations
MAPBOX_API_KEY = os.environ.get('MAPBOX_API_KEY', '')

# Cache configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 300,
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_HOST': os.environ.get('REDIS_HOST', 'redis'),
    'CACHE_REDIS_PORT': os.environ.get('REDIS_PORT', 6379),
    'CACHE_REDIS_DB': 1,
}

DATA_CACHE_CONFIG = CACHE_CONFIG

# Celery configuration
class CeleryConfig:
    broker_url = os.environ.get('CELERY_BROKER', 'redis://redis:6379/0')
    result_backend = os.environ.get('CELERY_RESULT_BACKEND', 'redis://redis:6379/0')
    worker_log_level = "INFO"
    worker_prefetch_multiplier = 1
    task_acks_late = False
    task_annotations = {
        'sql_lab.get_sql_results': {
            'rate_limit': '100/s',
        },
    }

CELERY_CONFIG = CeleryConfig

RESULTS_BACKEND = CACHE_CONFIG

# Async queries via Celery
FEATURE_FLAGS = {
    'ALERT_REPORTS': True,
    'DASHBOARD_CROSS_FILTERS': True,
    'DASHBOARD_RBAC': True,
    'EMBEDDED_SUPERSET': True,
    'ENABLE_TEMPLATE_PROCESSING': True,
    'SQLLAB_BACKEND_PERSISTENCE': True,
    'SSH_TUNNELING': True,
    'PLAYWRIGHT_REPORTS_AND_THUMBNAILS': True,  # Enable Playwright for reports
}

# Email configuration for alerts and reports
EMAIL_NOTIFICATIONS = True
SMTP_HOST = os.environ.get('SMTP_HOST', 'localhost')
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = os.environ.get('SMTP_USER')
SMTP_PASSWORD = os.environ.get('SMTP_PASSWORD')
SMTP_PORT = 587

# WebDriver configuration for reports and thumbnails
WEBDRIVER_TYPE = "chrome"
WEBDRIVER_OPTION_ARGS = [
    "--force-device-scale-factor=1.0",
    "--high-dpi-support=1.0",
    "--headless",
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-extensions",
    "--disable-background-timer-throttling",
    "--disable-backgrounding-occluded-windows",
    "--disable-renderer-backgrounding",
]

# Playwright configuration (when PLAYWRIGHT_REPORTS_AND_THUMBNAILS is enabled)
SCREENSHOT_SELENIUM_USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
)

# SQL Lab configuration
SQLLAB_ASYNC_TIME_LIMIT_SEC = 60 * 60 * 6  # 6 hours
SQLLAB_TIMEOUT = 30  # 30 seconds
SUPERSET_WEBSERVER_TIMEOUT = 60

# Enable uploading Excel files
ALLOWED_EXTENSIONS = {
    "csv", "tsv", "txt", "json", 
    "xls", "xlsx", "xlsm", "xlsb"
}

# CSV upload configuration
CSV_EXTENSIONS = {"csv", "tsv", "txt"}
EXCEL_EXTENSIONS = {"xls", "xlsx", "xlsm", "xlsb"}

# Allow for creating multiple tabs
TALISMAN_ENABLED = False

# Enable CORS
ENABLE_CORS = True
CORS_OPTIONS = {}

# Time grain configurations
TIME_GRAIN_FUNCTIONS = {
    'PT1S': 'DATE_TRUNC(\'second\', {col})',
    'PT1M': 'DATE_TRUNC(\'minute\', {col})',
    'PT5M': 'DATE_TRUNC(\'minute\', {col}) + INTERVAL \'5 minute\' * (EXTRACT(minute FROM {col})::int / 5)',
    'PT10M': 'DATE_TRUNC(\'minute\', {col}) + INTERVAL \'10 minute\' * (EXTRACT(minute FROM {col})::int / 10)',
    'PT15M': 'DATE_TRUNC(\'minute\', {col}) + INTERVAL \'15 minute\' * (EXTRACT(minute FROM {col})::int / 15)',
    'PT30M': 'DATE_TRUNC(\'minute\', {col}) + INTERVAL \'30 minute\' * (EXTRACT(minute FROM {col})::int / 30)',
    'PT1H': 'DATE_TRUNC(\'hour\', {col})',
    'P1D': 'DATE_TRUNC(\'day\', {col})',
    'P1W': 'DATE_TRUNC(\'week\', {col})',
    'P1M': 'DATE_TRUNC(\'month\', {col})',
    'P3M': 'DATE_TRUNC(\'quarter\', {col})',
    'P1Y': 'DATE_TRUNC(\'year\', {col})',
}

# Dashboard configuration
DASHBOARD_AUTO_REFRESH_INTERVALS = [
    [0, "Don't refresh"],
    [10, "10 seconds"],
    [30, "30 seconds"],
    [60, "1 minute"],
    [300, "5 minutes"],
    [1800, "30 minutes"],
    [3600, "1 hour"],
    [21600, "6 hours"],
    [43200, "12 hours"],
    [86400, "24 hours"],
]

# Custom branding
APP_NAME = "BI Platform"
APP_ICON = "/static/assets/images/superset-logo-horiz.png"
FAVICONS = [{"href": "/static/assets/images/favicon.png"}]
