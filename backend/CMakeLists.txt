include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Scriptorbackend_SRCS
    modules/Scriptor/backend.cpp
    modules/Scriptor/process.cpp
    modules/Scriptor/utils.cpp
)

# Make the unit test files visible on qtcreator
add_custom_target(Scriptorbackend_UNITTEST_QML_FILES ALL SOURCES "tests/unit/tst_mytype.qml")
# Add resource files to backend library
QT5_ADD_RESOURCES(Scriptorbackend_GRAPHICS ${CMAKE_SOURCE_DIR}/resources/graphics.qrc)

add_library(Scriptorbackend MODULE
    ${Scriptorbackend_SRCS}
    ${Scriptorbackend_GRAPHICS}
)

set_target_properties(Scriptorbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Scriptor)

qt5_use_modules(Scriptorbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Scriptorbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Scriptor/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Scriptor
    DEPENDS ${QMLFILES} ${Scriptorbackend_GRAPHICS}
)

# Install plugin file
install(TARGETS Scriptorbackend DESTINATION ${QT_IMPORTS_DIR}/Scriptor/)
install(FILES   modules/Scriptor/qmldir DESTINATION ${QT_IMPORTS_DIR}/Scriptor/)

