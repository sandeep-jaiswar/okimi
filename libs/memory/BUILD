# Memory library
# Custom memory pools and allocators

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "memory",
    srcs = glob(["*.cc"]),
    hdrs = glob(["*.h"]),
    deps = [
        "//libs/core",
    ],
)

cc_test(
    name = "memory_test",
    srcs = glob(["*_test.cc"]),
    deps = [
        ":memory",
        "@googletest//:gtest_main",
    ],
)
