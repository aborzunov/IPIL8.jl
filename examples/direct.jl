using IPIL8

eval(IPIL8.default_parameters());
IPIL8.solve!(u, u₀, N, h, Tₘ, M, τ, ε, ulₘ, urₘ)
IPIL8.makegif(u, Xₙ, Tₘ, name = "direct.gif");

ϕl, ϕr, ϕ, f1_data, f2_data = IPIL8.generate_obs_data(u, Xₙ, N, Tₘ, M, qₙ, ulₘ, urₘ);
IPIL8.makegif(u, Xₙ, Tₘ, ϕl, ϕr, ϕ, f1_data, f2_data, name = "direct_data.gif");
