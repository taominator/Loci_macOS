#ifndef DECK_H
#define DECK_H

#include <QObject>

class deck : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> fields READ getFields WRITE setFields NOTIFY fieldsChanged)

public:
    explicit deck(QObject *parent = nullptr, QList<QString> fields = QList<QString>());

    //READ functions
    Q_INVOKABLE QList<QString> getFields();

    //WRITE functions
    Q_INVOKABLE void setFields(QList<QString> fields);


signals:
    void fieldsChanged();

private:
    QList<QString> m_fields;

};

#endif // DECK_H
