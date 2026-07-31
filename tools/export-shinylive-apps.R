source(file.path("tools", "example-metadata.R"))

live_dir <- file.path("docs", "live")
unlink(live_dir, recursive = TRUE, force = TRUE)
dir.create(live_dir, recursive = TRUE, showWarnings = FALSE)

for (example in examples) {
  app_dir <- file.path("inst", "examples", example$slug)

  if (!dir.exists(app_dir)) {
    stop("Missing example application: ", app_dir, call. = FALSE)
  }

  shinylive::export(
    appdir = app_dir,
    destdir = live_dir,
    subdir = example$slug,
    wasm_packages = TRUE,
    quiet = FALSE,
    template_params = list(title = paste(example$title, "· bscode"))
  )

  message("Exported ", file.path(live_dir, example$slug))
}
