# Einleitung

Der Sudoku-Solver erfasst, loest und fuellt Sodukus autonom und korrekt aus.
Zumindest, sollte er das...


        "Ein gro�es Projekt bringt neben Ruhm auch immer gro�e Probleme mit sich." 

## Der Plan
Unsere Idee war es einen Roboter zu bauen, der bei der L�sung von Sudokus hilft. Er sollte die ihm vorgelegten Sudokus eigenst�ndig einlesen, optionalerweise auch eine
Eingabe vom Benutzer verwenden, und mit den gewonnenen Daten das vollst�ndige Sudoku berechnen. Abschlie�end sollte er die Ergebnisse an den richtigen Stellen im Sudoku
eintragen. Zur Erleichterung der Bedienung wollten wir eine grafische Benutzeroberflaeche zur Vefuegung stellen, die den aktuellen Fortschritt und das Ergebnis
anzeigt.

## Die Konstruktion
Der Roboter besteht aus zwei NXT-Bricks, vier Motoren, einem Touch-, drei Lichtsensoren und einer gro�en Anzahl an sonstigen Lego-Steinen.
Die Konstruktion entspricht der eines Autos mit Hinterradantrieb und einer Linearfuehrung als Sto�stange, die mit Hilfe eines Motors die Lichtsensoren beweglich machen.
Dadurch koennen senkrecht zur Fahrtrichtung die Sensoren bewegt werden, an die der Motor, der den Stift hoch und herunter laesst, gekoppelt ist. Durch die Konstruktion ist
eine schnelle Bewegung des Schreib- und Lesekopfes bei asynchroner Bewegung gewaehrleistet. Die Lichtsensoren sind mit einer Kette verbunden,die durch ein Getriebe vom Motor bewegt wird.


## Die Programmierung
F�r die Programmierung unserer Software arbeiteten wir mit Objektorientierter Programmierung in  MATLAB�. Damit ist es m�glich komplexe Anwendungen bzw. Datenstrukturen 
effizienter zu verwalten. 
 -> Picture: 'Filesystem' <-


## Probleme
Die Probleme bei diesem Projekt sind quasi ueberabzaehlbar. Sie gehen von einer guten Erkennung des Sudokufeldes, ueber die praezise Steuerung der Motoren bis hin zum Malen der Loesungszahlen.
Schlussendlich konnten wir nahezu alle Probleme au�er eins �berwinden. Das nicht zu l�sende Problem war eine korrekte Auswertung aus den eingelesenen Daten
der Lichtsensoren. Leider waren diese Daten nicht stabil interpretierbar und so war es nicht m�glich, die R�nder der K�stchen bzw. die Zahlen korrekt 
zu erkennen.