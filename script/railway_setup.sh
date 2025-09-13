#!/bin/bash

# Railway setup script for Canvas LMS
# Based on Canvas LMS Production Start guide requirements
# This script helps initialize Canvas after deployment

set -e

echo "🚀 Setting up Canvas LMS on Railway (Production Mode)..."

# Check if we're in production
if [ "$RAILS_ENV" != "production" ]; then
    echo "⚠️  Warning: Not in production environment"
fi

# Verify required environment variables
echo "🔍 Checking required environment variables..."
required_vars=("DATABASE_URL" "REDIS_URL" "CANVAS_SECRET_KEY_BASE" "CANVAS_ENCRYPTION_KEY")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Error: $var is not set"
        exit 1
    fi
done

# Create necessary directories
echo "📁 Creating Canvas directories..."
mkdir -p /var/canvas/log /var/canvas/tmp /var/canvas/public/uploads
chown -R docker:docker /var/canvas

# Database setup
echo "📊 Setting up database..."
bundle exec rails db:create || echo "Database may already exist"
bundle exec rails db:migrate

# Generate assets (required for production)
echo "🎨 Generating production assets..."
bundle exec rails assets:precompile

# Create initial admin user if it doesn't exist
echo "👤 Creating admin user..."
bundle exec rails runner "
if User.joins(:pseudonyms).where(pseudonyms: { unique_id: 'admin@example.com' }).exists?
  puts 'Admin user already exists'
else
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
  puts '✅ Admin user created: admin@example.com / admin123'
end
"

# Set up Canvas permissions (following production guide)
echo "🔐 Setting up Canvas permissions..."
chmod 400 config/database.yml config/redis.yml config/cache_store.yml
chown canvasuser:canvasuser config/database.yml config/redis.yml config/cache_store.yml

echo "✅ Canvas LMS production setup complete!"
echo "🌐 Your Canvas instance should be available at your Railway URL"
echo "🔑 Login with: admin@example.com / admin123"
echo "⚠️  Remember to change the default password!"
echo "📋 Next steps:"
echo "   - Configure email settings"
echo "   - Set up automated jobs (delayed_job)"
echo "   - Configure file storage"
echo "   - Review security settings"
