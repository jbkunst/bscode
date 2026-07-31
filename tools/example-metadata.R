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
    description = "Run independent Leaflet maps in separate navigation panels and verify widget resizing.",
    intro = paste(
      "Two independent maps share the same bscode shell without sharing a panel.",
      "Switching sections tests whether both widgets recover their full dimensions correctly."
    ),
    tests = c(
      "Two independent Leaflet widgets in one Shiny application.",
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
  ),
  list(
    slug = "06-sidebar",
    article = "sidebar-navigation",
    title = "Sidebar navigation",
    description = "Use the same bslib navigation workflow with a wider icon-and-label sidebar.",
    intro = paste(
      "Sidebar mode keeps the same navigation model as the compact activity bar.",
      "Only its presentation changes: section labels remain visible and the brand can use the full width."
    ),
    tests = c(
      "`nav_mode = \"sidebar\"` displays icons and section titles together.",
      "`nav_width` controls the width using any valid CSS unit.",
      "`nav_panel()`, `nav_spacer()`, and `nav_select()` work unchanged."
    ),
    viewer_height = 720
  )
)
