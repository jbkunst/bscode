\name{page_bscode}
\alias{page_bscode}
\title{A VS Code-inspired activity bar page}
\usage{
page_bscode(
  ...,
  title = NULL,
  id = NULL,
  selected = NULL,
  position = c("left", "right"),
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
\item{title}{Window title and source of the default brand letter.}
\item{id}{Navigation input ID, compatible with \code{bslib::nav_select()}.}
\item{selected}{Value of the initially selected panel.}
\item{position}{Activity bar position: \code{"left"} or \code{"right"}.}
\item{fillable}{Logical value or panel values that should fill the viewport.}
\item{fillable_mobile}{Whether the layout fills the viewport on narrow screens.}
\item{tooltip_placement}{Tooltip placement, \code{"auto"}, or \code{NULL} to disable.}
\item{theme}{A \code{bslib::bs_theme()} object.}
\item{brand}{Optional UI for the top of the activity bar.}
\item{lang}{Page language.}
}
\value{A Shiny page UI.}
\description{
Creates a screen-filling bslib page whose navigation is displayed as a compact activity bar on the left or right.
}
