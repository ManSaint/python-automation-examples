# Webhook API Reference

The Python Automation system provides several webhook endpoints that can be called from n8n workflows or other automation systems.

## Base URL

```
http://localhost:5000
```

For Docker deployments:
```
http://python-webhook:5000
```

## Authentication

Currently, no authentication is required for webhook endpoints. In production, consider implementing:
- API key authentication
- IP whitelisting
- JWT tokens
- Basic authentication

## Endpoints

### Health Check

**GET** `/health`

Returns the health status of the automation service.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-07-14T19:56:12.844Z",
  "service": "python-automation-webhook"
}
```

### File Organization

**POST** `/organize-files`

Organizes files in a directory based on file types and custom rules.

**Request Body:**
```json
{
  "directory": "/path/to/organize",
  "target_directory": "/path/to/organized",
  "dry_run": true,
  "recursive": false
}
```

**Parameters:**
- `directory` (required): Source directory to organize
- `target_directory` (optional): Target directory (defaults to source)
- `dry_run` (optional): If true, only simulates organization
- `recursive` (optional): Process subdirectories

**Response:**
```json
{
  "success": true,
  "result": {
    "files_processed": 25,
    "files_moved": 20,
    "files_skipped": 3,
    "errors": 2
  },
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

### Web Scraping

**POST** `/scrape-website`

Scrapes content from websites using BeautifulSoup or Selenium.

**Request Body:**
```json
{
  "url": "https://example.com",
  "selector": ".content",
  "dynamic": false
}
```

**Parameters:**
- `url` (required): Website URL to scrape
- `selector` (optional): CSS selector for content extraction
- `dynamic` (optional): Use Selenium for JavaScript-heavy sites

**Response:**
```json
{
  "success": true,
  "url": "https://example.com",
  "status_code": 200,
  "data": ["extracted", "content", "array"],
  "error": null,
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

### Email Sending

**POST** `/send-email`

Sends emails using SMTP with template support.

**Request Body:**
```json
{
  "to": "recipient@example.com",
  "subject": "Test Email",
  "body": "<h1>Hello World</h1>",
  "is_html": true,
  "cc": ["cc@example.com"],
  "bcc": ["bcc@example.com"],
  "smtp_config": {
    "server": "smtp.gmail.com",
    "port": 587,
    "username": "sender@gmail.com",
    "password": "app-password",
    "use_tls": true
  }
}
```

**Parameters:**
- `to` (required): Recipient email address(es)
- `subject` (required): Email subject
- `body` (required): Email body content
- `is_html` (optional): Whether body is HTML
- `cc` (optional): CC recipients
- `bcc` (optional): BCC recipients
- `smtp_config` (required): SMTP server configuration

**Response:**
```json
{
  "success": true,
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

### Data Processing

**POST** `/process-data`

Processes data using various transformation rules.

**Request Body:**
```json
{
  "type": "transform",
  "data": [
    {"name": "John", "age": 30, "score": 85},
    {"name": "Jane", "age": 25, "score": 92}
  ],
  "rules": {
    "name": {"transform": "uppercase"},
    "score": {"transform": "multiply", "factor": 1.1}
  }
}
```

**Processing Types:**
- `transform`: Apply transformation rules to data
- `filter`: Filter data based on conditions
- `aggregate`: Aggregate data (count, sum, average)

**Response:**
```json
{
  "success": true,
  "result": [
    {"name": "JOHN", "age": 30, "score": 93.5},
    {"name": "JANE", "age": 25, "score": 101.2}
  ],
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

### Custom Functions

**POST** `/custom-function`

Executes custom Python functions with provided arguments.

**Request Body:**
```json
{
  "function": "calculate_age",
  "args": {
    "birth_date": "1990-01-01"
  }
}
```

**Available Functions:**
- `calculate_age`: Calculate age from birth date
- `format_phone`: Format phone numbers
- Custom functions can be added to the webhook server

**Response:**
```json
{
  "success": true,
  "result": {"age": 35},
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

## Error Handling

All endpoints return consistent error responses:

```json
{
  "success": false,
  "error": "Error message describing what went wrong",
  "timestamp": "2025-07-14T19:56:12.844Z"
}
```

**Common HTTP Status Codes:**
- `200`: Success
- `400`: Bad Request (invalid parameters)
- `500`: Internal Server Error

## Rate Limiting

Currently, no rate limiting is implemented. For production use, consider:
- Request rate limiting per IP
- Concurrent request limits
- Resource usage monitoring

## Examples

### cURL Examples

```bash
# Health check
curl -X GET http://localhost:5000/health

# Organize files
curl -X POST http://localhost:5000/organize-files \
  -H "Content-Type: application/json" \
  -d '{
    "directory": "/home/user/Downloads",
    "dry_run": true
  }'

# Scrape website
curl -X POST http://localhost:5000/scrape-website \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://news.ycombinator.com",
    "selector": ".titleline > a"
  }'
```

### Python Examples

```python
import requests

# Organize files
response = requests.post('http://localhost:5000/organize-files', json={
    'directory': '/home/user/Downloads',
    'dry_run': True
})

if response.status_code == 200:
    result = response.json()
    print(f"Organized {result['result']['files_moved']} files")
else:
    print(f"Error: {response.json()['error']}")
```

### n8n HTTP Request Node

```json
{
  "method": "POST",
  "url": "http://python-webhook:5000/organize-files",
  "sendBody": true,
  "contentType": "json",
  "jsonBody": "={\n  \"directory\": \"{{ $json.directory }}\",\n  \"dry_run\": {{ $json.dry_run }}\n}"
}
```

## Security Considerations

### Production Deployment

1. **Enable Authentication**
   ```python
   # Add API key validation
   @app.before_request
   def require_api_key():
       if request.endpoint != 'health':
           api_key = request.headers.get('X-API-Key')
           if not api_key or api_key != os.getenv('API_KEY'):
               abort(401)
   ```

2. **Input Validation**
   ```python
   from cerberus import Validator
   
   schema = {
       'directory': {'type': 'string', 'required': True},
       'dry_run': {'type': 'boolean', 'default': True}
   }
   
   validator = Validator(schema)
   if not validator.validate(request.json):
       return jsonify({'error': validator.errors}), 400
   ```

3. **HTTPS Only**
   - Use SSL/TLS certificates
   - Redirect HTTP to HTTPS
   - Set secure headers

4. **Network Security**
   - Use firewalls
   - Implement IP whitelisting
   - VPN or private networks

## Monitoring and Logging

### Health Monitoring

```bash
# Check service health
curl -f http://localhost:5000/health || exit 1
```

### Log Analysis

Logs are written to:
- Console output
- `./logs/automation.log` (if configured)

**Log Format:**
```
2025-07-14 19:56:12,844 - automation.webhook - INFO - Processing file organization request
2025-07-14 19:56:13,123 - automation.file_management - INFO - Organized 15 files successfully
```

---

*For more information, see the [main documentation](../README.md) or [GitHub repository](https://github.com/ManSaint/python-automation-examples).*
