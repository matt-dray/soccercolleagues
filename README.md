
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

This package is dependent on [the excellent {worldfootballR} package by
Jason Zivkovic](https://jaseziv.github.io/worldfootballR/), which helps
fetch player data from [Transfermarkt](https://www.transfermarkt.com/).

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

sample_n(epl_players, 5) |> 
  select(player_name, team, year)
```

    # A tibble: 5 × 3
      player_name      team             year 
      <chr>            <chr>            <chr>
    1 Magnus Hedman    coventry-city    1998 
    2 Christian Dailly west-ham-united  2000 
    3 Jason Roberts    blackburn-rovers 2011 
    4 Julian Dicks     west-ham-united  1998 
    5 Steven Gerrard   fc-liverpool     2002 

Sample from the team mates of a named player. Sampling is weighted by
total playing time, so well-known players are more likely to arise.

``` r
sample_co_colleagues(
  all_players = epl_players,
  player = "James Milner",
  n = 5
)
```

    [1] "Aaron Lennon" "Ian Harte" "Pablo Zabaleta" "Wayne Routledge" "Kyle Walker"  

Find a common team mate for a set of named players.

``` r
sample_co_colleagues(
  all_players = epl_players,
  players = c(
    "Kevin Phillips",
    "Mark Viduka",
    "Dejan Lovren",
    "Danny Ings",
    "Nicky Butt"
  ),
  n = 1
)
```

    [1] "James Milner"
