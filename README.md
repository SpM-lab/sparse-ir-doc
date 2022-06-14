# sparse-ir

## Author guideline

* In Markdown cells, use the `$$`, `$$ $$` environments for equations.
* References are listed in the markdown cell at the bottom of each notebook.
* Remove all outputs in a jupyter notebook.

## Set up tools

```bash
pip3 install jupyter-book ghp-import jupytext
```

## Set up VS code + Docker
We strongly recommend to use VSCode + Docker to build HTML files.

1. Make sure you have Docker and VSCode installed.

2. Install the ``Remote - Containers`` in VSCode Extensions.

3. Go to the repository and open it in VS Code.

```
cd /path/to/this/repository

code .
```

4. To use Docker with VS Code, execute the following command.

```
ln -s .dev/devcontainer .devcontainer
```

5. Press the green mark at the bottom left and press `` Reopen in Container`` from the command palette.
   After the build is finished, you can enter the Docker container.

6. Open a new terminal and execute `./bin/install_sparseir ` to install `sparse-ir`, `xprec`, `SparseIR.jl` packages, whose versions are specified in `requirements.txt` and `Manifest.toml`.

7. Build html files

The following command builds html files, which takes a few minutes.

```bash
make build
```

8. Upload html files

```bash
make upload
```

## Update the specified versions of `sparse-ir`, `xprec`, `SparseIR.jl`
* For Python, edit `requirements.txt` manually.
* For Julia, use the package mode to update the package. Note that in the container, the `julia` command is aliased to `julia --project=@.`.


## Binder
mybinder reads `requirements.txt` and `Project.toml`.

## References
You can add references to `references.bib`.

## Trouble shooting

* https://github.com/executablebooks/jupyter-book/issues/1541
