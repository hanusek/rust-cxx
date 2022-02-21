function(add_rust_library)
    set(options)
    set(args TARGET PATH ARCH)
    set(list_args)
    cmake_parse_arguments(
            PARSE_ARGV 0
            this 
            "${options}"
            "${args}"
            "${list_args}"
    )

    message("BUILD RUST LIBRARY FOR ARCH: ${this_ARCH}")

    find_program(CARGO cargo)
    if(NOT CARGO)
        message(FATAL_ERROR "cargo not found!")
    endif()

    find_program(RUSTC rustc)
    if(NOT RUSTC)
        message(FATAL_ERROR "rustc not found!")
    endif()

    if(${this_ARCH} STREQUAL "X86_64")
        if (CMAKE_BUILD_TYPE STREQUAL "Debug")
            set(CARGO_CMD cargo build --verbose)
            set(TARGET_DIR "target/debug")
        else ()
            set(CARGO_CMD cargo build --release)
            set(TARGET_DIR "target/release")
        endif ()
        set(BINDINGS_DIRPATH "${this_PATH}/target/cxxbridge")
    else()
        if(${this_ARCH} STREQUAL "X86")
            set(ARCH_TARGET "i686-unknown-linux-gnu")
        elseif(${this_ARCH} STREQUAL "ARM")
            set(ARCH_TARGET "arm-unknown-linux-gnueabihf")
        endif ()

        set(BINDINGS_DIRPATH "${this_PATH}/target/${ARCH_TARGET}/cxxbridge/")

        if (CMAKE_BUILD_TYPE STREQUAL "Debug")
            set(CARGO_CMD cargo build --target ${ARCH_TARGET} --verbose)
            set(TARGET_DIR "target/${ARCH_TARGET}/debug")
        else ()
            set(CARGO_CMD cargo build --release --target ${ARCH_TARGET})
            set(TARGET_DIR "target/${ARCH_TARGET}/release")
        endif ()
    endif ()

    set(RUST_LIB_NAME "${this_TARGET}_rs")
    set(RUST_TARGET_LIB_FILE ${CMAKE_STATIC_LIBRARY_PREFIX}${RUST_LIB_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX})
    message("RUST_TARGET_LIB_FILE: ${RUST_TARGET_LIB_FILE}")

    set(CXX_SRC_FILE "${this_TARGET}.cpp")
    set(CXX_H_FILE "${this_TARGET}.h")
    set(CXX_SRC_FILEPATH "${this_PATH}/${CXX_SRC_FILE}")
    set(CXX_H_FILEPATH   "${this_PATH}/${CXX_H_FILE}")
    set(RUST_LIB_FILEPATH "${this_PATH}/${TARGET_DIR}/${RUST_TARGET_LIB_FILE}")

    set(TARGET_CXXBRIDGE_PATH "${BINDINGS_DIRPATH}/${RUST_LIB_NAME}/src")

    message("BINDINGS_DIRPATH: ${BINDINGS_DIRPATH}")
    message("CXX_SRC_FILEPATH: ${CXX_SRC_FILEPATH}")
    message("CXX_H_FILEPATH: ${CXX_H_FILEPATH}")
    message("TARGET_CXXBRIDGE_PATH: ${TARGET_CXXBRIDGE_PATH}")
    message("RUST_LIB_FILEPATH: ${RUST_LIB_FILEPATH}")

    execute_process(
            COMMAND ${CARGO_CMD}
            RESULT_VARIABLE cargo_ret_status
            WORKING_DIRECTORY ${this_PATH}
    )

    if(cargo_ret_status EQUAL "1")
            message(FATAL_ERROR "Cargo - Bad exit status")
    endif()

    execute_process(
        COMMAND echo "Coping files..."
        COMMAND cp ${TARGET_CXXBRIDGE_PATH}/bindings.rs.cc ${CXX_SRC_FILEPATH}
        COMMAND cp ${TARGET_CXXBRIDGE_PATH}/bindings.rs.h  ${CXX_H_FILEPATH}
        WORKING_DIRECTORY ${this_PATH}
    )

    add_library(${this_TARGET} STATIC ${CXX_SRC_FILEPATH})
    target_include_directories(${this_TARGET} PUBLIC ${this_PATH})
    target_link_libraries(${this_TARGET} PUBLIC ${RUST_LIB_FILEPATH} dl pthread)
 
    add_test(NAME cargo_test COMMAND cargo test --all WORKING_DIRECTORY ${this_PATH})

    return(${this_TARGET})
endfunction()
