# OtsX Search Engine

Private SearXNG instance built from YOUR forked repo with full control.

## Architecture Options

### Option 1: Production Setup (Current)
```
Internet → Caddy → uwsgi → SearXNG
```
- **uwsgi** = Production Python server (workers, threading, static files)
- **Caddy** = Reverse proxy (HTTPS, caching, security)

### Option 2: Simple Setup (Alternative)
```
Internet → Caddy → gunicorn → SearXNG
```
- **gunicorn** = Simple Python server
- **Caddy** = Reverse proxy (HTTPS only)

To use simple setup: `dockerfile: otsx/Dockerfile.simple` in docker-compose.yaml

## Configuration Files

- `settings.yml` - Main SearXNG configuration  
- `uwsgi.ini` - Production server settings (workers, threading, static files)
- `limiter.toml` - Bot protection settings (rate limiting, IP filtering)
- `Dockerfile` - Production build (uwsgi)
- `Dockerfile.simple` - Simple build (gunicorn)
- `docker-compose.yaml` - Complete deployment setup

## Missing Configs Explained

**Q: Where is uwsgi conf?**  
A: `uwsgi.ini` - Controls workers, threading, static file serving

**Q: Where is limits config?**  
A: `limiter.toml` - Bot detection, rate limiting, IP whitelisting  

**Q: Why uwsgi with Caddy?**  
A: **Caddy** = HTTPS/proxy, **uwsgi** = Python app server. Can use simpler **gunicorn** instead.

## Volume Requirements

**Required Volumes:**
- `/etc/searxng/` - All configuration files
- `/var/cache/searxng/` - Persistent cache (favicons, etc.)

**What's Mounted:**
- `./settings.yml` → `/etc/searxng/settings.yml`
- `./uwsgi.ini` → `/etc/searxng/uwsgi.ini`
- `./limiter.toml` → `/etc/searxng/limiter.toml`
- `otsx_cache` → `/var/cache/searxng`

## Deployment

```bash
# Production setup (uwsgi)
docker compose up -d --build

# OR simple setup (gunicorn)
# Edit docker-compose.yaml: dockerfile: otsx/Dockerfile.simple
docker compose up -d --build

# View logs
docker compose logs -f otsx
```

## Production Deployment

1. Choose architecture (uwsgi vs gunicorn)
2. Configure `limiter.toml` for your security needs
3. Set up Caddy for HTTPS (uncomment in docker-compose.yaml)
4. Deploy to your server/cloud platform
5. Update when YOU decide to pull upstream changes 