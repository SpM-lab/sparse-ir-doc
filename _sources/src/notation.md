# Notation and conventions

This page fixes the notation used by this document, the
[tutorials](https://spm-lab.github.io/sparse-ir-tutorial-v2) and the
documentation of the three libraries. There are three libraries:
- the Rust crate and its C API ([sparse-ir-rs](https://github.com/SpM-lab/sparse-ir-rs));
- the Python library ([sparse-ir](https://github.com/SpM-lab/sparse-ir));
- the Julia library ([SparseIR.jl](https://github.com/SpM-lab/SparseIR.jl)).

All three implement the conventions below. The table at the end maps each symbol to its name in each library.

## Statistics

$\zeta$ is the parity of the statistics: $\zeta = 1$ for fermions and $\zeta = 0$ for bosons.

In the libraries:

| Library | How ζ appears |
|---|---|
| SparseIR.jl | `SparseIR.zeta(stat)` |
| Python | the `zeta` attribute of `basis.uhat` |
| C API | the statistics constants `SPIR_STATISTICS_FERMIONIC = 1` and `SPIR_STATISTICS_BOSONIC = 0` |

A shift by $\beta$ multiplies a function by $(-1)^\zeta$: $-1$ for fermions and $+1$ for bosons.

## Imaginary time

Physics formulas are written for $0 < \tau < \beta$. A function of $\tau$ is extended to $[-\beta, \beta]$ by

$$
f(\tau + \beta) = (-1)^\zeta f(\tau).
$$

The libraries evaluate functions of $\tau$ for $\tau \in [-\beta, \beta]$ and raise an error outside this range. The inputs $0$ and $\pm\beta$ are one-sided limits. In floating point the sign of zero matters, and the libraries read the endpoints as follows:

| input | read as | value |
|---|---|---|
| `+0.0` | $0^+$ | $f(0^+)$ |
| `beta` | $\beta^-$ | $f(\beta^-)$ |
| `-0.0` | $0^-$ | $(-1)^\zeta f(\beta^-)$ |
| `-beta` | $(-\beta)^+$ | $(-1)^\zeta f(0^+)$ |

Consider a single-particle Green's function of elementary operators, $G(\tau) = -\langle T_\tau c(\tau) c^\dagger(0) \rangle$. It jumps by $G(0^+) - G(0^-) = -1$ for **both** statistics, so $G(0^+) - (-1)^\zeta G(\beta^-) = -1$. See [the periodicity note](tau_periodicity.md) for details.

## Matsubara frequencies

Matsubara frequencies are written $\mathrm{i}\nu$ with an upright $\mathrm{i}$; the letter $\omega$ is reserved for real frequencies. All libraries take the **reduced frequency** $n$, an integer with $n \equiv \zeta \pmod 2$ (odd for fermions, even for bosons):

$$
\nu = \frac{n \pi}{\beta}.
$$

Where the ordinary Matsubara index $m$ is needed, it is written explicitly: $n = 2m + \zeta$, i.e. $\nu = (2m + \zeta)\pi/\beta$. The letter $n$ always means the reduced frequency. Where fermionic and bosonic frequencies appear together, they are written $\mathrm{i}\nu^\mathrm{F}$ and $\mathrm{i}\nu^\mathrm{B}$.

## Fourier transform

The same letter denotes a function and its Fourier transform; the argument tells them apart:

$$
G(\mathrm{i}\nu) = \int_0^\beta d\tau\, e^{\mathrm{i}\nu\tau} G(\tau), \qquad
G(\tau) = \frac{1}{\beta} \sum_{\nu} e^{-\mathrm{i}\nu\tau} G(\mathrm{i}\nu).
$$

A Matsubara sum whose summand decays like $1/(\mathrm{i}\nu)$ needs a convergence factor: $e^{\mathrm{i}\nu 0^+}$ gives the value at $\tau = 0^-$, and $e^{\mathrm{i}\nu 0^-}$ that at $\tau = 0^+$. See [Matsubara sums](matsubarasum.md).

## Green's function and spectral function

For both statistics,

$$
G(\tau) = -\langle T_\tau c(\tau) c^\dagger(0) \rangle, \qquad
G(\mathrm{i}\nu) = \int d\omega\, \frac{A(\omega)}{\mathrm{i}\nu - \omega},
$$

with $A(\omega) = -\frac{1}{\pi} \mathrm{Im}\, G^\mathrm{R}(\omega)$ for a diagonal component. In imaginary time,

$$
G(\tau) = -\int_{-\omega_\mathrm{max}}^{\omega_\mathrm{max}} d\omega\, K^\mathrm{L}(\tau, \omega) \rho(\omega),
\qquad
\rho(\omega) =
\begin{cases}
A(\omega) & \text{fermions},\\
A(\omega)/\tanh(\beta\omega/2) & \text{bosons}.
\end{cases}
$$

## Kernels

The logistic kernel is the default kernel for both statistics:

$$
K^\mathrm{L}(\tau, \omega) = \frac{e^{-\tau\omega}}{1 + e^{-\beta\omega}}.
$$

It is written with the dimensionless variables and cutoff

$$
\Lambda = \beta\omega_\mathrm{max}, \qquad
x = \frac{2\tau}{\beta} - 1 \in [-1, 1], \qquad
y = \frac{\omega}{\omega_\mathrm{max}} \in [-1, 1].
$$

The same kernel in these variables is

$$
K^\mathrm{L}(x, y) = \frac{e^{-\Lambda y (x + 1)/2}}{1 + e^{-\Lambda y}}.
$$

The regularized bosonic kernel is **deprecated**:

$$
K^\mathrm{B}(\tau, \omega) = \frac{\omega\, e^{-\tau\omega}}{1 - e^{-\beta\omega}} = \omega_\mathrm{max} K^\mathrm{B}(x, y).
$$

It acts on $A(\omega)/\omega$. This is the definition of the irbasis paper, N. Chikano et al., Computer Physics Communications 240, 181 (2019). libsparseir releases without the fix of [sparse-ir-rs#273](https://github.com/SpM-lab/sparse-ir-rs/issues/273) scale the singular values of its bases by $\omega_\mathrm{max}^{-1}$ instead of $\omega_\mathrm{max}^{+1}$.

## IR basis

The IR basis is the singular value expansion of the kernel:

$$
K^\mathrm{L}(\tau, \omega) = \sum_{l=0}^{\infty} U_l(\tau)\, S_l\, V_l(\omega),
\qquad S_0 \ge S_1 \ge \cdots > 0.
$$

- **Normalization:** $U_l$ is orthonormal on $[0, \beta]$, and $V_l$ on $[-\omega_\mathrm{max}, \omega_\mathrm{max}]$.
- **Sign:** fixed by $U_l(\beta^-) > 0$.
- **Symmetries:** $U_l(\beta - \tau) = (-1)^l U_l(\tau)$ and $V_l(-\omega) = (-1)^l V_l(\omega)$.
- **Shared basis:** with the logistic kernel, fermions and bosons share $U_l$, $S_l$ and $V_l$; only the Matsubara transform below differs.
- **Truncation:** a basis keeps $l = 0, \ldots, L-1$, the functions with $S_l/S_0 \ge \varepsilon$; $L$ is the basis size. Julia indexes from 1, so `basis.u[l+1]` is $U_l$.

The Matsubara transform of the basis functions is

$$
\hat U_l(\mathrm{i}\nu) = \int_0^\beta d\tau\, e^{\mathrm{i}\nu\tau} U_l(\tau).
$$

The hat marks only this transform of the basis functions. For fermions, $\hat U_l(\mathrm{i}\nu)$ is purely imaginary for even $l$ and real for odd $l$; for bosons it is the other way round.

A Green's function is expanded as

$$
G(\tau) \approx \sum_{l=0}^{L-1} G_l U_l(\tau), \qquad
G(\mathrm{i}\nu) \approx \sum_{l=0}^{L-1} G_l \hat U_l(\mathrm{i}\nu), \qquad
G_l = -S_l \rho_l, \quad \rho_l = \int d\omega\, \rho(\omega) V_l(\omega).
$$

In the dimensionless form, $K^\mathrm{L}(x, y) = \sum_l s_l u_l(x) v_l(y)$, with $u_l$ and $v_l$ orthonormal on $[-1, 1]$. It is related to the physical form by

$$
U_l(\tau) = \sqrt{2/\beta}\, u_l(x), \qquad
V_l(\omega) = \sqrt{1/\omega_\mathrm{max}}\, v_l(y), \qquad
S_l = \sqrt{\beta\omega_\mathrm{max}/2}\, s_l.
$$

For the regularized bosonic kernel, $S_l = \sqrt{\beta\omega_\mathrm{max}^3/2}\, s_l$.

## Sampling points

**Imaginary time.** The default points are the roots of $U_L$, the first function beyond the basis.
- The libraries return them in $(0, \beta)$ (`use_positive_taus=True`, the default). Reversing the array then maps $\tau$ to $\beta - \tau$.
- Unfolded, they lie in $(-\beta/2, \beta/2]$: pairs $\pm\tau$, plus $\beta/2$ when their number is odd.
  Reversing the unfolded points therefore maps $\tau$ to $-\tau$ only for an even number.

**Matsubara frequencies.** The default points are the sign changes of the first discarded transform $\hat U_l$, with $l \ge L$ chosen to fit the parity. Bosonic sets always include $n = 0$.

**Custom points** may be given in any order; evaluation and fitting follow the order given.

**`positive_only`.** It asserts $G(-\mathrm{i}\nu) = G(\mathrm{i}\nu)^*$ (real IR coefficients) and samples only $n \ge 0$. Bosonic sets include $n = 0$.

## Discrete Lehmann representation (DLR)

The DLR writes the spectral function as $\rho(\omega) = \sum_p c_p \delta(\omega - \bar\omega_p)$ for both statistics. The poles $\bar\omega_p$ are by default the roots of $V_L$. Then

$$
G(\tau) = \sum_p c_p u_p(\tau), \qquad u_p(\tau) = -K^\mathrm{L}(\tau, \bar\omega_p),
$$

and

$$
\hat u_p(\mathrm{i}\nu) =
\begin{cases}
\dfrac{1}{\mathrm{i}\nu - \bar\omega_p} & \text{fermions},\\[2ex]
\dfrac{\tanh(\beta\bar\omega_p/2)}{\mathrm{i}\nu - \bar\omega_p} & \text{bosons}.
\end{cases}
$$

- **Spectral weights:** for bosons, $A(\omega) = \sum_p c_p \tanh(\beta\bar\omega_p/2)\, \delta(\omega - \bar\omega_p)$.
- **Coefficients:** they transform as $G_l = -S_l \sum_p V_l(\bar\omega_p)\, c_p$.
- **Name:** the method is called DLR; the name SPR is not used.

## Names in the libraries

| Symbol | Meaning | Python (`sparse_ir`) | Julia (`SparseIR`) | Rust / C API |
|---|---|---|---|---|
| $\beta$ | inverse temperature | `beta` | `β` (argument), `SparseIR.β(basis)` | `beta` |
| $\omega_\mathrm{max}$ | frequency cutoff | `wmax` | `ωmax` | `omega_max` |
| $\Lambda$ | $\beta\omega_\mathrm{max}$ | `lambda_` | `Λ`, `SparseIR.Λ(basis)` | `lambda` |
| $\varepsilon$ | cutoff on $S_l/S_0$ | `eps` (optional) | `ε` (positional) | `epsilon` |
| statistics | fermions / bosons | `'F'` / `'B'` | `Fermionic()` / `Bosonic()` | `SPIR_STATISTICS_FERMIONIC` / `_BOSONIC` |
| $\zeta$ | parity (1 F, 0 B) | `basis.uhat.zeta` | `SparseIR.zeta(stat)` | statistics constant |
| $U_l(\tau)$ | IR basis in $\tau$ | `basis.u[l](tau)` | `basis.u[l+1](τ)` | `spir_basis_get_u` |
| $S_l$ | singular values | `basis.s[l]` | `basis.s[l+1]` | `spir_basis_get_svals` |
| $V_l(\omega)$ | IR basis in $\omega$ | `basis.v[l](w)` | `basis.v[l+1](ω)` | `spir_basis_get_v` |
| $\hat U_l(\mathrm{i}\nu)$ | Matsubara transform | `basis.uhat[l](n)` | `basis.uhat[l+1](n)` | `spir_basis_get_uhat` |
| $n$ | reduced frequency | `int` | `Int`, `FermionicFreq(n)`, `BosonicFreq(n)` | `int64_t` |
| $G_l$ | IR coefficients | `gl` | `gl` | coefficient arrays |
| $\bar\omega_p$ | DLR poles | `dlr.sampling_points` | `dlr.poles`, `get_poles(dlr)` | `spir_dlr_get_poles` |
