node {
    stage "checkout"
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: []])
    stage "build"
    env.WORKSPACE = pwd()
    sh 'docker run --rm -v ' + env.WORKSPACE + ':/project saagie/r_builder'
    stage "publish artifact"
    archive '*.tar.gz'
}
