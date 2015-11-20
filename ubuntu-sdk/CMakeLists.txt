project(ubuntu-sdk C CXX)
cmake_minimum_required(VERSION 2.8.9)

# Do not remove this line, its required for the correct functionality of the Ubuntu-SDK
set(UBUNTU_MANIFEST_PATH "manifest.json.in" CACHE INTERNAL "Tells QtCreator location and name of the manifest file")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
# Find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)

# Figure out the component install path
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(CLICK_ARCH "all")
# If you want to add native code to your project, replace the set CLICK_ARCH command
# with the following part.
# This command figures out the target architecture for use in the manifest file
# execute_process(
#   COMMAND dpkg-architecture -qDEB_HOST_ARCH
#   OUTPUT_VARIABLE CLICK_ARCH
#   OUTPUT_STRIP_TRAILING_WHITESPACE
# )

set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")

option(INSTALL_TESTS "Install the tests on make install" on)

set(APP_NAME          "Tensor")
set(APP_ID            "tensor.davidar.io")
set(UBUNTU-SDK_DIR "share/qml/ubuntu-sdk")
set(MAIN_QML          "Main.qml")
set(ICON              "src/logo.png")

# Set install paths
set(CMAKE_INSTALL_PREFIX /)
set(DATA_DIR /)
set(DESKTOP_DIR ${DATA_DIR})
set(DESKTOP_FILE_NAME "Tensor.desktop")

# This sets the commandline that is executed on the device
set(EXEC "qmlscene $@ ${UBUNTU-SDK_DIR}/${MAIN_QML}")

# Configures the manifest file. The manifest file describes the click package
# to the target system. All cmake variables that are defined at this point
# can be used in the manifest file and will be automatically replaced by cmake
configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json
        DESTINATION ${CMAKE_INSTALL_PREFIX})

install(DIRECTORY "../src" DESTINATION ${DATA_DIR})
install(FILES "Tensor.apparmor" DESTINATION ${DATA_DIR})

add_subdirectory(app)
add_subdirectory(po)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    WORKING_DIRECTORY ./app)

add_custom_target("check" /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/backend
                    WORKING_DIRECTORY ./app)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend  ${CMAKE_SOURCE_DIR}/app/ubuntu-sdk.qml
                    WORKING_DIRECTORY ./app)

# Normally QtCreator would only show files that are part of a target, but we need it to show also files 
# that are not compiled. Therefore we add a custom target that just does nothing but list the files 
add_custom_target("ubuntu-sdk_ClickFiles" ALL SOURCES "Tensor.apparmor" "manifest.json.in")

