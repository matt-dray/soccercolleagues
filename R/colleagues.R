
#' Get A Single Player's Colleagues
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param player Character. A single player's name (case sensitive).
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

#' Get Player Colleagues
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param players Character. Two or more player names (case sensitive).
#'
#' @return Character vector.
#' @importFrom rlang .data
#' @export
#'
#' @examples \dontrun{get_co_colleagues()}
get_colleagues <- function(all_players, players) {

  colleague_list <- vector(mode = "list", length = length(players))

  for (i in seq_along(players)) {

    colleague_names <-
      .get_player_colleagues(all_players, players[i]) |>
      dplyr::filter(.data$player_name != "") |>
      dplyr::pull(.data$player_name) |>
      unique()

    colleague_list[[i]] <- colleague_names

  }

  co_colleagues_names <-
    colleague_list |>
    unlist() |>
    table() |>
    as.data.frame() |>
    dplyr::mutate(name = as.character(.data$Var1)) |>
    dplyr::filter(.data$Freq == length(players)) |>
    dplyr::pull(.data$name)

  all_players |>
    dplyr::filter(.data$player_name %in% co_colleagues_names)


}

#' Sample From Team Mates
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param players Character. One or more player names (case sensitive).
#' @param n Numeric. Number of team-mates' names to return.
#'
#' @return Character vector.
#' @importFrom rlang .data
#' @export
#'
#' @examples \dontrun{sample_colleagues()}
sample_colleagues <- function(all_players, players, n = 1) {

  get_colleagues(all_players, players) |>
    dplyr::group_by(.data$player_name) |>
    dplyr::summarise(minutes_played = sum(.data$minutes_played, na.rm = TRUE)) |>
    dplyr::slice_sample(n = n, weight_by = .data$minutes_played) |>
    dplyr::pull(.data$player_name)

}
