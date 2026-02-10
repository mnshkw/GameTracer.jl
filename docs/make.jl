using GameTracer
using Documenter

DocMeta.setdocmeta!(GameTracer, :DocTestSetup, :(using GameTracer); recursive=true)

makedocs(;
    modules=[GameTracer],
    authors="mnshkw <mao.nishikawa24@gmail.com> and contributors",
    sitename="GameTracer.jl",
    format=Documenter.HTML(;
        canonical="https://your-github-username.github.io/GameTracer.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/your-github-username/GameTracer.jl",
    devbranch="main",
)
