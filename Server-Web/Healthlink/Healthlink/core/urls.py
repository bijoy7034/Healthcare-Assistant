from django.urls import path, include
from . import views
from django.contrib.auth import views as auth_views


urlpatterns = [
#patient
path('', views.home, name='home'),
path('register/', views.registerView, name='reg'),
path('reg_user/', views.registerUser, name='reg_user'),
path('login/', views.loginView, name='login'),
path('patient/', views.patient_home, name='patient'),
path('create_profile/', views.create_profile, name='create_profile'),
path('diagnosis/', views.diagnosis, name='diagnosis'),
path('diagnosis/predict', views.MakePredict, name='predict'),
path("location/", views.locationServices, name="location"),
path('result/', views.patient_result, name='result'),
path('profile/', views.profile_details, name="profile"),    
path('ment/', views.patient_ment, name='ment_list'),
path('medical_profile/', views.medical_profile, name='med_pro'),
path('logout/', views.logoutView, name='logout'),
path('weight/', views.weight, name='weight'),
path('settings/', views.settings, name='set'),
path('medicine/', views.med_predict, name='medi'),
path('appointment/<param1>/<param2>/', views.appointment, name='app'),

#doctors
path('doclogin/', views.doctorLogin, name='docLogin'),

#Hospiatal  staff
path("hospital/register", views.hospitalRegister, name='hosReg'),
path("hospital/login", views.HospitalLogin, name='hosLog'),
path('hospital/home', views.HospitalHome, name= 'HospHome' ),
path('hospital/logout/', views.hospitalLogout, name='Hosplogout'),
path('hospital/doctors', views.DoctorsView, name='docs'),
path('get-doctors/', views.get_doctors, name='get_doctors'),
path('hospital/appointments', views.hospitalAppointments, name='hospApps'),
path('hospital/appointments/details/<param1>/<param2>/<param3>/', views.appointmentDetails, name='appDet'),
]
