# Copyright (c) 2016 The Chromium Embedded Framework Authors. All rights
# reserved. Use of this source code is governed by a BSD-style license that
# can be found in the LICENSE file.

# Download the CEF binary distribution for |platform| and |version| to
# |download_dir|. The |CEF_ROOT| variable will be set in global scope pointing
# to the extracted location.
# Visit http://opensource.spotify.com/cefbuilds/index.html for the list of
# supported platforms and versions.

function(DownloadCEF platform version download_dir)
  # Specify the binary distribution type and download directory.
  set(CEF_DISTRIBUTION "cef_binary_${version}_${platform}_minimal")
  set(CEF_DOWNLOAD_DIR "${download_dir}")

  # The location where we expect the extracted binary distribution.
  set(CEF_ROOT "${CEF_DOWNLOAD_DIR}/${CEF_DISTRIBUTION}" CACHE INTERNAL "CEF_ROOT")

  # Download and/or extract the binary distribution if necessary.
  if(NOT IS_DIRECTORY "${CEF_ROOT}")
    set(CEF_DOWNLOAD_FILENAME "${CEF_DISTRIBUTION}.tar.bz2")
    #set(CEF_DOWNLOAD_PATH "${CEF_DOWNLOAD_DIR}/${CEF_DOWNLOAD_FILENAME}")
        set(CEF_DOWNLOAD_PATH "${CEF_DOWNLOAD_DIR}/cef_binary.tar.bz2")

    if(NOT EXISTS "${CEF_DOWNLOAD_PATH}")
      set(CEF_DOWNLOAD_URL "http://opensource.spotify.com/cefbuilds/${CEF_DOWNLOAD_FILENAME}")

      # Download the SHA1 hash for the binary distribution.
      message(STATUS "Downloading ${CEF_DOWNLOAD_PATH}.sha1...")
      file(DOWNLOAD "${CEF_DOWNLOAD_URL}.sha1" "${CEF_DOWNLOAD_PATH}.sha1")
      file(READ "${CEF_DOWNLOAD_PATH}.sha1" CEF_SHA1)

      # Download the binary distribution and verify the hash.
      message(STATUS "Downloading ${CEF_DOWNLOAD_PATH}...")
      file(
        DOWNLOAD "${CEF_DOWNLOAD_URL}" "${CEF_DOWNLOAD_PATH}"
        EXPECTED_HASH SHA1=${CEF_SHA1}
        SHOW_PROGRESS
        )
    endif()

    # Extract the binary distribution.
    message(STATUS "Extracting ${CEF_DOWNLOAD_PATH}...")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf "${CEF_DOWNLOAD_DIR}/cef_binary.tar.bz2"
      WORKING_DIRECTORY ${CEF_DOWNLOAD_DIR}
      )
  endif()
endfunction()
