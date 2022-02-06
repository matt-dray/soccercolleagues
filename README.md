
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {soccercolleagues}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/soccercolleagues/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/soccercolleagues/actions)
[![Codecov test
coverage](https://codecov.io/gh/matt-dray/soccercolleagues/branch/main/graph/badge.svg)](https://codecov.io/gh/matt-dray/soccercolleagues?branch=main)
[![Blog
post](https://img.shields.io/badge/rostrum.blog-post-008900?labelColor=000000&logo=data%3Aimage%2Fgif%3Bbase64%2CR0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh%2BQQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2022/02/04/soccercolleagues/)
<!-- badges: end -->

A proof-of-concept R package to help you find:

-   past and present team mates of named footballers
-   a single team mate shared by multiple players at some point

Read more in [the accompanying blog
post](https://www.rostrum.blog/2022/02/04/soccercolleagues/).

This package is dependent on [the excellent {worldfootballR} package by
Jason Zivkovic](https://jaseziv.github.io/worldfootballR/), which helps
fetch player data from [Transfermarkt](https://www.transfermarkt.com/).

\[Insert gif of Kieran Dyer and Lee Bowyer fighting as Newcastle team
mates\]

You can install the package from GitHub. It uses the base R pipe (`|>`)
internally, so you’ll need R &gt;=v4.1.

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

From this, you can isolate all the team mates for a given player, or all
the common team mates for several named players for the teams and season
in which they played together.

``` r
get_colleagues(
  epl_players,
  c("Gary Neville", "Phil Neville")
) |>
  glimpse()
```

    ## Rows: 880
    ## Columns: 12
    ## $ focus_name     <chr> "Gary Neville", "Gary Neville", "Gary Neville", "Gary Neville", …
    ## $ player_name    <chr> "Kevin Pilkington", "Gary Walsh", "Peter Schmeichel", "Colin Mur…
    ## $ player_pos     <chr> "Goalkeeper", "Goalkeeper", "Goalkeeper", "Centre-Back", "Right-…
    ## $ player_age     <dbl> 18, 24, 28, 16, 28, 26, 31, 27, 18, 24, 18, 23, 17, 17, 17, 17, …
    ## $ nationality    <chr> "England", "England", "Denmark", "Northern Ireland", "England", …
    ## $ in_squad       <dbl> 1, 16, 46, 0, 36, 46, 47, 48, 0, 45, 45, 40, 3, 0, 1, 2, 30, 10,…
    ## $ appearances    <dbl> 0, 1, 46, 0, 35, 45, 47, 47, 0, 45, 45, 30, 1, 0, 0, 1, 29, 7, 2…
    ## $ goals          <dbl> 0, 0, 0, 0, 1, 5, 5, 1, 0, 6, 11, 3, 0, 0, 0, 0, 1, 1, 9, 9, 15,…
    ## $ minutes_played <dbl> 0, 90, 4170, 0, 3102, 3932, 4229, 4260, 0, 3890, 3871, 1546, 25,…
    ## $ team_url       <chr> "https://www.transfermarkt.com/manchester-united/startseite/vere…
    ## $ team_name      <chr> "manchester-united", "manchester-united", "manchester-united", "…
    ## $ season         <chr> "1992", "1992", "1992", "1992", "1992", "1992", "1992", "1992", …

Sample from all the current and former team mates of a named player or
players. Sampling is weighted by total playing time, so well-known
players are more likely to arise.

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

This is especially satisfying if they only have one player in common.

In the spirit of the ‘pub quiz’ nature of this, there’s also an
*extremely* proof-of-concept Shiny app available with
`open_colleagues_quiz()`. You’ll need to install {shiny} and {shinyjs}
from CRAN before you use it.
