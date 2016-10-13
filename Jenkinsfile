/**
 *
 * opencontrail docker build, test, promote pipeline
 *
 * Expected parameters:
 *   ARTIFACTORY_URL        Artifactory server location
 *   ARTIFACTORY_OUT_REPO   local repository name to upload image
 *   DOCKER_REGISTRY_SERVER Docker server to use to push image
 *   DOCKER_REGISTRY_SSL    Docker registry is SSL-enabled if true
 *   FORCE_BUILD            Force build even when image exists
 *   PROMOTE_ENV            Environment for promotion (default "stable")
 *   KEEP_REPOS             Always keep input repositories even on failure
 *   OC_VERSION             OpenContrail version (should be 3.0)
 *   PIPELINE_LIBS_URL      URL to git repo with shared pipeline libs
 *   PIPELINE_LIBS_BRANCH   Branch of pipeline libs repo
 *   PIPELINE_LIBS_CREDENTIALS_ID   Credentials ID to use to access shared
 *                                  libs repo
 */

// Load shared libs
def common, artifactory
fileLoader.withGit(PIPELINE_LIBS_URL, PIPELINE_LIBS_BRANCH, PIPELINE_LIBS_CREDENTIALS_ID, '') {
    common = fileLoader.load("common");
    artifactory = fileLoader.load("artifactory");
}

// Define global variables
def timestamp = common.getDatetime()

def images = [
    "opencontrail-database",
    "zookeeper",
    "redis",
    "opencontrail-config",
    "opencontrail-control",
    "opencontrail-analytics",
    "opencontrail-webui"
]
def inRepos = [
    "in-dockerhub",
    "in-ubuntu",
    "in-ubuntu-oc30"
]

def art = artifactory.connection(
    ARTIFACTORY_URL,
    DOCKER_REGISTRY_SERVER,
    DOCKER_REGISTRY_SSL ?: true,
    ARTIFACTORY_OUT_REPO
)

def git_commit

def buildComponentImageStep(img, opencontrail_version, timestamp) {
    return {
        // Other components, using opencontrail-base
        sh "git checkout -f docker/${img}.Dockerfile; sed -i -e 's,^FROM.*,FROM opencontrail-${opencontrail_version}/opencontrail-base:${timestamp},g' docker/${img}.Dockerfile"
        docker.build(
            "opencontrail-${opencontrail_version}/${img}:${timestamp}",
            [
                "-f docker/${img}.Dockerfile",
                "docker"
            ].join(' ')
        )
    }
}

def testComponentImageStep(img, opencontrail_version, timestamp) {
    return {
        docker.image("opencontrail-${opencontrail_version}/${img}:${timestamp}").inside {
            sh "true"
        }
    }
}

def uploadComponentImageStep(artifactory, art, img, opencontrail_version, properties, timestamp) {
    return {
        println "Uploading artifact ${img} into ${art.outRepo}"
        artifactory.dockerPush(
            art,
            docker.image("opencontrail-${opencontrail_version}/${img}:${timestamp}"),
            "opencontrail-${opencontrail_version}/${img}",
            properties,
            timestamp
        )
    }
}

node('docker') {
    checkout scm
    git_commit = common.getGitCommit()

    // Check if image of this commit hash isn't already built
    def results = artifactory.findArtifactByProperties(
        art,
        [
            "git_commit": git_commit
        ],
        art.outRepo
    )
    if (results.size() >= images.size()) {
        println "There are already ${results.size} artefacts with same git_commit"
        if (FORCE_BUILD.toBoolean() == false) {
            common.abortBuild()
        }
    }

    stage("prepare") {
        // Prepare Artifactory repositories
        out = artifactory.createRepos(art, inRepos, timestamp)
        println "Created input repositories: ${out}"
    }

    try {
        stage("build") {
            // Build nova-build image
            docker.withRegistry("${art.docker.proto}://in-dockerhub-${timestamp}.${art.docker.base}", "artifactory") {
                // Hack to set custom docker registry for base image
                sh "git checkout -f docker/opencontrail-base.Dockerfile; sed -i -e 's,^FROM ,FROM in-dockerhub-${timestamp}.${art.docker.base}/,g' docker/opencontrail-base.Dockerfile"
                docker.build(
                    "opencontrail-${OC_VERSION}/opencontrail-base:$timestamp",
                    [
                        "--build-arg artifactory_url=${art.url}",
                        "--build-arg timestamp=${timestamp}",
                        "-f docker/opencontrail-base.Dockerfile",
                        "docker"
                    ].join(' ')
                )
            }

            // Build per-component images
            buildSteps = [:]
            for (img in images) {
                buildSteps[img] = buildComponentImageStep(img, OC_VERSION, timestamp)
            }
            parallel buildSteps

            println "Setting offline parameter to input repositories"
            out = artifactory.setOffline(art, inRepos, timestamp)
        }

        stage("test") {
            testSteps = [:]
            for (img in images) {
                testSteps[img] = testComponentImageStep(img, OC_VERSION, timestamp)
            }
            parallel testSteps
        }
    } catch (Exception e) {
        currentBuild.result = 'FAILURE'
        if (KEEP_REPOS.toBoolean() == false) {
            println "Build failed, cleaning up input repositories"
            out = artifactory.deleteRepos(art, inRepos, timestamp)
        }
        throw e
    }

    stage("upload") {
        // Push to artifactory/docker registry
        uploadSteps = [:]
        for (img in images) {
            uploadSteps[img] = uploadComponentImageStep(
                artifactory,
                art,
                img,
                OC_VERSION,
                [
                    "git_commit": git_commit
                ],
                timestamp)
        }
        parallel uploadSteps
    }
}

def promoteEnv = PROMOTE_ENV ? PROMOTE_ENV : "stable"

timeout(time:1, unit:"DAYS") {
    input "Promote to ${promoteEnv}?"
}

node('docker') {
    stage("promote-${promoteEnv}") {
        for (img in images) {
            artifactory.dockerPromote(art, "opencontrail-${OC_VERSION}/${img}", timestamp, "${promoteEnv}")
        }
    }
}
