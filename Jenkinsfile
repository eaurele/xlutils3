node {
    stage "build"
    env.WORKSPACE = pwd()
    sh 'docker run --rm -v ' + env.WORKSPACE + ':/project saagie/r_builder'
    stage "publish artifact"
    archive '*.tar.gz'
}
