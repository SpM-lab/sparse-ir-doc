build:
	@echo "Installing Python packages..."
	uv sync
	@echo "Building HTML files..."
	. .venv/bin/activate && jupyter book build --all -v .

clean:
	rm -rf _build
