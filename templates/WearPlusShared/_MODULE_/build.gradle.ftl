<#--
 Copyright 2014 The Android Open Source Project

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
buildscript {
    repositories {
        jcenter()
        google()
    }

    dependencies {
      <#-- TODO (jewalker): Remove once 3.2 is in production. -->
      <#if sample.androidX?? && sample.androidX?has_content && sample.androidX == "true">
        classpath 'com.android.tools.build:gradle:3.2.0-beta01'
      <#else>
        classpath 'com.android.tools.build:gradle:3.1.3'
      </#if>
    }
}

apply plugin: 'com.android.application'

repositories {
    jcenter()
    google()
<#if sample.repository?has_content>
    <#list sample.repository as rep>
    ${rep}
    </#list>
</#if>
}

dependencies {
<#list sample.dependency as dep>
    <#-- Output dependency after checking if it is a play services depdency and
    needs the latest version number attached. -->
    <@update_play_services_dependency dep="${dep}" />
</#list>
<#list sample.dependency_external as dep>
    implementation files(${dep})
</#list>
    implementation ${play_services_wearable_dependency}

    <#-- TODO (jewalker): Revise once androidX is released to production. -->
    <#if !sample.androidX?? || !sample.androidX?has_content || sample.androidX == "false">
      implementation ${android_support_v13_dependency}
    </#if>

    implementation project(':Shared')
    wearApp project(':Wearable')
}

// The sample build uses multiple directories to
// keep boilerplate and common code separate from
// the main sample code.
List<String> dirs = [
    'main',     // main sample code; look here for the interesting stuff.
    'common',   // components that are reused by multiple samples
    'template'] // boilerplate code that is generated by the sample template process

android {
 <#if sample.compileSdkVersion?? && sample.compileSdkVersion?has_content>
    compileSdkVersion ${sample.compileSdkVersion}
  <#else>
    compileSdkVersion ${compile_sdk}
  </#if>

    buildToolsVersion ${build_tools_version}

    defaultConfig {
        minSdkVersion ${min_sdk}
        targetSdkVersion ${compile_sdk}
        versionCode 1
        versionName "1.0"
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    sourceSets {
        main {
            dirs.each { dir ->
<#noparse>
                java.srcDirs "src/${dir}/java"
                res.srcDirs "src/${dir}/res"
</#noparse>
            }
        }
        androidTest.setRoot('tests')
        androidTest.java.srcDirs = ['tests/src']

<#if sample.defaultConfig?has_content>
        defaultConfig {
        ${sample.defaultConfig}
        }
<#else>
</#if>
    }

}
