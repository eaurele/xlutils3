node {
    stage "checkout"
    checkout scm
    stage "build"
    env.WORKSPACE = pwd()
    sh 'docker run --rm -v ' + env.WORKSPACE + ':/project aurele/r_builder'
    stage "publish artifact"
    archive '*.tar.gz'
}
