build:
	@echo "Installing Python packages..."
	uv sync
	@echo "Building HTML files..."
	uv run jupyter book build --html

clean:
	rm -rf _build
