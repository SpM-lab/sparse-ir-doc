# Summation over Matsubara axis

In many cases, we want to perform the summation of a Greens-function-like object $f(\mathrm{i}\nu)$ over the Matsubara axis.
Here, $\nu = n\pi/\beta$ runs over the fermionic (odd $n$) or bosonic (even $n$) Matsubara frequencies; the letter $\omega$ is reserved for real frequencies and $A$ for the spectral function (see [Notation and conventions](notation.md)).

The Fourier transform of $f$ reads

$$
f(\tau) = \frac{1}{\beta} \sum_{\nu} f(\mathrm{i}\nu) e^{-\mathrm{i}\nu \tau}.
$$

This leads to the following the two formula:

$$
\begin{align}
 \sum_{\nu} f(\mathrm{i}\nu) e^{\mathrm{i}\nu 0^+} &= \beta f(\tau=0^-), \\
 \sum_{\nu} f(\mathrm{i}\nu) e^{\mathrm{i}\nu 0^-} &= \beta f(\tau=0^+). \\
\end{align}
$$

We now expand $f(\mathrm{i}\nu)$ at high frequencies as

$$
f(\mathrm{i}\nu) = \frac{c_1}{\mathrm{i}\nu} + \frac{c_2}{(\mathrm{i}\nu)^2} + \cdots.
$$

As discussed in [Sec. B3 of E. Gull's Ph. D thesis](https://www.research-collection.ethz.ch/handle/20.500.11850/104013),
$f(\tau=0^+) = f(\tau=0^-)$ if and only if $c_1 = 0$.
This condition is equivalent that $f(\mathrm{i}\nu)$ vanishes at high frequencies faster than $O(1/{\mathrm{i}\nu})$.
More precisely, $f(\tau=0^+) - f(\tau=0^-) = -c_1$: the Green's function of an elementary operator has $c_1 = 1$ and jumps by $-1$ at $\tau = 0$ for both statistics.
If $c_1 \neq 0$, the summation does NOT converge without a convergence factor and thus $ \sum_{\nu} f(\mathrm{i}\nu) e^{\mathrm{i}\nu 0^+} \neq  \sum_{\nu} f(\mathrm{i}\nu) e^{\mathrm{i}\nu 0^-}$.