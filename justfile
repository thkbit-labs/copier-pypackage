# -------------------------
# Lint, format and run test
# -------------------------

# Auto-format source files
[group('Lint, format and run test')]
format:
    uv run ruff check --fix .
    uv run ruff format .

# Perform type-checking
[group('Lint, format and run test')]
typecheck:
    uv run mypy .

# Run all tests
[group('Lint, format and run test')]
test:
    uv run pytest -m "not slow"
# Auto test when files change
watch:
    ptw  # ptw = pytest-watch

# Commit and push
commit MESSAGE="update":
    git add .
    git commit -m "{{MESSAGE}}"
    git push

# Pull from remote
pull:
    git pull

# Push to remote
push:
    git push

# Create and switch to a new branch
branch NAME:
    git checkout -b "{{NAME}}"

# Switch branch
switch NAME:
    git checkout "{{NAME}}"

# Merge a branch
merge NAME:
    git merge "{{NAME}}"

# Show git status
status:
    git status

# View git log
log:
    git log --oneline --graph --all
