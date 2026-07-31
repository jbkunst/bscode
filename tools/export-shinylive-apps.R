source(file.path("tools", "example-metadata.R"))

live_dir <- file.path("docs", "live")
unlink(live_dir, recursive = TRUE, force = TRUE)
dir.create(live_dir, recursive = TRUE, showWarnings = FALSE)

package_version <- read.dcf("DESCRIPTION")[1, "Version"]
package_source <- file.path("R", "page-bscode.R")
package_assets <- file.path("inst", "www", c("bscode.css", "bscode.js"))

if (!file.exists(package_source) || !all(file.exists(package_assets))) {
  stop("Missing bscode source or web assets required for Shinylive export.", call. = FALSE)
}

for (example in examples) {
  app_dir <- file.path("inst", "examples", example$slug)

  if (!dir.exists(app_dir)) {
    stop("Missing example application: ", app_dir, call. = FALSE)
  }

  build_dir <- file.path(tempdir(), paste0("bscode-shinylive-", example$slug))
  unlink(build_dir, recursive = TRUE, force = TRUE)
  dir.create(build_dir, recursive = TRUE, showWarnings = FALSE)

  app_files <- list.files(
    app_dir,
    all.files = TRUE,
    full.names = TRUE,
    no.. = TRUE
  )

  copied <- file.copy(app_files, build_dir, recursive = TRUE)
  if (length(copied) && !all(copied)) {
    stop("Could not copy example application: ", app_dir, call. = FALSE)
  }

  app_file <- file.path(build_dir, "app.R")
  app_code <- readLines(app_file, warn = FALSE, encoding = "UTF-8")
  app_code <- app_code[!grepl(
    "^[[:space:]]*(library|require)\\([[:space:]]*bscode[[:space:]]*\\)[[:space:]]*$",
    app_code
  )]
  app_code <- gsub("bscode::page_bscode", "page_bscode", app_code, fixed = TRUE)
  app_code <- c('source("bscode-shinylive.R", local = TRUE)', "", app_code)
  writeLines(app_code, app_file, useBytes = TRUE)

  file.copy(package_source, file.path(build_dir, "bscode-source.R"), overwrite = TRUE)

  shim <- c(
    'source("bscode-source.R", local = TRUE)',
    "",
    "bscode_dependency <- function() {",
    "  htmltools::htmlDependency(",
    '    name = "bscode",',
    paste0('    version = "', package_version, '",'),
    '    src = c(href = "bscode"),',
    '    stylesheet = "bscode.css",',
    '    script = "bscode.js"',
    "  )",
    "}"
  )
  writeLines(shim, file.path(build_dir, "bscode-shinylive.R"), useBytes = TRUE)

  asset_dir <- file.path(build_dir, "www", "bscode")
  dir.create(asset_dir, recursive = TRUE, showWarnings = FALSE)
  copied_assets <- file.copy(package_assets, asset_dir, overwrite = TRUE)
  if (!all(copied_assets)) {
    stop("Could not copy bscode web assets for Shinylive.", call. = FALSE)
  }

  shinylive::export(
    appdir = build_dir,
    destdir = live_dir,
    subdir = example$slug,
    wasm_packages = TRUE,
    quiet = FALSE,
    template_params = list(title = paste(example$title, "· bscode"))
  )

  unlink(build_dir, recursive = TRUE, force = TRUE)
  message("Exported ", file.path(live_dir, example$slug))
}
