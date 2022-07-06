#include "card_model.h"

card_model::card_model(QObject *parent)
    : QAbstractListModel{parent}
{

}

void card_model::refresh()
{
    emit dataChanged(index(0), index(fields.length()-1));
    emit layoutChanged();
}

int card_model::rowCount(const QModelIndex &parent) const
{
    if(parent.isValid()) //No idea why its not the opposite
    {
        return 0;
    }
    return m_data.count();
}

QVariant card_model::data(const QModelIndex &index, int role) const
{
    if(!index.isValid())
    {
        return QVariant();
    }

    const Data &data = m_data.at(index.row());
    if(role == FieldRole)
    {
        return data.field;
    }
    else if(role == ContentRole)
    {
        return data.content;
    }
    else
    {
        return QVariant();
    }
}

QHash<int, QByteArray> card_model::roleNames() const
{
    static QHash<int, QByteArray> mapping{
        {FieldRole, "field"},
        {ContentRole, "content"}
    };
    return mapping;
}

void card_model::setDb(QSqlDatabase &db)
{
    db2 = db;
}

void card_model::set_cardinfo(QString deckname, QString card_id)
{
    fields.clear();
    contents.clear();
    m_data.clear();
    m_deckname = deckname;
    m_card_id = card_id;

    QSqlQuery query(db2);
    callSql(&query, "SELECT * FROM " + m_deckname + " WHERE id = " + m_card_id);
    query.first();

    QSqlRecord record = db2.record(m_deckname);
    int num_columns = record.count();
    for(int i = 0; i < num_columns; i++)
    {
        QString field = record.field(i).name();
        fields.append(field);

        contents.append(query.value(i).toString());
    }


    for(int i = 0; i < fields.count(); i++)
    {
        Data data(fields.at(i), contents.at(i));
        m_data.append(data);
    }

    //for(int i = 0; i < m_data.length(); i++)
    //{
    //    //() << m_data.at(i).field;
    //    qInfo() << m_data.at(i).content;
    //}

    refresh();
}

void card_model::updateDb2(QString querystring)
{
    QSqlQuery query(db2);
    callSql(&query, querystring);
    set_cardinfo(m_deckname, m_card_id);
}

void card_model::callSql(QSqlQuery *query, QString queryString)
{
    query->prepare(queryString);
    query->exec();
}

void card_model::test()
{
    m_deckname = "test2";
    m_card_id = "2";
    set_cardinfo(m_deckname, m_card_id);
    //qInfo() << fields;
    //qInfo() << "-------------";
    //qInfo() << contents;
}

