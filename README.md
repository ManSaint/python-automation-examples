# Python Automation Examples 🐍🤖

A comprehensive collection of Python automation examples following modern best practices, with homelab and n8n integration examples.

[![Python Version](https://img.shields.io/badge/python-3.9%2B-blue)](https://www.python.org/downloads/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Code Style](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

## 🎯 Overview

This repository provides a curated collection of Python automation scripts and examples, designed to help developers automate repetitive tasks, manage systems, and integrate with modern automation platforms like n8n. All examples follow Python best practices and PEP 8 standards.

## ✨ Features

- **🔧 Diverse Automation Examples**: File management, email automation, web scraping, system monitoring
- **📊 Data Processing**: CSV/Excel automation, data cleaning, and report generation  
- **🌐 Web Automation**: Selenium-based web automation with Page Object Model
- **📧 Communication**: Email automation, Slack integration, and notification systems
- **🏠 Homelab Integration**: Docker automation, system monitoring, and n8n workflows
- **🧪 Testing**: Comprehensive test coverage with pytest
- **📚 Documentation**: Detailed examples with inline documentation
- **🚀 CI/CD Ready**: GitHub Actions workflows for testing and deployment

## 🚀 Quick Start

### Prerequisites

- Python 3.9 or higher
- Git
- Virtual environment tool (venv, conda, or virtualenv)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ManSaint/python-automation-examples.git
   cd python-automation-examples
   ```

2. **Create and activate virtual environment**
   ```bash
   python -m venv venv
   
   # On Windows
   .\\venv\\Scripts\\activate
   
   # On macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements/dev.txt
   ```

4. **Run setup script**
   ```bash
   python scripts/setup.py
   ```

## 📁 Project Structure

```
python-automation-examples/
├── src/                          # Source code
│   ├── automation/               # Main automation modules
│   │   ├── file_management/      # File organization & processing
│   │   ├── web_automation/       # Web scraping & browser automation
│   │   ├── email_automation/     # Email handling & notifications
│   │   ├── data_processing/      # CSV, Excel, JSON processing
│   │   ├── system_monitoring/    # System health & performance
│   │   ├── homelab/             # Docker & infrastructure automation
│   │   └── n8n_integration/     # n8n workflow examples
│   └── common/                  # Shared utilities
├── examples/                    # Standalone example scripts
├── tests/                       # Test suite
├── docs/                        # Documentation
├── config/                      # Configuration files
├── requirements/                # Requirements files
├── scripts/                     # Setup and utility scripts
├── .github/                     # GitHub workflows
└── docker/                      # Docker configurations
```

## 🎭 Automation Categories

### 📁 File Management
- **File Organization**: Automatic file sorting by type, date, or custom rules
- **Batch Processing**: Rename, move, and organize files in bulk
- **File Monitoring**: Watch directories for changes and trigger actions
- **Backup Automation**: Automated backup solutions with compression

### 🌐 Web Automation
- **Web Scraping**: Beautiful Soup and Selenium examples
- **API Integration**: REST API automation and data collection
- **Browser Automation**: Selenium with Page Object Model pattern
- **Data Extraction**: Automated data collection from websites

### 📧 Email & Communication
- **Email Automation**: Send scheduled emails, process attachments
- **Slack Integration**: Automated notifications and bot interactions
- **SMS Automation**: Text message sending via various providers
- **Report Generation**: Automated HTML/PDF report creation

### 📊 Data Processing
- **CSV Automation**: Data cleaning, transformation, and analysis
- **Excel Integration**: Automated spreadsheet processing
- **Database Operations**: Automated database backups and maintenance
- **Data Validation**: Automated data quality checks

### 🖥️ System Monitoring
- **Health Checks**: System performance monitoring
- **Log Analysis**: Automated log parsing and alerting
- **Resource Monitoring**: CPU, memory, and disk usage tracking
- **Process Management**: Automated service management

### 🏠 Homelab Integration
- **Docker Automation**: Container management and deployment
- **Infrastructure Monitoring**: Server health and performance
- **Network Automation**: Network device configuration
- **Service Discovery**: Automated service registration

## 🔄 n8n Integration

This repository includes examples for integrating Python automation with n8n workflows:

- **Webhook Endpoints**: Python services that receive n8n webhooks
- **API Integration**: Python scripts that interact with n8n API
- **Data Processing**: Python functions called from n8n workflows
- **Custom Nodes**: Examples for creating custom n8n nodes

## 🛠️ Development

### Running Tests

```bash
# Run all tests
python -m pytest

# Run with coverage
python -m pytest --cov=src

# Run specific test category
python -m pytest tests/test_file_management/
```

### Code Formatting

```bash
# Format code with black
black src/ tests/

# Sort imports
isort src/ tests/

# Lint with flake8
flake8 src/ tests/
```

## 📚 Examples

Check out the `examples/` directory for practical demonstrations:

- `file_organization_example.py` - Automated file organization
- `web_scraping_example.py` - Web scraping techniques
- `email_automation_example.py` - Email automation
- `n8n_integration_example.py` - n8n workflow integration

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:

- Code of conduct
- Development process
- Submitting pull requests
- Reporting issues

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by "Automate the Boring Stuff with Python" by Al Sweigart
- Python community best practices and PEP guidelines
- n8n community for workflow automation inspiration

---

⭐ **Star this repository if you find it helpful!** ⭐

*Made with ❤️ for the automation community*
