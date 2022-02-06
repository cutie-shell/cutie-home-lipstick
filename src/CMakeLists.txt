set(SRC
    cutiewindowmodel.cpp
    cutiewindowmodel.h
    main.cpp)

add_executable(lipstick
    ${SRC})

target_link_libraries(lipstick PUBLIC
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::DBus
    PkgConfig::LIPSTICK
    PkgConfig::MLITE5)

if(QT_VERSION EQUAL "5.6.0")
    target_link_libraries(lipstick PUBLIC
        Qt5::Compositor)
else()
    target_link_libraries(lipstick PUBLIC
        Qt5::WaylandCompositor)
endif()

install(TARGETS lipstick RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR})
install(DIRECTORY qml
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lipstick-cutie-home-qt5)
