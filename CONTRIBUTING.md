# Contributing to Python Automation Examples

We welcome contributions to the Python Automation Examples project! This document provides guidelines for contributing.

## 🤝 How to Contribute

### Reporting Issues

- Use the [GitHub issue tracker](https://github.com/ManSaint/python-automation-examples/issues)
- Search existing issues before creating a new one
- Provide detailed information including:
  - Python version
  - Operating system
  - Error messages and stack traces
  - Steps to reproduce

### Submitting Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/python-automation-examples.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding standards below
   - Add tests for new functionality
   - Update documentation as needed

4. **Test your changes**
   ```bash
   pytest tests/
   black src/ tests/
   flake8 src/ tests/
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: descriptive commit message"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Use a descriptive title
   - Explain what your changes do
   - Reference any related issues

## 📝 Coding Standards

### Python Style

- Follow [PEP 8](https://pep8.org/) style guidelines
- Use [Black](https://black.readthedocs.io/) for code formatting
- Use [isort](https://pycqa.github.io/isort/) for import sorting
- Maximum line length: 127 characters

### Documentation

- Write clear docstrings for all functions and classes
- Use Google-style docstrings
- Include type hints
- Add inline comments for complex logic

### Example Function Documentation

```python
def process_data(data: List[Dict], filters: Optional[Dict] = None) -> List[Dict]:
    """Process data according to specified filters.
    
    Args:
        data: List of dictionaries containing data to process
        filters: Optional dictionary of filter criteria
        
    Returns:
        Filtered and processed data
        
    Raises:
        ValueError: If data format is invalid
        
    Example:
        >>> data = [{'name': 'John', 'age': 30}, {'name': 'Jane', 'age': 25}]
        >>> filters = {'min_age': 26}
        >>> process_data(data, filters)
        [{'name': 'John', 'age': 30}]
    """
    # Implementation here
    pass
```

### Testing

- Write unit tests for all new functionality
- Use pytest for testing framework
- Aim for >80% code coverage
- Test both success and failure cases
- Use mocking for external dependencies

### Example Test

```python
import pytest
from unittest.mock import Mock, patch

from src.automation.example import ExampleClass


class TestExampleClass:
    """Test cases for ExampleClass."""
    
    @pytest.fixture
    def example_instance(self):
        """Create ExampleClass instance for testing."""
        return ExampleClass()
    
    def test_method_success(self, example_instance):
        """Test successful method execution."""
        result = example_instance.method("test_input")
        assert result == "expected_output"
    
    def test_method_failure(self, example_instance):
        """Test method with invalid input."""
        with pytest.raises(ValueError):
            example_instance.method(None)
    
    @patch('src.automation.example.external_dependency')
    def test_method_with_mock(self, mock_dependency, example_instance):
        """Test method with mocked external dependency."""
        mock_dependency.return_value = "mocked_result"
        result = example_instance.method_with_dependency()
        assert result == "expected_result"
        mock_dependency.assert_called_once()
```

## 🏗️ Project Structure

### Adding New Automation Categories

1. Create a new directory under `src/automation/`
2. Add `__init__.py` with module exports
3. Implement your automation classes
4. Add tests in `tests/test_[category]/`
5. Create examples in `examples/`
6. Update documentation

### File Organization

```
src/automation/new_category/
├── __init__.py          # Module exports
├── main_class.py        # Primary functionality
├── helpers.py           # Helper functions
└── exceptions.py        # Custom exceptions

tests/test_new_category/
├── __init__.py
├── test_main_class.py   # Main class tests
└── test_helpers.py      # Helper function tests

examples/
└── new_category_example.py  # Usage examples
```

## 🔍 Code Review Process

### What We Look For

- **Functionality**: Does the code work as intended?
- **Code Quality**: Is it readable, maintainable, and well-structured?
- **Testing**: Are there adequate tests with good coverage?
- **Documentation**: Is the code well-documented?
- **Performance**: Are there any obvious performance issues?
- **Security**: Are there any security vulnerabilities?

### Review Checklist

- [ ] Code follows Python style guidelines
- [ ] All tests pass
- [ ] New functionality is tested
- [ ] Documentation is updated
- [ ] No security vulnerabilities
- [ ] Performance is acceptable
- [ ] Error handling is appropriate
- [ ] Code is maintainable

## 🚀 Development Setup

### Prerequisites

- Python 3.9+
- Git
- Virtual environment tool

### Setup Development Environment

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/python-automation-examples.git
cd python-automation-examples

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install -r requirements/dev.txt

# Install pre-commit hooks
pre-commit install

# Run setup script
python scripts/setup.py

# Verify installation
pytest tests/
```

### Running Quality Checks

```bash
# Format code
black src/ tests/ examples/
isort src/ tests/ examples/

# Lint code
flake8 src/ tests/ examples/
pylint src/

# Type checking
mypy src/

# Security check
bandit -r src/

# Run all tests
pytest tests/ --cov=src --cov-report=html

# Run specific test category
pytest tests/test_file_management/
```

## 📋 Issue Templates

### Bug Report

```markdown
**Bug Description**
A clear description of the bug.

**To Reproduce**
1. Step 1
2. Step 2
3. See error

**Expected Behavior**
What you expected to happen.

**Environment**
- OS: [e.g., Ubuntu 20.04]
- Python Version: [e.g., 3.11.2]
- Package Version: [e.g., 1.0.0]

**Additional Context**
Any other context about the problem.
```

### Feature Request

```markdown
**Feature Description**
A clear description of the proposed feature.

**Use Case**
Why this feature would be useful.

**Proposed Implementation**
How you think this could be implemented.

**Additional Context**
Any other context or screenshots.
```

## 🏷️ Commit Message Guidelines

### Format

```
<type>: <description>

[optional body]

[optional footer]
```

### Types

- **Add**: New features or functionality
- **Fix**: Bug fixes
- **Update**: Updates to existing functionality
- **Remove**: Removing code or features
- **Docs**: Documentation changes
- **Test**: Adding or updating tests
- **Refactor**: Code refactoring
- **Style**: Formatting changes
- **CI**: CI/CD changes

### Examples

```
Add: file organization automation with custom rules

Implemented FileOrganizer class with support for:
- Custom organization rules
- Date-based organization
- Duplicate file handling
- Dry run mode

Closes #123
```

```
Fix: email sender connection timeout issue

Increased SMTP connection timeout from 10s to 30s
and added retry logic for transient failures.

Fixes #456
```

## 🎯 Areas for Contribution

### High Priority

- 🐛 Bug fixes
- 📚 Documentation improvements
- 🧪 Test coverage improvements
- 🔧 Performance optimizations

### Medium Priority

- ✨ New automation examples
- 🔌 Additional integrations (Slack, Discord, etc.)
- 🌐 Web scraping improvements
- 📊 Data processing enhancements

### Low Priority

- 🎨 UI improvements for examples
- 📱 Mobile compatibility
- 🌍 Internationalization
- 🚀 Advanced features

## 📞 Getting Help

- 💬 [GitHub Discussions](https://github.com/ManSaint/python-automation-examples/discussions) for questions
- 🐛 [Issue Tracker](https://github.com/ManSaint/python-automation-examples/issues) for bugs
- 📧 Email: automation@example.com for private inquiries

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Standards

**Positive Behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable Behavior:**
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project team at automation@example.com. All complaints will be reviewed and investigated promptly and fairly.

---

Thank you for contributing to Python Automation Examples! 🎉
