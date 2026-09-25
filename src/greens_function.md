# Green's function and Lehmann representation

$$
\newcommand{\iv}{{\mathrm{i}\nu}}
\newcommand{\wmax}{{\omega_\mathrm{max}}}
\newcommand{\dd}{{\mathrm{d}}}
$$

## One-particle Green's function

We introduce a Green's function with imaginary arguments in time and frequency.
This has no physical meaning but a mere mathematical trick to make calculations easier (to give another example of this: in Minkowski spacetime we take advantage of a similiar substitution).

The so-called imaginary-frequency (Matsubara) Green's functions are defined as follows: 

$$
G_{ij}(\tau-\tau') = -\langle T_\tau [c_i(\tau){c}^\dagger_j(\tau')]\rangle,
$$

where $i$ and $j$ denote spin/orbital/band and $T_\tau$ is the time-ordering operator.
Here, $\tau$ represents a imaginary time unit $\mathrm{i}t$,
while $c_i$/$c_j$ is a fermionic or bosonic annihilation/creation operator.

The Fourier Transformation of $G_{ij}(\tau)$ (defined for $0 < \tau < \beta$) reads

$$
G_{ij}(\iv) = \int_0^{\beta} \dd \tau e^{\iv\tau} G_{ij}(\tau),
$$

where $\nu = n\pi/\beta$ is a Matsubara frequency.
The integer $n$ is the **reduced frequency**, which the libraries take as input: $n \equiv \zeta \pmod 2$, i.e., $n$ is odd for fermions and even for bosons,
where $\zeta$ is the parity of the statistics, $\zeta = 1$ (fermion) and $\zeta = 0$ (boson).
In terms of the ordinary Matsubara index $m$, $n = 2m + \zeta$, i.e., $\nu = (2m+1)\pi/\beta$ (fermion) and $\nu = 2m\pi/\beta$ (boson).
The inverse temperature is denoted by $\beta$ (We take $\hbar=1$).
The inverse transformation is given by

$$
G_{ij}(\tau) = \frac{1}{\beta}\sum_{\nu} e^{-\iv\tau}G_{ij}(\iv),
$$ 

where the sum runs over all fermionic (bosonic) Matsubara frequencies.

Continuing $G_{ij}(\iv)$ to a holomorphic function in the upper half of the complex plane,
the imaginary-frequency (Matsubara) Green's function can be related to the "ordinary" retarded Green's function as

$$
G_{ij}^\mathrm{R}(\omega)=G_{ij}(z \rightarrow \omega+\mathrm{i}0^{+}).
$$

In the following, we omit the indices $i$ and $j$ unless there is confusion.
The notation is summarized in [Notation and conventions](notation.md).

## Lehmann representation

In the imaginary-frequency domain, the Lehmann representation reads

$$
\begin{align}
    G(\iv) &= \int_{-\infty}^\infty \dd\omega \underbrace{\frac{1}{\iv - \omega}}_{\equiv K(\iv, \omega)} A(\omega),
\end{align}
$$

where $A(\omega)$ is a spectral function.
In terms of retarded and advanced Green's functions in real frequency, the spectral function is related to them as

$$
A_{ii}(\omega) = -\frac{1}{\pi} \operatorname{Im} G^R_{ii}(\omega)
$$

for the diagonal (local) components, and more generally

$$
\boxed{A_{ij}(\omega) = \frac{\mathrm{i}}{2\pi}\left(G^R_{ij}(\omega) - G^A_{ij}(\omega)\right)}.
$$

Here $G^R$ and $G^A$ denote the retarded and advanced Green's functions, respectively.
$K(\iv, \omega)$ is the so-called analytic continuation kernel.
The Lehmann representation can be transformed to the imaginary-time domain as

$$
\begin{align}
    G(\tau) &= - \int_{-\infty}^\infty \dd\omega K(\tau, \omega) A(\omega),
\end{align}
$$ (lehmann-tau)

where the **primary domain** is the open interval $0 < \tau < \beta$ and

