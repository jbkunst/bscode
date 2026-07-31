# Flight operations dashboard

The activity bar only handles page navigation. The dashboard itself is
built from regular bslib layouts and popular htmlwidgets.

This example checks:

- Cards, value boxes, and filling layouts inside a screen-filling panel.
- Plotly, Leaflet, and Reactable rendering in the same application.
- Staged initialization of two Plotly widgets in the Shinylive build.

## Live app

> The first load may take a moment. The application runs entirely in the
> browser through WebAssembly.

[Open live app](https://jbkunst.github.io/bscode/live/02-cards/)

## Source code

``` bscode-example-source
library(shiny)
library(bslib)
library(bscode)
library(plotly)

required_packages <- c("leaflet", "reactable")
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

airports <- data.frame(
  code = c("SCL", "LIM", "EZE", "GRU", "BOG", "MIA", "JFK", "MAD"),
  city = c(
    "Santiago", "Lima", "Buenos Aires", "Sao Paulo",
    "Bogota", "Miami", "New York", "Madrid"
  ),
  lat = c(-33.3930, -12.0219, -34.8222, -23.4356, 4.7016, 25.7959, 40.6413, 40.4983),
  lng = c(-70.7858, -77.1143, -58.5358, -46.4731, -74.1469, -80.2870, -73.7781, -3.5676),
  flights = c(312, 84, 91, 76, 48, 35, 22, 19),
  on_time = c(0.84, 0.79, 0.76, 0.81, 0.86, 0.74, 0.72, 0.83)
)

routes <- airports[airports$code != "SCL", ]
origin <- airports[airports$code == "SCL", ]

route_lines <- do.call(
  rbind,
  lapply(seq_len(nrow(routes)), function(index) {
    data.frame(
      route = paste(origin$code, routes$code[index], sep = "–"),
      lng = c(origin$lng, routes$lng[index]),
      lat = c(origin$lat, routes$lat[index])
    )
  })
)

flights <- data.frame(
  flight = c("LA2696", "LA2378", "LA8036", "LA500", "LA602", "LA630", "LA706", "LA532"),
  destination = c("LIM", "EZE", "GRU", "MIA", "BOG", "JFK", "MAD", "LIM"),
  departure = c("08:10", "09:25", "10:40", "11:15", "12:30", "13:05", "14:20", "15:10"),
  gate = c("12", "7", "18", "21", "9", "15", "24", "6"),
  status = c("Boarding", "On time", "Delayed", "On time", "Boarding", "Delayed", "On time", "On time"),
  delay_min = c(0, 0, 28, 0, 0, 42, 0, 0)
)

ui <- page_bscode(
  title = "Flight Operations",
  id = "main_nav",

  nav_panel(
    "Dashboard",
    value = "dashboard",
    icon = icon("plane-departure"),
    layout_columns(
      col_widths = c(4, 4, 4, 6, 6, 7, 5),
      row_heights = c("115px", "minmax(260px, 1fr)", "minmax(260px, 1fr)"),
      fill = TRUE,
      class = "p-3",

      value_box(
        "Flights today",
        sum(airports$flights),
        showcase = icon("plane"),
        theme = "primary"
      ),
      value_box(
        "Destinations",
        nrow(routes),
        showcase = icon("location-dot")
      ),
      value_box(
        "On-time rate",
        paste0(round(weighted.mean(airports$on_time, airports$flights) * 100), "%"),
        showcase = icon("clock")
      ),

      card(
        full_screen = TRUE,
        card_header("Route network"),
        plotlyOutput("globe", height = "100%")
      ),
      card(
        full_screen = TRUE,
        card_header("Airport map"),
        leaflet::leafletOutput("airport_map", height = "100%")
      ),
      card(
        full_screen = TRUE,
        card_header("Departures from SCL"),
        reactable::reactableOutput("departures", height = "100%")
      ),
      card(
        full_screen = TRUE,
        card_header("On-time performance"),
        plotlyOutput("punctuality", height = "100%")
      )
    )
  ),

  nav_spacer(),

  nav_panel(
    "Notes",
    value = "notes",
    icon = icon("circle-info"),
    div(
      class = "p-4",
      h2("A dashboard made from ordinary components"),
      p(
        "The activity bar only provides page navigation. Cards, layouts, ",
        "themes and htmlwidgets remain standard bslib and Shiny components."
      ),
      tags$ul(
        tags$li("Plotly renders the route globe and punctuality chart."),
        tags$li("Leaflet renders the interactive airport map."),
        tags$li("Reactable renders the searchable departures table.")
      )
    )
  )
)

server <- function(input, output, session) {
  plotly_stage <- reactiveVal(0L)

  session$onFlushed(
    function() {
      plotly_stage(1L)

      later::later(
        function() plotly_stage(2L),
        delay = 1.2
      )
    },
    once = TRUE
  )

  output$globe <- renderPlotly({
    req(plotly_stage() >= 1L)

    plot_geo() |>
      add_lines(
        data = route_lines,
        x = ~lng,
        y = ~lat,
        split = ~route,
        hoverinfo = "text",
        text = ~route,
        line = list(width = 1)
      ) |>
      add_markers(
        data = airports,
        x = ~lng,
        y = ~lat,
        text = ~paste0(code, " · ", city, "<br>", flights, " flights"),
        hoverinfo = "text",
        marker = list(size = 7)
      ) |>
      layout(
        geo = list(
          projection = list(type = "orthographic"),
          showland = TRUE,
          showcountries = TRUE,
          showocean = TRUE
        ),
        margin = list(l = 0, r = 0, b = 0, t = 0),
        showlegend = FALSE
      )
  })

  output$airport_map <- leaflet::renderLeaflet({
    map <- leaflet::leaflet(airports) |>
      leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) |>
      leaflet::addCircleMarkers(
        lng = ~lng,
        lat = ~lat,
        radius = ~pmax(5, sqrt(flights)),
        stroke = TRUE,
        fillOpacity = 0.8,
        label = ~paste0(code, " · ", city),
        popup = ~paste0(
          "<strong>", code, " · ", city, "</strong><br>",
          flights, " flights<br>",
          round(on_time * 100), "% on time"
        )
      )

    for (index in seq_len(nrow(routes))) {
      map <- leaflet::addPolylines(
        map,
        lng = c(origin$lng, routes$lng[index]),
        lat = c(origin$lat, routes$lat[index]),
        weight = 1.5,
        opacity = 0.65
      )
    }

    leaflet::fitBounds(
      map,
      lng1 = min(airports$lng) - 5,
      lat1 = min(airports$lat) - 5,
      lng2 = max(airports$lng) + 5,
      lat2 = max(airports$lat) + 5
    )
  })

  output$departures <- reactable::renderReactable({
    reactable::reactable(
      flights,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      compact = TRUE,
      pagination = FALSE,
      defaultSorted = "departure",
      columns = list(
        flight = reactable::colDef(name = "Flight"),
        destination = reactable::colDef(name = "To"),
        departure = reactable::colDef(name = "Departure"),
        gate = reactable::colDef(name = "Gate", align = "center"),
        status = reactable::colDef(name = "Status"),
        delay_min = reactable::colDef(
          name = "Delay",
          align = "right",
          cell = function(value) if (value == 0) "—" else paste(value, "min")
        )
      )
    )
  })

  output$punctuality <- renderPlotly({
    req(plotly_stage() >= 2L)

    plot_ly(
      routes,
      x = ~code,
      y = ~on_time,
      text = ~paste0(city, ": ", round(on_time * 100), "%"),
      hoverinfo = "text",
      type = "bar"
    ) |>
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "", tickformat = ".0%", range = c(0, 1)),
        margin = list(l = 45, r = 10, b = 35, t = 10)
      )
  })
}

shinyApp(ui, server)
```

[View the original
`app.R`](https://github.com/jbkunst/bscode/blob/main/inst/examples/02-cards/app.R)
