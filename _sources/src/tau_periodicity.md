# Periodicity in imaginary time (Green's functions and basis functions)

$$
\newcommand{\iv}{{\mathrm{i}\nu}}
\newcommand{\dd}{{\mathrm{d}}}
$$

This note explains how sparse-ir handles (anti-)periodicity in imaginary time, including the treatment of boundary/special points.
The key idea is that the periodicity rule is a **statistical symmetry** and should be shared consistently by the Green's function \(G(\tau)\)
and any basis functions used to represent it (e.g. IR/DLR basis functions in \(\tau\)).

## (Anti-)periodicity rules

Imaginary-time Green's functions (and the corresponding basis functions) satisfy periodicity conditions that depend on statistics:

**Fermions (anti-periodic):**

$$
G(\tau + \beta) = -G(\tau)
$$

**Bosons (periodic):**

$$
G(\tau + \beta) = G(\tau)
$$

These conditions arise from the trace over the thermal density matrix and the (anti-)commutation relations of the operators.

It is convenient to introduce a sign factor \(\zeta\):

$$
\zeta =
\begin{cases}
 -1 & (\mathrm{fermion})\\
 +1 & (\mathrm{boson})
\end{cases}
$$

Then both cases are summarized as \(f(\tau+\beta)=\zeta f(\tau)\), where \(f\) may stand for \(G\) itself or a basis function.

## Special points and conventions in sparse-ir

For \(\tau\notin\{-\beta,0,\beta\}\), \(f(\tau)\) is evaluated using the statistical symmetry
\(f(\tau+\beta)=\zeta f(\tau)\) (with \(\zeta=-1\) for fermions and \(\zeta=+1\) for bosons).

At the special points \(\tau\in\{-\beta,0,\beta\}\) (and, in floating-point arithmetic, \(\pm 0\)),
fermionic objects can be discontinuous, so the point value is **not uniquely defined without a convention**.

For backward compatibility and convenience, sparse-ir adopts the following one-sided convention:

$$
G(0^+) = \mp G(\beta^-) \quad \text{(upper sign: fermion, lower: boson)}
$$

where $0^+$ and $\beta^-$ denote limits from above and below, respectively.
Equivalently, with \(\zeta\), this reads \(G(0^+)=\zeta\,G(\beta^-)\).

With this convention, one can treat \(\tau\)-dependent basis functions as a continuous function on \([0,\beta]\) by
interpreting endpoint values as \(f(0)\equiv f(0^+)\) and \(f(\beta)\equiv f(\beta^-)\).

For general \(\tau\) (including negative values), sparse-ir reduces evaluation to \(\tau_\mathrm{norm}\in[0,\beta]\) plus a prefactor:

$$
f(\tau) = \mathrm{sign}\cdot f(\tau_\mathrm{norm}),
$$

where the convention at the special points is encoded in how \(\tau_\mathrm{norm}\) is chosen.
In particular, \(\tau=-\beta\) is interpreted via one-sided limits (e.g. \(-\beta^+\mapsto 0^+\)) rather than as a regular interior point.

### The \(\tau=0\) special point and \(\pm 0\)

The special points \(\tau\in\{-\beta,0,\beta\}\) require special care due to the discontinuity in fermionic Green's functions.
In sparse-ir, boundary points are interpreted as one-sided limits (e.g. \(0^+\), \(\beta^-\)) so that the folded representation remains consistent.
In IEEE 754 floating-point arithmetic, there are two representations of zero: $+0$ and $-0$.
sparse-ir uses this to distinguish the limits.

More generally, the following special-point conventions are used (shown as the mapping returned by `normalize_tau`):

| Input \(\tau\) | Interpretation | Output \((\tau_\mathrm{norm}, \mathrm{sign})\) |
|---|---|---|
| \(+0.0\) | \(0^+\) | \((0.0, +1)\) |
| \(-0.0\) | \(0^-\) | \((\beta, \zeta)\) |
| \(\beta\) | \(\beta^-\) | \((\beta, +1)\) |
| \(-\beta\) | \(-\beta^+\) | \((0.0, \zeta)\) |

