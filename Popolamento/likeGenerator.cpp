#include <cstdio>
#include <iostream>
#include <fstream>
#include <ctime>
#include <cstring>
#include <time.h>
#include "dependencies/include/libpq-fe.h"

using namespace std ;

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



void queryProcedure(PGconn* conn, string query, string account, string video, string data, string like){
    PGresult* stmt = PQprepare(conn, "query_queryProcedure", query.c_str(), 1, NULL);
    const char* accountC = account.c_str();
    const char* vidC = video.c_str();
    const char* dateC = data.c_str();
    const char* likeC = like.c_str();
    const char* paramValues4[4] = {accountC, vidC, dateC, likeC};
    PGresult* res = PQexecPrepared(conn, "query_queryProcedure", 4, paramValues4, NULL, 0, 0);
}



//Funzione d'appoggio per decidere se like o dislike -> il 70% saranno likes
int likeFun(){
    return (rand() % 100) <= 70 ?  1 : -1;
}



int main(){
    //Connessione database
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    srand(time(NULL));
    
    //Leggere da views account e id_Video, copiare timestamp di views e generare valutazione
    PGresult* res = PQexec(conn, "SELECT * FROM views");
    checkResults(res, conn);
    int tuple = PQntuples(res);

    string account, video, data, like;
    
    for(int i=0; i<(tuple*0.7); i++){
        account = PQgetvalue(res, i, 0);
        video = PQgetvalue(res, i, 1);
        data = PQgetvalue(res, i, 2);
        like = to_string(likeFun());
        
        //Query insert into
        string query = "INSERT INTO likevideo(account, id_Video, data, valutation) VALUES ($1::int, $2::int, $3::timestamp, $4::Likes)";
        queryProcedure(conn, query, account, video, data, like);
    }
    PQclear(res);
    PQfinish(conn);
    cout << "Completato con successo\n\n";
    return 0;
}