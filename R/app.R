#' Open 'Guess The Player' Quiz App
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#'
#' @return Opens a Shiny app.
#' @export
#'
#' @examples \dontrun{open_colleagues_quiz()}
open_colleagues_quiz <- function(all_players) {

  ui <- shiny::fluidPage(

    shinyjs::useShinyjs(),

    shiny::textOutput("colleague_names"),
    shiny::actionButton("reveal_btn", "Reveal"),
    shinyjs::hidden(
      shiny::div(id = "reveal_div", shiny::textOutput("target_player"))
    ),
    shiny::actionButton("refresh_btn", "Refresh")

  )

  server <- function(input, output) {

    target_player <- all_players |>
      dplyr::group_by(player_name) |>
      dplyr::summarise(mins = sum(minutes_played)) |>
      dplyr::sample_n(1, weight = mins) |>
      dplyr::pull(player_name)

    colleagues <- sample_colleagues(
      all_players = all_players,
      player = target_player,
      n = 5
    )

    output$colleague_names <- renderText({
      paste(colleagues, collapse = ", ")
    })

    shiny::observeEvent(input$refresh_btn, { shinyjs::refresh() })

    shiny::observeEvent(input$reveal_btn, {
      shinyjs::toggle("reveal_div")
      output$target_player <- shiny::renderText({ target_player })
    })

  }

  shiny::shinyApp(ui = ui, server = server)

}
