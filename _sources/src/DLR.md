# Discrete Lehmann representation

We explain the implementation of Discrete Lehmann Representation (DLR){cite:p}`DLR` in sparse-ir.
For both of fermions and bosons, we expand the Green's function as

$$
G(\tau) = - \sum_{p=1}^L K^\mathrm{L}(\tau, \bar{\omega}_p) c_p
$$

for $0 < \tau < \beta$.
The pole positions $\{\bar{\omega}_1, \cdots, \bar{\omega}_{L}\}$ are by default the $L$ roots of $V_L(\omega)$, the first singular function beyond the IR basis of size $L$.
$\{K^\mathrm{L}(\tau, \bar{\omega}_p) \}$ forms a non-orthogonal basis set in $\tau$, which is common for fermions and bosons.


```{note}
In the original DLR work {cite:p}`DLR`, the basis is derived by applying an *interpolative decomposition* (a rank-revealing factorization) to a discretized kernel, without explicitly referring to the IR basis.
Here, for both pedagogical and practical reasons, we instead *define* the DLR starting from the IR singular functions $U_l(\tau)$ and $V_l(\omega)$ and then choosing poles $\{\bar\omega_p\}$ on the real axis, which is also how the sparse-ir implementation constructs the DLR basis.
In addition, we choose the pole locations based on the zeros of the IR basis functions on the real axis {cite:p}`scipostreview`, which is a heuristic.  We do not expect that difference to matter, but please don't blame the DLR authors if we were wrong :-)
```

## Basis functions

### Imaginary-time basis functions

The DLR basis functions in the imaginary-time domain are defined using the logistic kernel:

$$
u_p(\tau) = -K^\mathrm{L}(\tau, \bar{\omega}_p) = -\frac{e^{-\tau \bar{\omega}_p}}{1 + e^{-\beta \bar{\omega}_p}},
$$

for $0 < \tau < \beta$.
On this interval, these basis functions are **common for both fermions and bosons**, which is a key advantage of using the logistic kernel.
Like any function of $\tau$, they are extended to $-\beta \le \tau < 0$ by $u_p(\tau) = (-1)^\zeta u_p(\tau + \beta)$, where $\zeta = 1$ (fermion) and $\zeta = 0$ (boson); see [Notation and conventions](notation.md).
The lower-case letter distinguishes them from the IR basis functions $U_l(\tau)$.

The Green's function is expanded as:

$$
G(\tau) = \sum_{p=1}^L u_p(\tau) c_p.
$$

### Matsubara basis functions

The DLR basis functions in the Matsubara-frequency domain differ between fermions and bosons due to the regularization factor:

**Fermions:**

$$
\hat{u}_p(\mathrm{i}\nu) = \frac{1}{\mathrm{i}\nu - \bar{\omega}_p},
$$

where $\nu = n\pi/\beta$ with odd $n$ (the reduced frequency) is a fermionic Matsubara frequency.

**Bosons:**

$$
\hat{u}_p(\mathrm{i}\nu) = \frac{\tanh(\beta \bar{\omega}_p/2)}{\mathrm{i}\nu - \bar{\omega}_p},
$$

where $\nu = n\pi/\beta$ with even $n$ is a bosonic Matsubara frequency.
The factor $\tanh(\beta \bar{\omega}_p/2)$ is the regularization factor that compensates for the modified spectral function $\rho(\omega) = A(\omega)/\tanh(\beta\omega/2)$ used with the logistic kernel.

The Matsubara Green's function is expanded as:

$$
G(\mathrm{i}\nu) = \sum_{p=1}^L \hat{u}_p(\mathrm{i}\nu) c_p.
$$

## Fermions
For fermions, this is equivalent to modeling the spectral function as

$$
    A(\omega) = \rho(\omega) = \sum_{p=1}^L c_p \delta(\omega - \bar{\omega}_p).
$$

The choice of the pole positions is heuristic but allows a numerically stable transform between $\rho_l$ and $c_p$ through the relation

$$
\rho_l = \sum_{p=1}^L \boldsymbol{V}_{lp} c_p,
$$

where the matrix $\boldsymbol{V}_{lp}~[\equiv V_l(\bar{\omega}_p)]$ is well-conditioned.

## Bosons

For bosons, the DLR is defined with the modified spectral function:

$$
    A(\omega) = \sum_{p=1}^L c_p \tanh(\beta\bar{\omega}_p/2) \delta(\omega - \bar{\omega}_p),
$$

$$
    \rho(\omega) = \frac{A(\omega)}{\tanh(\beta\omega/2)} = \sum_{p=1}^L c_p \delta(\omega - \bar{\omega}_p).
$$

Note that $\rho(\omega)$ has the same form as for fermions, which means the same transformation matrix $\boldsymbol{V}_{lp}$ can be used for both statistics when transforming between IR and DLR coefficients.