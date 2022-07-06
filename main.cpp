#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <dbmanager.h>
#include <QDebug>
#include <QScreen>
#include <QStandardPaths>
#include <QDateTime>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("taominator");
    app.setApplicationName("loci");

    dbmanager DBManager;

    int screenWidth = app.primaryScreen()->size().width();
    // 5.0 to prevent truncation of integer
    int tableSize = screenWidth*(4/5.0) - (DBManager.m_model.m_borderWidth*2); //10 for scrollbar width

    DBManager.m_model.setTableWidth(tableSize);

    DBManager.m_card_model.test();

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qml/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);


    /*card* card1 = deck1->getCardList().at(0);
    cardModel->setSelectedCard(deck1, card1);

    engine.rootContext()->setContextProperty("deck", deck1);
    engine.rootContext()->setContextProperty("cardmodel", cardModel);*/
    engine.rootContext()->setContextProperty("dbmanager", &DBManager);
    engine.rootContext()->setContextProperty("m_model", &DBManager.m_model);
    engine.rootContext()->setContextProperty("card_model", &DBManager.m_card_model);
    engine.rootContext()->setContextProperty("m_deckListModel", &DBManager.m_deckListModel);

    engine.load(url);


    //QString time_format = "yyyy-MM-dd  HH:mm:ss";
    //QDateTime a = QDateTime::currentDateTime();
    //QString as = a.toString(time_format);
    //
    //qInfo() << as; // print "2014-07-16  17:47:04"
    //
    //QDateTime b = QDateTime::fromString(as,time_format);
    //qInfo() << b;

    /*qInfo() << DBManager.m_model.record();
    qInfo() << DBManager.m_db1.isOpen();
    qInfo() << DBManager.m_decklist.at(1).m_table;
    qInfo() << "---------";
    qInfo() << DBManager.m_decklist.at(0).m_fields;
    qInfo() << DBManager.m_decklist.at(1).m_fields;
    qInfo() << "---------";
    qInfo() << DBManager.m_model.m_roleNames;
    qInfo() << "---------";
    qInfo() << DBManager.m_model.m_columnWidths;
    qInfo() << DBManager.m_model.m_columnWidths;
    qInfo() << app.primaryScreen()->size().width();*/

    return app.exec();
}
