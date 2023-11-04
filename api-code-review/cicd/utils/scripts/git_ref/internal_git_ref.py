import os
import git
import strenum

class CloudProviderMap( strenum.StrEnum ):
    AWS     = 'aws'
    GCP     = 'gcp'
    AZURE   = 'azure'

class RepoSetup():    
    
    GIT_FOLDER         = None 
    AWS_PROVIDER       = None 
    AZURE_PROVIDER     = None 
    GCP_PROVIDER       = None 
    CICD_CODE_FOLDER   = None 
    CICD_YAMLS         = None 
    CICD_UTILS         = None 
    CICD_SCRIPTS       = None 
    CICD_BUNDLES       = None 
    CICD_BUNDLE_STUB   = None 
    CICD_JSONS         = None 
    CICD_VALID_JSONS   = None 
    
    def __init__( self ):
        ## these all-caps fields map out the repo folder paths
        #
        ## if a future dev runs 'git mv` or 'git rm` on one of these folders 
        ## then they will also need to update these all-caps fields
        #
        self.GIT_FOLDER         = get_git_toplevel()                                                            # https://partnershealthcare.visualstudio.com/Cloud-Foundations/_git/Cloud-Foundations
        self.AWS_PROVIDER       = os.path.join( self.GIT_FOLDER,        CloudProviderMap.AWS.value      )       # git://aws
        self.GCP_PROVIDER       = os.path.join( self.GIT_FOLDER,        CloudProviderMap.GCP.value      )       # git://gcp
        self.AZURE_PROVIDER     = os.path.join( self.GIT_FOLDER,        CloudProviderMap.AZURE.value    )       # git://azure
        self.CICD_CODE_FOLDER   = os.path.join( self.GIT_FOLDER,        "cicd"                          )       # git://cicd 
        #
        ## right now we only have a singl cicd_main.tf file that is statically defined
        ## in the future we will have to dynamically create one based on the inputs to the api
        self.CICD_MAINTF        = os.path.join( self.CICD_CODE_FOLDER,  "cicd_main.tf"                  )       # git://cicd/cicd_main.tf
        #
        ##
        #
        self.CICD_YAMLS         = os.path.join( self.CICD_CODE_FOLDER,  "yamls"                         )       # git://cicd/yamls
        self.CICD_UTILS         = os.path.join( self.CICD_CODE_FOLDER,  "utils"                         )       # git://cicd/utils
        self.CICD_SCRIPTS       = os.path.join( self.CICD_UTILS,        "scripts"                       )       # git://cicd/utils/scripts
        self.CICD_BUNDLES       = os.path.join( self.CICD_UTILS,        "bundles"                       )       # git://cicd/utils/bundles
        self.CICD_BUNDLE_STUB   = os.path.join( self.CICD_BUNDLES,      "readme.no-touchy"              )       # git://cicd/utils/bundles/readme.no-touchy
        self.CICD_JSONS         = os.path.join( self.CICD_CODE_FOLDER,  "jsons"                         )       # git://cicd/jsons                  
        self.CICD_VALID_JSONS   = os.path.join( self.CICD_JSONS,        "api_examples"                  )       # git://cicd/jsons/api_examples
        
def get_git_toplevel():
    git_repo = git.Repo( __file__, search_parent_directories=True )
    git_root = git_repo.git.rev_parse( "--show-toplevel" )
    return git_root

book_keeper = RepoSetup()
providers = { CloudProviderMap.AWS.value    : book_keeper.AWS_PROVIDER
            , CloudProviderMap.GCP.value    : book_keeper.GCP_PROVIDER
            , CloudProviderMap.AZURE.value  : book_keeper.AZURE_PROVIDER
            }
