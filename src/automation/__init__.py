"""
Python Automation Examples Package

A comprehensive collection of automation scripts and utilities.
"""

__version__ = "1.0.0"
__author__ = "ManSaint"
__email__ = "automation@example.com"
__description__ = "Python automation examples following modern best practices"

# Import main automation modules
from . import file_management
from . import web_automation
from . import email_automation
from . import data_processing
from . import system_monitoring
from . import homelab
from . import n8n_integration

__all__ = [
    "file_management",
    "web_automation", 
    "email_automation",
    "data_processing",
    "system_monitoring",
    "homelab",
    "n8n_integration"
]
