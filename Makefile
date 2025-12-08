build:
	@echo "Installing Python packages..."
	uv sync
	@echo "Installing Julia packages..."
	julia --project=@. --startup-file=no -e "import Pkg;Pkg.instantiate()"
	@echo "Building HTML files..."
	. .venv/bin/activate && jupyter book build --all -v .

clean:
	rm -rf _build
