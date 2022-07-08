cmake_minimum_required(VERSION 3.16)

project(loci_macOS VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 6.2 COMPONENTS Quick Sql Quickcontrols2 REQUIRED)

qt_add_executable(apploci_macOS MACOSX_BUNDLE
    main.cpp
    card_model.h
    card_model.cpp
    dbmanager.h
    dbmanager.cpp
    deck.h
    deck.cpp
    tablemodel.h
    tablemodel.cpp
    qml.qrc
)

FILE(GLOB_RECURSE LibFiles "include/*.hpp")
add_custom_target(headers SOURCES ${LibFiles})

qt_add_qml_module(apploci_macOS
    URI loci_macOS
    VERSION 1.0
    QML_FILES main.qml
)

set_target_properties(apploci_macOS PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.domain.style.identifier.Loci
    MACOSX_BUNDLE_BUNDLE_NAME Loci
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(apploci_macOS
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(apploci_macOS
    PRIVATE Qt6::Quick Qt6::Sql)
