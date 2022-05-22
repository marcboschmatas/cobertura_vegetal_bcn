# cobertura_vegetal_bcn
Anàlisi de la cobertura vegetal a l'espai públic de Barcelona


Aquest codi serveix per a calcular el nivell mitjà de vegetació al voltant de cada edifici o grup d'edificis contigus de Barcelona.
Utilitza les dades de NDVI (Índex de Vegetació de Diferència Normalitzada) de [l'ICGC](https://www.icgc.cat/ca/Administracio-i-empresa/Descarregues/Imatges-aeries-i-de-satel-lit/NDVI) i el concepte de tessel·les morfològiques (és a dir, l'espai més proper a cada edifici) conceptualitzat per [Martin Fleischmann et. al (2020)](doi:10.1016/j.compenvurbsys.2019.101441).

En el primer arxiu es descarreguen les dades d'edificis del cadastre i se simplifiquen de tal manera que cada grup d'edificis contigus esdevé un sol polígon. En el segon, utilitzant la llibreria [momepy](https://github.com/pysal/momepy) de Python, es calculen les tessel·les morfològiques al voltant de cada edifici. En el tercer, es reescala l'índex de vegetació de 0:200 a l'original -1:1 i es calcula la mitjana per tessel·la.


Analysis of greening in Barcelona public space.

This code computes the average green coverage around each building or group of contiguous buildings in Barcelona.
It uses NDVI data from the [Catalan Institute of Geography and Cartography](https://www.icgc.cat/en/Public-Administration-and-Enterprises/Downloads/Aerial-photos-and-orthophotos/NDVI) and the concept of morphological tessellation (i.e. the space closest to each building) as conceptualised by [Martin Fleischmann et. al (2020)](doi:10.1016/j.compenvurbsys.2019.101441).

In the first file, data is downloaded from the Spanish Cadaster and simplified so as each group of contiguous buildings becomes one single polygon. In the second one, by using the Python [momepy](https://github.com/pysal/momepy) library, a tessellation is computed. In the third one, the NDVI is rescaled back to -1:1 from 0:200 and the average by tessera is computed.
