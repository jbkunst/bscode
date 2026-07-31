library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("bsicons", quietly = TRUE) ||
    !requireNamespace("fontawesome", quietly = TRUE)) {
  stop("This example requires the bsicons and fontawesome packages.")
}

ui <- page_bscode(
  title = "Studio",
  id = "main_nav",
  position = "right",
  theme = bs_theme(
    primary = "#6F42C1",
    secondary = "#20C997",
    base_font = font_google("IBM Plex Sans")
  ),

  nav_panel(
    "Bootstrap icon",
    value = "bootstrap",
    icon = bsicons::bs_icon("palette"),
    div(
      class = "p-4",
      h2("bsicons"),
      p("Any HTML tag can be used as a navigation icon."),
      value_box("Primary", "#6F42C1", showcase = bsicons::bs_icon("droplet-fill"), theme = "primary")
    )
  ),

  nav_panel(
    "Font Awesome",
    value = "fontawesome",
    icon = fontawesome::fa("wand-magic-sparkles"),
    div(
      class = "p-4",
      h2("fontawesome"),
      p("The activity bar is on the right, so automatic tooltips open to the left.")
    )
  ),

  nav_spacer(),

  nav_panel(
    "Fallback letter",
    value = "fallback",
    div(
      class = "p-4",
      h2("No icon supplied"),
      p("bscode recommends icons, warns once per R session, and falls back to the first letter.")
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
