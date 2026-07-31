library(shiny)
library(bslib)
library(bscode)

ui <- page_bscode(
  title = "Basic app",
  id = "main_nav",

  nav_panel(
    "Home",
    value = "home",
    icon = icon("house"),
    div(
      class = "p-4",
      h2("A familiar bslib workflow"),
      p("The page changes, but nav_panel(), nav_spacer(), and nav_select() remain familiar."),
      actionButton("go_data", "Open data", class = "btn-primary")
    )
  ),

  nav_panel(
    "Data",
    value = "data",
    icon = icon("table"),
    div(
      class = "p-4",
      sliderInput("rows", "Rows", min = 3, max = 12, value = 6),
      tableOutput("iris_table")
    )
  ),

  nav_spacer(),

  nav_panel(
    "About",
    value = "about",
    icon = icon("circle-info"),
    div(class = "p-4", h2("About"), p("One page function; standard bslib navigation items."))
  )
)

server <- function(input, output, session) {
  observeEvent(input$go_data, {
    nav_select("main_nav", "data")
  })

  output$iris_table <- renderTable({
    head(iris, input$rows)
  })
}

shinyApp(ui, server)
