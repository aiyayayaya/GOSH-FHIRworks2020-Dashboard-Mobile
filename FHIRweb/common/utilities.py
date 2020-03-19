# A library that deal with the read and write
# read consists of reading from file and reading from web
import requests
import json
from fhir.resources.bundle import Bundle

BASE_URL = "https://localhost:5001/api"

def read_from_file(path):
    content = ''
    with open(path, 'r') as f:
        content = f.read()
    return content

def get_from_url(query_path):
    response = requests.get(BASE_URL + query_path, verify=False)
    return response.content

def post_from_url(query_path, request):
    response = requests.post(BASE_URL + query_path, request)
    return response.content

def get_data_source(source_is_file, path):
    if source_is_file:
        return read_from_file(path)
    return get_from_url(path)

def read_bundles_from_json(json_string):
    parsed_objects = json.loads(json_string)
    return [Bundle(i) for i in parsed_objects]

def get_observation(patientid):
    response = requests.get(BASE_URL + "/Observation/" + patientid, verify=False)
    return response.content

def read_observations(observationJson):
    entries = [bundle.entry for bundle in read_bundles_from_json(observationJson)]
    observations = []
    for entry in entries:
        observations.extend([singleentry.resource for singleentry in entry])    
    return observations

def readPatientsJson(path):
    content = read_from_file(path)
    entries = [bundle.entry for bundle in read_bundles_from_json(content)]
    patients = []
    for entry in entries:
        patients.extend([singleentry.resource for singleentry in entry])
    return patients