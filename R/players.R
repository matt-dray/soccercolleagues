
#' Fetch Player Data From Transfermarkt
#'
#' @param seasons Numeric. One of more season starting-years for which to fetch
#'   data from \href{https://www.transfermarkt.com/}{Transfermarkt}. Defaults to
#'   seasons where the English Premier League has existed (since 1992).
#' @param country Character. Country from which to fetch data from
#'     \href{https://www.transfermarkt.com/}{Transfermarkt}. Defaults to
#'     \code{"England"} for the English Premier League.
#'
#' @return A data.frame/tibble with a row per player/season and columns for
#'     name, position, age, team, year, etc.
#' @importFrom rlang .data
#' @export
#'
#' @examples \dontrun{epl_players <- get_players(1992:2021, "England")}
get_players <- function(seasons = 1992:2021, country = "England") {

  message("- Fetching team URLs")

  team_urls <- purrr::map(
    seasons,
    ~worldfootballR::tm_league_team_urls(
      country_name = country,
      start_year = as.character(.x)
    )
  )

  message("- Fetching squad data (could take a few minutes)")

  players_df <- purrr::map_dfr(
    team_urls,
    ~purrr::map(
      .x,
      ~worldfootballR::tm_squad_stats(.x) |>
        dplyr::mutate(team_url = .x)
    )
  ) |>
    dplyr::mutate(
      team_name = stringr::str_extract(.data$team_url, "(?<=com/).*(?=/startseite)"),
      season = stringr::str_extract(.data$team_url, "(?<=id/)\\d{4}$")
    ) |>
    dplyr::tibble()

}
