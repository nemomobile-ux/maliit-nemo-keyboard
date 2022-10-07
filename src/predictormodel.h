#ifndef PREDICTORMODEL_H
#define PREDICTORMODEL_H

#include <QAbstractListModel>
#include <QMutex>
#include <QObject>
#include <QThread>

#include "predict/spellpredictworker.h"

class PredictorModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QString checkingWord READ checkingWord NOTIFY checkingWordChanged)
    Q_PROPERTY(int limit READ limit WRITE setLimit NOTIFY limitChanged)

public:
    explicit PredictorModel(QObject* parent = nullptr);
    ~PredictorModel();

    QVariant data(const QModelIndex& index, int role) const;
    int rowCount(const QModelIndex& parent) const;
    QHash<int, QByteArray> roleNames() const { return m_hash; }

    void reload(const QStringList predictedWords);

    QString language() const { return m_language; }
    void setLanguage(const QString& language);

    QString checkingWord() const { return m_nextSpellWord; }

    int limit() const { return m_limit; }
    void setLimit(int limit);

    Q_INVOKABLE void check(QString word);

signals:
    void languageChanged(const QString& language);
    void checkingWordChanged();
    void limitChanged();

    void newSpellCheckWord(QString word);
    void setSpellCheckLimit(int limit);
    void setSpellPredictLanguage(QString language, QString pluginPath);
    void parsePredictionText(QString surroundingLeft, QString preedit);
    void setPredictionLanguage(QString language);
    void addToUserWordList(const QString& word);
    void addOverride(const QString& orig, const QString& overridden);

private slots:
    void spellCheckFinishedProcessing(QString word, QStringList suggestions);

private:
    QHash<int, QByteArray> m_hash;
    QStringList m_predictedWords;

    int m_limit;

    QString m_nextSpellWord;
    bool m_processingSpelling;

    QString m_language;

    SpellPredictWorker* m_spellPredictWorker;
    QThread* m_spellPredictThread;
};

#endif // PREDICTORMODEL_H
