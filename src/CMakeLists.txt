### Sets QT_INSTALL_QML to the directory where QML Plugins should be installed
function(FindQtInstallQml)
    find_program(QMAKE NAMES qmake6 qmake)
    if(NOT QMAKE)
    message(FATAL_ERROR "qmake not found")
    endif()
    execute_process(
        COMMAND ${QMAKE} -query QT_INSTALL_QML
        OUTPUT_VARIABLE PROC_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(QT_INSTALL_QML ${PROC_RESULT} PARENT_SCOPE)
endfunction()

set(PACKAGE glacierkeyboardplugin)
set(HUNSPELL_DICT_PATH "/usr/share/myspell" CACHE PATH "Directory containing hunspell dictionary files")

set(SRC
    plugin.cpp
    keyboardslayoutmodel.cpp
    predictormodel.cpp
    predict/candidatescallback.cpp
    predict/spellchecker.cpp
    predict/spellpredictworker.cpp
    )

set(HEADERS
    keyboardslayoutmodel.h
    predictormodel.h
    predict/candidatescallback.h
    predict/spellchecker.h
    predict/spellpredictworker.h
    plugin.h)

set(QML
    qml/BackspaceKey.qml
    qml/CharacterKey.qml
    qml/DigitKey.qml
    qml/EnterKeyItem.qml
    qml/FunctionKey.qml
    qml/InputHandler.qml
    qml/KeyBase.qml
    qml/KeyboardBase.qml
    qml/KeyboardDigits.qml
    qml/KeyboardLandscape.qml
    qml/KeyboardPortrait.qml
    qml/LandscapeCharacterKey.qml
    qml/PluginSwitch.qml
    qml/Popper.qml
    qml/PortraitCharacterKey.qml
    qml/ShiftKey.qml
    qml/SpellChecker.qml
    qml/SymbolKey.qml)

add_library(${PACKAGE} SHARED ${SRC})

qt6_add_qml_module(${PACKAGE}
    URI Glacier.Keyboard
    VERSION 2.0
    PLUGIN_TARGET ${PACKAGE}
    NO_GENERATE_PLUGIN_SOURCE
    SOURCES
        ${SOURCES}
        ${HEADERS}
    QML_FILES
        ${QML}
    OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/Glacier/Keyboard
)

target_link_libraries(${PACKAGE} PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    PkgConfig::MLITE6
    -lpresage -lhunspell)

target_compile_definitions(${PACKAGE} PRIVATE
        HUNSPELL_DICT_PATH="${HUNSPELL_DICT_PATH}")

FindQtInstallQml()

install(DIRECTORY qml/ DESTINATION ${QT_INSTALL_QML}/Glacier/Keyboard)
install(TARGETS ${PACKAGE} DESTINATION ${QT_INSTALL_QML}/Glacier/Keyboard/)
