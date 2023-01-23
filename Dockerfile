FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y && mkdir -p /var/lib/shiny-server/bookmarks/shiny

RUN R -e "install.packages(c('shiny', 'shinythemes', 'ggplot2'))"

COPY ./LifelinesML/ /srv/shiny-server/

RUN chmod -R 755 /srv/shiny-server/

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]