# Canvas LMS Railway Deployment Guide

This guide will help you deploy Canvas LMS to Railway for your civic debate academy portal.

## Prerequisites

1. A Railway account (sign up at [railway.app](https://railway.app))
2. A GitHub account with this Canvas LMS repository

## Step 1: Set up Railway Project

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your Canvas LMS repository
5. Railway will automatically detect the `railway.json` configuration

## Step 2: Add Required Services

Canvas LMS requires PostgreSQL and Redis. Add these services:

### PostgreSQL Database
1. In your Railway project, click "New Service"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically provision a PostgreSQL database
4. Note the connection details (you'll need these for environment variables)

### Redis Cache
1. Click "New Service" again
2. Select "Database" → "Redis"
3. Railway will provision a Redis instance
4. Note the connection details

## Step 3: Configure Environment Variables

Based on the [Canvas LMS Production Start guide](https://github.com/instructure/canvas-lms/wiki/Production-Start), add these environment variables to your Railway project:

### Database Configuration (PostgreSQL 14+ required)
```
DATABASE_URL=postgresql://username:password@hostname:port/database_name
CANVAS_DB_ADAPTER=postgresql
CANVAS_DB_ENCODING=utf8
CANVAS_DB_TIMEOUT=5000
```

### Redis Configuration (Required for production)
```
REDIS_URL=redis://username:password@hostname:port
```

### Canvas Core Configuration
```
CANVAS_RAILS_ENV=production
CANVAS_SECRET_KEY_BASE=your_secret_key_base_here
CANVAS_ENCRYPTION_KEY=your_encryption_key_here
CANVAS_DOMAIN=your-app.railway.app
CANVAS_CDN_HOST=your-app.railway.app
```

### Security Configuration
```
CANVAS_FORCE_SSL=true
CANVAS_SESSION_COOKIE_SECURE=true
CANVAS_SESSION_COOKIE_HTTPONLY=true
```

### Performance Configuration
```
CANVAS_USE_OPTIMIZED_JS=true
CANVAS_CACHE_STORE=redis_cache_store
CANVAS_THREADS=5
CANVAS_MAX_THREADS=5
CANVAS_MIN_THREADS=1
```

### File Storage Configuration
```
CANVAS_FILE_STORAGE_TYPE=local
CANVAS_FILE_STORAGE_PATH=/var/canvas/public/uploads
```

### Automated Jobs Configuration (Critical for production)
```
CANVAS_DELAYED_JOB_PRIORITY=20
CANVAS_DELAYED_JOB_MAX_ATTEMPTS=3
```

### Email Configuration (Required for notifications)
```
CANVAS_OUTGOING_EMAIL_ADDRESS=noreply@your-domain.com
CANVAS_OUTGOING_EMAIL_DEFAULT_NAME=Canvas LMS
CANVAS_OUTGOING_EMAIL_ADDRESS_NAME=Canvas LMS
```

### Canvas-specific Production Settings
```
CANVAS_APPLICATION_ROOT=/usr/src/app
CANVAS_FILE_UPLOAD_PATH=/var/canvas/public/uploads
CANVAS_TEMP_PATH=/var/canvas/tmp
CANVAS_LOG_PATH=/var/canvas/log
CANVAS_LOG_LEVEL=info
CANVAS_LOG_TO_STDOUT=true
```

## Step 4: Generate Secret Keys

Generate secure secret keys for your deployment:

```bash
# Generate secret key base
openssl rand -hex 64

# Generate encryption key
openssl rand -hex 32
```

Add these to your Railway environment variables.

## Step 5: Deploy

1. Railway will automatically build and deploy your application
2. The build process may take 10-15 minutes due to Canvas's complexity
3. Monitor the build logs for any issues

## Step 6: Initialize Database

After deployment, you need to initialize the database:

1. Go to your Railway project dashboard
2. Click on your web service
3. Go to the "Deployments" tab
4. Click on the latest deployment
5. Open the terminal/console
6. Run these commands:

```bash
# Set up the database
bundle exec rails db:create
bundle exec rails db:migrate

# Create initial admin user
bundle exec rails runner "
user = User.new
user.name = 'Admin User'
user.workflow_state = 'registered'
user.pseudonym = Pseudonym.new
user.pseudonym.unique_id = 'admin@example.com'
user.pseudonym.password = 'admin123'
user.pseudonym.password_confirmation = 'admin123'
user.pseudonym.account = Account.default
user.pseudonym.workflow_state = 'active'
user.save!
account = Account.default
account.account_users.create!(user: user)
puts 'Admin user created: admin@example.com / admin123'
"
```

## Step 7: Access Your Canvas Instance

1. Your Canvas instance will be available at `https://your-app.railway.app`
2. Log in with the admin credentials you created
3. Start customizing for your civic debate academy!

## Customization for Civic Debate Academy

Once Canvas is running, you can:

1. **Branding**: Customize colors, logos, and themes
2. **Course Structure**: Set up debate courses, tournaments, and modules
3. **User Roles**: Create roles for students, judges, coaches, and administrators
4. **Integration**: Connect with external tools for debate scoring and video recording
5. **Content**: Add debate-specific content, rubrics, and assessment tools

## Troubleshooting

### Build Failures
- Check that all environment variables are set correctly
- Ensure PostgreSQL and Redis services are running
- Review build logs for specific error messages

### Database Issues
- Verify DATABASE_URL is correctly formatted
- Check that the database service is accessible
- Run `bundle exec rails db:migrate` if needed

### Performance Issues
- Railway provides limited resources on the free tier
- Consider upgrading to a paid plan for better performance
- Monitor resource usage in the Railway dashboard

## Next Steps

1. **Domain Setup**: Configure a custom domain for your academy
2. **SSL Certificate**: Railway provides automatic SSL, but verify it's working
3. **Backup Strategy**: Set up regular database backups
4. **Monitoring**: Configure logging and monitoring for production use
5. **Scaling**: Plan for scaling as your academy grows

## Support

- Canvas LMS Documentation: [canvas.instructure.com](https://canvas.instructure.com)
- Railway Documentation: [docs.railway.app](https://docs.railway.app)
- Canvas Community: [community.canvaslms.com](https://community.canvaslms.com)

Happy debating! 🎓
