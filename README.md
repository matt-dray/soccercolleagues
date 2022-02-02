
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {soccercolleagues}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

A work-in-progress, proof-of-concept R package to help you find the past
and current team mates of a named footballer, or to find a team mate
shared by multiple players at some point. Inspired by pub-quiz questions
in this style.

\[Insert gif of Kieran Dyer and Lee Bowyer fighting as Newcastle team
mates\]

Install from GitHub.

``` r
remotes::install_github("matt-dray/soccercolleagues")
library(soccercolleagues)
```

Fetch all players from all seasons of the English Premier League.

``` r
epl_players <- get_players(
  years = 1992:2020,
  country = "England"
)
```

Find all the team mates of a named player for these years.

``` r
colleagues <- get_player_colleagues(
  all_players = epl_players,
  player = "James Milner"
)
```

Find a common team mate for a set of named players.

``` r
sample_colleagues(
  all_players = epl_players,
  players = colleagues
)
```