$$
\begin{align}
    K(\tau, \omega) &\equiv - \frac{1}{\beta} \sum_{\nu} e^{-\iv \tau} K(\iv, \omega) =
    \begin{cases}
        \frac{e^{-\tau\omega}}{1+e^{-\beta\omega}} & (\mathrm{fermion}),\\
        \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}} & (\mathrm{boson})
    \end{cases}.
\end{align}
$$

The minus sign in {eq}`lehmann-tau` is a convention that makes the fermionic kernel positive, $K(\tau, \omega) > 0$;
this kernel is the logistic kernel $K^\mathrm{L}$ used below.
The bosonic kernel is negative for $\omega < 0$.

### Imaginary-time domain, (anti-)periodicity, and special points

The (anti-)periodicity in imaginary time is a **symmetry dictated by statistics** and should be shared consistently by
the Green's function $G(\tau)$ and any basis functions used to represent it (e.g. IR/DLR basis functions in $\tau$).
With the parity $\zeta=1$ (fermion) and $\zeta=0$ (boson), the rule is

$$
f(\tau+\beta)=(-1)^\zeta f(\tau),
$$

for $\tau$ away from boundary/special points, where $f$ may stand for $G$ itself or a basis function.

In practice, $G(\tau)$ (and likewise the basis functions) are smooth on $(0,\beta)$, while the boundary points
$\tau\in\{-\beta,\pm 0,\beta\}$ require one-sided interpretations:

- $\tau=0$ and $\tau=\beta$ are understood as **limits**, $0^+$ and $\beta^-$;
  the floating-point input $-0.0$ is read as $0^-$ and $\tau=-\beta$ as $(-\beta)^+$.
  The periodicity relates the endpoint values as $G(0^-)=(-1)^\zeta G(\beta^-)$.
- $G(\tau)$ is discontinuous at $\tau=0$: for the Green's function of an elementary operator $c$,
  $G(\tau) = -\langle T_\tau c(\tau) c^\dagger(0) \rangle$, the jump is $G(0^+)-G(0^-)=-1$ for **both** statistics,
  so that $G(0^+)-(-1)^\zeta G(\beta^-)=-1$.
- Values at negative $\tau$, $-\beta \le \tau < 0$, follow from $f(\tau)=(-1)^\zeta f(\tau+\beta)$.
  The libraries evaluate functions of $\tau$ on $[-\beta,\beta]$ and raise an error outside this range.

For implementation details (including the distinction between $+0$ and $-0$ in floating-point arithmetic),
see [Periodicity of Green's functions in imaginary time](tau_periodicity).

(regularization-of-the-bosonic-kernel)=
## Regularization of the bosonic kernel

The bosonic kernel $K(\tau, \omega)$ above diverges at $\omega = 0$:

$$
K(\tau, \omega) = \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}} \sim \frac{1}{\beta\omega} \quad (\omega \to 0).
$$

To perform the singular value expansion numerically, this divergence must be regularized.
There are two common approaches:

### Method 1: Logistic kernel with modified spectral function

This approach, introduced in {cite:p}`DLR`, uses the **logistic kernel** for both fermions and bosons:

$$
K^\mathrm{L}(\tau, \omega) =  \frac{e^{-\tau\omega}}{1+e^{-\beta\omega}}.
$$ (KL)

The Lehmann representation is reformulated as

$$
G(\tau)= - \int_{-\infty}^\infty\dd{\omega} K^\mathrm{L}(\tau,\omega) \rho(\omega),
$$

where $\rho(\omega)$ is the **modified spectral function**:

$$
\begin{align}
    \rho(\omega) &\equiv 
    \begin{cases}
        A(\omega) & (\mathrm{fermion}),\\
        \displaystyle\frac{A(\omega)}{\tanh(\beta \omega/2)} & (\mathrm{boson}).
    \end{cases}
\end{align}
$$

**Advantage**: The same kernel $K^\mathrm{L}$ can be used for both fermions and bosons, simplifying the implementation.
It is the default kernel of the libraries for both statistics.

