### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 173e8242-9494-11eb-0323-730cf65f7289
using Plots

# ╔═╡ 60857878-346a-4480-948c-8c56be1b2833
using PlutoUI

# ╔═╡ 630fa33e-a1a7-47ef-b030-dcecb315b774
md"""
## Dedekind eta function

$\eta(\tau) = q(\tau)^{\frac{1}{24}} \prod^{\infty}_{n = 1} (1 - q(\tau)^n)$

where

$q(\tau) := \exp(2\pi \cdot i \cdot \tau)$.

Using the Gatteschi-Sokal algorithm,

$\prod^{\infty}_{n = 1} (1 - x^n) \approx e^{\pi^2 / 6 \log x} \cdot \left(1 + \frac{4\pi^2}{(log x)^2}\right)^{1 / 4} =: R_1(x)$

"""

# ╔═╡ cfc8e5ee-6a88-41c7-9594-cdc18fe4790b
md""" ### $R(x)$ approximation """

# ╔═╡ 8d771b82-0e94-47fb-b803-ec305d29231d
function R(x)
	c = exp(π^2 / (6 * log(x)))
	b = 1 + (4*π^2) / (log(x))^2
	
	return c * b^(1/4)
end

# ╔═╡ 46f33003-62bb-49e1-af48-ac7db926ad6c
begin
	zs = range(0, 0.8, length = 100)
	naive(x) = prod((1 - x^n) for n in 1:1_000_000)
	
	plot(title = "Comparison of R(x) and naive implementation")
	
	plot!(zs, naive, label = "naive")
	plot!(zs, R, label = "R(x)")
end

# ╔═╡ a252a139-6981-45c2-8d16-937ce6dac2f6
md"""### Evaluation of $\eta(\tau)$"""

# ╔═╡ 3f620edd-8ba8-4bb2-8883-a3804ff86de5
q(τ) = exp((τ*2π)im)

# ╔═╡ 5af8593f-2462-49bd-8973-925ecf595c42
function η(τ)
	q′ = q(τ)
	return R(q′)*q′^(1 / 24)
end

# ╔═╡ 4db5cf75-d4bc-4cd0-84a4-08e09c0f04a0
function evaluate(xs, ys)
	Surface((x, y) -> angle(η(x + (y)im)), xs, ys)	
end

# ╔═╡ 0d8cd377-5f55-4ce5-b33f-717167992972
begin
	N = 1_000
	xs = range(-2., 2., length=N)
	ys = range(0.01, 0.2, length=N)
	z = evaluate(xs, ys)
	
	heatmap(
		xs, ys, z, 
		c = :thermal,
		legend = false, xaxis = false, yaxis = false,
		xticks = false, yticks = false
	)
end

# ╔═╡ 9066abef-9ac7-492b-8eb1-f2cff292360d
md"""### Euler's $\phi(q)$"""

# ╔═╡ 690c43a9-9153-4920-9862-7008361e6e39
ϕ(q) = R(q)*q^(1 / 24)

# ╔═╡ df2da370-dcd3-4c33-862f-53d080883734
begin
	xs_eu = ys_eu = range(-0.999, 0.999, length=2_000)
	
	incircle(x, y) = abs(x^2 + y^2) < 1
	
	ϕz = Surface((x, y) -> angle(ϕ(x + (y)im)), xs_eu, ys_eu)	
	
	heatplt = heatmap(
		xs_eu, ys_eu, ϕz, 
		c = :thermal,
		size = (600, 600),
		dpi=200,
		legend = false, xaxis = false, yaxis = false,
		xticks = false, yticks = false
	)
	
	
end

# ╔═╡ af1743d6-03a2-4284-a37f-efd484cbfeb3
savefig(heatplt, "angle.png")

# ╔═╡ Cell order:
# ╠═173e8242-9494-11eb-0323-730cf65f7289
# ╠═60857878-346a-4480-948c-8c56be1b2833
# ╟─630fa33e-a1a7-47ef-b030-dcecb315b774
# ╟─cfc8e5ee-6a88-41c7-9594-cdc18fe4790b
# ╠═8d771b82-0e94-47fb-b803-ec305d29231d
# ╟─46f33003-62bb-49e1-af48-ac7db926ad6c
# ╟─a252a139-6981-45c2-8d16-937ce6dac2f6
# ╠═3f620edd-8ba8-4bb2-8883-a3804ff86de5
# ╠═5af8593f-2462-49bd-8973-925ecf595c42
# ╠═4db5cf75-d4bc-4cd0-84a4-08e09c0f04a0
# ╠═0d8cd377-5f55-4ce5-b33f-717167992972
# ╟─9066abef-9ac7-492b-8eb1-f2cff292360d
# ╠═690c43a9-9153-4920-9862-7008361e6e39
# ╠═df2da370-dcd3-4c33-862f-53d080883734
# ╠═af1743d6-03a2-4284-a37f-efd484cbfeb3
