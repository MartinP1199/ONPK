# LanHelper

Webový nástroj pre zjednodušenie subsieťovania.

Aktuálna verzia:    V1.0

### Projekt je riešený v prostredí:
Python, HTML, CSS, javascript

### Použité moduly a doplnky: 

- Flask - https://flask.palletsprojects.com/
  
    Python knižnica vytvára web server.
    Knižnica v aplikácii zabezpečuje komunikáciu web-server.
    Je nutné doinštalovať, nie je súčasťou základného Pythonu, inštalácia pip `pip install Flask`


- netaddr - https://netaddr.readthedocs.io/

    Python knižnica so základnými prvkami siete ako je napr IP adresa.
    Bola použitá pre položenie algoritmu subsieťovania.
    Je nutné doinštalovať, nie je súčasťou základného Pythonu, inštalácia pip `pip install netaddr`


- Bootstrap 5 - https://getbootstrap.com/

    Front-end framework s predvyplnenými vzormi pre prácu s HTML/CSS.
    Použité pre dosiahnutie príjemnejšieho vzhľadu aplikácie.
    Bola nalikovaná prenosná verzia, nie je nutné inštalovať.

### Funkcionalita

- subsieťovanie IPV4 so statickou maskou
- subsieťovanie IPV4 s variabilnou maskou
- ohlásenie chybne zadaných parametrov cez webové rozhranie

### Spustenie

Program sa spúšťa cez príkazový riadok pytonu spustením súboru main.py čím sa zapne web server a aplikácia je dostupná z lokálnej adresy a portu 8888.

### Ovládanie
 
Aplikácia sa ovláda cez webové grafické rozhranie, do jednotlivých okien treba zadať parametre a po stlačení tlačidla "Subnet" sa zobrazí požadované subsiete.


### Položky menu
 
- Domov - stránka určená pre základnú prezentáciu nástrojov
- Subnets - stránka s funkcionalitou subsieťovania
- Helper - stránka určená pre rýchlu diagnostiku IP a masky

