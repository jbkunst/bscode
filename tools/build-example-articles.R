source(file.path("tools", "example-metadata.R"))

article_dir <- file.path("vignettes", "articles")
dir.create(article_dir, recursive = TRUE, showWarnings = FALSE)

quote_yaml <- function(x) {
  paste0('"', gsub('"', '\\"', x, fixed = TRUE), '"')
}

html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

for (example in examples) {
  app_path <- file.path("inst", "examples", example$slug, "app.R")

  if (!file.exists(app_path)) {
    stop("Missing example application: ", app_path, call. = FALSE)
  }

  app_code <- readLines(app_path, warn = FALSE, encoding = "UTF-8")
  escaped_code <- paste(html_escape(app_code), collapse = "\n")
  article_path <- file.path(article_dir, paste0(example$article, ".qmd"))
  live_url <- paste0("../live/", example$slug, "/")

  article <- c(
    "---",
    paste0("title: ", quote_yaml(example$title)),
    paste0("description: ", quote_yaml(example$description)),
    "engine: markdown",
    "format:",
    "  html:",
    "    minimal: true",
    "---",
    "",
    example$intro,
    "",
    "This example checks:",
    "",
    paste0("- ", example$tests),
    "",
    "## Live app",
    "",
    "> The first load may take a moment. The application runs entirely in the browser through WebAssembly.",
    "",
    paste0(
      '<p><a class="btn btn-primary" href="', live_url,
      '" target="_blank" rel="noopener">Open live app</a></p>'
    ),
    paste0(
      '<iframe class="bscode-live-frame" src="', live_url,
      '" title="', example$title,
      '" loading="eager" style="height:', example$viewer_height, 'px"></iframe>'
    ),
    "",
    "## Source code",
    "",
    paste0('<pre class="bscode-example-source"><code>', escaped_code, '</code></pre>'),
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
