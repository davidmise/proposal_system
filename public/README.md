# SmartManager ERP Proposals - Production Deployment

This directory contains the production-ready files for deploying the SmartManager ERP proposal system on Ubuntu with Nginx.

## 📁 Directory Structure

```
public/
├── index.html                   # Landing page
├── home.html                   # Alternative home page
├── proposal_template_v1.html   # SaaS Partnership proposal
├── proposal_template_v2.html   # Standalone Enterprise proposal
├── nginx.conf                  # Nginx configuration
├── deploy.sh                   # Automated deployment script
└── README.md                   # This file
```

## 🚀 Quick Deployment

### Option 1: Automated Deployment (Recommended)

1. **Upload the public folder to your Ubuntu server:**
   ```bash
   scp -r public/ user@your-server-ip:/home/user/
   ```

2. **Connect to your server and run the deployment script:**
   ```bash
   ssh user@your-server-ip
   cd public
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Update domain configuration:**
   ```bash
   sudo nano /etc/nginx/sites-available/proposal
   # Replace "your-domain.com" with your actual domain
   sudo systemctl reload nginx
   ```

### Option 2: Manual Deployment

1. **Install Nginx:**
   ```bash
   sudo apt update
   sudo apt install nginx -y
   ```

2. **Create web directory:**
   ```bash
   sudo mkdir -p /var/www/proposal
   sudo chown -R $USER:$USER /var/www/proposal
   ```

3. **Copy files:**
   ```bash
   cp -r * /var/www/proposal/
   sudo chown -R www-data:www-data /var/www/proposal
   ```

4. **Configure Nginx:**
   ```bash
   sudo cp /var/www/proposal/nginx.conf /etc/nginx/sites-available/proposal
   sudo ln -s /etc/nginx/sites-available/proposal /etc/nginx/sites-enabled/
   sudo rm /etc/nginx/sites-enabled/default
   sudo nginx -t
   sudo systemctl restart nginx
   ```

## 🌐 URL Structure (Pretty URLs)

The system is configured with clean URLs without .html extensions:

- **Landing Page:** `https://your-domain.com/`
- **SaaS Partnership:** `https://your-domain.com/proposal-v1`
- **Enterprise Solution:** `https://your-domain.com/proposal-v2`
- **Alternative routes:**
  - `https://your-domain.com/v1` → proposal_template_v1.html
  - `https://your-domain.com/v2` → proposal_template_v2.html
  - `https://your-domain.com/home` → home.html

## 🔧 Nginx Configuration Features

- ✅ **Pretty URLs** - No .html extensions
- ✅ **Gzip Compression** - Faster loading
- ✅ **Security Headers** - XSS protection, CSRF protection
- ✅ **Static Asset Caching** - 1-year cache for CSS/JS/images
- ✅ **SSL Ready** - Commented SSL configuration included
- ✅ **Mobile Optimized** - Proper headers for mobile devices

## 🔒 SSL Certificate Setup (Let's Encrypt)

1. **Install Certbot:**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   ```

2. **Get SSL certificate:**
   ```bash
   sudo certbot --nginx -d your-domain.com -d www.your-domain.com
   ```

3. **Auto-renewal is configured automatically**

## 🔥 Firewall Configuration

```bash
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw status
```

## 📊 Performance Optimizations

The configuration includes:

- **Gzip compression** for text files
- **Browser caching** for static assets
- **CDN-ready** headers
- **Optimized for mobile** viewing

## 🛠️ Maintenance Commands

**Check Nginx status:**
```bash
sudo systemctl status nginx
```

**Test configuration:**
```bash
sudo nginx -t
```

**Reload configuration:**
```bash
sudo systemctl reload nginx
```

**View error logs:**
```bash
sudo tail -f /var/log/nginx/error.log
```

**View access logs:**
```bash
sudo tail -f /var/log/nginx/access.log
```

## 📱 Mobile Compatibility

The proposals are fully responsive and optimized for:
- ✅ Desktop browsers
- ✅ Tablets
- ✅ Mobile phones
- ✅ Progressive Web App features

## 🔄 Updating Content

To update the proposals:

1. **Edit the HTML files locally**
2. **Upload to server:**
   ```bash
   scp proposal_template_v1.html user@server:/var/www/proposal/
   scp proposal_template_v2.html user@server:/var/www/proposal/
   ```

3. **No server restart needed** - changes are live immediately

## 📞 Support

For technical support with deployment:
- Check Nginx error logs: `/var/log/nginx/error.log`
- Verify file permissions: `ls -la /var/www/proposal/`
- Test configuration: `sudo nginx -t`

## 🎯 Production Checklist

Before going live, ensure:

- [ ] Domain DNS points to server IP
- [ ] SSL certificate is installed
- [ ] Firewall is configured
- [ ] Backups are set up
- [ ] Contact information is updated in proposals
- [ ] All links are tested
- [ ] Mobile responsiveness is verified

---

**🚀 Your SmartManager ERP proposal system is ready for production!**