\name{page_bscode}
\alias{page_bscode}
\title{A VS Code-inspired navigation page}
\usage{
page_bscode(
  ...,
  header = NULL,
  title = NULL,
  id = NULL,
  selected = NULL,
  position = c("left", "right"),
  nav_mode = c("activity", "sidebar"),
  nav_width = "240px",
  size = "md",
  fillable = TRUE,
  fillable_mobile = TRUE,
  tooltip_placement = "auto",
  theme = bslib::bs_theme(primary = "#007ACC"),
  brand = NULL,
  lang = NULL
)
}
\arguments{
\item{...}{Navigation items created by \code{bslib::nav_panel()} or \code{bslib::nav_spacer()}.}
\item{header}{Optional UI displayed above every navigation panel.}
\item{title}{Window title and source of the default brand.}
\item{id}{Navigation input ID, compatible with \code{bslib::nav_select()}.}
\item{selected}{Value of the initially selected panel.}
\item{position}{Navigation position: \code{"left"} or \code{"right"}.}
\item{nav_mode}{Navigation presentation: \code{"activity"} for icons only or \code{"sidebar"} for icons and labels.}
\item{nav_width}{Width of the navigation when \code{nav_mode = "sidebar"}.}
\item{size}{Navigation item size: \code{"sm"}, \code{"md"}, \code{"lg"}, or \code{"xl"}.}
\item{fillable}{Logical value or panel values that should fill the viewport.}
\item{fillable_mobile}{Whether the layout fills the viewport on narrow screens.}
\item{tooltip_placement}{Tooltip placement in activity mode, \code{"auto"}, or \code{NULL} to disable.}
\item{theme}{A \code{bslib::bs_theme()} object.}
\item{brand}{Optional UI for the top of the navigation. By default, activity mode uses the first letter of \code{title} and sidebar mode uses the full title.}
\item{lang}{Page language.}
}
\value{A Shiny page UI.}
\description{
Creates a screen-filling bslib page whose navigation is displayed as either a compact activity bar or a wider sidebar with icons and labels.
}
