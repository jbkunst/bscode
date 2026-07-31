library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("DBI", quietly = TRUE) ||
    !requireNamespace("RSQLite", quietly = TRUE)) {
  stop("This example requires the DBI and RSQLite packages.")
}

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
DBI::dbWriteTable(con, "cars", cbind(model = rownames(mtcars), mtcars))
DBI::dbWriteTable(con, "flowers", iris)

sql_default <- paste(
  "SELECT model, mpg, cyl, wt",
  "FROM cars",
  "WHERE mpg > 20",
  "ORDER BY mpg DESC;",
  sep = "\n"
)

ui <- page_bscode(
  title = "SQL Lab",
  id = "main_nav",
  theme = bs_theme(
    primary = "#007ACC",
    bg = "#1E1E1E",
    fg = "#D4D4D4"
  ),

  nav_panel(
    "Query",
    value = "query",
    icon = icon("terminal"),
    layout_sidebar(
      fillable = TRUE,
      border = FALSE,
      sidebar = sidebar(
        title = "Explorer",
        width = 240,
        tags$strong("SQLite tables"),
        tags$ul(lapply(DBI::dbListTables(con), tags$li)),
        hr(),
        actionButton("run", "Run query", icon = icon("play"), class = "btn-primary w-100"),
        p(class = "small text-body-secondary mt-2", "Ctrl/Cmd + Enter also submits the editor value.")
      ),
      layout_columns(
        col_widths = 12,
        row_heights = c(2, 1),
        fill = TRUE,
        class = "p-2",
        card(
          card_header("query.sql"),
          input_code_editor(
            "sql",
            value = sql_default,
            language = "sql",
            height = "100%",
            theme_light = "vs-code-light",
            theme_dark = "vs-code-dark",
            fill = TRUE
          )
        ),
        card(
          card_header(textOutput("console_title", inline = TRUE)),
          card_body(tableOutput("result"), fillable = TRUE)
        )
      )
    )
  ),

  nav_spacer(),

  nav_panel(
    "Help",
    value = "help",
    icon = icon("circle-question"),
    div(
      class = "p-4",
      h2("Try these queries"),
      tags$pre("SELECT * FROM flowers LIMIT 10;"),
      tags$pre("SELECT cyl, AVG(mpg) AS avg_mpg FROM cars GROUP BY cyl;")
    )
  )
)

server <- function(input, output, session) {
  result <- reactiveVal(DBI::dbGetQuery(con, sql_default))
  status <- reactiveVal("Ready")

  run_query <- function() {
    query <- trimws(input$sql)
    allowed <- grepl("^(SELECT|WITH|PRAGMA)\\b", query, ignore.case = TRUE)

    if (!allowed) {
      status("Only SELECT, WITH, and PRAGMA queries are allowed in this example.")
      return()
    }

    tryCatch(
      {
        value <- DBI::dbGetQuery(con, query)
        result(value)
        status(sprintf("%s row(s)", nrow(value)))
      },
      error = function(error) status(conditionMessage(error))
    )
  }

  observeEvent(input$run, run_query())
  observeEvent(input$sql, run_query(), ignoreInit = TRUE)

  output$result <- renderTable(result(), rownames = FALSE)
  output$console_title <- renderText(paste("Results ·", status()))

  session$onSessionEnded(function() {
    DBI::dbDisconnect(con)
  })
}

shinyApp(ui, server)
