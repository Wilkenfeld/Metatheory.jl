using Metatheory

taylor = @theory x a b  begin
    exp(x) --> Σ(x^:n / factorial(big(:n)))
    cos(x) --> Σ((-1)^:n * x^2(:n) / factorial(big(2 * :n)))
    Σ(a) + Σ(b) --> Σ(a + b)
end

function expand(iters)
    RewriteRule(PatTerm(:call, :Σ, [PatVar(:a)], @__MODULE__), 
        PatTerm(:call, :sum, [PatTerm(:(->), :(->), [:n, PatVar(:a)], @__MODULE__), 0:iters], @__MODULE__))
end

a = rewrite(:(exp(x) + cos(x)), taylor)

r = expand(5000)
bexpr = rewrite(a, [r])

# you may want to do algebraic simplification
# with egraphs here

x = big(42)

b =  eval(bexpr)
# 1.739274941520501044994695988622883932193276720547806372656638132701531037200611e+18

exp(x) + cos(x)
# 1.739274941520501046994695988622883932193276720547806372656638132701531037200651e+18

@testset "Infinite Series Approximation" begin
   @test b ≈ (exp(x) + cos(x))
end
