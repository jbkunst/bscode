library(shiny)
library(bslib)
library(bscode)

required_packages <- c(
  "bsicons",
  "fontawesome",
  "lucidr",
  "phosphoricons"
)
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages)) {
  stop(
    "This example requires: ",
    paste(missing_packages, collapse = ", "),
    "."
  )
}

primary <- "#C2410C"
secondary <- "#0F766E"

icon_card <- function(title, package, icon, description) {
  card(
    class = "h-100",
    card_header(title),
    card_body(
      div(class = "display-5 mb-3", icon),
      tags$code(package),
      p(class = "mt-3 mb-0 text-body-secondary", description)
    )
  )
}

ui <- page_bscode(
  title = "Icon Studio",
  id = "main_nav",
  position = "right",
  size = "xl",
  brand = phosphoricons::ph("code", weight = "bold", title = "Icon Studio"),
  theme = bs_theme(
    primary = primary,
    secondary = secondary,
    bg = "#FFFDF9",
    fg = "#292524"
  ),

  nav_panel(
    "Bootstrap Icons",
    value = "bootstrap",
    icon = bsicons::bs_icon("palette2"),
    div(
      class = "p-4 h-100",
      h2("bslib themes and icon libraries"),
      p(
        class = "text-body-secondary",
        "This example tests page_bscode() with a custom bslib theme and ",
        "navigation icons from bsicons, Font Awesome, Lucide, Phosphor, and Shiny."
      ),
      layout_columns(
        col_widths = c(7, 5),
        icon_card(
          "Bootstrap Icons",
          "bsicons::bs_icon()",
          bsicons::bs_icon("palette2"),
          "A compact SVG icon package designed to work naturally with bslib."
        ),
        value_box(
          "Theme primary",
          primary,
          showcase = bsicons::bs_icon("droplet-fill"),
          theme = "primary"
        )
      )
    )
  ),

  nav_panel(
    "Font Awesome",
    value = "fontawesome",
    icon = fontawesome::fa("wand-magic-sparkles"),
    div(
      class = "p-4",
      icon_card(
        "Font Awesome",
        "fontawesome::fa()",
        fontawesome::fa("wand-magic-sparkles"),
        "Font Awesome SVG tags can be passed directly as navigation icons."
      )
    )
  ),

  nav_panel(
    "Lucide",
    value = "lucide",
    icon = lucidr::lucide("blocks"),
    div(
      class = "p-4",
      icon_card(
        "Lucide",
        "lucidr::lucide()",
        lucidr::lucide("blocks", size = 46),
        "Lucide provides lightweight line icons rendered as inline SVG."
      )
    )
  ),

  nav_panel(
    "Phosphor",
    value = "phosphor",
    icon = phosphoricons::ph("circles-three-plus", weight = "bold"),
    div(
      class = "p-4",
      icon_card(
        "Phosphor",
        "phosphoricons::ph()",
        phosphoricons::ph("circles-three-plus", weight = "fill", height = "3rem"),
        "Phosphor offers several weights from thin outlines to filled icons."
      )
    )
  ),

  nav_panel(
    "Shiny icon",
    value = "shiny",
    icon = shiny::icon("gear"),
    div(
      class = "p-4",
      icon_card(
        "Shiny",
        "shiny::icon()",
        shiny::icon("gear"),
        "Existing Shiny icons continue to work, so migration can be gradual."
      )
    )
  ),

  nav_spacer(),

  nav_panel(
    "Fallback letter",
    value = "fallback",
    div(
      class = "p-4",
      h2("No icon supplied"),
      p(
        "bscode recommends an explicit icon, warns once per R session, ",
        "and uses the first letter only as a fallback."
      ),
      p(
        class = "text-body-secondary",
        "The activity bar is on the right, so automatic light tooltips open to the left."
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
