# Set PowerShell as the default shell for Windows
set windows-powershell := true

# Environment variables for development
export UV_HTTP_TIMEOUT := "10000"
export COVERAGE_CORE := "sysmon"
export PYTHONDONTWRITEBYTECODE := "1"

# Display available commands
default:
    @just --list --unsorted

# ===================================
# Development Environment Management
# ===================================

# Install project dependencies and development tools
[group('Development Environment')]
install:
    @echo "Installing project dependencies..."
    uv sync --all-packages
    @echo "Installing pre-commit hooks..."
    pre-commit install --install-hooks

# Update all project dependencies to latest versions
[group('Development Environment')]
upgrade:
    @echo "Updating dependency lock file..."
    uv lock --upgrade
    @echo "Updating pre-commit hooks..."
    pre-commit autoupdate

# =====================
# Code Quality & Testing
# =====================

# Auto-format source code using Ruff
[group('Code Quality')]
format:
    @echo "Fixing code style issues..."
    uv run ruff check --fix .
    @echo "Formatting code..."
    uv run ruff format .

# Lint Python source files for code quality issues
[group('Code Quality')]
lint:
    @echo "Checking code style and quality..."
    uv run ruff check .
    uv run ruff format --check .

# Perform static type checking with MyPy
[group('Code Quality')]
typecheck:
    @echo "Running type checks..."
    uv run mypy .

# Run unit tests (excluding slow tests)
[group('Testing')]
test:
    @echo "Running test suite..."
    uv run pytest -m "not slow"

# Run comprehensive quality checks (lint + typecheck + test)
[group('Code Quality')]
check: lint typecheck test

# Run performance benchmarks
[group('Testing')]
benchmark:
    @echo "Running benchmark tests..."
    uv run pytest --benchmark-only

# Run slow integration tests
[group('Testing')]
test-slow:
    @echo "Running slow tests..."
    uv run pytest -m "slow"

# Run complete test suite including slow tests
[group('Testing')]
test-all:
    @echo "Running complete test suite..."
    uv run pytest

# ===================
# Maintenance & Cleanup
# ===================

# Remove build artifacts and cache files
[group('Maintenance')]
clean:
    @echo "Cleaning build artifacts and cache files..."
    -rm -rf dist
    -rm -rf .cache
    -rm -rf .hypothesis
    -rm -rf .pytest_cache
    -rm -rf .mypy_cache
    -rm -rf .ruff_cache
    @powershell -Command "Get-ChildItem -Path . -Name '__pycache__' -Recurse -Force | Remove-Item -Recurse -Force"
    @powershell -Command "Get-ChildItem -Path . -Filter '*.pyc' -Recurse -Force | Remove-Item -Force"
    @powershell -Command "Get-ChildItem -Path . -Filter '*.pyo' -Recurse -Force | Remove-Item -Force"

# Deep clean including dependency cache
[group('Maintenance')]
clean-all: clean
    @echo "Performing deep clean..."
    uv cache clean

# Display project information and environment status
[group('Information')]
info:
    @echo "Project Information:"
    @echo "==================="
    @uv --version
    @python --version
    @echo "UV cache location: $(uv cache dir)"
    @echo "Active Python interpreter: $(uv run python -c 'import sys; print(sys.executable)')"
