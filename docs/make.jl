using Documenter
using MyExtendedExtremes

makedocs(
    sitename = "MyExtendedExtremes",
    format = Documenter.HTML(),
    modules = [MyExtendedExtremes],
)

deploydocs(repo = "github.com/caroline-cognot/MyExtendedExtremes.jl.git")