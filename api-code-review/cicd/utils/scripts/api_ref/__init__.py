import sys
import json

from . import internal_api_ref

class ApiMap():
    provider_api_table  = None
    requests_api_tabl   = None
    
    def __init__( self ):
        self.provider_api_table = internal_api_ref.provider_api_options
        self.requests_api_table = internal_api_ref.InputJsonFields  
                                # { field.name : field.value for field in internal_api_ref.InputJsonFields }
    def providers_list( self ):
        return list( self.provider_api_table.keys() )
    def request_fields_list( self ):
        return [ self.requests_api_table[ field ] for field in list( requests_api_table.keys() ) ] 
    
    ## no try-catch blocks because if this is formatted incorrectly then we want to fail and exit since no work can be done if we aren't correctly told what work to do
    def validate_request( self, json_request_data ):
        json.dumps( json_request_data )
        work_order = json_request_data[ "work-order" ]
        validate_apicall_fields( work_order )

def validate_apicall_fields( json_request_data ):
    keylist = list( json_request_data.keys() )
    for field in internal_api_ref.InputJsonFields:
        if not field.value in keylist:
            sys.exit( f"{field} is missing from the required APi-fields" )
