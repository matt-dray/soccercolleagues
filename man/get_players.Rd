% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/players.R
\name{get_players}
\alias{get_players}
\title{Fetch Player Data From Transfermarkt}
\usage{
get_players(seasons = 1992:2021, country = "England")
}
\arguments{
\item{seasons}{Numeric. One of more season starting-years for which to fetch
data from \href{https://www.transfermarkt.com/}{Transfermarkt}. Defaults to
seasons where the English Premier League has existed (since 1992).}

\item{country}{Character. Country from which to fetch data from
\href{https://www.transfermarkt.com/}{Transfermarkt}. Defaults to
\code{"England"} for the English Premier League.}
}
\value{
A data.frame/tibble with a row per player/season and columns for
name, position, age, team, year, etc.
}
\description{
Fetch Player Data From Transfermarkt
}
\examples{
\dontrun{epl_players <- get_players(1992:2021, "England")}
}
