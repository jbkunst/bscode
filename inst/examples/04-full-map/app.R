library(shiny)
library(bslib)
library(bscode)

required_packages <- c("leaflet", "mapgl")
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

ui <- page_bscode(
  title = "Maps",
  id = "main_nav",

  nav_panel(
    "MapLibre",
    value = "maplibre",
    icon = icon("map"),
    div(
      style = "position:relative; width:100%; height:100%; min-height:0;",
      mapgl::maplibreOutput("maplibre_map", width = "100%", height = "100%"),
      absolutePanel(
        top = 16,
        left = 16,
        width = 300,
        class = "card shadow",
        div(
          class = "card-body",
          h5("MapLibre", class = "card-title"),
          p("A full-screen WebGL map inside a fillable navigation panel."),
          actionButton(
            "open_leaflet",
            "Open Leaflet",
            icon = icon("location-dot"),
            class = "btn-primary btn-sm"
          )
        )
      )
    )
  ),

  nav_panel(
    "Leaflet",
    value = "leaflet",
    icon = icon("location-dot"),
    div(
      style = "position:relative; width:100%; height:100%; min-height:0;",
      leaflet::leafletOutput("leaflet_map", width = "100%", height = "100%"),
      absolutePanel(
        top = 16,
        left = 16,
        width = 300,
        class = "card shadow",
        div(
          class = "card-body",
          h5("Leaflet", class = "card-title"),
          p("A second map library using the same full-screen shell."),
          actionButton(
            "open_maplibre",
            "Open MapLibre",
            icon = icon("map"),
            class = "btn-primary btn-sm"
          )
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
      h2("Two map libraries, one activity bar"),
      p(
        "MapLibre and Leaflet live in separate nav panels. Switching panels ",
        "tests that each htmlwidget receives the resize event and fills the ",
        "available viewport without interfering with the other."
      ),
      actionButton("back_maplibre", "Back to MapLibre", icon = icon("arrow-left"))
    )
  )
)

server <- function(input, output, session) {
  output$maplibre_map <- mapgl::renderMaplibre({
    mapgl::maplibre(
      center = c(-70.6483, -33.4569),
      zoom = 10,
      projection = "mercator"
    )
  })

  output$leaflet_map <- leaflet::renderLeaflet({
    leaflet::leaflet() |>
      leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
      leaflet::setView(lng = -70.6483, lat = -33.4569, zoom = 11) |>
      leaflet::addCircleMarkers(
        lng = -70.6483,
        lat = -33.4569,
        radius = 8,
        label = "Santiago"
      )
  })

  observeEvent(input$open_leaflet, nav_select("main_nav", "leaflet"))
  observeEvent(input$open_maplibre, nav_select("main_nav", "maplibre"))
  observeEvent(input$back_maplibre, nav_select("main_nav", "maplibre"))
}

shinyApp(ui, server)
