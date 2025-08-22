# Example

```@example ex1
using MyExtendedExtremes 
using Distributions
using ExtendedExtremes
```
## Parameters

```@example ex1
a, b = 0.1, 0.5
p = 0.3
```

## Create the mixed distribution

```@example ex1
d = MixedUniformTail(p, Uniform(a, b), ExtendedGeneralizedPareto( TBeta(0.4), GeneralizedPareto(0.0,3, 0.1))   , a, b)
```

use it like any Distributions.jl distribution

```@example ex1
println(pdf(d, 0.2))      # PDF in uniform part
println(cdf(d, 0.2))      # CDF in uniform part
println(quantile(d, 0.8)) # Quantile in tail part
```

## Random draws

```@example ex1
using Plots

samples = rand(d, 10000)
histogram(samples, bins=50, normalize=true, label="Sampled PDF",alpha=0.3)
plot!(x -> pdf(d, x), 0, 50, label="Theoretical PDF", lw=2)
```

```@example ex1
dd = fit_mix(MixedUniformTail,samples)
samples2 = rand(dd,10000)
histogram!(samples2 , bins=50,normalize=true,label="samples from fitted on previous samples",alpha=0.3)
```
