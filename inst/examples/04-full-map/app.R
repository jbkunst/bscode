library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("leaflet", quietly = TRUE)) {
  stop("This example requires: leaflet.")
}

places <- data.frame(
  name = c("Santiago", "Valparaiso", "Rancagua", "Concepcion"),
  lng = c(-70.6483, -71.6127, -70.7406, -73.0498),
  lat = c(-33.4569, -33.0472, -34.1708, -36.8270)
)

ui <- page_bscode(
  title = "Maps",
  id = "main_nav",

  nav_panel(
    "Network",
    value = "network",
    icon = icon("route"),
    div(
      style = "position:relative; width:100%; height:100%; min-height:0;",
      leaflet::leafletOutput("network_map", width = "100%", height = "100%"),
      absolutePanel(
        top = 16,
        left = 16,
        width = 300,
        class = "card shadow",
        div(
          class = "card-body",
          h5("Network map", class = "card-title"),
          p("A full-screen Leaflet map inside a fillable navigation panel."),
          actionButton(
            "open_terrain",
            "Open terrain",
            icon = icon("mountain-sun"),
            class = "btn-primary btn-sm"
          )
        )
      )
    )
  ),

  nav_panel(
    "Terrain",
    value = "terrain",
    icon = icon("mountain-sun"),
    div(
      style = "position:relative; width:100%; height:100%; min-height:0;",
      leaflet::leafletOutput("terrain_map", width = "100%", height = "100%"),
      absolutePanel(
        top = 16,
        left = 16,
        width = 300,
        class = "card shadow",
        div(
          class = "card-body",
          h5("Terrain map", class = "card-title"),
          p("A second independent map using the same full-screen shell."),
          actionButton(
            "open_network",
            "Open network",
            icon = icon("route"),
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
      h2("Two maps, one activity bar"),
      p(
        "The maps live in separate navigation panels. Switching panels tests ",
        "that each htmlwidget receives a resize event and fills the available ",
        "viewport without interfering with the other."
      ),
      actionButton("back_network", "Back to network", icon = icon("arrow-left"))
    )
  )
)

server <- function(input, output, session) {
  output$network_map <- leaflet::renderLeaflet({
    map <- leaflet::leaflet(
      places,
      options = leaflet::leafletOptions(zoomControl = FALSE)
    ) |>
      leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
      leaflet::addCircleMarkers(
        lng = ~lng,
        lat = ~lat,
        radius = 7,
        stroke = TRUE,
        fillOpacity = 0.85,
        label = ~name
      )

    for (index in seq.int(2, nrow(places))) {
      map <- leaflet::addPolylines(
        map,
        lng = c(places$lng[1], places$lng[index]),
        lat = c(places$lat[1], places$lat[index]),
        weight = 2,
        opacity = 0.75
      )
    }

    leaflet::fitBounds(
      map,
      lng1 = min(places$lng) - 0.5,
      lat1 = min(places$lat) - 0.5,
      lng2 = max(places$lng) + 0.5,
      lat2 = max(places$lat) + 0.5
    )
  })

  output$terrain_map <- leaflet::renderLeaflet({
    leaflet::leaflet(
      places,
      options = leaflet::leafletOptions(zoomControl = FALSE)
    ) |>
      leaflet::addProviderTiles(leaflet::providers$OpenTopoMap) |>
      leaflet::addMarkers(lng = ~lng, lat = ~lat, label = ~name) |>
      leaflet::fitBounds(
        lng1 = min(places$lng) - 0.5,
        lat1 = min(places$lat) - 0.5,
        lng2 = max(places$lng) + 0.5,
        lat2 = max(places$lat) + 0.5
      )
  })

  observeEvent(input$open_terrain, nav_select("main_nav", "terrain"))
  observeEvent(input$open_network, nav_select("main_nav", "network"))
  observeEvent(input$back_network, nav_select("main_nav", "network"))
}

shinyApp(ui, server)
