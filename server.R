# input <- list(variable = "edad")
# source("global.R")

function(input, output, session) {

  # mapa principal
  output$map <- renderLeaflet({

    leaflet(
      options = leafletOptions(
        attributionControl = FALSE,
        zoomControl = FALSE
        )
      ) |>

      addProviderTiles(providers$CartoDB.Positron,  group = "CartoDB") |>
      addProviderTiles(providers$Esri.WorldImagery, group = "ESRI WI") |>
      addProviderTiles(providers$Esri.WorldTopoMap, group = "ESRI WTM") |>

      addLayersControl(
        baseGroups = c("CartoDB", "ESRI WI", "ESRI WTM"),
        position   = "bottomright",
        options = layersControlOptions(collapsed = FALSE)
      ) |>
      htmlwidgets::onRender("function(el, x) { L.control.zoom({ position: 'topright' }).addTo(this) }") |>
      setView(lng =  -70.74827, lat = -32.95694, zoom = 9) |>
      leafem::addLogo(
        img = "https://odes-chile.org/img/logo.png",
        src= "remote",
        position = "bottomleft",
        offset.x = 5,
        offset.y = 5,
        ) |>
      leaflet.extras::addSearchOSM(
        options = leaflet.extras::searchOptions(
          textErr = "Ubicación no encontrada",
          textCancel = "Cancelar",
          textPlaceholder = "Buscar...",
          position = "bottomright"
        )
      ) |>
      addEasyButton(
        easyButton(
          position = "bottomright",
          icon = "fa-crosshairs",
          title = "Mi ubicación",
          onClick = JS("function(btn, map){ map.locate({setView: true}); }")
          )
      )

  })

  # observer de mapa
  observe({

    cli::cli_h3("observer de mapa")
    cli::cli_alert_info("variable {input$variable}")

    daux <- data |>
      select(all_of(c("cod_comuna", input$variable))) |>
      set_names(c("cod_comuna", "variable"))

    if(TRUE){

      daux <- daux |>
        group_by(cod_comuna) |>
        summarise(variable = round(mean(variable), 2))

    }

    colorData <- daux[["variable"]]
    pal <- colorBin("RdYlBu", colorData, 5, pretty = TRUE)

    dgeoaux <- dgeo |>
      select(cod_comuna, Comuna, geometry)

    # Join comunas_valpo y datos bd_cluster by cod_comunas
    dgeoaux <- merge(dgeoaux, daux, by = "cod_comuna")
    dgeoaux <- st_transform(dgeoaux, "+init=epsg:4326")

    leafletProxy("map") |>
      # leaflet() |> addTiles() |>
      clearShapes() |>
      clearTopoJSON() |>
      leaflet::addPolygons(
        data = dgeoaux,
        fillColor = ~pal(`variable`),
        weight = .5,
        dashArray = "3",
        stroke = NULL,
        fillOpacity = 0.7,
        layerId = ~cod_comuna,
        label = ~paste0(Comuna , " ",  round(variable, 3)),
        highlightOptions = highlightOptions(
          color = "white",
          weight = 4,
          fillColor = parametros$color,
          bringToFront = TRUE
        ),
        labelOptions = labelOptions(
          # offset = c(-20, -20),
          style = list(
            "font-family" = parametros$font_family,
            "box-shadow" = "2px 2px rgba(0,0,0,0.15)",
            "font-size" = "15px",
            "padding" = "15px",
            "border-color" = "rgba(0,0,0,0.15)"
          )
        )
      ) |>
      addLegend(
        position  = "topright",
        na.label = "No disponible",
        pal       = pal,
        values    = colorData,
        # labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE)),
        layerId   = "colorLegend",
        title     = str_to_title(names(which(input$variable == opt_variables)))
      )

  })

}
