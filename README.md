
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {soccercolleagues}

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/matt-dray/soccercolleagues/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/soccercolleagues/actions)
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
League. This will take several minutes.

``` r
epl_players <- get_players(
  seasons = 1992:2020,
  country = "England"
)

sample_n(epl_players, 5) |> 
  select(player_name, team_name, season)
```

    ## # A tibble: 5 × 3
    ##   player_name      team_name           season
    ##   <chr>            <chr>               <chr> 
    ## 1 Rob Lee          newcastle-united    1998  
    ## 2 Gordon Durie     tottenham-hotspur   1992  
    ## 3 Cheikhou Kouyaté west-ham-united     2017  
    ## 4 Daniel James     swansea-city        2016  
    ## 5 Julian Watts     sheffield-wednesday 1995  

Sample from all the current and former team mates of a named player.
Sampling is weighted by total playing time, so well-known players are
more likely to arise.

``` r
sample_colleagues(
  all_players = epl_players,
  players = "Emile Heskey",
  n = 5
)
```

    ## [1] "Shay Given"    "Dwight Yorke"    "El-Hadji Diouf"
    ## [4] "Matthew Upson" "Leighton Baines"

You can also sample common team mates for a set of named players, if
they have any. This is especially sayisfying if they only have one
player in common.

``` r
sample_colleagues(
  all_players = epl_players,
  players = c(
    "Shay Given",
    "Dwight Yorke",
    "El-Hadji Diouf",
    "Matthew Upson",
    "Leighton Baines"
  )
)
```

    ## [1] "Emile Heskey"

In the spirit of the ‘pub quiz’ nature of this, there’s also an
*extremely* proof-of-concept Shiny app available with
`open_colleagues_quiz()`. You’ll need to install {shiny} and {shinyjs}
from CRAN before you use it.