**Note**: For bosons, the spectral function $A(\omega)$ must vanish at least linearly at $\omega = 0$ to compensate for the $1/\tanh(\beta\omega/2) \sim 2/(\beta\omega)$ factor, so that $\rho(\omega)$ stays finite.

### Method 2: Regularized Bose kernel (deprecated)

This approach, used in {cite:p}`Shinaoka:2017ix`, introduces a **regularized bosonic kernel**:

$$
K^\mathrm{B}(\tau, \omega) = \omega \cdot \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}}.
$$ (Kreg)

This kernel is **deprecated**; use the logistic kernel (Method 1) instead.
Its definition here, together with the dimensionless form given below, is the reference definition of the irbasis paper {cite:p}`irbasis2019`.

The factor $\omega$ cancels the $1/\omega$ divergence, making the kernel well-behaved at $\omega = 0$.
The Lehmann representation becomes

$$
G(\tau)= - \int_{-\infty}^\infty\dd{\omega} K^\mathrm{B}(\tau,\omega) \rho'(\omega),
$$

where $\rho'(\omega) = A(\omega)/\omega$ is the modified spectral function.

**Basis size**: As shown in {cite:p}`Shinaoka:2017ix`, the number of basis functions grows only logarithmically with $\Lambda = \beta\wmax$.
The same holds for the logistic kernel of Method 1, so this is not an advantage of this kernel.

**Note**: The physical spectral function $A(\omega)$ must vanish at least linearly at $\omega = 0$ for the integral to converge.

### Comparison

| Property | Logistic kernel | Regularized Bose kernel |
|----------|-----------------|------------------------|
| Status | Default | Deprecated |
| Fermion support | Yes | No |
| Boson support | Yes (with modified $\rho$) | Yes |
| Kernel form | $K^\mathrm{L} = \frac{e^{-\tau\omega}}{1+e^{-\beta\omega}}$ | $K^\mathrm{B} = \omega \cdot \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}}$ |
| Modified spectral function | $\rho = A/\tanh(\beta\omega/2)$ | $\rho' = A/\omega$ |
| Implementation | Unified for F/B | Separate for B |

## Non-dimensionalization of kernels

For numerical work it is convenient to introduce dimensionless variables.
We define the dimensionless parameters

$$
\Lambda \equiv \beta \wmax, \qquad x \equiv 2\tau/\beta - 1 \in [-1,1], \qquad y \equiv \omega/\wmax \in [-1,1].
$$

In terms of $(x,y)$, the **logistic kernel** becomes

$$
K^\mathrm{L}(x, y) = \frac{\exp[-\Lambda y (x+1)/2]}{1 + \exp[-\Lambda y]},
$$

which is the form used internally in the IR and DLR implementations.
The physical kernel in $(\tau,\omega)$ is obtained by the change of variables above,
with the integration range $\omega \in [-\wmax, \wmax]$.

For the (deprecated) **regularized Bose kernel**, the dimensionless form is

$$
K^\mathrm{B}(x, y) = y \frac{\exp[-\Lambda y (x+1)/2]}{1 - \exp[-\Lambda y]},
$$

and the dimensional kernel is recovered via

$$
K^\mathrm{B}(\tau, \omega) = \wmax \; K^\mathrm{B}(x, y), 
$$

with the same definitions of $x$, $y$, and $\Lambda$ as above.
This convention is consistent with the implementation in the Rust backend (see `kernel.rs`),
and allows us to tabulate and manipulate kernels on the compact domain $x,y \in [-1,1]$ while
keeping the dependence on $\beta$ and $\wmax$ only through $\Lambda$.
With this definition, the singular values of $K^\mathrm{B}(\tau, \omega)$ are $S_l = \wmax^{+1} \sqrt{\beta\wmax/2}\, s_l$,
where $s_l$ are those of $K^\mathrm{B}(x, y)$ (see [Notation and conventions](notation.md)).
libsparseir releases without the fix of [sparse-ir-rs#273](https://github.com/SpM-lab/sparse-ir-rs/issues/273)
scale the singular values of bases built from this kernel by $\wmax^{-1}$ instead of $\wmax^{+1}$.
