
#' Fetch A Dataframe From Transfermarkt
#'
#' @param years Numeric. Years for which to fetch data.
#' @param country Character. Country from which to fetch data.
#'
#' @return A data.frame/tibble.
#' @export
#'
#' @examples \dontrun{get_players()}
get_players <- function(years = 1992:2021, country = "England") {

  message("- Fetching team URLs")

  team_urls <- purrr::map(
    years,
    ~worldfootballR::tm_league_team_urls(
      country_name = country,
      start_year = as.character(.x)
    )
  )

  team_names <- purrr::map(
    team_urls,
    ~stringr::str_extract(.x, "(?<=com/).*(?=/start)") |>
      stringr::str_replace_all("-", "_")
  )

  message("- Fetching squad data")

  purrr::map_dfr(
    team_urls,
    ~purrr::map(
      .x,
      ~worldfootballR::tm_squad_stats(.x) |>
        dplyr::mutate(team_url = .x)
    )
  ) |>
    dplyr::mutate(
      team = stringr::str_extract(team_url, "(?<=com/).*(?=/start)"),
      year = stringr::str_extract(team_url, "(?<=id/)\\d{4}$"),
      team_year = paste0(team, "_", year)
    ) |>
    dplyr::tibble()

}
