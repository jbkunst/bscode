library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("plotly", quietly = TRUE)) {
  stop("This example requires the plotly package.")
}

ui <- page_bscode(
  title = "Cards",
  id = "main_nav",

  nav_panel(
    "Dashboard",
    value = "dashboard",
    icon = icon("chart-column"),
    layout_columns(
      col_widths = c(4, 4, 4, 6, 6),
      row_heights = c("120px", 1),
      fill = TRUE,
      class = "p-3",
      value_box("Rows", nrow(mtcars), showcase = icon("database"), theme = "primary"),
      value_box("Columns", ncol(mtcars), showcase = icon("table-columns")),
      value_box("Average MPG", round(mean(mtcars$mpg), 1), showcase = icon("gauge-high")),
      card(
        full_screen = TRUE,
        card_header("MPG and weight"),
        plotly::plotlyOutput("scatter", height = "100%")
      ),
      card(
        full_screen = TRUE,
        card_header("Cars"),
        tableOutput("cars")
      )
    )
  ),

  nav_spacer(),

  nav_panel(
    "Notes",
    value = "notes",
    icon = icon("note-sticky"),
    div(
      class = "p-4",
      h2("Filling layouts"),
      p("Cards and htmlwidgets remain ordinary bslib and Shiny components.")
    )
  )
)

server <- function(input, output, session) {
  output$scatter <- plotly::renderPlotly({
    plotly::plot_ly(
      mtcars,
      x = ~wt,
      y = ~mpg,
      text = rownames(mtcars),
      type = "scatter",
      mode = "markers"
    )
  })

  output$cars <- renderTable({
    head(cbind(model = rownames(mtcars), mtcars), 12)
  }, rownames = FALSE)
}

shinyApp(ui, server)
