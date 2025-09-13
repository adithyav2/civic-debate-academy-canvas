# Canvas LMS Production Checklist for Railway

Based on the [Canvas LMS Production Start guide](https://github.com/instructure/canvas-lms/wiki/Production-Start), this checklist ensures your Railway deployment follows production best practices.

## ✅ Pre-Deployment Requirements

### System Requirements
- [ ] **PostgreSQL 14+** - Canvas requires PostgreSQL 14 or higher
- [ ] **Redis** - Required for caching and session storage
- [ ] **8GB+ RAM** - Recommended minimum for production
- [ ] **SSL Certificate** - Railway provides automatic SSL

### Environment Variables
- [ ] `DATABASE_URL` - PostgreSQL connection string
- [ ] `REDIS_URL` - Redis connection string
- [ ] `CANVAS_SECRET_KEY_BASE` - Secure secret key (64+ characters)
- [ ] `CANVAS_ENCRYPTION_KEY` - Encryption key (32+ characters)
- [ ] `CANVAS_DOMAIN` - Your Railway domain
- [ ] `CANVAS_RAILS_ENV=production`

## ✅ Production Configuration

### Database Configuration
- [ ] PostgreSQL 14+ installed and running
- [ ] Database user created with proper permissions
- [ ] `database.yml` configured with production settings
- [ ] Database migrations run successfully

### Redis Configuration
- [ ] Redis instance running and accessible
- [ ] `redis.yml` configured for production
- [ ] `cache_store.yml` configured for Redis caching
- [ ] Redis connection tested

### Security Configuration
- [ ] `CANVAS_FORCE_SSL=true`
- [ ] `CANVAS_SESSION_COOKIE_SECURE=true`
- [ ] `CANVAS_SESSION_COOKIE_HTTPONLY=true`
- [ ] Secret keys generated securely
- [ ] File permissions set correctly (400 for config files)

### File Storage
- [ ] Upload directories created (`/var/canvas/public/uploads`)
- [ ] Proper permissions set on upload directories
- [ ] File storage type configured (local for Railway)

## ✅ Automated Jobs (Critical)

Canvas requires automated jobs to function properly. These handle:
- Email notifications
- Statistics gathering
- File processing
- Background tasks

### Job Configuration
- [ ] Worker service deployed (separate from web service)
- [ ] `script/delayed_job run` command configured
- [ ] Job queue monitoring set up
- [ ] Failed job handling configured

## ✅ Asset Generation

- [ ] CSS assets compiled (`yarn build:css:compressed`)
- [ ] JavaScript assets compiled (`yarn webpack-production`)
- [ ] Asset precompilation completed
- [ ] Static assets served correctly

## ✅ Email Configuration

Canvas requires email for:
- User notifications
- Password resets
- Course announcements
- System alerts

### Email Setup
- [ ] SMTP server configured
- [ ] `CANVAS_OUTGOING_EMAIL_ADDRESS` set
- [ ] Email templates working
- [ ] Test emails sent successfully

## ✅ Performance Optimization

- [ ] `CANVAS_USE_OPTIMIZED_JS=true`
- [ ] Redis caching enabled
- [ ] Thread pool configured (5 threads recommended)
- [ ] Memory limits set appropriately
- [ ] Database connection pooling configured

## ✅ Monitoring and Logging

- [ ] Log files configured (`/var/canvas/log`)
- [ ] Log level set to `info` for production
- [ ] Log rotation configured
- [ ] Error monitoring set up
- [ ] Performance monitoring configured

## ✅ Post-Deployment Verification

### System Health
- [ ] Web service responding on port 3000
- [ ] Worker service processing jobs
- [ ] Database connections working
- [ ] Redis connections working
- [ ] File uploads working

### User Access
- [ ] Admin user created successfully
- [ ] Login functionality working
- [ ] Password reset working
- [ ] User registration working (if enabled)

### Canvas Features
- [ ] Course creation working
- [ ] File uploads working
- [ ] Email notifications working
- [ ] Gradebook functioning
- [ ] Discussion forums working

## ✅ Security Hardening

- [ ] Default admin password changed
- [ ] Unnecessary services disabled
- [ ] File permissions restricted
- [ ] SSL/TLS properly configured
- [ ] Security headers configured
- [ ] Regular security updates planned

## ✅ Backup Strategy

- [ ] Database backup strategy implemented
- [ ] File storage backup configured
- [ ] Backup testing performed
- [ ] Recovery procedures documented

## ✅ Scaling Considerations

- [ ] Multiple web servers (if needed)
- [ ] Load balancer configuration
- [ ] Database read replicas (if needed)
- [ ] CDN configuration (if needed)
- [ ] Monitoring and alerting set up

## 🚨 Common Issues

### Build Failures
- Check all environment variables are set
- Verify PostgreSQL and Redis services are running
- Review build logs for specific errors

### Database Issues
- Verify DATABASE_URL format
- Check database permissions
- Run `bundle exec rails db:migrate` if needed

### Performance Issues
- Monitor memory usage
- Check Redis connection
- Verify thread pool configuration
- Review database query performance

## 📚 Additional Resources

- [Canvas LMS Production Start Guide](https://github.com/instructure/canvas-lms/wiki/Production-Start)
- [Canvas LMS Troubleshooting](https://github.com/instructure/canvas-lms/wiki/Troubleshooting)
- [Railway Documentation](https://docs.railway.app)
- [Canvas Community](https://community.canvaslms.com)

---

**Remember**: Canvas LMS is a complex application. Take time to test each component thoroughly before going live with your civic debate academy!
