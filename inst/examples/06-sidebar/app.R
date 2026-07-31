library(shiny)
library(bslib)
library(bscode)

set.seed(123)

distribution <- data.frame(value = rnorm(500))
scatter <- data.frame(x = rnorm(300))
scatter$y <- 0.8 * scatter$x + rnorm(300, sd = 0.6)

ui <- page_bscode(
  title = "My Dashboard",
  id = "main_nav",
  nav_mode = "sidebar",
  nav_width = "230px",
  brand = tagList(
    icon("chart-column"),
    span("My Dashboard")
  ),

  nav_panel(
    "Dashboard",
    value = "dashboard",
    icon = icon("gauge-high"),
    layout_columns(
      col_widths = c(4, 4, 4, 6, 6),
      row_heights = c("120px", "minmax(300px, 1fr)"),
      fill = TRUE,
      class = "p-3",

      value_box(
        "Observations",
        nrow(distribution),
        showcase = icon("database"),
        theme = "primary"
      ),
      value_box(
        "Mean",
        round(mean(distribution$value), 2),
        showcase = icon("calculator")
      ),
      value_box(
        "Correlation",
        round(cor(scatter$x, scatter$y), 2),
        showcase = icon("arrow-trend-up")
      ),

      card(
        full_screen = TRUE,
        card_header("Distribution"),
        plotOutput("distribution", height = "100%")
      ),
      card(
        full_screen = TRUE,
        card_header("Scatterplot"),
        plotOutput("scatter", height = "100%")
      )
    )
  ),

  nav_panel(
    "Widgets",
    value = "widgets",
    icon = icon("sliders"),
    div(
      class = "p-4",
      h2("Widgets"),
      p("The sidebar changes only navigation. Inputs and content remain ordinary Shiny components."),
      sliderInput("bins", "Histogram bins", min = 5, max = 60, value = 25),
      checkboxInput("grid", "Show plot grid", value = TRUE)
    )
  ),

  nav_panel(
    "Charts",
    value = "charts",
    icon = icon("chart-line"),
    div(
      class = "p-4",
      h2("Charts"),
      p("A wider navigation mode is useful when section names matter as much as their icons."),
      plotOutput("trend", height = 360)
    )
  ),

  nav_spacer(),

  nav_panel(
    "About",
    value = "about",
    icon = icon("circle-info"),
    div(
      class = "p-4",
      h2("Sidebar navigation"),
      p("This example uses the same nav_panel(), nav_spacer(), and nav_select() workflow as activity mode."),
      actionButton("open_dashboard", "Back to dashboard", icon = icon("arrow-left"))
    )
  )
)

server <- function(input, output, session) {
  output$distribution <- renderPlot({
    hist(
      distribution$value,
      breaks = input$bins %||% 25,
      col = "#007ACC",
      border = "white",
      main = NULL,
      xlab = "Value"
    )

    if (isTRUE(input$grid)) {
      grid()
    }
  }, res = 96)

  output$scatter <- renderPlot({
    plot(
      scatter$x,
      scatter$y,
      pch = 16,
      col = grDevices::adjustcolor("#007ACC", alpha.f = 0.45),
      xlab = "x",
      ylab = "y"
    )
    abline(lm(y ~ x, data = scatter), col = "#C2410C", lwd = 2)
  }, res = 96)

  output$trend <- renderPlot({
    values <- cumsum(rnorm(80))
    plot(
      values,
      type = "l",
      lwd = 2,
      col = "#007ACC",
      xlab = "Time",
      ylab = "Value"
    )
  }, res = 96)

  observeEvent(input$open_dashboard, {
    nav_select("main_nav", "dashboard")
  })
}

shinyApp(ui, server)
