include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Scriptorbackend_SRCS
    modules/Scriptor/backend.cpp
    modules/Scriptor/system.cpp
)

# Make the unit test files visible on qtcreator
add_custom_target(Scriptorbackend_UNITTEST_QML_FILES ALL SOURCES "tests/unit/tst_mytype.qml")

add_library(Scriptorbackend MODULE
    ${Scriptorbackend_SRCS}
)

set_target_properties(Scriptorbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Scriptor)

qt5_use_modules(Scriptorbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Scriptorbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Scriptor/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Scriptor
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS Scriptorbackend DESTINATION ${QT_IMPORTS_DIR}/Scriptor/)
install(FILES   modules/Scriptor/qmldir DESTINATION ${QT_IMPORTS_DIR}/Scriptor/)