Notes:

- Distinguishing \(+0\) and \(-0\) is a natural way (supported by IEEE 754) to represent the two-sided limit at \(\tau=0\),
  and is necessary to handle the fermionic discontinuity.
- Treating the input \(\tau=\beta\) as \(\beta^-\) preserves backward compatibility: it allows basis functions to be treated as continuous on \([0,\beta]\)
  by using the representative values \(f(0)\equiv f(0^+)\) and \(f(\beta)\equiv f(\beta^-)\).

### Implementation: `normalize_tau`

The function `normalize_tau` (available in both Python and Julia) provides a canonical \((\tau_\mathrm{norm}, \mathrm{sign})\)
pair such that evaluation can be reduced to \(\tau_\mathrm{norm}\in[0,\beta]\) together with a prefactor \(\mathrm{sign}\in\{+1,-1\}\)
implementing the (anti-)periodicity:

```python
from sparse_ir._util import normalize_tau

beta = 10.0

# Positive zero: τ = 0⁺
tau_norm, sign = normalize_tau('F', +0.0, beta)
# tau_norm = 0.0, sign = +1.0

# Negative zero: τ = 0⁻ → τ = β with sign flip (fermion)
tau_norm, sign = normalize_tau('F', -0.0, beta)
# tau_norm = 10.0, sign = -1.0

# Negative tau: τ = -3 → τ = 7 with sign flip (fermion)
tau_norm, sign = normalize_tau('F', -3.0, beta)
# tau_norm = 7.0, sign = -1.0

# Bosonic case: no sign flip
tau_norm, sign = normalize_tau('B', -3.0, beta)
# tau_norm = 7.0, sign = +1.0
```

## Sampling points: language-specific conventions

The default tau sampling points are generated differently across language implementations:

### Python / Julia: \((0, \beta)\) range

For backward compatibility with existing codes, the Python (`sparse-ir`) and Julia (`SparseIR.jl`) implementations generate sampling points in the conventional open interval \((0,\beta)\):

```python
import sparse_ir

basis = sparse_ir.FiniteTempBasis('F', beta=10, wmax=5)
points = basis.default_tau_sampling_points()
# All points in (0, β), sorted in ascending order
```

The `use_positive_taus` parameter controls this behavior:
- `use_positive_taus=True` (default): Points are folded to $[0, \beta]$ using $\tau \mapsto \tau \mod \beta$
- `use_positive_taus=False`: Points are returned as generated by the backend (symmetric around $\beta/2$)

### Rust: \((-\beta/2, \beta/2)\) range

The Rust backend (`sparse-ir-rs`) natively generates sampling points in the symmetric open interval \((-\beta/2, \beta/2)\).
This convention is chosen with future extensions in mind:

- **Absolute zero limit**: As $\beta \to \infty$, the domain naturally extends to $(-\infty, \infty)$

The Python/Julia wrappers automatically convert these points to $[0, \beta]$ when `use_positive_taus=True`.

## Summary

| Concept | Fermion | Boson |
|---------|---------|-------|
| Periodicity (also for basis) | $f(\tau+\beta) = -f(\tau)$ | $f(\tau+\beta) = f(\tau)$ |
| Sign factor \(\zeta\) | $-1$ | $+1$ |
| $-0.0$ maps to | $(\beta, -1)$ | $(\beta, +1)$ |
| Negative $\tau$ maps to | $(\tau+\beta, -1)$ | $(\tau+\beta, +1)$ |

This handling ensures consistent evaluation of Green's functions and basis functions for arbitrary \(\tau\) while maintaining the correct (anti-)periodicity,
with special-point values understood as one-sided limits.

## References

For more details on imaginary-time Green's functions and their properties, see:
- The [Green's function and Lehmann representation](greens_function) page
- The [Summation over Matsubara axis](matsubarasum) note for related boundary considerations
