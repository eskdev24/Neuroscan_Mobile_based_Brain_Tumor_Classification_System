allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    if (project.name == "app") return@subprojects

    project.plugins.withId("com.android.library") {
        project.afterEvaluate {
            val ext = extensions.findByType<com.android.build.gradle.LibraryExtension>()
            val javaTarget = ext?.compileOptions?.sourceCompatibility ?: JavaVersion.VERSION_17
            val kotlinTarget = when (javaTarget) {
                JavaVersion.VERSION_1_8 -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
                JavaVersion.VERSION_11 -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
                else -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
            }
            project.plugins.withId("org.jetbrains.kotlin.android") {
                project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                    compilerOptions.jvmTarget.set(kotlinTarget)
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
