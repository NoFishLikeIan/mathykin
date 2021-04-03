### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ cf37ae6b-d2b2-47dd-b245-e634ee65454a
using PlutoUI

# ╔═╡ a64a4046-93c1-11eb-0dd6-6167fc3a9aa2
using Plots

# ╔═╡ 9d6140db-df81-4a4c-a76b-0cd11af8305c
md"""
## Doley iteration
A doiley iteration from mathematician Barry Martin. The linear map is,


$f(x, y) = \begin{pmatrix} y - sign(x) \cdot \sqrt(|bx - c|) \\ a-x \end{pmatrix}$

Came across it thanks to [John Cook](https://www.johndcook.com/blog/2021/02/17/martins-doileys/).
"""

# ╔═╡ 73a248b4-2a9f-4e08-8333-1a10f23de3a2
function construct(a, b, c)	
	function f(x, y)
		y′ = a - x
		x′ = y - sign(x) * √(abs(b*x - c))
		
		return x′, y′
	end
end

# ╔═╡ 83dcbbbc-b8d5-4791-965d-7721663e4d0a
md"""### Drawing"""

# ╔═╡ 3cbc37c3-a02a-48c3-ad3f-9eaeeb7fe93f
function generate(x₀, y₀, a, b, c; N=1_000)
	f = construct(a, b, c)
	xs, ys = zeros(N), zeros(N)
	xs[1] = x₀
	ys[1] = y₀
	
	for n in 2:N
		x, y = f(xs[n-1], ys[n-1])
		xs[n], ys[n] = x, y
	end
	
	return xs, ys
end

# ╔═╡ bc347d9e-61ba-423d-bbd6-1472d86cb159
md"""### Static """

# ╔═╡ 622ef2c6-a494-4532-b490-9e83c92a24ba
md"""#### Parameters """

# ╔═╡ 6b49231b-2f6f-4e3b-adcb-874c9a996269
md"""
a: $(@bind a Slider(1:100, show_value = true, default = 42)),
b: $(@bind b Slider(1:100, show_value = true, default = 4)),
c: $(@bind c Slider(1:100, show_value = true, default = 4))
"""

# ╔═╡ 6ae0828b-8f82-4e8e-ae24-93455e8f175e
md"""
x₀: $(@bind x₀ Slider(0.00 : 0.01 : 1., default = 0.2, show_value = true)),
y₀: $(@bind y₀ Slider(0.00 : 0.01 : 1., default = 0.2, show_value = true))
"""


# ╔═╡ b549faec-0a8b-49ba-bb2e-2acec641eebc
begin
	xs, ys = generate(x₀, y₀, a, b, c)
		scatter(
			xs, ys,
			markersize = 1, markercolor = :black,
			legend = false, xaxis = false, yaxis = false,
			xticks = false, yticks = false
		)
end

# ╔═╡ b64f16be-1ac9-4379-b217-904872475c06
md"""### Dynamic"""

# ╔═╡ cff62ac2-8f23-4ff2-aca6-d166a5f28f79
function animate(a, c, l = 100)
	anim = @animate for b in range(0., 5., length = l)
		xs, ys = generate(5, 5, a, b, c; N = 10_000)
		scatter(
			xs, ys,
			markersize = 1, markercolor = :black,
			legend = false, xaxis = false, yaxis = false,
			xticks = false, yticks = false
		)
	end
	
	return anim
end

# ╔═╡ d747ba99-985e-4f47-94b8-3bbf4440eb7e
anim = animate(3, 2.5)

# ╔═╡ df73fa06-b762-49e0-98b5-2a0e24460072
gif(anim, fps = 7)

# ╔═╡ Cell order:
# ╠═cf37ae6b-d2b2-47dd-b245-e634ee65454a
# ╠═a64a4046-93c1-11eb-0dd6-6167fc3a9aa2
# ╟─9d6140db-df81-4a4c-a76b-0cd11af8305c
# ╠═73a248b4-2a9f-4e08-8333-1a10f23de3a2
# ╟─83dcbbbc-b8d5-4791-965d-7721663e4d0a
# ╠═3cbc37c3-a02a-48c3-ad3f-9eaeeb7fe93f
# ╟─bc347d9e-61ba-423d-bbd6-1472d86cb159
# ╟─622ef2c6-a494-4532-b490-9e83c92a24ba
# ╟─6b49231b-2f6f-4e3b-adcb-874c9a996269
# ╟─6ae0828b-8f82-4e8e-ae24-93455e8f175e
# ╠═b549faec-0a8b-49ba-bb2e-2acec641eebc
# ╟─b64f16be-1ac9-4379-b217-904872475c06
# ╠═cff62ac2-8f23-4ff2-aca6-d166a5f28f79
# ╠═d747ba99-985e-4f47-94b8-3bbf4440eb7e
# ╠═df73fa06-b762-49e0-98b5-2a0e24460072
