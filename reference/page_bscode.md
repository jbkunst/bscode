# A VS Code-inspired navigation page

Creates a screen-filling bslib page whose navigation is displayed as
either a compact activity bar or a wider sidebar with icons and labels.

## Usage

``` r
page_bscode(
  ...,
  header = NULL,
  title = NULL,
  id = NULL,
  selected = NULL,
  position = c("left", "right"),
  nav_mode = c("activity", "sidebar"),
  nav_width = "240px",
  size = "md",
  fillable = TRUE,
  fillable_mobile = TRUE,
  tooltip_placement = "auto",
  theme = bslib::bs_theme(primary = "#007ACC"),
  brand = NULL,
  lang = NULL
)
```

## Arguments

- ...:

  Navigation items created by
  [`bslib::nav_panel()`](https://rstudio.github.io/bslib/reference/nav-items.html)
  or
  [`bslib::nav_spacer()`](https://rstudio.github.io/bslib/reference/nav-items.html).

- header:

  Optional UI displayed above every navigation panel.

- title:

  Window title and source of the default brand.

- id:

  Navigation input ID, compatible with
  [`bslib::nav_select()`](https://rstudio.github.io/bslib/reference/nav_select.html).

- selected:

  Value of the initially selected panel.

- position:

  Navigation position: `"left"` or `"right"`.

- nav_mode:

  Navigation presentation: `"activity"` for icons only or `"sidebar"`
  for icons and labels.

- nav_width:

  Width of the navigation when `nav_mode = "sidebar"`.

- size:

  Navigation item size: `"sm"`, `"md"`, `"lg"`, or `"xl"`.

- fillable:

  Logical value or panel values that should fill the viewport.

- fillable_mobile:

  Whether the layout fills the viewport on narrow screens.

- tooltip_placement:

  Tooltip placement in activity mode, `"auto"`, or `NULL` to disable.

- theme:

  A
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  object.

- brand:

  Optional UI for the top of the navigation. By default, activity mode
  uses the first letter of `title` and sidebar mode uses the full title.

- lang:

  Page language.

## Value

A Shiny page UI.
