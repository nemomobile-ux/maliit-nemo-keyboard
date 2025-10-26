#ifndef FAKEINPUTMETHOD_H
#define FAKEINPUTMETHOD_H

#include <QObject>
#include <QSharedPointer>

#include "fakekeyoverridequick.h"

class FakeInputMethod : public QObject {
    Q_OBJECT
    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenWidthChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenHeightChanged)
    Q_PROPERTY(int appOrientation READ appOrientation NOTIFY appOrientationChanged)
    Q_PROPERTY(FakeKeyOverrideQuick* actionKeyOverride READ actionKeyOverride NOTIFY actionKeyOverrideChanged)
    Q_PROPERTY(bool active READ isActive NOTIFY activeChanged)
    Q_PROPERTY(bool surroundingTextValid READ surroundingTextValid NOTIFY surroundingTextValidChanged)
    Q_PROPERTY(QString surroundingText READ surroundingText NOTIFY surroundingTextChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int anchorPosition READ anchorPosition NOTIFY anchorPositionChanged)
    Q_PROPERTY(bool hasSelection READ hasSelection NOTIFY hasSelectionChanged)
    Q_PROPERTY(int contentType READ contentType NOTIFY contentTypeChanged)
    Q_PROPERTY(bool predictionEnabled READ predictionEnabled NOTIFY predictionEnabledChanged)
    Q_PROPERTY(bool autoCapitalizationEnabled READ autoCapitalizationEnabled NOTIFY autoCapitalizationChanged)
    Q_PROPERTY(bool hiddenText READ hiddenText NOTIFY hiddenTextChanged)
public:
    explicit FakeInputMethod(QObject* parent = nullptr);

    int screenWidth() const;
    int screenHeight() const;
    int appOrientation() const;
    bool isActive() const;
    bool surroundingTextValid() const;
    int cursorPosition() const;
    int anchorPosition() const;
    QString surroundingText() const;
    bool hasSelection() const;
    int contentType() const;
    bool predictionEnabled() const;
    bool autoCapitalizationEnabled() const;
    bool hiddenText() const;
    FakeKeyOverrideQuick* actionKeyOverride() const;

signals:
    void screenWidthChanged();
    void screenHeightChanged();
    void appOrientationChanged();
    void activeChanged();
    void surroundingTextValidChanged();
    void cursorPositionChanged();
    void anchorPositionChanged();
    void surroundingTextChanged();
    void hasSelectionChanged();
    void contentTypeChanged();
    void predictionEnabledChanged();
    void autoCapitalizationChanged();
    void hiddenTextChanged();
    void actionKeyOverrideChanged();

public slots:
    void inputMethodReset();

private:
    int m_screenWidth;
    int m_screenHeight;
    int m_appOrientation;
    bool m_active;
    bool m_surroundingTextValid;
    int m_cursorPosition;
    int m_anchorPosition;
    QString m_surroundingText;
    bool m_hasSelection;
    int m_contentType;
    bool m_predictionEnabled;
    bool m_autoCapitalizationEnabled;
    bool m_hiddenText;
    QSharedPointer<FakeKeyOverrideQuick> m_actionKeyOverride;
    //    KeyOverrideQuick *m_actionKeyOverride = nullptr;
};

#endif // FAKEINPUTMETHOD_H
