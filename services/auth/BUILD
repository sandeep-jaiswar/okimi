# Auth Service
# Handles authentication and authorization

package(default_visibility = ["//visibility:public"])

java_library(
    name = "auth_lib",
    srcs = glob(["src/main/java/**/*.java"]),
    resources = glob(["src/main/resources/**"]),
    deps = [
        "@maven//:org_springframework_boot_spring_boot_starter_web",
        "@maven//:org_springframework_boot_spring_boot_starter_security",
        "@maven//:org_springframework_boot_spring_boot_starter_data_jpa",
        "@maven//:org_postgresql_postgresql",
        "@maven//:redis_clients_jedis",
        "@maven//:io_jsonwebtoken_jjwt_api",
        "@maven//:io_jsonwebtoken_jjwt_impl",
        "@maven//:io_jsonwebtoken_jjwt_jackson",
    ],
)

java_binary(
    name = "auth_service",
    main_class = "com.okimi.auth.AuthServiceApplication",
    runtime_deps = [":auth_lib"],
)

java_test(
    name = "auth_test",
    srcs = glob(["src/test/java/**/*.java"]),
    deps = [
        ":auth_lib",
        "@maven//:org_springframework_boot_spring_boot_starter_test",
        "@maven//:junit_junit",
    ],
)
