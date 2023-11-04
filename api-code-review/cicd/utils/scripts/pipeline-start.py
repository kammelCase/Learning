import os
import sys
import json
import shutil
import pathlib
import argparse

from collections import defaultdict, OrderedDict

## local imports from the repo
from api_ref import ApiMap 
from git_ref import GitMap

api_map = ApiMap()
git_map = GitMap()

def read_args():
    simple_parser = argparse.ArgumentParser( description="read and evaluate inventory data provided to this script" )
    simple_parser.add_argument( '-i', '--inventory' , type=read_inv_arg , help="streamable/readable json input" )
    # simple_parser.add_argument( '-h', '--help'      , help='' )
    cliargs = simple_parser.parse_args()  
    return cliargs.inventory

def read_inv_arg( inv_json ):
    data = None
    ## no try-catch block b/c if the json is malformed we should raise an exception and exit
    if os.path.exists( inv_json ):
        with open( inv_json, 'r' ) as file_handle:
            data = json.load( file_handle )
    else:
        data = json.laods( inv_json )
    return data

def environ_apifield_to_provider( work_order_json ):
    hosting_data = work_order_json[ api_map.requests_api_table.ENVIRON.value ]
    if not isinstance( hosting_data, str ):
        sys.exit( f"hosting environment field was not transmitted correctly - incorrect data is {hosting_data}" )
    clean_string = str( hosting_data ).lower().strip()
    ret_string = None
    while ret_string is None:
        if git_map.provider_table.AWS.value in clean_string:
            ret_string = git_map.provider_table.AWS.value
        if git_map.provider_table.GCP.value:
            ret_string = git_map.provider_table.GCP.value
        if git_map.provider_table.AZURE.value:
            ret_string = git_map.provider_table.AZURE.value
    return ret_string 

def deploys_apifield_to_modules( work_order_json ):
    ret_provider_modules_list = []
    ## read the deploys field and the provider field to figure out which module paths to use
    deploys_data_list = work_order_json[ api_map.requests_api_table.DEPLOYS.value ]
    ## we will accept either a list-of-strings or a string from the api-call
    if not isinstance( deploys_data_list, list ):
        if isinstance( deploys_data_list, str ):
            deploys_data_list = [ deploys_data_list ]
        else:
            sys.exit( f"deployment request field was not transmitted correctly - incorrect data is {deploys_data_list}" )
    
    provider                = environ_apifield_to_provider( work_order_json )
    provider_path           = git_map.provider_modules[ provider ]
    provider_module_options = api_map.provider_api_table[ provider ]
    for deployment_menu_dict in deploys_data_list:
        for deployment_menu_key in deployment_menu_dict:
            module_folder_name = provider_module_options[ deployment_menu_key ]
            module_folder_path = os.path.join( provider_path, module_folder_name )
            if not os.path.exists( module_folder_path ):
                sys.exit( f"the git repo is out of sync with the api - the deployment requested a valid menu-item but there is not a matching folder in the repo" )
            deployment_request_dict = deployment_menu_dict[ deployment_menu_key ]
            ret_provider_modules_list.append( ( module_folder_path, deployment_request_dict ) )
    return ret_provider_modules_list

## at the end of this fnxn we should know which hosting environment we're being asked to build for and the tf-modules to bundle
def parse_workorder( json_pipeline_data ):
    api_map.validate_request( json_pipeline_data )
    work_order              = json_pipeline_data[ "work-order" ]
    provider                = environ_apifield_to_provider( work_order )
    provider_path           = git_map.provider_modules[ provider ]
    provider_modules_list   = deploys_apifield_to_modules( work_order )  
    return ( provider, provider_path, provider_modules_list )

def write_temp_deployment_json( json_content, folder_path ):
    json_dict = {}
    json_dict[ 'deployment' ] = []
    json_dict[ 'deployment' ].append( json_content )
    file_path = os.path.join( folder_path, "deployment.json" ) 
    with open( file_path, 'w' ) as file_handle:
        json.dump( json_dict, file_handle, indent=4 )

def setup_deployment( provider_modules_list ):
    
    ## create a bundling folder for today
    git_map.setup_clean_bundle()

    ## put the provider modules, cicd_main.tf, and deployment.json into the bundling folder
    deployment_index = 1
    for provider_path, deployment_data_json in provider_modules_list:
        provider_folder_name = os.path.basename( provider_path ) + "_" + str( deployment_index )
        provider_deploy_path = os.path.join( git_map.temp_deployment_path, provider_folder_name )
        shutil.copytree( provider_path, provider_deploy_path )
        write_temp_deployment_json( deployment_data_json, provider_deploy_path )
        #
        ## right now we only have a singl cicd_main.tf file that is statically defined
        ## in the future we will have to dynamically create one based on the inputs to the api
        #
        cicd_main_path = os.path.join( provider_deploy_path, "cicd_main.tf" )
        shutil.copyfile( git_map.repopaths.CICD_MAINTF, cicd_main_path )
        deployment_index += 1 



if __name__ == '__main__':
    ## read the arguments
    json_data = read_args() 

    ## parse the work order from the api call
    provider, provider_path, provider_modules_list = parse_workorder( json_data )
    
    ## setup the deployment folder for the next segment/phase of the pipeline
    setup_deployment( provider_modules_list )
    
    ## exit cleanly/successfully
    sys.exit( 0 )                                
    


