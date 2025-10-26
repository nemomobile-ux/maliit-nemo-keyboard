#include "fakeinputmethod.h"

FakeInputMethod::FakeInputMethod(QObject* parent)
    : QObject { parent }
    , m_actionKeyOverride(QSharedPointer<FakeKeyOverrideQuick>(new FakeKeyOverrideQuick(this)))
{
}

int FakeInputMethod::screenWidth() const
{
    return 720;
}

int FakeInputMethod::screenHeight() const
{
    return 1080;
}

int FakeInputMethod::appOrientation() const
{
    return 0;
}

bool FakeInputMethod::isActive() const
{
    return true;
}

bool FakeInputMethod::surroundingTextValid() const
{
    return m_surroundingTextValid;
}

int FakeInputMethod::cursorPosition() const
{
    return m_cursorPosition;
}

int FakeInputMethod::anchorPosition() const
{
    return m_anchorPosition;
}

QString FakeInputMethod::surroundingText() const
{
    return m_surroundingText;
}

bool FakeInputMethod::hasSelection() const
{
    return m_hasSelection;
}

int FakeInputMethod::contentType() const
{
    return m_contentType;
}

bool FakeInputMethod::predictionEnabled() const
{
    return true;
}

bool FakeInputMethod::autoCapitalizationEnabled() const
{
    return m_autoCapitalizationEnabled;
}

bool FakeInputMethod::hiddenText() const
{
    return m_hiddenText;
}

FakeKeyOverrideQuick* FakeInputMethod::actionKeyOverride() const
{
    return m_actionKeyOverride.data();
}

void FakeInputMethod::inputMethodReset()
{
}
