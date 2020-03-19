from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('observations/<str:patientid>', views.getPatientObservation, name='patientObservation'),
    path('names/', views.getPatientsList, name='patientsList'),
    # path('ethnicity/', views.getPatientEthnicityOverview, name='patientsEthnicity'),
]