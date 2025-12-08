# Development history and contributions

This section summarizes the development history of the sparse-intermediate
representation (sparse-IR) ecosystem and acknowledges the main contributors.

## Predecessor: irbasis

Before sparse-ir and SparseIR.jl, the **irbasis** library {cite:p}`irbasis2019`
provided precomputed, tabulated intermediate-representation (IR) basis
functions. In irbasis, the IR basis functions were obtained by solving the
integral equation for each choice of the cutoff parameter $\Lambda = \beta \omega_\mathrm{max}$
with high precision, and the results were stored in a database.
Users could then load these tabulated basis functions and use them directly
in their calculations.

The sparse-ir family of libraries generalizes this idea by computing the basis
functions **on the fly** for arbitrary $\Lambda$, without relying on a fixed
precomputed database.

## First implementation of on-the-fly basis construction (sparse-ir 1.x, SparseIR.jl 1.x)

The original Python implementation **sparse-ir 1.x** was mainly developed by
**Markus Wallerberger**. It was the first implementation that constructed the
IR basis functions **on the fly** for arbitrary cutoff $\Lambda$, without
relying on a precomputed database. This provided a practical and widely used
realization of the intermediate representation for imaginary-time Green's
functions.

The Julia port **SparseIR.jl 1.x** was then developed primarily by
**Samuel Badr** and **Markus Wallerberger**. Both the Python and Julia
implementations received contributions from **Hiroshi Shinaoka**.

The tutorials for these libraries were developed collaboratively by the three
authors above and many physicists listed in the contributor list below.

## Portable and universal low-level implementation

Since around 2024, the focus has shifted towards building a **portable and
universal low-level implementation** that can be used from multiple languages
via a common C-compatible API.

An important application that motivated this direction is the work of
{cite:p}`Mori2024`, where IR-based quantities were computed with
**sparse-ir (Python)** and the resulting data were saved to files and
consumed by the EPW code ([EPW website](https://epw-code.org)).
This workflow made it clear that having a low-level library which can
compute IR basis functions **on the fly in any language** via a stable C API
would be highly beneficial.

As a first step, a C++ prototype library [`libsparseir`][libsparseir] was
developed by **Satoshi Terasaki** and **Hiroshi Shinaoka**. This attempt
explored how to expose IR functionality through a C API, but was not released
as a long-term, production-quality solution.

The project then migrated to Rust as [`sparse-ir-rs`][sparse-ir-rs], again led
by **Satoshi Terasaki** and **Hiroshi Shinaoka**. The new versions

- **SparseIR.jl 2.x** (Julia)
- **sparse-ir 2.x** (Python)

are designed as high-level wrappers around this Rust implementation.
The move from C++ to Rust was motivated by improved portability and
maintainability, while still exposing a C-compatible API that can be used
from C, C++, Fortran, Python, Julia, and other languages.

For high-precision computations, **sparse-ir-rs** uses the emulated
quadruple-precision backend provided by the Rust crate
[`xprec-rs`][xprec-rs], which was developed in parallel by
**Markus Wallerberger**.

The Fortran bindings to the Rust implementation were developed by
**Hitoshi Mori** in collaboration with **Satoshi Terasaki** and
**Hiroshi Shinaoka**.

[libsparseir]: https://github.com/SpM-lab/libsparseir
[sparse-ir-rs]: https://github.com/SpM-lab/sparse-ir-rs
[xprec-rs]: https://github.com/tuwien-cms/xprec-rs

## Contributors

The sparse-IR ecosystem (libraries and tutorials) has benefitted from the
contributions of many researchers. The following list collects the main
contributors in alphabetical order (by family name):

- **Samuel Badr** (TU Wien)
- **Shintaro Hoshino** (Saitama Univ.)
- **Fumiya Kakizawa** (Saitama Univ.)
- **Takashi Koretsune** (Tohoku Univ.)
- **Hitoshi Mori** (Riken)
- **Yuki Nagai** (JAEA, Riken)
- **Kosuke Nogaki** (Kyoto Univ.)
- **Takuya Nomoto** (Univ. Tokyo)
- **Junya Otsuki** (Okayama Univ.)
- **Soshun Ozaki** (Univ. Tokyo)
- **Rihito Sakurai** (Saitama Univ.)
- **Hiroshi Shinaoka** (Saitama Univ.)
- **Satoshi Terasaki** (AtelierArith)
- **Constanze Vogel** (TU Wien)
- **Markus Wallerberger** (TU Wien)
- **Niklas Witt** (Univ. Hamburg)
- **Kazuyoshi Yoshimi** (ISSP)

If you find that your contribution is missing or incorrectly described,
please feel free to open an issue or pull request on the documentation
repository.
