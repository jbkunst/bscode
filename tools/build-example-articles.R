examples <- list(
  list(
    slug = "01-basic",
    article = "basic-navigation",
    title = "Basic navigation",
    description = "A minimal bscode app using familiar bslib navigation and nav_select().",
    intro = paste(
      "This is the smallest useful bscode application.",
      "It changes the page shell while keeping the usual bslib navigation workflow."
    ),
    tests = c(
      "`nav_panel()` and `nav_spacer()` remain ordinary bslib components.",
      "`nav_select()` changes the active panel from the server.",
      "The content area fills the available browser viewport."
    ),
    viewer_height = 620
  ),
  list(
    slug = "02-cards",
    article = "flight-operations",
    title = "Flight operations dashboard",
    description = "Combine bscode with bslib cards, value boxes, Plotly, Leaflet, and Reactable.",
    intro = paste(
      "The activity bar only handles page navigation.",
      "The dashboard itself is built from regular bslib layouts and popular htmlwidgets."
    ),
    tests = c(
      "Cards, value boxes, and filling layouts inside a screen-filling panel.",
      "Plotly, Leaflet, and Reactable rendering in the same application.",
      "Widget resizing after navigation and full-screen card changes."
    ),
    viewer_height = 780
  ),
  list(
    slug = "03-sql-console",
    article = "sql-console",
    title = "SQL console",
    description = "A VS Code-like SQL editor and results console backed by an in-memory SQLite database.",
    intro = paste(
      "This example uses bscode as a compact application shell for a small analytical tool.",
      "Queries run only when one of the Run buttons is pressed."
    ),
    tests = c(
      "`bslib::input_code_editor()` inside a fillable card.",
      "A sidebar explorer and a monospaced results console.",
      "A light theme using the original VS Code blue."
    ),
    viewer_height = 720
  ),
  list(
    slug = "04-full-map",
    article = "maps",
    title = "Full-screen maps",
    description = "Run MapLibre and Leaflet in separate navigation panels and verify widget resizing.",
    intro = paste(
      "MapLibre and Leaflet share the same bscode shell without sharing a panel.",
      "Switching sections tests whether both map libraries recover their full dimensions correctly."
    ),
    tests = c(
      "Two map libraries coexisting in one Shiny application.",
      "Full-viewport htmlwidgets with floating controls.",
      "Resize events when the selected navigation panel changes."
    ),
    viewer_height = 760
  ),
  list(
    slug = "05-themes-icons",
    article = "themes-and-icons",
    title = "Themes and icon libraries",
    description = "Test custom bslib themes and navigation icons from several R packages.",
    intro = paste(
      "This example deliberately mixes icon sources and moves the activity bar to the right.",
      "It also demonstrates that the page follows a custom bslib theme."
    ),
    tests = c(
      "Bootstrap Icons, Font Awesome, Lucide, Phosphor, and Shiny icons.",
      "A first-letter fallback when no icon is supplied.",
      "Automatic light tooltips and right-side navigation."
    ),
    viewer_height = 700
  )
)

article_dir <- file.path("vignettes", "articles")
dir.create(article_dir, recursive = TRUE, showWarnings = FALSE)

quote_yaml <- function(x) {
  paste0('"', gsub('"', '\\"', x, fixed = TRUE), '"')
}

for (example in examples) {
  app_path <- file.path("inst", "examples", example$slug, "app.R")

  if (!file.exists(app_path)) {
    stop("Missing example application: ", app_path, call. = FALSE)
  }

  app_code <- readLines(app_path, warn = FALSE, encoding = "UTF-8")
  article_path <- file.path(article_dir, paste0(example$article, ".qmd"))

  article <- c(
    "---",
    paste0("title: ", quote_yaml(example$title)),
    paste0("description: ", quote_yaml(example$description)),
    "format:",
    "  html:",
    "    minimal: true",
    "    embed-resources: false",
    "filters:",
    "  - shinylive",
    "---",
    "",
    example$intro,
    "",
    "This example checks:",
    "",
    paste0("- ", example$tests),
    "",
    paste0(
      "> The first load may take a moment. The application runs entirely in the browser through WebAssembly."
    ),
    "",
    "```{shinylive-r}",
    "#| standalone: true",
    "#| components: [editor, viewer]",
    "#| layout: vertical",
    paste0("#| viewerHeight: ", example$viewer_height),
    app_code,
    "```",
    "",
    paste0(
      "[View the original `app.R`](https://github.com/jbkunst/bscode/blob/main/inst/examples/",
      example$slug,
      "/app.R){.btn .btn-outline-primary}"
    ),
    ""
  )

  writeLines(article, article_path, useBytes = TRUE)
  message("Generated ", article_path)
}
