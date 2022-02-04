#' Open 'Guess The Player' Quiz App
#'
#' @param all_players Data.frame. Data fetched from
#'   \href{https://www.transfermarkt.com/}{Transfermarkt} with
#'   \code{\link{get_players}}.
#'
#' @return Opens a Shiny app.
#' @importFrom rlang .data
#' @export
#'
#' @examples \dontrun{
#' # Fetch player data from Transfermarkt
#' epl_players <- get_players(1992:2020, "England")
#'
#' # Open Shiny App
#' open_colleagues_quiz(epl_players)
#' }
open_colleagues_quiz <- function(all_players) {

  if (!inherits(all_players, "data.frame")) {
    stop("Argument 'all_players' must be class data.frame.")
  }

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
      dplyr::group_by(.data$player_name) |>
      dplyr::summarise(mins = sum(.data$minutes_played)) |>
      dplyr::sample_n(1, weight = .data$mins) |>
      dplyr::pull(.data$player_name)

    colleagues <- sample_colleagues(
      all_players = all_players,
      players = target_player,
      n = 5
    )

    output$colleague_names <- shiny::renderText({
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
