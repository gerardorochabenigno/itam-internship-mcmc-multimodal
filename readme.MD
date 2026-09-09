# Implementing Markov Chain Monte Carlo Algorithms for Multimodal Posterior Distributions

Markov Chain Monte Carlo (MCMC) algorithms constitute the standard tool for exploring posterior distributions in Bayesian inference and their convergence guarantees are asymptotic. In finite runtime, however, a chain explores the region of the parameter space surrounding a starting point, and when the posterior is multimodal this typically means a single mode. Convergence is assessed through between-chain diagnostics which detect this only when the chains happen to have settled in different modes; otherwise the output looks unremarkable.

In hidden Markov models (HMMs) and Markov switching models (MSMs) multimodality arises from the likelihood itself because the states are exchangeable, so permuting the labels leaves the likelihood unchanged. Under an exchangeable prior the posterior inherits this symmetry, so the chain can then move between equivalent labellings, which makes state-specific posterior summaries meaningless. This problem is called label switching. 

Even after correcting for label switching the posterior can remain multimodal with modes corresponding to different segmentations of the data rather than relabelling of the same one. Parallel tempering (PT) is a class of MCMC algorithms that addresses multimodality by running several chains along a sequence of tempered distributions and swapping states between them, improving the exploration between modes.

While PT is well developed theoretically, materials on implementing it are scarce. To reduce this gap, this repository documents a workflow for exploring multimodal posteriors with Stan, Pigeons.jl and emcee, using HMMs and MSMs as the working example. The notebooks cover how the algorithms work, common pitfalls and practical guidelines for people fitting these models.


## References

- Vehtari, A., Gelman, A., Simpson, D., Carpenter, B. & Bürkner, P.-C. (2021). Rank-normalization, folding, and localization: An improved R̂ for assessing convergence of MCMC (with discussion). *Bayesian Analysis*, 16(2), 667–718. [doi:10.1214/20-BA1221](https://doi.org/10.1214/20-BA1221)

- Papastamoulis, P. (2016). label.switching: An R package for dealing with the label switching problem in MCMC outputs. *Journal of Statistical Software, Code Snippets*, 69(1), 1–24. [doi:10.18637/jss.v069.c01](https://doi.org/10.18637/jss.v069.c01)

- Gallegos-Herrada, M. A., Leos-Barajas, V. & Rosenthal, J. S. (2026). Bayesian inference for hidden Markov models under genuine multimodality with application to ecological time series. arXiv:2604.24587. [arXiv](https://arxiv.org/abs/2604.24587)