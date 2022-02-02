
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {soccercolleagues}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

A work-in-progress, proof-of-concept R package to help you find:

-   past and present team mates of a named footballer
-   a single team mate shared by multiple players at some point

This package is dependent on [the excellent {worldfootballR} package by
Jason Zivkovic](https://jaseziv.github.io/worldfootballR/), which helps
fetch player data from [Transfermarkt](https://www.transfermarkt.com/).

\[Insert gif of Kieran Dyer and Lee Bowyer fighting as Newcastle team
mates\]

You can install the package from GitHub.

``` r
remotes::install_github("matt-dray/soccercolleagues")
library(soccercolleagues)
```

Example: fetch all players from all seasons of the English Premier
League.

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

Sample from all the current and former team mates of a named player.
Sampling is weighted by total playing time, so well-known players are
more likely to arise.

``` r
sample_colleagues(
  all_players = epl_players,
  player = "James Milner",
  n = 5
)
```

    [1] "Aaron Lennon" "Ian Harte" "Pablo Zabaleta" "Stiliyan Petrov" "Kyle Walker"  

You can also find a common team mate for a set of named players, if they
have one.

``` r
sample_colleagues(
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

In the spirit of the ‘pub quiz’ nature of this, there’s also an
*extremely* proof-of-concept Shiny app available with `open_quiz_app()`.
You’ll need to install {shiny} and {shinyjs} from CRAN before you use
it.
