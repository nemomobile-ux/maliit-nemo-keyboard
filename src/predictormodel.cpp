#include "predictormodel.h"

#include <QMutexLocker>
#include <QDebug>

PredictorModel::PredictorModel(QObject *parent)
    : QAbstractListModel{parent}
    , m_limit(3)
{
    m_hash.insert(Qt::UserRole ,QByteArray("index"));
    m_hash.insert(Qt::UserRole+1 ,QByteArray("predictionText"));

    m_spellPredictThread = new QThread();
    m_spellPredictWorker = new SpellPredictWorker();
    m_spellPredictWorker->moveToThread(m_spellPredictThread);

    connect(m_spellPredictWorker, &SpellPredictWorker::newSpellingSuggestions, this, &PredictorModel::spellCheckFinishedProcessing);


    connect(this, &PredictorModel::newSpellCheckWord, m_spellPredictWorker, &SpellPredictWorker::newSpellCheckWord);
    connect(this, &PredictorModel::languageChanged, m_spellPredictWorker, &SpellPredictWorker::setLanguage);
    connect(this, &PredictorModel::setSpellCheckLimit, m_spellPredictWorker, &SpellPredictWorker::setSpellCheckLimit);
    connect(this, &PredictorModel::parsePredictionText, m_spellPredictWorker, &SpellPredictWorker::parsePredictionText);
    connect(this, &PredictorModel::addToUserWordList, m_spellPredictWorker, &SpellPredictWorker::addToUserWordList);
    connect(this, &PredictorModel::addOverride, m_spellPredictWorker, &SpellPredictWorker::addOverride);

    m_spellPredictThread->start();
}

PredictorModel::~PredictorModel()
{
    m_spellPredictWorker->deleteLater();
    m_spellPredictThread->quit();
    m_spellPredictThread->wait();
}

QVariant PredictorModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() && index.row() > m_predictedWords.count() ) {
        return QVariant();
    }

    if(role == Qt::UserRole) {
        return index.row();
    }

    if(role == Qt::UserRole+1) {
        return m_predictedWords.at(index.row());
    }

    return QVariant();
}

int PredictorModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_predictedWords.size();
}

void PredictorModel::reload(const QStringList predictedWords)
{
    beginResetModel();
    m_predictedWords = predictedWords;
    endResetModel();
}

void PredictorModel::setLanguage(const QString &language)
{
    if(language != m_language) {
        m_language = language;
        emit languageChanged(m_language);
    }
}

void PredictorModel::setLimit(int limit)
{
    if(limit != m_limit) {
        m_limit = limit;
        emit limitChanged();
    }
}

void PredictorModel::check(QString word)
{
    if(m_nextSpellWord != word) {
        m_nextSpellWord = word;
        emit checkingWordChanged();
        if (!m_processingSpelling) {
            m_processingSpelling = true;
            Q_EMIT setSpellCheckLimit(m_limit);
            Q_EMIT newSpellCheckWord(word);
        }
    }
}

void PredictorModel::spellCheckFinishedProcessing(QString word, QStringList suggestions)
{
    reload(suggestions);
    m_processingSpelling = false;
}

