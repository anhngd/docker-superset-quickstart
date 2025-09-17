# JB BI Platform - Apache Superset

A modern Business Intelligence platform powered by Apache Superset, designed for data visualization, exploration, and dashboard creation.

## 🚀 Features

- **Interactive Dashboards**: Create beautiful, responsive dashboards with drag-and-drop functionality
- **SQL Lab**: Advanced SQL IDE with syntax highlighting and query history
- **Rich Visualizations**: 50+ chart types including time-series, bar charts, heatmaps, and geospatial visualizations
- **Data Source Connectivity**: Connect to PostgreSQL, MySQL, SQLite, and many other databases
- **Excel/CSV Import**: Upload and analyze Excel/CSV files directly
- **Email Alerts & Reports**: Automated dashboard reports and data alerts
- **Role-Based Access Control**: Granular permissions and security controls
- **Real-time Caching**: Redis-powered caching for optimal performance
- **Async Query Processing**: Celery-based background job processing

## 🏗️ Architecture

This deployment uses a containerized architecture with the following services:

- **Superset Application**: Main web application (Port 8088)
- **PostgreSQL Database**: Metadata and configuration storage (Port 15432)
- **Redis Cache**: Session storage and caching layer (Port 16379)
- **Celery Worker**: Background task processing
- **Celery Beat**: Scheduled task scheduler

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM available
- 10GB+ disk space

## 🚀 Quick Start

### 1. Clone and Navigate

```bash
git clone <repository-url>
cd superset
```

### 2. Start Services

```bash
# Start all services in detached mode
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f superset
```

### 3. Access the Platform

- **URL**: http://localhost:8088
- **Username**: `admin`
- **Password**: `admin`

> ⚠️ **Security Note**: Change the default admin credentials immediately after first login!

## 🛠️ Configuration

### Environment Variables

Key configuration is managed through `/docker/.env-non-dev`:

```bash
# Database
DATABASE_DB=superset
DATABASE_HOST=db
DATABASE_USER=superset
DATABASE_PASSWORD=superset

# Cache & Queue
REDIS_HOST=redis
CELERY_BROKER=redis://redis:6379/0

# Security
SUPERSET_SECRET_KEY=your-secret-key-here

# Email (Optional)
SMTP_HOST=your-smtp-server
SMTP_USER=your-email@domain.com
SMTP_PASSWORD=your-password
```

### Custom Configuration

Advanced settings are available in `superset_config.py`:

- **Feature Flags**: Enable/disable advanced features
- **Cache Settings**: Redis configuration and timeouts
- **Email Setup**: SMTP configuration for alerts
- **Security Options**: CORS, CSRF, and authentication settings
- **Dashboard Options**: Auto-refresh intervals and branding

## 📊 Data Sources

### Supported Databases

- PostgreSQL
- MySQL/MariaDB
- SQLite
- Microsoft SQL Server
- Oracle
- And many more...

### Adding a Data Source

1. Navigate to **Data → Databases**
2. Click **+ Database**
3. Select your database type
4. Enter connection details
5. Test connection and save

### File Upload Support

Upload CSV, Excel, TSV, and JSON files directly:

1. Go to **Data → Upload a CSV**
2. Select your file
3. Configure columns and data types
4. Create charts and dashboards

## 🔧 Development

### Local Development Setup

```bash
# Build custom image
docker build -t jb-superset:local .

# Update docker-compose to use local image
# Edit docker-compose.yml: change image to jb-superset:local

# Start with build
docker-compose up --build
```

### Adding Python Packages

Edit the `Dockerfile` to add additional packages:

```dockerfile
RUN pip install \
    your-package-name \
    another-package
```

### Custom Visualizations

1. Place custom viz plugins in `/superset_home/`
2. Install via pip in the Dockerfile
3. Rebuild and restart containers

## 📈 Monitoring & Maintenance

### Health Checks

```bash
# Check service health
docker-compose ps

# View specific service logs
docker-compose logs superset
docker-compose logs superset-worker
docker-compose logs db

# Monitor resource usage
docker stats
```

### Database Maintenance

```bash
# Connect to PostgreSQL
docker exec -it superset_db psql -U superset -d superset

# Backup database
docker exec superset_db pg_dump -U superset superset > backup.sql

# Restore database
cat backup.sql | docker exec -i superset_db psql -U superset -d superset
```

### Performance Tuning

1. **Redis Memory**: Adjust `CACHE_DEFAULT_TIMEOUT` in config
2. **Worker Scaling**: Increase Celery worker `--concurrency`
3. **Database**: Tune PostgreSQL settings for your workload
4. **Query Limits**: Adjust `ROW_LIMIT` for large datasets

## 🔒 Security

### Production Deployment

1. **Change Default Credentials**
   ```bash
   # Access container and create new admin user
   docker exec -it superset_app superset fab create-admin
   ```

2. **Update Secret Keys**
   ```bash
   # Generate secure secret key
   python -c "import secrets; print(secrets.token_hex(32))"
   ```

3. **Configure HTTPS**
   - Use reverse proxy (nginx, traefik)
   - Obtain SSL certificates
   - Update CORS settings

4. **Network Security**
   - Use custom Docker networks
   - Restrict database access
   - Configure firewall rules

### User Management

- **Roles**: Admin, Alpha, Gamma (read-only)
- **Row-Level Security**: Filter data by user attributes
- **Database Permissions**: Grant access to specific schemas/tables

## 🛠️ Troubleshooting

### Common Issues

1. **Container Won't Start**
   ```bash
   # Check logs
   docker-compose logs [service-name]
   
   # Verify file permissions
   chmod +x docker/entrypoints/*.sh
   ```

2. **Database Connection Failed**
   ```bash
   # Verify database is running
   docker-compose ps db
   
   # Check database logs
   docker-compose logs db
   ```

3. **Redis Connection Issues**
   ```bash
   # Test Redis connectivity
   docker exec superset_cache redis-cli ping
   ```

4. **Performance Issues**
   - Increase Docker memory allocation
   - Monitor query performance in SQL Lab
   - Check cache hit rates

### Log Locations

- Superset App: `docker-compose logs superset`
- Worker: `docker-compose logs superset-worker`
- Database: `docker-compose logs db`
- Redis: `docker-compose logs redis`

## 📚 Documentation

- [Official Superset Documentation](https://superset.apache.org/)
- [API Documentation](http://localhost:8088/api/v1/openapi.json)
- [Security Guide](https://superset.apache.org/docs/security)
- [Chart Types](https://superset.apache.org/gallery)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: Create a GitHub issue for bugs or feature requests
- **Documentation**: Check the official Superset documentation
- **Community**: Join the Apache Superset Slack community

---

**JB BI Platform** - Empowering data-driven decisions through beautiful visualizations and powerful analytics.
