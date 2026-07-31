library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("mapgl", quietly = TRUE)) {
  stop("This example requires the mapgl package.")
}

ui <- page_bscode(
  title = "Map",
  id = "main_nav",

  nav_panel(
    "Map",
    value = "map",
    icon = icon("map-location-dot"),
    div(
      style = "position:relative; width:100%; height:100%; min-height:0;",
      mapgl::maplibreOutput("map", width = "100%", height = "100%"),
      absolutePanel(
        top = 16,
        left = 16,
        width = 300,
        class = "card shadow",
        div(
          class = "card-body",
          h5("Full-screen htmlwidget", class = "card-title"),
          p("The activity bar leaves the rest of the viewport to MapLibre."),
          actionButton("open_info", "Open information", class = "btn-primary btn-sm")
        )
      )
    )
  ),

  nav_spacer(),

  nav_panel(
    "Information",
    value = "info",
    icon = icon("circle-info"),
    div(
      class = "p-4",
      h2("MapLibre integration"),
      p("Switching tabs triggers a resize event so the map uses the full available panel."),
      actionButton("back_map", "Back to map")
    )
  )
)

server <- function(input, output, session) {
  output$map <- mapgl::renderMaplibre({
    mapgl::maplibre(
      center = c(-70.6483, -33.4569),
      zoom = 10,
      projection = "mercator"
    )
  })

  observeEvent(input$open_info, nav_select("main_nav", "info"))
  observeEvent(input$back_map, nav_select("main_nav", "map"))
}

shinyApp(ui, server)
