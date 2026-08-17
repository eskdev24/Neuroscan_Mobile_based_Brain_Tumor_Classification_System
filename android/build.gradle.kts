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
    project.plugins.withId("org.jetbrains.kotlin.android") {
        project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
        }
    }
    project.plugins.withId("com.android.library") {
        project.afterEvaluate {
            val ext = extensions.findByType<com.android.build.gradle.LibraryExtension>()
            val javaTarget = ext?.compileOptions?.sourceCompatibility
            if (javaTarget != null) {
                project.plugins.withId("org.jetbrains.kotlin.android") {
                    project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                        compilerOptions.jvmTarget.set(
                            when (javaTarget) {
                                JavaVersion.VERSION_1_8 -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
                                else -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
                            }
                        )
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
