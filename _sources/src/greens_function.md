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

The Fourier Transformation of $G_{ij}(\tau)$ (with $\tau \in [0,\beta]$) reads

$$
G_{ij}(\iv_n) = \int_0^{\beta} \dd \tau e^{\iv_n\tau} G_{ij}(\tau),
$$

where $\nu_n = (2n+1)\pi/\beta$ (fermion) and $\nu_n = 2n\pi/\beta$ (boson) with $n$ being an integer.
The inverse temperature is denoted by $\beta$ (We take $\hbar=1$).
The inverse transformation is given by

$$
G_{ij}(\tau) = \frac{1}{\beta}\sum_{n=-\infty}^\infty e^{-\iv_n\tau}G_{ij}(\iv_n).
$$ 

Continuing $G_{ij}(\iv_n)$ to a holomorphic function in the upper half of the complex plane,
the imaginary-frequency (Matsubara) Green's function can be related to the "ordinary" retarded Green's function as

$$
G_{ij}^\mathrm{R}(\omega)=G_{ij}(z \rightarrow \omega+\mathrm{i}0^{+}).
$$

In the following, we omit the symbols $i$, $j$, $n$ unless there is confusion.

## Lehmann representation

In the imaginary-frequency domain, the Lehmann representation reads

$$
\begin{align}
    G(\iv) &= \int_{-\infty}^\infty \dd\omega \underbrace{\frac{1}{\iv - \omega}}_{\equiv K(\iv, \omega)} A(\omega),
\end{align}
$$

where $A(\omega)$ is a spectral function.
$K(\iv, \omega)$ is the so-called analytic continuation kernel.
The Lehmann representation can be transformed to the imaginary-time domain as

$$
\begin{align}
    G(\tau) &= - \int_{-\infty}^\infty \dd\omega K(\tau, \omega) A(\omega),
\end{align}
$$ (lehmann-tau)

where $0 < \tau < \beta$ and 

$$
\begin{align}
    K(\tau, \omega) &\equiv - \frac{1}{\beta} \sum_{\iv} e^{-\iv \tau} K(\iv, \omega) =
    \begin{cases}
        \frac{e^{-\tau\omega}}{1+e^{-\beta\omega}} & (\mathrm{fermion}),\\
        \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}} & (\mathrm{boson})
    \end{cases}.
\end{align}
$$

The minus sign originates from our convention $K(\tau, \omega) > 0$.

## Regularization of the bosonic kernel

The bosonic kernel diverges at $\omega = 0$:

$$
K^\mathrm{B}(\tau, \omega) = \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}} \sim \frac{1}{\beta\omega} \quad (\omega \to 0).
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

**Note**: For bosons, the modified spectral function $\rho(\omega)$ must vanish at least linearly at $\omega = 0$ to compensate for the $1/\tanh(\beta\omega/2) \sim 2/(\beta\omega)$ factor.

### Method 2: Regularized Bose kernel

This approach, used in {cite:p}`Shinaoka:2017ix`, introduces a **regularized bosonic kernel**:

$$
K^\mathrm{reg}(\tau, \omega) = \omega \cdot \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}}.
$$ (Kreg)

The factor $\omega$ cancels the $1/\omega$ divergence, making the kernel well-behaved at $\omega = 0$.
The Lehmann representation becomes

$$
G(\tau)= - \int_{-\infty}^\infty\dd{\omega} K^\mathrm{reg}(\tau,\omega) \rho'(\omega),
$$

where $\rho'(\omega) = A(\omega)/\omega$ is the modified spectral function.

**Advantage**: As shown in {cite:p}`Shinaoka:2017ix`, the number of basis functions grows only logarithmically with $\Lambda = \beta\wmax$, making this representation highly compact for large $\Lambda$.

**Note**: The physical spectral function $A(\omega)$ must vanish at least linearly at $\omega = 0$ for the integral to converge.

### Comparison

| Property | Logistic kernel | Regularized Bose kernel |
|----------|-----------------|------------------------|
| Fermion support | Yes | No |
| Boson support | Yes (with modified $\rho$) | Yes |
| Kernel form | $K^\mathrm{L} = \frac{e^{-\tau\omega}}{1+e^{-\beta\omega}}$ | $K^\mathrm{reg} = \omega \cdot \frac{e^{-\tau\omega}}{1-e^{-\beta\omega}}$ |
| Modified spectral function | $\rho = A/\tanh(\beta\omega/2)$ | $\rho' = A/\omega$ |
| Implementation | Unified for F/B | Separate for B |
