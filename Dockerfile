# Image PostgreSQL de la pile, épinglée par condensat et construite ici plutôt que tirée telle
# quelle : l'image officielle porte des failles HIGH et CRITICAL corrigeables que la veille de
# storia relève (analyse du 28/10/2026), et qu'aucune version publiée ne ferme encore.
FROM postgres:18.6-alpine@sha256:10a5c69a83035ab5239f5620d708520e8b28f5aa1f2b20143e6024532edadfb5

# brotli-libs (CVE-2026-111497, au catalogue KEV) et libcurl ont un correctif Alpine que l'image
# officielle n'a pas encore repris. gosu ne sert qu'à quitter root au démarrage ; compilé avec un
# Go ancien, il porte le reste des failles. Le conteneur démarre directement sous le compte
# postgres (uid 70, propriétaire du volume, vérifié le 28/10/2026) : le script d'entrée n'appelle
# alors plus gosu. Même méthode que les bases d'authentik et d'infisical sur appia.
RUN apk upgrade --no-cache brotli-libs libcurl \
 && rm /usr/local/bin/gosu
USER postgres
