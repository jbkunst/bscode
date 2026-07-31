.bscode_state <- new.env(parent = emptyenv())

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

has_class <- function(x, class) {
  if (!inherits(x, "shiny.tag")) {
    return(FALSE)
  }

  classes <- htmltools::tagGetAttribute(x, "class") %||% ""
  class %in% strsplit(classes, "\\s+")[[1L]]
}

is_bscode_nav_panel <- function(x) {
  has_class(x, "tab-pane")
}

is_bscode_nav_spacer <- function(x) {
  has_class(x, "bslib-nav-spacer")
}

panel_label <- function(x) {
  label <- htmltools::tagGetAttribute(x, "title") %||%
    htmltools::tagGetAttribute(x, "data-value") %||%
    "panel"

  as.character(label)
}

warn_missing_icons <- function(items) {
  panels <- Filter(is_bscode_nav_panel, items)
  missing <- vapply(
    panels,
    function(panel) is.null(attr(panel, "_shiny_icon")),
    logical(1)
  )

  if (!any(missing) || isTRUE(.bscode_state$missing_icon_warning)) {
    return(invisible(NULL))
  }

  labels <- vapply(panels[missing], panel_label, character(1))
  warning(
    paste0(
      "Icons are recommended for page_bscode() navigation. ",
      "Using the first letter as a fallback for: ",
      paste(labels, collapse = ", "),
      "."
    ),
    call. = FALSE
  )

  .bscode_state$missing_icon_warning <- TRUE
  invisible(NULL)
}

prepare_panel_fill <- function(item, fillable) {
  if (!is_bscode_nav_panel(item)) {
    return(item)
  }

  value <- htmltools::tagGetAttribute(item, "data-value")
  should_fill <- isTRUE(fillable) ||
    (is.character(fillable) && !is.null(value) && value %in% fillable)

  if (!should_fill) {
    return(htmltools::tagAppendAttributes(item, class = "bscode-pane-scroll"))
  }

  item <- htmltools::tagAppendAttributes(item, class = "bscode-pane-fill")
  bslib::as_fill_carrier(item)
}

make_brand <- function(title, brand) {
  if (identical(brand, FALSE)) {
    return(NULL)
  }

  label <- if (is.character(title) && length(title) == 1L) title else "bscode"

  if (is.null(brand)) {
    if (!is.character(title) || length(title) != 1L || !nzchar(trimws(title))) {
      return(NULL)
    }

    brand <- substr(trimws(title), 1L, 1L)
  }

  htmltools::div(
    class = "bscode-brand",
    title = label,
    `aria-label` = label,
    brand
  )
}

bscode_dependency <- function() {
  path <- system.file("www", package = "bscode")

  htmltools::htmlDependency(
    name = "bscode",
    version = as.character(utils::packageVersion("bscode")),
    src = c(file = path),
    stylesheet = "bscode.css",
    script = "bscode.js"
  )
}

#' A VS Code-inspired activity bar page
#'
#' Creates a screen-filling bslib page whose navigation is displayed as a
#' compact activity bar on the left or right. The dots must contain
#' [bslib::nav_panel()] and [bslib::nav_spacer()] objects.
#'
#' @param ... Navigation items created by [bslib::nav_panel()] or
#'   [bslib::nav_spacer()].
#' @param title Window title and source of the default brand letter.
#' @param id Navigation input ID, compatible with [bslib::nav_select()].
#' @param selected Value of the initially selected panel.
#' @param position Position of the activity bar: `"left"` or `"right"`.
#' @param fillable `TRUE` to make every panel fill the viewport, `FALSE` to use
#'   normal scrolling, or a character vector containing panel values to fill.
#' @param fillable_mobile Whether the page fills the viewport on narrow screens.
#' @param tooltip_placement Tooltip placement. `"auto"` uses the side opposite
#'   the activity bar. Use `NULL` to disable tooltips.
#' @param theme A [bslib::bs_theme()] object. The default uses VS Code blue as
#'   the Bootstrap primary color.
#' @param brand Optional UI shown at the top of the activity bar. `NULL` uses
#'   the first letter of a character `title`; `FALSE` removes the brand.
#' @param lang Language attribute passed to [bslib::page_fillable()].
#'
#' @return A Shiny page UI.
#' @export
page_bscode <- function(
  ...,
  title = NULL,
  id = NULL,
  selected = NULL,
  position = c("left", "right"),
  fillable = TRUE,
  fillable_mobile = TRUE,
  tooltip_placement = "auto",
  theme = bslib::bs_theme(primary = "#007ACC"),
  brand = NULL,
  lang = NULL
) {
  position <- match.arg(position)

  if (!is.null(tooltip_placement)) {
    tooltip_placement <- match.arg(
      tooltip_placement,
      c("auto", "top", "right", "bottom", "left")
    )
  }

  valid_fillable <-
    (is.logical(fillable) && length(fillable) == 1L && !is.na(fillable)) ||
    is.character(fillable)

  if (!valid_fillable) {
    stop("`fillable` must be TRUE, FALSE, or a character vector of panel values.", call. = FALSE)
  }

  items <- list(...)

  if (!length(items)) {
    stop("page_bscode() requires at least one nav_panel().", call. = FALSE)
  }

  valid <- vapply(
    items,
    function(item) is_bscode_nav_panel(item) || is_bscode_nav_spacer(item),
    logical(1)
  )

  if (!all(valid)) {
    stop(
      "Every item in `...` must be created by bslib::nav_panel() or bslib::nav_spacer().",
      call. = FALSE
    )
  }

  warn_missing_icons(items)
  items <- lapply(items, prepare_panel_fill, fillable = fillable)

  navset <- do.call(
    bslib::navset_pill,
    c(items, list(id = id, selected = selected))
  )

  if (length(navset) < 2L) {
    stop("Unable to build the bslib navigation container.", call. = FALSE)
  }

  nav <- htmltools::tagAppendAttributes(navset[[1L]], class = "bscode-nav")
  content <- htmltools::tagAppendAttributes(
    navset[[2L]],
    class = "bscode-tab-content"
  )
  content <- bslib::as_fill_carrier(content)

  bar <- htmltools::div(
    class = "bscode-activity-bar",
    make_brand(title, brand),
    nav
  )

  shell <- htmltools::div(
    class = paste("bscode-shell", paste0("bscode-position-", position)),
    `data-bscode-position` = position,
    `data-bscode-tooltip-placement` = tooltip_placement %||% "none",
    bar,
    htmltools::tags$main(class = "bscode-content", content)
  )
  shell <- bslib::as_fill_carrier(shell)

  bslib::page_fillable(
    class = "bscode-page",
    bscode_dependency(),
    shell,
    padding = 0,
    gap = 0,
    fillable_mobile = fillable_mobile,
    title = title,
    theme = theme,
    lang = lang
  )
}
