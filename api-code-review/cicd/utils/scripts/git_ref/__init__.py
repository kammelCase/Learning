import os
import shutil
import pathlib
import datetime

from . import internal_git_ref

class GitMap():
    repopaths               = None
    provider_modules        = None
    provider_table          = None
    temp_deployment_path    = None

    def __init__( self ):
        current_date                = datetime.datetime.now()
        today                       = current_date.strftime( "%Y%m%d" )
        now                         = current_date.strftime( "%Y%m%d-%H%M%S" )
        current_deployment          = "deploying_" + now
        self.repopaths              = internal_git_ref.book_keeper
        self.provider_modules       = internal_git_ref.providers
        self.provider_table         = internal_git_ref.CloudProviderMap
        self.temp_deployment_path   = os.path.join( self.repopaths.CICD_BUNDLES, current_deployment )

    def provider_paths( self ):
        ## return the fully qualified filesystem folder paths for each collection of provider modules 
        return [ self.provider_modules[ key ] for key in list( self.provider_modules.keys() ) ]
    
    def providers( self ):
        ## return the folder names for each collection of provider modules
        return list( self.provider_modules.keys() )
   
    def setup_clean_bundle( self ):
        ## delete any artifacts that errantly made it into the repo,,
        for file_object in os.listdir( self.repopaths.CICD_BUNDLES ):
            file_path = os.path.join( self.repopaths.CICD_BUNDLES, file_object )
            if file_path == self.repopaths.CICD_BUNDLE_STUB:
                continue
            if os.path.isdir( file_path ):
                shutil.rmtree( str( file_path ) )
            else:
                pathlib.Path.unlink( pathlib.Path( file_path ) )
        ## write the dated deployment folder
        if not os.path.exists( self.temp_deployment_path ):
            os.mkdir( self.temp_deployment_path )
    

