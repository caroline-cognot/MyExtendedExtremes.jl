using Documenter
using MyExtendedExtremes

ENV["GKSwstype"] = "100" # Avoid graphic display during CI

makedocs(
    sitename = "MyExtendedExtremes",
    format = Documenter.HTML(),
    modules = [MyExtendedExtremes],
    pages = [
        "Documentation" => "index.md",
        "Example" => "example.md",],
)

deploydocs(repo = "github.com/caroline-cognot/MyExtendedExtremes.jl.git")
