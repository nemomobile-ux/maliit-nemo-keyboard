### Sets QT_INSTALL_QML to the directory where QML Plugins should be installed
function(FindQtInstallQml)
    find_program(QMAKE NAMES qmake-qt6 qmake)
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

set(HUNSPELL_DICT_PATH "/usr/share/myspell" CACHE PATH "Directory containing hunspell dictionary files")

set(SRC
    plugin.cpp
    keyboardslayoutmodel.cpp
    keyboardslayoutmodel.h
    predictormodel.cpp
    predictormodel.h
    predict/candidatescallback.cpp
    predict/candidatescallback.h
    predict/spellchecker.cpp
    predict/spellchecker.h
    predict/spellpredictworker.cpp
    predict/spellpredictworker.h)

add_library(glacierkeyboard SHARED ${SRC})

target_link_libraries(glacierkeyboard
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    PkgConfig::MLITE6
    -lpresage -lhunspell)
target_compile_definitions(glacierkeyboard PRIVATE
        HUNSPELL_DICT_PATH="${HUNSPELL_DICT_PATH}")

FindQtInstallQml()

install(FILES qmldir DESTINATION ${QT_INSTALL_QML}/org/glacier/keyboard/)
install(TARGETS glacierkeyboard DESTINATION ${QT_INSTALL_QML}/org/glacier/keyboard/)
