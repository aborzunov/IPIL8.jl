function
makegif(
    u::Matrix,
    Xₙ::Vector,
    Tₘ::Vector;
    frames_to_write::Vector = Vector(),
    title::String = "Анимация чего-то",
    name::String = "animation.gif"
)

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

        frame(a)
    end

    if endswith(name, ".gif")
        gif(a, name);
    elseif endswith(name, ".mp4")
        mp4(a, name);
    elseif endswith(name, ".avi")
        @error "Avi не поддерживается"
    end

end
