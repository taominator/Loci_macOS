#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlQuery>
#include <QDebug>

class tablemodel : public QSqlQueryModel
{
    Q_OBJECT
    Q_PROPERTY(int defaultColumnWidth READ getDefaultColumnWidth CONSTANT)
    Q_PROPERTY(int borderWidth READ getBorderWidth CONSTANT)

public:
    explicit tablemodel(QObject *parent = nullptr);

    //Overwritten tableView functions
    void setQuery(QSqlQuery *query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE void callSql(QString queryString);


    void setDb(QSqlDatabase &db);
    void generateColumnWidths();

    //QML functions
    Q_INVOKABLE int getColumnWidth(int n);
    Q_INVOKABLE void setColumnWidth(int n, int new_width);    
    Q_INVOKABLE int getDefaultColumnWidth();
    Q_INVOKABLE int getTableWidth();
    Q_INVOKABLE void setTableWidth(int width);
    Q_INVOKABLE int getBorderWidth();
    Q_INVOKABLE void updateSumColumnWidths();
    //to extend last column to the right border of tableview
    Q_INVOKABLE void rectifyLastColumnWidth();
    Q_INVOKABLE int lastColumnWidth();
    Q_INVOKABLE bool tooSmallTable();

    //mouse event functions for QML
    Q_INVOKABLE bool containsRow(int index);
    Q_INVOKABLE QString colorProvider(int index);
    Q_INVOKABLE void leftClick(int index);
    Q_INVOKABLE void ctrlClick(int index);
    Q_INVOKABLE void shiftClick(int index);
    Q_INVOKABLE void ctrlAll(int num_rows);

    //update id of selected rows to m_selectedIds
    Q_INVOKABLE void update_ids();
    Q_INVOKABLE void update_intervals();
    Q_INVOKABLE void update_card_states();

    Q_INVOKABLE int getNumInternalFields();

public:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

    QSqlDatabase db1;
    int m_numInternalFields;
    QHash<int, int> m_columnWidths;
    int m_defaultColumnWidth;
    int m_borderWidth = 20;
    int m_tableWidth;
    int m_sumColumnWidths;

    QList<int> m_selectedRows;
    QList<int> m_selectedIds;
    QList<int> m_intervals;
    QList<QString> m_card_states;

signals:

};

#endif // TABLEMODEL_H
