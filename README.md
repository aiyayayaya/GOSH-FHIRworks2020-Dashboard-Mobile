# GOSH FHIRworks2020 Dashboard Mobile

## Description
This is a mobile dashboard for both Android and ios using Flutter, and also using Django server as the backend to process data. It provides an overview on patient, e.g. mortality, races, ethnicity. It also provides a search interface that can search patients by their ID. The observations of search patient is shown  when you click on the patient. The observations are grouped by their type and sorted by date. It provides a straight forward interface to view the data.

Note that for patients data, the Django backend should have the full json bundle lists to run. The Django backend would use the web API to ask for patient observation since there are too many patients. Also, feel free to supply a capability statement bundle json to let the app read the version number.

## How to run
First, you have to run the FHIR server provided by GoshDrive using `dotnet run`. Record your domain.

Next, make sure you have installed Django. Navigate to `FHIRWEB` folder and run `python3 manage.py runserver`. Record your local port and domain (need a remote domain if you are using a physical phone).

Then, as the app uses local patients JSON for better performance, save the file you get from `/api/Patients` dotnet server endpoint inside `FHIRWEB/jsons/patients` and rename it as `download.json`.

(Optional) Download a capabilitystatement json object inside `FHIRWEB/jsons/capabilitystatement` as `download.json` to get the FHIR version in your app.

Change the `BASE_URL` into the domain you used for the Django server in the `httprequest.dart` file. Note that if you want to open the app in Android Studio emulators, the domain would be 10.0.2.2 assuming you are using 127.0.0.1 originally. You might also need to change the `BASE_URL` in `FHIRWEB/common/utilities` into the domain you use for the dotnet server.

If you are using the Android Studio emulator, you can run it directly in Android Studio. If you are using a physical phone, do the following.

Open the project in Android Studio. Then, type the command to build the project:
- Android - https://flutter.dev/docs/deployment/android#build-an-app-bundle or uploaded [here](https://github.com/aiyayayaya/GOSH-FHIRworks2020-Dashboard-Mobile/releases/tag/1.0) 
- IOS - https://flutter.dev/docs/deployment/ios

Install the package on your phone. Remember to allow your phone to install external apps.

## Possible extensions
- allow the user to choose between using jsons or web API
- compatibility with DSTU3 and DSTU2 (the imported python library supports DSTU3 json object)
- connect with a database with authentication
- detailed patient information
