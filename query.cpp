//2)query parametrica: barra di ricerca video/canale/topic

#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

using namespace std ;

#define PG_HOST "127.0.0.1" //NewServer ? // oppure "localhost" o "postgresql"
#define PG_USER "postgres" // il vostro nome utente
#define PG_DB "pro2" // il nome del database
#define PG_PASS "davide2002" // la vostra password
#define PG_PORT 5432

void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsistenti! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}

int main(int argc, char **argv) {  

    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    //Menu per ricerca video/canale/topic
    int scelta = -1;

    do{
        cout << "Selezionare l'opzione desiderata: \n" << "0) Terminare ricerca\n" << "1) Ricerca video\n" << "2) Ricerca canale\n" << "3) Ricerca video per categoria\n" << "4) Ricerca canale per categoria\n\n"
            << "Inserire scelta: ";
        cin >> scelta;
        cout <<"\n\n";

        switch(scelta){
            case 1:{
                    string query = "SELECT titolo, descrizione, datapubblicazione, durata, costo FROM Video WHERE titolo = $1::varchar(256) AND visibilita = 'Pubblico'";
                    PGresult* stmt = PQprepare(conn, "query_ricercaVideo", query.c_str(), 1, NULL);
              
                    string video;
                    cout << "Inserire il titolo del video: ";
                    getline(cin, video); //cin >> video;  std::getline(std::cin, stringa);
                    cout << "\n->" << video <<endl; //Output per vedere cosa si salva dell'input
                    const char* parameter = video.c_str();
                    cout << "\nRisultati della ricerca: \n";

                    PGresult* res = PQexecPrepared(conn, "query_ricercaVideo", 1, &parameter, NULL, 0, 0);
                    checkResults(res, conn);

                    int tuple = PQntuples(res);
                    int campi = PQnfields(res);

                    for (int i = 0; i < campi; ++i) {
                        cout << PQfname(res, i) << ", ";
                    }
                    cout << endl;

                    for (int i = 0; i < tuple; ++i) {
                        for (int j = 0; j < campi; ++j) {
                            cout << PQgetvalue(res, i, j) << ", ";
                        }
                        cout << endl;
                    }

                    cout << "\n\n";
                }
                break;
            case 2:
                {
                    //SELECT imgprofilo, handle, dataiscrizione FROM account  WHERE handle = $1::varchar(256) AND statoaccount = 'Attivo';
                }
                break;
            case 3:
                {
                    //SELECT * FROM video WHERE categoria = $1::varchar(256) AND visibilita = 'Pubblico';
                }
                break;
            case 4: //Basta avere un video di una categoria per essere considerato un canale di quella categoria
                {
                    //SELECT A.imgprofilo, A.handle, A.dataiscrizione FROM account AS A JOIN video AS V ON V.id_account = A.id_account WHERE V.categoria = $1::varchar(256) AND statoaccount = 'Attivo';
                }
                break;
            case 5:{
                    PGresult* res;
                    res = PQexec(conn, "SELECT titolo, descrizione, datapubblicazione, durata, costo FROM Video WHERE titolo = 'Titolo del video 1' AND visibilita = 'Pubblico'");
                    checkResults(res, conn);

                    int tuple = PQntuples(res);
                    int campi = PQnfields(res);

                    for (int i = 0; i < campi; ++i) {
                        cout << PQfname(res, i) << ", ";
                    }
                    cout << endl;

                    for (int i = 0; i < tuple; ++i) {
                        for (int j = 0; j < campi; ++j) {
                            cout << PQgetvalue(res, i, j) << ", ";
                        }
                    }

                    cout << "\n\n";
                }
                break;
        }
    }while(scelta != 0);

    PQfinish(conn);

    return 0;
}
