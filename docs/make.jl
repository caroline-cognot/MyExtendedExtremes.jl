using Documenter
using MyExtendedExtremes

makedocs(
    sitename = "MyExtendedExtremes",
    format = Documenter.HTML(),
    modules = [MyExtendedExtremes]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
