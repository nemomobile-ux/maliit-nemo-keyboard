import QtQuick 2.0
import "KeyboardUiConstants.js" as UI

CharacterKey {
    width: keyArea.width / 10
    height: keyArea.height / 4

    topPadding: Theme.itemSpacingExtraSmall
    bottomPadding: topPadding
    leftPadding: Theme.itemSpacingExtraSmall/2
    rightPadding: leftPadding
}
