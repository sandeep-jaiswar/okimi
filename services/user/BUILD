# User Service
# Handles user management and profile operations

package(default_visibility = ["//visibility:public"])

java_library(
    name = "user_lib",
    srcs = glob(["src/main/java/**/*.java"]),
    resources = glob(["src/main/resources/**"]),
    deps = [
        "@maven//:org_springframework_boot_spring_boot_starter_web",
        "@maven//:org_springframework_boot_spring_boot_starter_data_jpa",
        "@maven//:org_postgresql_postgresql",
        "@maven//:redis_clients_jedis",
    ],
)

java_binary(
    name = "user_service",
    main_class = "com.okimi.user.UserServiceApplication",
    runtime_deps = [":user_lib"],
)

java_test(
    name = "user_test",
    srcs = glob(["src/test/java/**/*.java"]),
    deps = [
        ":user_lib",
        "@maven//:org_springframework_boot_spring_boot_starter_test",
        "@maven//:junit_junit",
    ],
)
