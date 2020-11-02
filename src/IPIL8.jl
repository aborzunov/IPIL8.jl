"""
    module IPIL8

Пакет реализует исследование численные методы решения обратных задач для нелинейных сингулярно
возмущённых уравнений типа реакция-диффузия-адвекция с данными о положении фронта реакции.

Автор исходного кода пакета:
    - [Андрей Борзунов](mailto:aborzunov@physics.msu.ru), Кафедра математики физического факультета МГУ им. Ломоносова.

"""
module IPIL8

using LinearAlgebra
using Plots
using ProgressMeter

include("direct.jl")
include("utilities.jl")
include("plotting.jl")

end
