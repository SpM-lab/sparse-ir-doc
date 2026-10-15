# The sparse-ir ecosystem

sparse-ir is a family of libraries for compact representations of imaginary-time Green's functions:
the intermediate representation (IR), the discrete Lehmann representation (DLR), sparse sampling, and minimal pole representations (MiniPole).
This site is the entry point for all of them: the theory, the history, the notation they share, and where to find each library's documentation.

The libraries are maintained by [SpM-lab](https://spm-lab.github.io/), which also develops tools for analytic continuation.

## Where to go

| If you want to … | Go to |
| --- | --- |
| know what IR, DLR and MiniPole are, where they came from, and which to use | [IR, DLR and MiniPole: history and comparison](src/history_comparison.md) |
| check a symbol or a sign convention, or find the matching name in a library | [Notation and conventions](src/notation.md) |
| learn the basics step by step | [Basic theory](src/greens_function.md): Green's functions, IR, sparse sampling, DLR |
| pick a library and find its installation guide, API reference and examples | [Libraries](src/libraries.md) |
| run worked examples (GW, DMFT, FLEX, TPSC, Eliashberg, analytic continuation) | [Python and Julia tutorial](https://spm-lab.github.io/sparse-ir-tutorial/), [Rust guide](https://spm-lab.github.io/sparse-ir-rs/) |

## The libraries at a glance

| Language | Library | Documentation |
| --- | --- | --- |
| Python | [sparse-ir](https://github.com/SpM-lab/sparse-ir) (`pip install sparse-ir`) | [sparse-ir.readthedocs.io](https://sparse-ir.readthedocs.io/) |
| Julia | [SparseIR.jl](https://github.com/SpM-lab/SparseIR.jl) (`] add SparseIR`) | [SparseIR.jl documentation](https://spm-lab.github.io/SparseIR.jl/stable/) |
| Rust, C, Fortran | [sparse-ir-rs](https://github.com/SpM-lab/sparse-ir-rs) (crates `sparse-ir`, `sparse-ir-capi`) | [Rust guide](https://spm-lab.github.io/sparse-ir-rs/) |

sparse-ir-rs is the shared backend: the Python and Julia libraries call its C API (libsparseir), and it ships the Fortran bindings.
New features land there first.

## Citing

If you use these libraries, please cite
M. Wallerberger *et al.*, sparse-ir: Optimal compression and sparse sampling of many-body propagators,
[SoftwareX 21, 101266 (2023)](https://doi.org/10.1016/j.softx.2022.101266),
and the papers on the methods you use, listed in [history and comparison](src/history_comparison.md).
