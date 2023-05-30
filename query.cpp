//query parametrica: barra di ricerca video/canale/topic

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



string capitalizeString(const string& input) {
    if(input.empty()) {
        return input;  // Restituisce la stringa vuota se l'input è vuoto
    }

    string result = input;
    result[0] = toupper(result[0]);  // Converte il primo carattere in maiuscolo

    for(size_t i = 1; i < result.length(); i++) {
        result[i] = tolower(result[i]);  // Converte tutti gli altri caratteri in minuscolo
    }
    return result;
}




void stampaRes(PGresult* res){
    int tuple = PQntuples(res);
    int campi = PQnfields(res);

    for (int i = 0; i < campi; ++i) {
        cout << capitalizeString(PQfname(res, i));
        if(i < campi-1)
                cout << ", ";
    }
    cout << endl;

    for (int i = 0; i < tuple; ++i) {
        for (int j = 0; j < campi; ++j) {
            cout << PQgetvalue(res, i, j);
            if(j < campi-1)
                cout << ", ";
        }
        cout << endl;
    }
}



void queryProcedure(PGconn* conn, string query){
    string input;
    cin.ignore();
    getline(cin, input);

    PGresult* stmt = PQprepare(conn, "query_ricerca", query.c_str(), 1, NULL);
    
    cout << "\n->" << input <<endl; //Output per vedere cosa si salva dell'input //Da eliminare/////////////////////////////
    const char* parameter = input.c_str();
    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexecPrepared(conn, "query_ricerca", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);

    stampaRes(res);
}



void queryProcedureInt(PGconn* conn, string query){
    string input;
    cin.ignore();
    getline(cin, input);

    PGresult* stmt = PQprepare(conn, "query_ricerca", query.c_str(), 1, NULL);
    
    cout << "\n->" << input <<endl; //Output per vedere cosa si salva dell'input //Da eliminare/////////////////////////////
    const char* parameter = input.c_str();
    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexecPrepared(conn, "query_ricerca", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);

    stampaRes(res);
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

        switch(scelta){
            case 1:{
                    cout << "Inserire il titolo del video: ";
                    string query = "SELECT thumbnail, titolo, descrizione, datapubblicazione, durata, costo FROM Video WHERE titolo = $1::varchar(256) AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query);
                }
            break;

            case 2:{
                    cout << "Inserire il nome del canale: ";
                    string query = "SELECT imgprofilo, handle, dataiscrizione FROM Account WHERE handle = $1::varchar(256) AND statoaccount = 'Attivo'";
                    queryProcedure(conn, query);
                }
            break;

            case 3:{
                    cout << "Inserire il nome della categoria (iniziale maiuscola): ";
                    string query = "SELECT thumbnail, titolo, descrizione, datapubblicazione, durata, costo FROM Video WHERE categoria = $1::Categorie AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query);
                }
            break;

            case 4:{
                    cout << "Inserire il nome della categoria (iniziale maiuscola):  ";
                    string query = "SELECT DISTINCT A.imgprofilo, A.handle, A.dataiscrizione, A.descrizione FROM Account AS A JOIN Video AS V ON V.id_account = A.id_account WHERE V.categoria = $1::Categorie AND statoaccount = 'Attivo'";
                    queryProcedure(conn, query);
                }
            break;
        }
        cout << "\n-----------------------------------\n\n";
    }while(scelta != 0);

    PQfinish(conn);

    return 0;
}
