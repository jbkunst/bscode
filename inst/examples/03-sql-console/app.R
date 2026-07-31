library(shiny)
library(bslib)
library(bscode)

if (!requireNamespace("DBI", quietly = TRUE) ||
    !requireNamespace("RSQLite", quietly = TRUE) ||
    !requireNamespace("tibble", quietly = TRUE)) {
  stop("This example requires the DBI, RSQLite, and tibble packages.")
}

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
    bg = "#FFFFFF",
    fg = "#1E1E1E"
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
        tags$ul(tags$li("cars"), tags$li("flowers")),
        hr(),
        actionButton(
          "run",
          "Run query",
          icon = icon("play"),
          class = "btn-primary w-100"
        ),
        p(
          class = "small text-body-secondary mt-2",
          "Both Run buttons execute the current editor contents."
        )
      ),
      layout_columns(
        col_widths = 12,
        row_heights = c(2, 1),
        fill = TRUE,
        class = "p-2",
        card(
          card_header(
            div(
              class = "d-flex align-items-center justify-content-between w-100",
              span("query.sql"),
              actionButton(
                "run_editor",
                NULL,
                icon = icon("play"),
                class = "btn-primary btn-sm",
                title = "Run query"
              )
            )
          ),
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
          card_body(
            div(
              class = "h-100 overflow-auto",
              verbatimTextOutput("result", placeholder = TRUE)
            ),
            fillable = TRUE
          )
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
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  DBI::dbWriteTable(con, "cars", cbind(model = rownames(mtcars), mtcars))
  DBI::dbWriteTable(con, "flowers", iris)

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
  observeEvent(input$run_editor, run_query())

  output$result <- renderPrint({
    tibble::as_tibble(result())
  })

  output$console_title <- renderText(paste("Results ·", status()))

  session$onSessionEnded(function() {
    DBI::dbDisconnect(con)
  })
}

shinyApp(ui, server)
