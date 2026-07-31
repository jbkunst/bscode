# A VS Code-inspired activity bar page

Creates a screen-filling bslib page whose navigation is displayed as a
compact activity bar on the left or right.

## Usage

``` r
page_bscode(
  ...,
  header = NULL,
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

  Window title and source of the default brand letter.

- id:

  Navigation input ID, compatible with
  [`bslib::nav_select()`](https://rstudio.github.io/bslib/reference/nav_select.html).

- selected:

  Value of the initially selected panel.

- position:

  Activity bar position: `"left"` or `"right"`.

- fillable:

  Logical value or panel values that should fill the viewport.

- fillable_mobile:

  Whether the layout fills the viewport on narrow screens.

- tooltip_placement:

  Tooltip placement, `"auto"`, or `NULL` to disable.

- theme:

  A
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  object.

- brand:

  Optional UI for the top of the activity bar.

- lang:

  Page language.

## Value

A Shiny page UI.
