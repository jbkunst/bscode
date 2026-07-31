# bscode

> A lightweight VS Code-inspired navigation shell for bslib.
>
> **`bscode = bslib + VS Code`**

`bscode` provides an opinionated, screen-filling page layout for Shiny. It is a compact alternative to `bslib::page_navbar()` and `bslib::page_sidebar()` that keeps the familiar `nav_panel()`, `nav_spacer()`, and `nav_select()` workflow.

```r
bscode::page_bscode(
  title = "My app",
  id = "main_nav",

  bslib::nav_panel(
    "Explore",
    value = "explore",
    icon = shiny::icon("map"),
    ...
  ),

  bslib::nav_spacer(),

  bslib::nav_panel(
    "About",
    value = "about",
    icon = shiny::icon("circle-info"),
    ...
  )
)
```

Icons are strongly recommended. When a panel has no icon, `bscode` falls back to the first letter of its title and emits one recommendation per R session.

## Navigation modes

The default activity bar displays icons only:

```r
bscode::page_bscode(
  nav_mode = "activity",
  size = "md",
  ...
)
```

Sidebar mode keeps the same navigation API but displays icons and labels together:

```r
bscode::page_bscode(
  title = "My Dashboard",
  nav_mode = "sidebar",
  nav_width = "230px",
  brand = htmltools::tagList(
    shiny::icon("chart-column"),
    htmltools::span("My Dashboard")
  ),
  ...
)
```

## Defaults

- VS Code blue (`#007ACC`) as the Bootstrap primary color.
- Screen-filling panels.
- Navigation on the left; `position = "right"` is also supported.
- Activity mode uses tooltips on the side opposite the navigation.
- `tooltip_placement = NULL` disables tooltips.
- `size` accepts `"sm"`, `"md"`, `"lg"`, and `"xl"`.

## Examples

After installing the package, run an example with:

```r
shiny::runApp(system.file("examples/01-basic", package = "bscode"))
```

Available examples:

- `01-basic`: familiar `bslib` navigation and `nav_select()`.
- `02-cards`: cards, value boxes, Plotly, Leaflet, and Reactable.
- `03-sql-console`: a VS Code-like SQL editor and console backed by SQLite.
- `04-full-map`: independent full-screen Leaflet panels that test htmlwidget resizing when navigation changes.
- `05-themes-icons`: right-side navigation, custom themes, mixed icon packages, and letter fallback.
- `06-sidebar`: a classic dashboard-style sidebar using the same `nav_panel()` workflow.

## Development

This is an early experiment extracted from a real Shiny application. The goal is deliberately small: provide one additional page layout, not a dashboard framework.
