function
makegif(
    u::Matrix,
    Xₙ::Vector,
    Tₘ::Vector,
    ϕl::Matrix = missings(2, 2),
    ϕr::Matrix = missings(2, 2),
    ϕ::Matrix = missings(2,2),
    f1::Vector = missings(2),
    f2::Vector = missings(2);
    frames_to_write::Vector = Vector(),
    title::String = "Анимация чего-то",
    name::String = "animation.gif"
)
    check(x::Array) = !any(ismissing.(x))
    check(x::Tuple) = !any(ismissing.(x))

    @info "Создадим анимацию решения $(name)"

    N, M = size(u) .- 1;
    if isempty(frames_to_write)
        h = div(M, 100);
        @info "Отрисовываем каждый $(h)-ый кадр. Всего 100 кадров"
        frames_to_write = collect(1:h:M+1);
    end

    limits = extrema(u) .* 1.05;
    @info "Устанавливаем пределы графика $(limits)"

    a = Animation()
    @showprogress "Plotting animation..." for m in frames_to_write
        pl = plot(Xₙ, u[:, m], label = "",
             title = title, size = (800, 800),
             xlabel = "X", ylabel = "u(x, t)",
             xlims = extrema(Xₙ), ylims = limits)

        if check(ϕl) && check(ϕr) && check(ϕ)

            # Рисуем вырожденные корни
            plot!(Xₙ, ϕl[:, m], label=L"\phi_l", color=:darkgoldenrod)
            plot!(Xₙ, ϕr[:, m], label=L"\phi_r", color=:darkgoldenrod)
            plot!(Xₙ, ϕ[:, m], label=L"\widetilde{\Phi}", color=:gold)

            # Плавающая по оси Y вслед за пунктиром надпись
            buff = latexstring("f_2", @sprintf("(t) = %.2f",f2[m]));
            annotate!(0.0, f2[m] * 1.25, Plots.text(buff, :left))
            # Горизонтальный пунктир
            plot!([0, f1[m]], [f2[m], f2[m]], line=:dash, color=:black, label="")
            # Красная точка слева, около подписи f2
            scatter!( [0], [f2[m]], color=:red, label="")

            # история f1, f2
            scatter!(f1[1:div(M+1, 80)+1:m], f2[1:div(M+1, 80)+1:m], color=:red, alpha = 0.3, label="")

            # Плавающая по оси X вслед за пунктиром надпись
            buff = latexstring("f_1" , @sprintf("(t) = %.2f",f1[m]));
            annotate!(f1[m] * 1.05, 0.95 * first(limits), Plots.text(buff, :left))
            # Вертикальная линия
            plot!([f1[m], f1[m]], [limits[1], f2[m]], line=:dash, color=:black, label="")
            # Красная точка снизу, около надписи f_1
            # Значение по Y умножаем на нормировочный коэффициент, чтобы точка полностью влезла в кадр
            scatter!( [f1[m]], [limits[1]*0.99], color=:red, label="")

            # красная точка на пересечении пунктиров априорной информации
            scatter!( [f1[m]], [f2[m]], color=:red, label="")
        end

        frame(a)
    end

    if endswith(name, ".gif")
        gif(a, name);
    elseif endswith(name, ".mp4")
        mp4(a, name);
    else
        @error "Неподдерживаемый формат анимации"
    end

end
