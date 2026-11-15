# Image PostgreSQL de la pile, épinglée par condensat et construite ici plutôt que tirée telle
# quelle : l'image officielle porte des failles HIGH et CRITICAL corrigeables que la veille de
# storia relève (analyse du 28/10/2026), et qu'aucune version publiée ne ferme encore.
FROM postgres:18.6-alpine@sha256:10a5c69a83035ab5239f5620d708520e8b28f5aa1f2b20143e6024532edadfb5

# L'image officielle tarde à reprendre les correctifs Alpine : brotli-libs (CVE-2026-111497) le
# 28/10/2026, puis krb5-libs et libxslt (CVE-2026-125350, toutes deux au catalogue KEV) le
# 15/11/2026, que la liste nominative d'alors laissait passer. Tous les paquets sont donc mis à
# jour, à chaque reconstruction hebdomadaire. gosu ne sert qu'à quitter root au démarrage ; compilé avec un
# Go ancien, il porte le reste des failles. Le conteneur démarre directement sous le compte
# postgres (uid 70, propriétaire du volume, vérifié le 28/10/2026) : le script d'entrée n'appelle
# alors plus gosu. Même méthode que les bases d'authentik et d'infisical sur appia.
RUN apk upgrade --no-cache \
 && rm /usr/local/bin/gosu
USER postgres
