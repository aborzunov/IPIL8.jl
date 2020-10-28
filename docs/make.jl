using IPIL8
using Documenter

makedocs(;
    modules=[IPIL8],
    authors="Andrey Borzunov <Andrey.Borzunov@gmail.com> and contributors",
    repo="https://github.com/aborzunov/IPIL8.jl/blob/{commit}{path}#L{line}",
    sitename="IPIL8.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://aborzunov.github.io/IPIL8.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aborzunov/IPIL8.jl",
)
