#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h" 
#include <string>

using namespace std;

#define PG_HOST "127.0.0.1" //NewServer ? // oppure "localhost" o "postgresql"
#define PG_USER "postgres" // il vostro nome utente
#define PG_DB "project" // il nome del database
#define PG_PASS "davide2002" // la vostra password
#define PG_PORT 5432

void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsistenti! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}



int main() {
    //Connessioni e relativa verifica
    ofstream outputFile("outputView.txt"); // Apriamo il file di output
    if (!outputFile.is_open()) { // Controlliamo se il file è stato aperto correttamente
        cout << "Errore nell'apertura del file." << endl;
        return 1;
    }

    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);
    PGconn* conn = PQconnectdb(conninfo);
    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    //Lettura dal database e scrittura nel file
    PGresult* res;
    res = PQexec(conn, "SELECT * FROM views");
    checkResults(res, conn);

    int tuple = PQntuples(res); //numero di tuple restituite dalla query
    int campi = PQnfields(res); //numero di campi restituiti utilizzando la funzione

    // Scrivo i valori 
    for (int i = 0; i < tuple; ++i) {
        outputFile << "('" << PQgetvalue(res, i, 0) << "', '" << PQgetvalue(res, i, 1) << "', '" << PQgetvalue(res, i, 2) << "')," << endl;
    }

    PQclear(res); //Liberata la memoria associata ai risultati
    PQfinish(conn); //Per chiudere la connessione al database
// Fine codice query

    
    outputFile.close(); // Chiudiamo il file di output

    return 0;
}
