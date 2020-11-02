function
initial_condition(
    x::Real,
    ε::Real     = 10^(-1.5),
    x_tp::Real  = 0.1,
)
    ξ = (x - x_tp) / ε;
    return ((x + 1) + (x - 5) * exp(-3 * ξ)) / (1 + exp(-3 * ξ))
end

function
default_parameters()

    exp = quote
        a       = 0.0;
        b       = 1.0;
        Tₑ      = 1.0;
        t₀      = 0.0;
        N       = 100;
        M       = 250;
        h       = (b - a) / N;
        τ       = (Tₑ - t₀) / M;
        Xₙ      = [h * n for n in 0:N];
        Tₘ      = [τ * m for m in 0:M];
        ε       = 10^(-1.5);
        x_tp    = 0.1;
        u₀      = [IPIL8.initial_condition(x, ε, x_tp) for x in Xₙ];
        ulₘ     = [-5.0 for m in 0:M];
        urₘ     = [ 2.0 for m in 0:M];
        u       = zeros(N+1, M+1);    # Выделим память заблаговременно
    end;

    return exp;
end
