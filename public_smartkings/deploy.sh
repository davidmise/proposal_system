#!/bin/bash

# SmartManager ERP Proposal Deployment Script
# This script sets up the proposal system on Ubuntu with Nginx

echo "🚀 Starting SmartManager ERP Proposal Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    print_status "Installing Nginx..."
    sudo apt install nginx -y
else
    print_status "Nginx is already installed"
fi

# Create web directory
print_status "Creating web directory..."
sudo mkdir -p /var/www/proposal
sudo chown -R $USER:$USER /var/www/proposal
sudo chmod -R 755 /var/www/proposal

# Copy files to web directory
print_status "Copying proposal files..."
cp -r * /var/www/proposal/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/proposal
sudo chmod -R 644 /var/www/proposal
sudo chmod -R 755 /var/www/proposal

# Create Nginx site configuration
print_status "Configuring Nginx..."
sudo cp /var/www/proposal/nginx.conf /etc/nginx/sites-available/proposal

# Enable the site
sudo ln -sf /etc/nginx/sites-available/proposal /etc/nginx/sites-enabled/

# Remove default Nginx site if it exists
if [ -f /etc/nginx/sites-enabled/default ]; then
    print_warning "Removing default Nginx site..."
    sudo rm /etc/nginx/sites-enabled/default
fi

# Test Nginx configuration
print_status "Testing Nginx configuration..."
if sudo nginx -t; then
    print_status "Nginx configuration is valid"
else
    print_error "Nginx configuration has errors. Please check the configuration."
    exit 1
fi

# Restart Nginx
print_status "Restarting Nginx..."
sudo systemctl restart nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Check if firewall is active and configure it
if sudo ufw status | grep -q "Status: active"; then
    print_status "Configuring firewall..."
    sudo ufw allow 'Nginx Full'
    sudo ufw allow ssh
else
    print_warning "UFW firewall is not active. Consider enabling it for security."
fi

# Display completion message
print_status "🎉 Deployment completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Update the domain name in /etc/nginx/sites-available/proposal"
echo "2. Point your domain's DNS to this server's IP address"
echo "3. Consider setting up SSL with Let's Encrypt (instructions below)"
echo ""
echo "🔒 To set up SSL with Let's Encrypt:"
echo "   sudo apt install certbot python3-certbot-nginx"
echo "   sudo certbot --nginx -d your-domain.com -d www.your-domain.com"
echo ""
echo "🌐 Your proposals are now available at:"
echo "   http://your-domain.com/ (Landing page)"
echo "   http://your-domain.com/proposal-v1 (SaaS Partnership)"
echo "   http://your-domain.com/proposal-v2 (Standalone Enterprise)"
echo ""
echo "📁 Files are located at: /var/www/proposal/"
echo "⚙️  Nginx config: /etc/nginx/sites-available/proposal"