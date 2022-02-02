
#' Get A Single Player's Colleagues
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param player Character. A single player's name (case sensitive).
#'
#' @return A data.frame/tibble.
#' @export
#'
#' @examples \dontrun{get_player_colleagues()}
get_player_colleagues <- function(all_players, player) {

  player_team_urls <-
    all_players |>
    dplyr::filter(player_name == player) |>
    dplyr::distinct(team_url) |>
    dplyr::pull()

  all_players |>
    dplyr::filter(
      team_url %in% player_team_urls,
      player_name != player
    )

}

#' Get Multiple Players' Co-Colleagues
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param players Character. Two or more player names (case sensitive).
#'
#' @return Character vector.
#' @export
#'
#' @examples \dontrun{get_co_colleagues()}
get_co_colleagues <- function(all_players, players) {

  colleague_list <- vector(mode = "list", length = length(players))

  for (i in seq_along(players)) {

    colleague_names <-
      get_player_colleagues(all_players, players[i]) |>
      dplyr::filter(player_name != "") |>
      dplyr::pull(player_name) |>
      unique()

    colleague_list[[i]] <- colleague_names

  }

  co_colleagues_names <-
    colleague_list |>
    unlist() |>
    table() |>
    as.data.frame() |>
    dplyr::mutate(name = as.character(Var1)) |>
    dplyr::filter(Freq == length(players)) |>
    dplyr::pull(name)

  all_players |> filter(player_name %in% co_colleagues_names)


}

#' Sample From A Single Player's Colleagues
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param players Character. A single player name (case sensitive).
#' @param n Numeric. Number of team-mates' names to return.
#'
#' @return Character vector.
#' @export
#'
#' @examples \dontrun{sample_player_colleagues()}
sample_player_colleagues <- function(all_players, player, n = 5) {

  get_player_colleagues(all_players, player) |>
    group_by(player_name) |>
    summarise(minutes_played = sum(minutes_played, na.rm = TRUE)) |>
    slice_sample(n = n, weight_by = minutes_played) |>   # TODO: sample from as many clubs as poss?
    pull(player_name)

}

#' Sample From Multiple Players' Co-Colleagues
#'
#' @param all_players Data.frame. Data fetched with \code{\link{get_players}}.
#' @param players Character. Two or more player names (case sensitive).
#' @param n Numeric. Number of team-mates' names to return.
#'
#' @return Character vector.
#' @export
#'
#' @examples \dontrun{sample_co_colleagues()}
sample_co_colleagues <- function(all_players, players, n = 1) {

  get_co_colleagues(all_players, players) |>
    group_by(player_name) |>
    summarise(minutes_played = sum(minutes_played, na.rm = TRUE)) |>
    slice_sample(n = n, weight_by = minutes_played) |>
    pull(player_name)

}
