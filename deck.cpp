#include "deck.h"

deck::deck(QObject *parent, QList<QString> fields)
    : QObject{parent}, m_fields(fields)
{

}

QList<QString> deck::getFields() {return m_fields;}


void deck::setFields(QList<QString> fields)
{
    m_fields = fields;
    emit fieldsChanged();
}

