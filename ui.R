page_navbar(
  title  = tags$span(
    class = "title",
    tags$a(
      tags$img(src = "horizontal_SB_blanco.png", height = "30px", style = "margin-top: -5px"),
      href = "https://odes-chile.org/"
    ),
    "Cuenta del Acongagua"
  ),
  id = "nav",
  lang = "es",
  theme = theme_odes,
  fillable = TRUE,
  fillable_mobile = TRUE,
  # mapa --------------------------------------------------------------------
  bslib::nav_panel(
    title = "Vulnerabilidad",
    tags$head(
      # Include our custom CSS
      includeCSS("www/css/styles.css"),
    ),
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        selectInput("variable", tags$small("Variable"), opt_variables)
        ),
      leafletOutput("map", width="100%", height="100%")
    )
  ),
  bslib::nav(
    title = "Biodiversidad",
    "Próximamente"
  ),
  bslib::nav(
    title = "Huertos",
    "Próximamente"
  ),
)
