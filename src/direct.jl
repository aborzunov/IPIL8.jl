function
directRP!(
    RP::Vector,
    y::Vector,
    m::Int,
    h::Real,
    N::Int,
    ε::Real,
    ulₘ::Vector,
    urₘ::Vector
)
    # Функция для внутреннего использования, поэтому входные массивы размерности N-1
    @assert length(y)   == N-1  "Вектор искомой функции размерности N-1"
    @assert length(RP)  == N-1  "Вектор функции правой части размерности N-1"

    @assert length(ulₘ) > m > 0
    @assert length(urₘ) > m > 0

    @assert N > 4
    @assert ε > 0

    RP[1] = ε * (y[2] - 2 * y[1] + ulₘ[m]) / h^2 +
        y[1] * (y[2] - ulₘ[m]) / 2h - y[1];

    for n in 2:N-2
        RP[n] = ε * (y[n+1] - 2 * y[n] + y[n-1]) / h^2 +
            y[n] * (y[n+1] - y[n-1]) / 2h - y[n];
    end

    RP[N-1] = ε * (urₘ[m] - 2 * y[N-1] + y[N-2]) / h^2 +
        y[N-1] * (urₘ[m] - y[N-1 - 1]) / 2h - y[N-1];

    return RP;
end

function
DRP!(
    dl::Vector,
    dd::Vector,
    du::Vector,
    y::Vector,
    m::Int,
    h::Real,
    N::Int,
    ε::Real,
    ulₘ::Vector,
    urₘ::Vector
)
    # Функция для внутреннего использования, поэтому входные массивы размерности N-1
    @assert length(y)   == N-1  "Вектор искомой функции размерности N-1"

    @assert length(ulₘ) > m > 0
    @assert length(urₘ) > m > 0

    @assert m > 0
    @assert h > 0
    @assert N > 3
    @assert ε > 0

    @assert length(dl) == N-2   "Вектор поддиагональных элементов размерностью N-2"
    @assert length(dd) == N-1   "Вектор    диагональных элементов размерностью N-1"
    @assert length(du) == N-2   "Вектор поддиагональных элементов размерностью N-2"

    dd[1] = -2 * ε / h^2 + (y[2] - ulₘ[m]) / (2 * h) - 1;
    du[1] = ε / h^2 - y[1] / (2 * h);

    for n in 2:N-2
        dl[n - 1] = ε / h^2 - y[n] / (2 * h);
        dd[n] = - 2 * ε / h^2 + (y[n+1] - y[n-1])/ (2 * h) - 1;
        du[n] = ε / h^2 + y[n] / (2 * h);
    end

    dl[N-2] = ε / h^2 + y[N-1] / (2 * h);
    dd[N-1] = - 2 * ε / h^2 + (urₘ[m] - y[N-2])/ (2 * h) - 1;

    return dl, dd, du;
end

function
solve!(
    u::Matrix,
    u₀::Vector,
    N::Int,
    h::Real,
    Tₘ::Vector,
    M::Int,
    τ::Real,
    ε::Real,
    ulₘ::Vector,
    urₘ::Vector;
    α::Complex = complex(0.5, 0.5)
)
    # TODO:
    # check solution length
    #
    if length(u₀) != N+1
        throw(ArgumentError("""length(u₀) == $(length(u₀)), N == $(N)
        Массив `u₀` должен иметь размерность N+1."""))
    end

    if length(Tₘ) != M+1
        throw(ArgumentError("""length(Tₘ) == $(length(Tₘ)), M == $(M)
        Массив `Tₘ` должен иметь размерность M+1"""))
    end
    if length(ulₘ) != M+1
        throw(ArgumentError("""length(ulₘ) == $(length(ulₘ)), M == $(M)
        Массив `ulₘ` должен иметь размерность M+1"""))
    end
    if length(urₘ) != M+1
        throw(ArgumentError("""length(y) == $(length(y)), M == $(M)
        Массив `ulₘ` должен иметь размерность M+1"""))
    end

    u[1  , :]   = ulₘ;                  # Запись левого  ГУ на каждом шаге
    u[N+1, :]   = urₘ;                  # Запись правого ГУ на каждом шаге
    u[:, 1] = u₀;                       # Запись начального условия, это перепишет ГУ.

    y = u₀[2:end-1];
    rp = zero(y);
    dl = zeros(N-2);
    dd = zeros(N-1);
    du = zeros(N-2);
    j = Tridiagonal(zeros(N-2), zeros(N-1), zeros(N-2));

    for m in 1:M

        directRP!(rp, y, m, h, N, ε, ulₘ, urₘ);
        DRP!(dl, dd, du, y, m, h, N, ε, ulₘ, urₘ);

        j = Tridiagonal(dl, dd, du);

        W = (I - α  * τ * j) \ rp;
        y = y .+ τ * real(W);

        u[2:N, m+1] = y;
    end

    return u;
end
