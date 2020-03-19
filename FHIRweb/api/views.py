from common.utilities import readPatientsJson, read_bundles_from_json, readPatientsJson, read_observations, get_observation
from common.jsonObjects import getPatientRaceOverview, getPatientEthnicityOverview, getPatientMortalityOverview, getSinglePatientsAllObservations, getAllPatientsNameID
from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.conf import settings
from django.views.generic import View
from collections import Counter
import os

def getPatientsId(patients):
    return [patient.id for patient in patients]

def index(request):
    patients = readPatientsJson(settings.MEDIA_ROOT + "jsons/patients/download.json")
    data = {
        "serverinfo": getServerInfo(request),
        "race": getPatientRaceOverview(patients),
        "ethnicity": getPatientEthnicityOverview(patients),
        "mortality": getPatientMortalityOverview(patients),
        "patientsnumber": len(patients) 
    }
    return JsonResponse(data)

def getPatientsList(request):
    patients = readPatientsJson(settings.MEDIA_ROOT + "jsons/patients/download.json")
    return JsonResponse(getAllPatientsNameID(patients), safe=False)

def getServerInfo(request):
    if request.method == 'POST':
        server_url = request.POST['url']
    else:
        server_url = ""
    try:
        with open(settings.MEDIA_ROOT + "jsons/capabilitystatement/download.json") as f:
            fhir_version = read_bundles_from_json(f.read()).entry[0].resource.fhirVersion
    except Exception:
        fhir_version = "unknown"
    data = {
        "server_url": server_url,
        "fhir_version": fhir_version
    }
    return data

def getPatientObservation(request, patientid):
    json = get_observation(patientid)
    observations = read_observations(json)
    return JsonResponse(getSinglePatientsAllObservations(observations), safe=False)

