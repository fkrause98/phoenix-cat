# Chat

## Spinning up project with Docker
* Install Docker for Mac
* In one terminal tab:
  `docker-compose build`
  `docker-compose up`
* In a second tab, once the two commands in the first tab are completed:
  `docker-compose exec web mix ecto.setup`
* If everything spins up with no errors, site will be live at localhost:4000
