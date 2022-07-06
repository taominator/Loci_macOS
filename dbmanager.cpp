#include "dbmanager.h"
#include <QSqlRecord>
#include <QtDebug>
#include <QStandardPaths>
#include <QSqlError>
#include <QDir>

dbmanager::dbmanager(QObject *parent)
    : QObject{parent}
{
    //check if appdata path directory exists. If not, make the directory
    QString path(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    QDir dir;
    if (!dir.exists(path))
        dir.mkpath(path);

    //make first database connection and send db1 to m_model
    m_db1 = QSqlDatabase::addDatabase("QSQLITE", "db1");
    m_db1.setDatabaseName(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/decks.db");
    m_db1.open();
    m_model.setDb(m_db1);
    m_tables = m_db1.tables(QSql::Tables);


    //make second database connection and send db2 to card_model
    m_db2 = QSqlDatabase::addDatabase("QSQLITE", "db2");
    m_db2.setDatabaseName(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/decks.db");
    m_db2.open();
    m_card_model.setDb(m_db2);


    //m_today = today.toString(time_format);
    m_time_format = "dd-MM-yyyy";
    m_today = QDateTime::currentDateTime();


    //update overdue review date of all cards in all decks
    for(QString table : m_tables)
    {
        QString querystring = "SELECT * FROM " + table + ";";
        QSqlQuery query(m_db1);
        query.prepare(querystring);
        query.exec();

        while(query.next())
        {
            QString card_id = query.value(1).toString();
            QString review_date = query.value(5).toString();
            QDateTime review = QDateTime::fromString(review_date, m_time_format);

            if(m_today.daysTo(review) < 0)
            {
                QString new_review_date = m_today.toString(m_time_format);

                QString querystring2 = "UPDATE " + table + " SET review_date = '" + new_review_date + "' WHERE id = " + card_id + ";";

                QSqlQuery query2(m_db1);
                query2.prepare(querystring2);
                query2.exec();
            }
        }
    }


    m_deckListModel.setStringList(m_tables);

    m_internal_fields = {"deckname", "id", "Question", "Answer", "previous_date", "review_date", "interval", "ease", "easy_bonus", "interval_modifier", "card_state"};
}

void dbmanager::setModel(QString tablename)
{
    m_model.callSql("SELECT * FROM " + tablename);
}

void dbmanager::set_cardinfo(int row_index)
{
    QSqlQuery query = m_model.query();
    query.seek(row_index);

    QString deckname = query.value(0).toString();
    QString card_id = query.value(1).toString();

    m_card_model.set_cardinfo(deckname, card_id);
}

QString dbmanager::allTableQuery(QString state)
{
    QString querystring = "SELECT deckname, id, Question, Answer FROM " + m_tables.at(0) + " WHERE card_state = \"" + state + "\"";
    int num_tables = m_tables.length();

    for(int i = 1; i < num_tables; i++)
    {
        querystring += " UNION ALL SELECT deckname, id, Question, Answer FROM " + m_tables.at(i) + " WHERE card_state = \"" + state + "\"";
    }

    return querystring;
}

QString dbmanager::allTableQuery()
{
    QString querystring = "SELECT deckname, id, Question, Answer FROM " + m_tables.at(0);
    int num_tables = m_tables.length();

    for(int i = 1; i < num_tables; i++)
    {
        querystring += " UNION ALL SELECT deckname, id, Question, Answer FROM " + m_tables.at(i);
    }

    return querystring;
}

void dbmanager::updateFieldContent(QString deckname, QString card_id, QString field, QString new_content)
{
    QString querystring = "UPDATE " + deckname + " SET " + field + " = \"" + new_content + "\" WHERE id = \"" + card_id + "\"";
    m_card_model.updateDb2(querystring);
}

void dbmanager::updateQuestion(QString deckname, QString card_id, QString field, QString new_content)
{
    QString querystring = "UPDATE " + deckname + " SET " + field + " = \"" + new_content + "\" WHERE id = \"" + card_id + "\"";
    m_card_model.updateDb2(querystring);
    querystring = "UPDATE " + deckname + " SET Question = \"" + new_content + "\" WHERE id = \"" + card_id + "\"";
    m_card_model.updateDb2(querystring);
}

void dbmanager::updateAnswer(QString deckname, QString card_id, QString field, QString new_content)
{
    QString querystring = "UPDATE " + deckname + " SET " + field + " = \"" + new_content + "\" WHERE id = \"" + card_id + "\"";
    m_card_model.updateDb2(querystring);
    querystring = "UPDATE " + deckname + " SET Answer = \"" + new_content + "\" WHERE id = \"" + card_id + "\"";
    m_card_model.updateDb2(querystring);
}

void dbmanager::set_selected_table(QString my_table)
{
    m_selected_table = my_table;
}

QVariant dbmanager::get_next_id(QString my_table)
{
    QString querystring = "Select MAX(id) from " + my_table + ";";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
    query.first();
    int id = query.value(0).toInt() + 1;
    return id;
}

void dbmanager::add_card()
{
    QString querystring = "INSERT INTO " + m_selected_table + " (deckname, id, interval_left, ease, easy_bonus, card_state) VALUES (" + "\'" + m_selected_table + "\'" + ", " + get_next_id(m_selected_table).toString() + ", '-1', 2.5, 1.3, 'New');";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
}

void dbmanager::remove_cards()
{
    QString querystring;
    for(int i = 0; i < m_model.m_selectedIds.size(); i++)
    {
        QSqlQuery query(m_db1);
        querystring = "DELETE FROM " + m_selected_table + " WHERE id = " + QString::number(m_model.m_selectedIds[i]) + ";";
        query.exec(querystring);
    }
}

void dbmanager::reset_cards()
{
    QString querystring;
    for(int i = 0; i < m_model.m_selectedIds.size(); i++)
    {
        QSqlQuery query(m_db1);
        querystring = "UPDATE " + m_selected_table + " SET previous_date = '', review_date = '', interval_left = -1, ease = 2.5, easy_bonus = 1.3, card_state = 'New' WHERE id = " + QString::number(m_model.m_selectedIds[i]) + ";";
        query.exec(querystring);
    }
}

int dbmanager::getIntervalLeft(QString my_table, QString id, QString card_state)
{
    if(card_state == "New")
    {
        return -1;
    }

    QSqlQuery query(m_db1);
    QString querystring = "SELECT * FROM " + my_table + " WHERE id = " + id + ";";
    query.exec(querystring);

    query.first();
    QString previous_date_string = query.value(4).toString();
    QDateTime previous_date = QDateTime::fromString(previous_date_string, m_time_format);
    QString review_date_string = query.value(5).toString();
    QDateTime review_date = QDateTime::fromString(review_date_string, m_time_format);

    int interval = previous_date.daysTo(review_date);
    int days_passed = previous_date.daysTo(m_today);
    int interval_left = interval - days_passed;

    return interval_left;
}

int dbmanager::readIntervalLeft(QString my_table, QString id)
{
    QSqlQuery query(m_db1);
    QString querystring = "SELECT * FROM " + my_table + " WHERE id = " + id + ";";
    query.exec(querystring);

    query.first();
    int interval_left = query.value(6).toInt();
    return interval_left;
}

QStringList dbmanager::getNewDatesAndCardState(QString my_table, QString id, int interval_left)
{
    if(interval_left == -1)
    {
        return QStringList {"", "", "New"};
    }

    QSqlQuery query(m_db1);
    QString querystring = "SELECT * FROM " + my_table + " WHERE id = " + id + ";";
    query.exec(querystring);

    query.first();
    QString previous_date_string = query.value(4).toString();
    QDateTime previous_date = QDateTime::fromString(previous_date_string, m_time_format);
    QString review_date_string = query.value(5).toString();
    QDateTime review_date = QDateTime::fromString(review_date_string, m_time_format);

    int interval = previous_date.daysTo(review_date);
    int days_passed = interval - interval_left;

    QDateTime new_previous = m_today.addDays(-days_passed);
    QString new_previous_date = new_previous.toString(m_time_format);
    QDateTime new_review = m_today.addDays(interval_left);
    QString new_review_date = new_review.toString(m_time_format);

    return QStringList {new_previous_date, new_review_date, "Review"};
}

void dbmanager::suspend_cards()
{
    QString querystring;
    for(int i = 0; i < m_model.m_selectedIds.size(); i++)
    {
        QString card_state = m_model.m_card_states[i];
        int interval_left = getIntervalLeft(m_selected_table, QString::number(m_model.m_selectedIds[i]), card_state);

        QSqlQuery query(m_db1);
        querystring = "UPDATE " + m_selected_table + " SET interval_left = " + QString::number(interval_left) + ", card_state = 'Suspended' WHERE id = " + QString::number(m_model.m_selectedIds[i]) + ";";
        query.exec(querystring);
    }
}

void dbmanager::unsuspend_cards()
{
    QString querystring;
    for(int i = 0; i < m_model.m_selectedIds.size(); i++)
    {
        if(m_model.m_card_states[i] == "Suspended")
        {
            int interval_left = readIntervalLeft(m_selected_table, QString::number(m_model.m_selectedIds[i]));
            QStringList new_dates = getNewDatesAndCardState(m_selected_table, QString::number(m_model.m_selectedIds[i]), interval_left);

            //QDateTime review = m_today.addDays(m_model.m_intervals[i]);
            //QString review_date = review.toString(m_time_format);

            QSqlQuery query(m_db1);
            querystring = "UPDATE " + m_selected_table + " SET previous_date = '" + new_dates[0] + "', review_date = '" + new_dates[1] + "', card_state = '" + new_dates[2] + "' WHERE id = " + QString::number(m_model.m_selectedIds[i]) + ";";
            query.exec(querystring);
        }
    }
}

void dbmanager::reload_m_model()
{
    setModel(m_selected_table);
}

void dbmanager::create_table(QString my_table)
{
    QString querystring;
    querystring += "CREATE TABLE IF NOT EXISTS " + my_table +" ( deckname TEXT, ";
    querystring += "id INTEGER, ";
    querystring += "Question TEXT DEFAULT 'question_field', ";
    querystring += "Answer TEXT DEFAULT 'answer_field', ";
    querystring += "previous_date TEXT, ";
    querystring += "review_date TEXT, ";
    querystring += "interval_left INTEGER, ";
    querystring += "ease REAL, ";
    querystring += "easy_bonus REAL, ";
    querystring += "interval_modifier REAL, ";
    querystring += "card_state TEXT );";


    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    m_tables = m_db1.tables(QSql::Tables);
    m_deckListModel.setStringList(m_tables);
}

void dbmanager::drop_table(QString my_table)
{
    QString querystring;
    querystring += "DROP TABLE IF EXISTS " + my_table + ";";

    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    m_tables = m_db1.tables(QSql::Tables);
    m_deckListModel.setStringList(m_tables);
}

void dbmanager::create_field(QString my_table, QString my_field)
{
    if( m_internal_fields.contains(my_field))
    {
        return;
    }

    QString querystring;
    if(m_model.columnCount() - m_model.m_numInternalFields > 1)
    {
        querystring = "ALTER TABLE " + my_table + " ADD " + my_field + " TEXT DEFAULT 'regular_field';";
    }
    else if (m_model.columnCount() - m_model.m_numInternalFields == 0)
    {
        querystring = "ALTER TABLE " + my_table + " ADD " + my_field + " TEXT DEFAULT 'question_field';";
    }
    else
    {
        querystring = "ALTER TABLE " + my_table + " ADD " + my_field + " TEXT DEFAULT 'answer_field';";
    }


    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    reload_m_model();
}

void dbmanager::drop_field(QString my_table, QString my_field)
{
    if( m_internal_fields.contains(my_field))
    {
        return;
    }


    QString querystring;

    if(my_field != m_model.record().fieldName(m_model.m_numInternalFields) && my_field != m_model.record().fieldName(m_model.m_numInternalFields+1) && m_model.record().count() > m_model.m_numInternalFields + 2)
    {
        querystring = "ALTER TABLE " + my_table + " DROP " + my_field + ";";
    }
    else if (m_model.record().count() < m_model.m_numInternalFields + 3)
    {
        if(m_model.record().count() == m_model.m_numInternalFields + 2)
        {
            if(my_field == m_model.record().fieldName(m_model.m_numInternalFields + 1))
            {
                querystring = "ALTER TABLE " + my_table + " DROP " + my_field + ";";
            }
            else
            {
                return;
            }
        }

        querystring = "ALTER TABLE " + my_table + " DROP " + my_field + ";";

    }
    else
    {
        return;
    }


    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    reload_m_model();
}

int dbmanager::get_height(bool show_front, int row)
{
    if(show_front)
    {
        return row != m_model.m_numInternalFields ? 0 : m_model.getBorderWidth() * 4;
    }
    else
    {
        return row < m_model.m_numInternalFields ? 0 : m_model.getBorderWidth() * 4;
    }
}

int dbmanager::getNumNewCards(QString my_table)
{
    QString querystring = "SELECT COUNT(1) FROM " + my_table + " WHERE card_state = 'New'";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    query.seek(0);
    int rows = query.value(0).toString().toInt();

    return rows;
}

int dbmanager::getNumReviewCards(QString my_table)
{
    QString today_date = m_today.toString(m_time_format);
    QString querystring = "SELECT COUNT(1) FROM " + my_table + " WHERE card_state = 'Review' AND review_date = '" + today_date + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    query.seek(0);
    int rows = query.value(0).toString().toInt();

    return rows;
}

bool dbmanager::setReviewCard(QString my_table)
{
    QString today_date = m_today.toString(m_time_format);
    QString querystring = "SELECT * FROM " + my_table + " WHERE card_state = 'Review' AND review_date = '" + today_date + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    if(query.seek(0))
    {
        m_card_model.set_cardinfo(my_table, query.record().value(1).toString());
        return true;
    }
    else
    {
        return false;
    }
}

bool dbmanager::setNewCard(QString my_table)
{
    QString querystring = "SELECT * FROM " + my_table + " WHERE card_state = 'New'";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();

    if(query.seek(0))
    {
        m_card_model.set_cardinfo(my_table, query.record().value(1).toString());
        return true;
    }
    else
    {
        return false;
    }
}

QVariant dbmanager::getInterval()
{
    QDateTime previous = QDateTime::fromString(m_card_model.contents.at(4), m_time_format);
    int interval = previous.daysTo(m_today);
    return interval;
}

QVariant dbmanager::getEase()
{
    QVariant value = m_card_model.contents.at(7);
    double ease = value.toDouble();
    return ease;
}

QVariant dbmanager::getEasyBonus()
{
    QVariant value = m_card_model.contents.at(8);
    double ease = value.toDouble();
    return ease;
}

void dbmanager::againButton()
{
    QString my_table = m_card_model.m_deckname;
    QString id = m_card_model.m_card_id;

    QDateTime previous = m_today.addDays(-1);
    QString previous_date = previous.toString(m_time_format);
    QString review_date = m_today.toString(m_time_format);

    QString querystring = "UPDATE " + my_table + " SET previous_date = '" + previous_date + "', review_date = '" + review_date + "', card_state = 'Review' WHERE deckname = '" + my_table + "' AND id = '" + id + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
}

void dbmanager::hardButton()
{
    QString my_table = m_card_model.m_deckname;
    QString id = m_card_model.m_card_id;
    QString card_state = m_card_model.contents.at(10);
    int interval = getInterval().toInt();
    double ease = getEase().toDouble();

    int new_interval = qCeil(interval * ease / 2);
    double new_ease;
    if(ease > 1.30)
    {
        new_ease = ease - 0.15;
    }
    else
    {
        new_ease = ease;
    }

    QDateTime newReview;
    if(card_state == "Review")
    {
        newReview = m_today.addDays(new_interval);
    }
    else
    {
        newReview = m_today.addDays(1);
    }
    QString new_previous_date = m_today.toString(m_time_format);
    QString new_review_date = newReview.toString(m_time_format);


    QString querystring = "UPDATE " + my_table + " SET previous_date = '" + new_previous_date + "', review_date = '" + new_review_date + "', ease = " + QString::number(new_ease) + ", card_state = 'Review' WHERE deckname = '" + my_table + "' AND id = '" + id + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
}

void dbmanager::goodButton()
{
    QString my_table = m_card_model.m_deckname;
    QString id = m_card_model.m_card_id;
    QString card_state = m_card_model.contents.at(10);
    int interval = getInterval().toInt();
    double ease = getEase().toDouble();

    int new_interval = qCeil(interval * ease);
    double new_ease = ease;

    QDateTime newReview;
    if(card_state == "Review")
    {
        newReview = m_today.addDays(new_interval);
    }
    else
    {
        newReview = m_today.addDays(1);
    }
    QString new_previous_date = m_today.toString(m_time_format);
    QString new_review_date = newReview.toString(m_time_format);


    QString querystring = "UPDATE " + my_table + " SET previous_date = '" + new_previous_date + "', review_date = '" + new_review_date + "', ease = " + QString::number(new_ease) + ", card_state = 'Review' WHERE deckname = '" + my_table + "' AND id = '" + id + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
}

void dbmanager::easyButton()
{
    QString my_table = m_card_model.m_deckname;
    QString id = m_card_model.m_card_id;
    QString card_state = m_card_model.contents.at(10);
    int interval = getInterval().toInt();
    double ease = getEase().toDouble();
    double easy_bonus = getEasyBonus().toDouble();

    int new_interval = qCeil(interval * ease * easy_bonus);
    double new_ease = ease + 0.15;

    QDateTime newReview;
    if(card_state == "Review")
    {
        newReview = m_today.addDays(new_interval);
    }
    else
    {
        newReview = m_today.addDays(1);
    }
    QString new_previous_date = m_today.toString(m_time_format);
    QString new_review_date = newReview.toString(m_time_format);

    QString querystring = "UPDATE " + my_table + " SET previous_date = '" + new_previous_date + "', review_date = '" + new_review_date + "', ease = " + QString::number(new_ease) + ", card_state = 'Review' WHERE deckname = '" + my_table + "' AND id = '" + id + "';";
    QSqlQuery query(m_db1);
    query.prepare(querystring);
    query.exec();
}

QString dbmanager::getCardType()
{
    return m_card_type;
}

void dbmanager::setCardType(QString str)
{
    m_card_type = str;
}

