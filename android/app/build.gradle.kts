plugins {
    id("com.android.application")
    id("kotlin-android")

    // Firebase plugin
    id("com.google.gms.google-services")

    // Flutter plugin (keep this after android/kotlin plugins)
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.tahirdotdev.taskApp.task_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled   = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.tahirdotdev.taskApp.task_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM - handles compatible versions
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // Firebase Analytics (optional)
    implementation("com.google.firebase:firebase-analytics")

    // ✅ Firestore - required for your task app
    implementation("com.google.firebase:firebase-firestore-ktx")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Add other Firebase libraries here if needed:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-storage")
}
