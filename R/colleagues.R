
#' Get A Single Player's Team Mates
#' @param all_players Data.frame. Data fetched from
#'   \href{https://www.transfermarkt.com/}{Transfermarkt} with
#'   \code{\link{get_players}}.
#' @param player Character. A single player's name for whom to return team
#'     mates from \code{all_players} data.frame.
#' @importFrom rlang .data
#' @noRd
.get_player_colleagues <- function(all_players, player) {

  player_team_urls <-
    all_players |>
    dplyr::filter(.data$player_name == player) |>
    dplyr::distinct(.data$team_url) |>
    dplyr::pull()

  all_players |>
    dplyr::filter(
      .data$team_url %in% player_team_urls,
      .data$player_name != player
    )

}

#' Get Common Team Mates For Named Players
#'
#' @param all_players Data.frame. Data fetched from
#'   \href{https://www.transfermarkt.com/}{Transfermarkt} with
#'   \code{\link{get_players}}.
#' @param players Character vector. One or more player names for whom to return
#'     common team mates from the \code{all_players} data.frame. See details.
#'
#' @details Pass one player name to the \code{players} argument to fetch all of
#'   their team mates in the dataset. Pass multiple players to return common
#'   team mates and they seasons they played together.
#'
#' @return A data.frame with a row per player and season.
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' # Fetch player data from Transfermarkt
#' epl_players <- get_players(1992:2020, "England")
#'
#' # Return all team mate data for one named player
#' get_colleagues(epl_players, "James Milner")
#'
#' # Return data for all team mates in common for named players
#' get_colleagues(
#'   epl_players,
#'   c("Mark Viduka", "Kevin Phillips", "Nicky Butt")
#' )
#' }
get_colleagues <- function(all_players, players) {

  colleague_list <- vector(mode = "list", length = length(players))

  for (i in seq_along(players)) {

    colleague_names <-
      .get_player_colleagues(all_players, players[i]) |>
      dplyr::filter(.data$player_name != "") |>
      dplyr::mutate(focus_name = players[i]) |>
      dplyr::select(.data$focus_name, dplyr::everything())

    colleague_list[[i]] <- colleague_names

  }

  colleague_list_unique <- purrr::map(
    colleague_list,
    ~.x |> dplyr::pull(.data$player_name) |> unique()
  )

  co_colleagues_names <-
    colleague_list_unique |>
    unlist() |>
    table() |>
    as.data.frame() |>
    dplyr::mutate(player_name = as.character(.data$Var1)) |>
    dplyr::filter(.data$Freq == length(players)) |>
    dplyr::pull(.data$player_name)

  purrr::map(
    colleague_list,
    ~.x |> dplyr::filter(.data$player_name %in% co_colleagues_names)
  ) |>
    purrr::reduce(dplyr::bind_rows) |>
    dplyr::arrange(.data$focus_name, .data$season, .data$team_name)

}

#' Sample From Named Players' Common Team Mates
#'
#' @param all_players Data.frame. Data fetched from
#'   \href{https://www.transfermarkt.com/}{Transfermarkt} with
#'   \code{\link{get_players}}.
#' @param players Character vector. One or more player names for whom to return
#'     common team mates from the \code{all_players} data.frame. See details.
#' @param n Numeric. Number of team-mates' names to return. See details.
#'
#' @details
#' Pass one player name to the \code{players} argument to sample from all of
#' their team mates in the dataset. Pass multiple players to sample from
#' common team mates.
#'
#' The default number of player names returned, \code{n}, by will depend on the
#' number of players supplied to the \code{players} argument: one input name
#' will result in \code{n = 5}; multiple input names will result in
#' \code{n = 1}.
#'
#' @return A character vector of player names.
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' # Fetch player data from Transfermarkt
#' epl_players <- get_players(1992:2020, "England")
#'
#' # Return several team mates for one named player
#' sample_colleagues(epl_players, "James Milner", n = 5)
#'
#' # Return one team mate in common for named players
#' sample_colleagues(
#'   epl_players,
#'   c("Mark Viduka", "Kevin Phillips", "Nicky Butt"),
#'   n = 1
#' )
#' }
sample_colleagues <- function(all_players, players, n = NULL) {

  if (is.null(n)) {

    if (length(players) == 1) {
      n = 5
    }

    if (length(players) > 1) {
      n = 1
    }

  }

  get_colleagues(all_players, players) |>
    dplyr::group_by(.data$player_name) |>
    dplyr::summarise(minutes_played = sum(.data$minutes_played, na.rm = TRUE)) |>
    dplyr::slice_sample(n = n, weight_by = .data$minutes_played) |>
    dplyr::pull(.data$player_name)

}
