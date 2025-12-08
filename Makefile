build:
	@echo "Installing Python packages..."
	uv sync
	@echo "Building HTML files..."
	uv run jupyter book build --all .

serve:
	@echo "Serving _build/html on http://localhost:8000"
	python -m http.server 8000 -d _build/html

clean:
	rm -rf _build
