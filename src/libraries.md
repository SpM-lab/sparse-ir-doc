# Libraries

All libraries compute the same IR basis, DLR and sampling points, follow the [notation and conventions](notation.md), and share the backend in [sparse-ir-rs](https://github.com/SpM-lab/sparse-ir-rs).
Pick the one for your language.

## Python: sparse-ir

```bash
pip install sparse-ir
```

- Repository: [SpM-lab/sparse-ir](https://github.com/SpM-lab/sparse-ir)
- Documentation and API reference: [sparse-ir.readthedocs.io](https://sparse-ir.readthedocs.io/)
- Tutorial notebooks: [sparse-ir tutorial](https://spm-lab.github.io/sparse-ir-tutorial/) (the `_py` chapters)

## Julia: SparseIR.jl

```julia
] add SparseIR
```

- Repository: [SpM-lab/SparseIR.jl](https://github.com/SpM-lab/SparseIR.jl)
- Documentation and API reference: [SparseIR.jl documentation](https://spm-lab.github.io/SparseIR.jl/stable/)
- Tutorial notebooks: [sparse-ir tutorial](https://spm-lab.github.io/sparse-ir-tutorial/) (the `_jl` chapters)

## Rust: sparse-ir-rs

```toml
[dependencies]
sparse-ir = "0.13"
```

- Repository: [SpM-lab/sparse-ir-rs](https://github.com/SpM-lab/sparse-ir-rs)
- Guide and tutorials, including MiniPole and the applied examples: [Rust guide](https://spm-lab.github.io/sparse-ir-rs/).
  The Rust tutorials live in this guide, not in the Python and Julia tutorial.
- API reference: [docs.rs/sparse-ir](https://docs.rs/sparse-ir)

## C and C++

The C API is the `sparse-ir-capi` crate of sparse-ir-rs; it builds a shared library (libsparseir) and a C header.

- Building and usage: [sparse-ir-capi README](https://github.com/SpM-lab/sparse-ir-rs/blob/main/sparse-ir-capi/README.md)
- API reference: [docs.rs/sparse-ir-capi](https://docs.rs/sparse-ir-capi)

## Fortran

The Fortran bindings call the C API and are part of sparse-ir-rs.

- Building and usage: [Fortran README](https://github.com/SpM-lab/sparse-ir-rs/blob/main/fortran/README.md)
- Example: [second-order perturbation theory](https://github.com/SpM-lab/sparse-ir-rs/blob/main/fortran/examples/second_order_perturbation_fort.f90)

## Older libraries

irbasis, irlib, libsparseir, pysparseir, LibSparseIR.jl, sparse-ir-fortran and the tutorial for sparse-ir v1 are superseded by the libraries above.
The [SpM-lab home page](https://spm-lab.github.io/#archive) lists what replaces each of them.
