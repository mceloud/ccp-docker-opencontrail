/**
 * Docker Aptly image build pipeline
 *
 * IMAGE_GIT_URL - Image git repo URL
 * IMAGE_BRANCH - Image repo branch
 * IMAGE_CREDENTIALS_ID - Image repo credentials id
 * REGISTRY_URL - Docker registry URL (can be empty)
 * REGISTRY_CREDENTIALS_ID - Docker hub credentials id
 *
**/

def common = new com.mirantis.mk.Common()
def gerrit = new com.mirantis.mk.Gerrit()
def dockerLib = new com.mirantis.mk.Docker()

def server = Artifactory.server('mcp-ci')
def artTools = new com.mirantis.mcp.MCPArtifactory()
def timestamp = common.getDatetime()
def artifactoryUrl = server.getUrl()
def dockerDevRepo = 'docker-dev-local'
def dockerProdRepo = 'docker-prod-local'
def dockerDevRegistry = "${dockerDevRepo}.docker.mirantis.net"
def dockerProdRegistry = "${dockerProdRepo}.docker.mirantis.net"
def imageNameSpace = 'openstack-docker'


node("docker") {
  def workspace = common.getWorkspace()
  def imageList = []
  def images = []

  try {
    stage("cleanup") {
      sh("rm -rf * || true")
    }

    stage("checkout") {
        gerrit.gerritPatchsetCheckout(IMAGE_GIT_URL, "", IMAGE_BRANCH, IMAGE_CREDENTIALS_ID)
    }

    docker.withRegistry("http://${dockerDevRegistry}/", 'artifactory') {
      stage("build") {

        def baseImage = ""
        dir("${workspace}/docker") {
          imageList = sh(script: "ls *Dockerfile -1 | sed -e 's/\\..*\$//'", returnStdout: true).trim().tokenize()
          baseImage = sh(script: "ls *-base.Dockerfile -1 | sed -e 's/\\..*\$//'", returnStdout: true).trim().tokenize()[0]
        }

        imageList.remove(baseImage)
        imageList.add(0,baseImage)

        for (int i = 0; i < imageList.size(); i++) {
          def imageName = imageList[i]
            common.infoMsg("Building image ${imageName}")
            images.add(dockerLib.buildDockerImage("${dockerDevRegistry}/${imageNameSpace}/${imageName}", "", "./Docker/${imageName}.Dockerfile", "latest"))
        }
      }

      stage("upload to ${REGISTRY_URL}"){
        for (int i = 0; i < images.size(); i++) {
            def imageName = imageList[i]
            artTools.uploadImageToArtifactory(server, dockerDevRegistry,
                    "${imageNameSpace}/${imageName}",
                    timestamp,
                    dockerDevRepo)
            sh "docker rmi -f ${dockerDevRegistry}/${imageNameSpace}/${imageName}"
        }
      }
    }
    stage('promote') {
        for (int i = 0; i < imageList.size(); i++) {
            def imageName = imageList[i]
            def properties = [ 'com.mirantis.targetImg': "${imageNameSpace}/${imageName}" ]
            // Search for an artifact with required properties
            String artifact_uri = artTools.uriByProperties(artifactoryUrl, properties)
            if ( artifact_uri ) {
                def buildInfo = artTools.getPropertiesForArtifact(artifact_uri)
                String currentTag = buildInfo.get('com.mirantis.targetTag')[0]
                String targetTag = currentTag.split('_')[0]
                // promote docker image

                artTools.promoteDockerArtifact(artifactoryUrl,
                        dockerDevRepo,
                        dockerProdRepo,
                        "${imageNameSpace}/${imageName}",
                        currentTag,
                        targetTag,
                        true)
            } else {
                echo 'Artifacts were not found, nothing to promote'
            }
        }
    }
  } catch (Throwable e) {
     currentBuild.result = "FAILURE"
     throw e
  } finally {
     common.sendNotification(currentBuild.result,"",["slack"])
  }

}
