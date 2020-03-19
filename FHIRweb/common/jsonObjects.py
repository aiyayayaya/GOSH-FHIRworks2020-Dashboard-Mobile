# A library that deal with the python objects generated from jsons
from collections import Counter
import requests
import json
from fhir.resources.bundle import Bundle

def getPatientMortalityOverview(patients):
    male_deceased = sum([1 for patient in patients if patient.gender == 'male' and patient.deceasedDateTime != None])
    female_deceased = sum([1 for patient in patients if patient.gender == 'female' and patient.deceasedDateTime != None])
    male_alive = sum([1 for patient in patients if patient.gender == 'male' and patient.deceasedDateTime == None])
    female_alive = sum([1 for patient in patients if patient.gender == 'female' and patient.deceasedDateTime == None])
    data = {
        "male_deceased": male_deceased,
        "female_deceased": female_deceased,
        "male_alive": male_alive,
        "female_alive": female_alive,
    }
    return data

def getPatientRaceOverview(patients):
    extensions_lists = [extension for patient in patients for extension in patient.extension]
    
    race = [extension.extension[0].valueCoding.display for extension in extensions_lists if extension.url == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"]
    data = Counter(race)
    return data

def getPatientEthnicityOverview(patients):
    extensions_lists = [extension for patient in patients for extension in patient.extension]
    
    ethnicity = [extension.extension[0].valueCoding.display for extension in extensions_lists if extension.url == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"]
    data = Counter(ethnicity)
    return data

def getAllPatientsNameID(patients):
    results = []
    for patient in patients:
        patient_dict = {}
        patient_dict["name"] = patient.name[0].given[0] + " " + patient.name[0].family
        patient_dict["id"] = patient.id
        results.append(patient_dict)
    return results

def getSinglePatientsAllObservations(observations):
    results = []
    types = sorted(set([observation.code.text for observation in observations]))
    data = {valuetype: [] for valuetype in types}
    for observation in observations:
        simplified_observation = {"id": observation.id}
        simplified_observation['value'] = (str(observation.valueQuantity.value) + observation.valueQuantity.unit) if observation.valueQuantity is not None else ""
        simplified_observation['date'] = observation.effectiveDateTime.date.isoformat(" ") if observation.effectiveDateTime is not None else ""
        data[observation.code.text].append(simplified_observation)
    for key, item in data.items():
        data[key] = sorted(data[key], key=lambda observation: observation['date'])
    return data
