## set up lists of sources and headers for tags
file(GLOB_RECURSE all_srcs
  include/*.cc
  toku_include/*.cc
  buildheader/*.cc
  portability/*.cc
  ft/*.cc
  src/*.cc
  utils/*.cc
  db-benchmark-test/*.cc
  )
list(APPEND all_srcs
  ${CMAKE_CURRENT_BINARY_DIR}/ft/log_code.cc
  ${CMAKE_CURRENT_BINARY_DIR}/ft/log_print.cc
  )
file(GLOB_RECURSE all_hdrs
  include/*.h
  toku_include/*.h
  buildheader/*.h
  portability/*.h
  ft/*.h
  src/*.h
  utils/*.h
  db-benchmark-test/*.h
  )
list(APPEND all_hdrs
  ${CMAKE_CURRENT_BINARY_DIR}/toku_include/config.h
  ${CMAKE_CURRENT_BINARY_DIR}/buildheader/db.h
  ${CMAKE_CURRENT_BINARY_DIR}/ft/log_header.h
  )

option(USE_CTAGS "Build the ctags database." ON)
if (USE_CTAGS)
  find_program(CTAGS "ctags")
  if (NOT CTAGS MATCHES NOTFOUND)
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/tags"
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ctags-stamp"
      COMMAND ${CTAGS} -o tags ${all_srcs} ${all_hdrs}
      COMMAND touch "${CMAKE_CURRENT_BINARY_DIR}/ctags-stamp"
      DEPENDS ${all_srcs} ${all_hdrs} install_tdb_h generate_config_h generate_log_code
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    add_custom_target(build_ctags ALL DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tags" ctags-stamp)
  endif ()
endif ()

option(USE_ETAGS "Build the etags database." ON)
if (USE_ETAGS)
  find_program(ETAGS "etags")
  if (NOT ETAGS MATCHES NOTFOUND)
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/TAGS"
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/etags-stamp"
      COMMAND ${ETAGS} -o TAGS ${all_srcs} ${all_hdrs}
      COMMAND touch "${CMAKE_CURRENT_BINARY_DIR}/etags-stamp"
      DEPENDS ${all_srcs} ${all_hdrs} install_tdb_h generate_config_h generate_log_code
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    add_custom_target(build_etags ALL DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/TAGS" etags-stamp)
  endif ()
endif ()

option(USE_CSCOPE "Build the cscope database." ON)
if (USE_CSCOPE)
  find_program(CSCOPE "cscope")
  if (NOT CSCOPE MATCHES NOTFOUND)
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/cscope.out"
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/cscope.in.out"
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/cscope.po.out"
      COMMAND ${CSCOPE} -b -q -R
      DEPENDS ${all_srcs} ${all_hdrs} install_tdb_h generate_config_h generate_log_code
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    add_custom_target(build_cscope.out ALL DEPENDS
      "${CMAKE_CURRENT_SOURCE_DIR}/cscope.out"
      "${CMAKE_CURRENT_SOURCE_DIR}/cscope.in.out"
      "${CMAKE_CURRENT_SOURCE_DIR}/cscope.po.out")
  endif ()
endif ()

option(USE_GTAGS "Build the gtags database." ON)
if (USE_GTAGS)
  find_program(GTAGS "gtags")
  find_program(MKID "mkid")
  if (NOT GTAGS MATCHES NOTFOUND)
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/gtags.files" "")
    foreach(file ${all_srcs} ${all_hdrs})
      file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/gtags.files" "${file}\n")
    endforeach(file)
    if (NOT MKID MATCHES NOTFOUND)
      set(idutils_option "-I")
    endif ()
    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/GTAGS"
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/GRTAGS"
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/GPATH"
      OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/GSYMS"
      COMMAND ${GTAGS} -i ${idutils_option} -f "${CMAKE_CURRENT_BINARY_DIR}/gtags.files"
      DEPENDS ${all_srcs} ${all_hdrs} install_tdb_h generate_config_h generate_log_code
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    add_custom_target(build_GTAGS ALL DEPENDS
      "${CMAKE_CURRENT_SOURCE_DIR}/GTAGS"
      "${CMAKE_CURRENT_SOURCE_DIR}/GRTAGS"
      "${CMAKE_CURRENT_SOURCE_DIR}/GPATH"
      "${CMAKE_CURRENT_SOURCE_DIR}/GSYMS")
  endif ()
endif ()
