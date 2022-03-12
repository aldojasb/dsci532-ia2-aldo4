library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(readr)
library(here)
library(purrr)
library(ggthemes)
library(shiny)
library(plotly)


app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

#penguins <- readr::read_csv('C:/Users/aldos/Documents/LESSONS/532/dsci532-ia2-aldo-R/data/us_counties_processed.csv')
#head(penguins)
penguins <- readr::read_csv(here::here('data', 'us_counties_processed.csv'))

app$layout(
  dbcContainer(
    list(htmlH1('Mean temperature chart - It takes around 1 HOUR to download the data. Please, be patience'),
      dccGraph(id='plot-area'),
      dccDropdown(
        id='col-select',
        options = penguins %>%
          colnames() %>%
          purrr::map(function(col) list(label = col, value = col)), 
        value='max_temp')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('col-select', 'value')),
  function(xcol) {
    p <- ggplot(penguins, aes(x = !!sym(xcol),
                            y = mean_temp,
                            color = state)) +
      geom_point() +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)
#app$run_server(debug = T)
app$run_server(host = '0.0.0.0')
