from django.http import JsonResponse
from django.shortcuts import render, redirect
from .models import Medical, User, Ment, Profile, Hospitals, WeightRecord, Doctors
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.contrib import auth
import numpy as np
import os
from django.contrib import messages
from datetime import datetime
import joblib as joblib
from django.contrib.auth.hashers import make_password
from django.db import connection
from openai import OpenAI
from django.contrib.auth.hashers import check_password


def home(request):
	return render(request, 'home.html')

def registerView(request):
	return render(request, 'register.html')

def registerUser(request):
	if request.method == 'POST':
		username = request.POST['username']
		email = request.POST['email']
		password = request.POST['password']
		password = make_password(password)
		a = User(username=username, email=email, password=password, is_patient=True)
		a.save()
		messages.success(request, 'Account Was Created Successfully')
		return redirect('reg')
	else:
		messages.error(request, 'Failed To Register, Try Again Later')
		return redirect('reg')

def loginView(request):
	if request.method == 'POST':
		username = request.POST['username']
		password = request.POST['password']
		user = authenticate(request, username=username, password=password)
		if user is not None and user.is_active:
			auth.login(request, user)
			if user.is_patient:
				return redirect('patient')
			elif user.is_doctor:
				return redirect('doctor')
			else:
				return redirect('login')
		else:
			messages.info(request, "Invalid Username Or Password")
			return redirect('login')
	else:
		return render(request, 'login.html')					


def patient_home(request):
	doctor = User.objects.filter(is_doctor=True).count()
	patient = User.objects.filter(is_patient=True).count()
	appointment = Ment.objects.filter(patient = request.user.id).count()
	medical1 = Medical.objects.filter(medicine='See Doctor').count()
	medical2 = Medical.objects.all().count()
	medical3 = int(medical2) - int(medical1)
 

	with connection.cursor() as cursor:
			cursor.execute("""
				SELECT symptom, COUNT(symptom) AS frequency
				FROM (
					SELECT s1 AS symptom FROM core_medical WHERE patient_id = %s
					UNION ALL
					SELECT s2 AS symptom FROM core_medical WHERE patient_id = %s
					UNION ALL
					SELECT s3 AS symptom FROM core_medical WHERE patient_id = %s
					UNION ALL
					SELECT s4 AS symptom FROM core_medical WHERE patient_id = %s
					UNION ALL
					SELECT s5 AS symptom FROM core_medical WHERE patient_id = %s
				) AS all_symptoms
				GROUP BY symptom
				ORDER BY frequency DESC
				LIMIT 5
			""", (request.user.id, request.user.id, request.user.id, request.user.id, request.user.id))

			rows = cursor.fetchall()
	user_id = request.user.id
	print(rows)
	weight_arr = WeightRecord.objects.all().filter(user = user_id)
	user_profile = Profile.objects.filter(user_id=user_id)
	if not user_profile:
		context = {'profile_status':'Please Create Profile To Continue', 'status': '0', 'doctor':doctor, 'ment':appointment, patient:'patient', 'drug':medical3, 'arr' : weight_arr, 'sympt' : rows}
		return render(request, 'patient/home.html', context)
	else:
		context = {'status':'1', 'doctor':doctor, 'ment':appointment, patient:'patient', 'drug':medical3, 'arr' : weight_arr,  'sympt' : rows }
		return render(request, 'patient/home.html', context)


def create_profile(request):
	if request.method == 'POST':
		birth_date = request.POST['birth_date']
		region = request.POST['region']
		email = request.POST['email']
		phonenumber = request.POST['phone']
		country = request.POST['country']
		gender = request.POST['gender']
		user_id = request.user.id

		Profile.objects.filter(id = user_id).create(user_id=user_id, birth_date=birth_date, gender=gender, region=region, country=country, phonenumber=phonenumber, email=email)
		messages.success(request, 'Your Profile Was Created Successfully')
		return redirect('patient')
	else:
		user_id = request.user.id
		users = Profile.objects.filter(user_id=user_id)
		users = {'users':users}
		choice = ['1','0']
		gender = ["Male", "Female"]
		context = {"users": {"users":users}, "choice":{"choice":choice}, "gender":gender}
		return render(request, 'patient/create_profile.html', context)	



def diagnosis(request):
	symptoms = ['itching','skin_rash','nodal_skin_eruptions','continuous_sneezing','shivering','chills','joint_pain','stomach_pain','acidity','ulcers_on_tongue','muscle_wasting','vomiting','burning_micturition','spotting_ urination','fatigue','weight_gain','anxiety','cold_hands_and_feets','mood_swings','weight_loss','restlessness','lethargy','patches_in_throat','irregular_sugar_level','cough','high_fever','sunken_eyes','breathlessness','sweating','dehydration','indigestion','headache','yellowish_skin','dark_urine','nausea','loss_of_appetite','pain_behind_the_eyes','back_pain','constipation','abdominal_pain','diarrhoea','mild_fever','yellow_urine','yellowing_of_eyes','acute_liver_failure','fluid_overload','swelling_of_stomach','swelled_lymph_nodes','malaise','blurred_and_distorted_vision','phlegm','throat_irritation','redness_of_eyes','sinus_pressure','runny_nose','congestion','chest_pain','weakness_in_limbs','fast_heart_rate','pain_during_bowel_movements','pain_in_anal_region','bloody_stool','irritation_in_anus','neck_pain','dizziness','cramps','bruising','obesity','swollen_legs','swollen_blood_vessels','puffy_face_and_eyes','enlarged_thyroid','brittle_nails','swollen_extremeties','excessive_hunger','extra_marital_contacts','drying_and_tingling_lips','slurred_speech','knee_pain','hip_joint_pain','muscle_weakness','stiff_neck','swelling_joints','movement_stiffness','spinning_movements','loss_of_balance','unsteadiness','weakness_of_one_body_side','loss_of_smell','bladder_discomfort','foul_smell_of urine','continuous_feel_of_urine','passage_of_gases','internal_itching','toxic_look_(typhos)','depression','irritability','muscle_pain','altered_sensorium','red_spots_over_body','belly_pain','abnormal_menstruation','dischromic _patches','watering_from_eyes','increased_appetite','polyuria','family_history','mucoid_sputum','rusty_sputum','lack_of_concentration','visual_disturbances','receiving_blood_transfusion','receiving_unsterile_injections','coma','stomach_bleeding','distention_of_abdomen','history_of_alcohol_consumption','fluid_overload','blood_in_sputum','prominent_veins_on_calf','palpitations','painful_walking','pus_filled_pimples','blackheads','scurring','skin_peeling','silver_like_dusting','small_dents_in_nails','inflammatory_nails','blister','red_sore_around_nose','yellow_crust_ooze']
	symptoms = sorted(symptoms)
	context = {'symptoms':symptoms, 'status':'1'}
	return render(request, 'patient/diagnosis.html', context)



@csrf_exempt
def MakePredict(request):
	s1 = request.POST.get('s1')
	s2 = request.POST.get('s2')
	s3 = request.POST.get('s3')
	s4 = request.POST.get('s4')
	s5 = request.POST.get('s5')
	id = request.POST.get('id')
	user_id = request.user.id
	
	list_b = [s1,s2,s3,s4,s5]
	print(list_b)

	list_a = ['itching','skin_rash','nodal_skin_eruptions','continuous_sneezing','shivering','chills','joint_pain','stomach_pain','acidity','ulcers_on_tongue','muscle_wasting','vomiting','burning_micturition','spotting_ urination','fatigue','weight_gain','anxiety','cold_hands_and_feets','mood_swings','weight_loss','restlessness','lethargy','patches_in_throat','irregular_sugar_level','cough','high_fever','sunken_eyes','breathlessness','sweating','dehydration','indigestion','headache','yellowish_skin','dark_urine','nausea','loss_of_appetite','pain_behind_the_eyes','back_pain','constipation','abdominal_pain','diarrhoea','mild_fever','yellow_urine','yellowing_of_eyes','acute_liver_failure','fluid_overload','swelling_of_stomach','swelled_lymph_nodes','malaise','blurred_and_distorted_vision','phlegm','throat_irritation','redness_of_eyes','sinus_pressure','runny_nose','congestion','chest_pain','weakness_in_limbs','fast_heart_rate','pain_during_bowel_movements','pain_in_anal_region','bloody_stool','irritation_in_anus','neck_pain','dizziness','cramps','bruising','obesity','swollen_legs','swollen_blood_vessels','puffy_face_and_eyes','enlarged_thyroid','brittle_nails','swollen_extremeties','excessive_hunger','extra_marital_contacts','drying_and_tingling_lips','slurred_speech','knee_pain','hip_joint_pain','muscle_weakness','stiff_neck','swelling_joints','movement_stiffness','spinning_movements','loss_of_balance','unsteadiness','weakness_of_one_body_side','loss_of_smell','bladder_discomfort','foul_smell_of urine','continuous_feel_of_urine','passage_of_gases','internal_itching','toxic_look_(typhos)','depression','irritability','muscle_pain','altered_sensorium','red_spots_over_body','belly_pain','abnormal_menstruation','dischromic _patches','watering_from_eyes','increased_appetite','polyuria','family_history','mucoid_sputum','rusty_sputum','lack_of_concentration','visual_disturbances','receiving_blood_transfusion','receiving_unsterile_injections','coma','stomach_bleeding','distention_of_abdomen','history_of_alcohol_consumption','fluid_overload','blood_in_sputum','prominent_veins_on_calf','palpitations','painful_walking','pus_filled_pimples','blackheads','scurring','skin_peeling','silver_like_dusting','small_dents_in_nails','inflammatory_nails','blister','red_sore_around_nose','yellow_crust_ooze']


	list_c = []
	for x in range(0,len(list_a)):
		list_c.append(0)

	print(list_c)


	for z in range(0,len(list_a)):
		for k in list_b:
			if(k==list_a[z]):
				list_c[z]=1

	test = list_c
	test = np.array(test)
	test = np.array(test).reshape(1,-1)
	print(test.shape)

	clf = joblib.load('model/naive_bayes.pkl')

	
	prediction = clf.predict(test)
	result = prediction[0]
 
	profile_details = Profile.objects.get(user_id = user_id )

	a = Medical(s1=s1, s2=s2, s3=s3, s4=s4, s5=s5, disease=result, patient_id=id, blood_high = profile_details.blood_high, blood_low = profile_details.blood_low, bmi = profile_details.bmi, weight = profile_details.weight )
	a.save()

	return JsonResponse({'status':result})			

def locationServices(request):
    hosp = []
    context = {'hospitals': hosp,'status':'1'}
    if request.method == 'POST':
        dist = request.POST.get('district')
        hosp = Hospitals.objects.all().filter(District = dist)
        print(hosp)
        context = {'hospitals': hosp, 'status':'1'}
        return render(request, "patient/location.html", context)
    else:
    	return render(request, "patient/location.html", context)
    


def patient_result(request):
    user_id = request.user.id
    hosp = Hospitals.objects.all().filter(Available =True)
    disease = Medical.objects.all().filter(patient_id=user_id)
    profile_details = Profile.objects.all().filter(user_id = user_id)
    context = {'disease':disease, 'status':'1', 'profile' :  profile_details, 'Hospitals' : hosp}
    return render(request, 'patient/result.html', context)


@csrf_exempt
def appointment(request, param1, param2):
    print(param1)
    print(param2)
    userId = request.user.id
    hosp = Hospitals.objects.all().filter(Available =True)
    med = Medical.objects.get(id = param1)
    diagnosis_id = param1
    if request.method == 'POST' :
        hospital = request.POST.get('hosp')
        doc = request.POST.get('doctor')
        mode = request.POST.get('app')
        check_medical = Ment.objects.filter(medical=diagnosis_id).exists()
        if check_medical == False:
            app = Medical.objects.get(id = diagnosis_id)
            d = Doctors.objects.get(id = doc)
            a = Ment(patient = userId, doctor = doc, medical = diagnosis_id, appointment = mode, hospital = hospital, Doctor_Name= d.Name , Disease = app.disease )
            app.appointment = True
            app.save()
            a.save()
            return redirect('result')
    context = {'status' : '1', 'Hospitals' : hosp, 'd' : med }
    return render(request, 'patient/appointment.html' , context)


@csrf_exempt
def med_predict(request):
    disease = request.POST.get('disease')
    userid = request.user.id
    med =  Medical.objects.get(id = disease) 
    dob = Profile.objects.filter(user_id=userid).values_list('birth_date', flat=True)
    dob = list(dob)
    dob = dob[0]
    print('Date of birth is',dob)
    dob = str(dob)
    dob = dob[0:4]
    print('New Date of birth is',dob)
    dob = int(dob)
    age = 2024 - dob
    print('Patient Age is',age)
    try:
        d = med.disease 
        a = age 

        client = OpenAI(api_key="")
        stream = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": f"Suggest two drugs and their details for {d} and age: {a} available in India. Do not give a description; suggest only the name of the drug and company name in brackets (important)"}],
        stream=True,)
            
        suggestions = []
        for chunk in stream:
            if chunk.choices[0].delta.content is not None:
                suggestion = chunk.choices[0].delta.content.strip()  
                suggestions.append(suggestion)
        suggestions_str = ''.join(suggestions)
        split_index = suggestions_str.find('2.')
        first_line = suggestions_str[:split_index]
        second_line = suggestions_str[split_index:]
        med.medicine = first_line
        med.medicine2 = second_line
        med.save()
        return redirect('result')
    except Exception as e:
        return JsonResponse({'status':'error'})	


def patient_ment(request):
	user_id = request.user.id
	appointment = Ment.objects.all().filter(patient= user_id)
	context = {'ment':appointment, 'status':'1'}
	return render(request, 'patient/ment.html', context)

def ment(request):
    user_id = request.user.id
    appo = Ment.objects.all().filter(patient = user_id)
    docs = []
    med = []
    for a in appo:
        doct = Doctors.objects.get(id = a.doctor)
        medi = Medical.objects.get(id = a.medical) 
        docs.append(doct)
        med.append(medi)
        

def profile_details(request):
    user_id = request.user.id
    profile = Profile.objects.all().filter(user_id=user_id)
    context = {'profile': profile, 'status' : '1'}
    return render(request, 'patient/profile.html', context)


def medical_profile(request):
    user_id = request.user.id
    profile = Profile.objects.get(user_id=user_id)
    print(profile.medical_profile)
    if request.method == 'POST':
        w =request.POST.get('weight')
        h = request.POST.get('height')
        profile.height = request.POST.get('height')
        profile.weight = request.POST.get('weight')
        profile.allergies = request.POST.get('allergic')
        profile.blood_type = request.POST.get('group')
        profile.blood_low = request.POST.get('low')
        profile.blood_high = request.POST.get('high')
        profile.medications = request.POST.get('meds')
        profile.family_history = request.POST.get('fam')
        profile.past_medical = request.POST.get('past')
        profile.medical_profile = True
        h = (float(h))/100
        bmi = (float(w))/(h**2)
        profile.bmi = bmi
        today_date = datetime.now().date()
        weight = WeightRecord(user = user_id, date = today_date, weight = w)
        weight.save()
        profile.save()
    if profile.medical_profile == False:
        context = {'profile': profile, 'status' : '1', 'health' : '0'}
        return render(request, 'patient/healthprofile.html', context)
    context = {'profile': profile, 'status' : '1', }
    return render(request, 'patient/healthprofile.html', context)


def weight(request):
    user_id = request.user.id
    today = WeightRecord.objects.filter(date = datetime.now().date(), user = user_id).exists()
    weight_arr = WeightRecord.objects.all().filter(user = user_id)
    if today:
        context = {'status' : '1', 'today' : '1', 'arr': weight_arr}
    else:
        context = {'status' : '1' , 'today' : '0', 'arr': weight_arr}
    if request.method == 'POST':
        weight = request.POST.get('weight')
        low = request.POST.get('low')
        high = request.POST.get('high')
        sleep = request.POST.get('hr')
        w = WeightRecord(user = user_id, date = datetime.now().date(), weight = weight, blood_low = low, blood_high = high, sleep = sleep  )
        w.save()
        profile = Profile.objects.get(user_id=user_id)
        profile.weight = weight
        profile.blood_low = low
        profile.blood_high = high
        h = (float(profile.height))/100
        bmi = (float(weight))/(h**2)
        profile.bmi = bmi
        profile.save()
        context = {'status' : '1', 'today' : '1', 'arr': weight_arr}
        return render(request, 'patient/weight.html', context)
    return render(request, 'patient/weight.html', context)

def settings(request):
    context = {'status' : '1'}
    return render(request, 'patient/settings.html', context)

def logoutView(request):
	logout(request)
	return redirect('login')



#doctor login

def doctorLogin(request):
    return render(request, 'docLogin.html')




#hospital register

def hospitalRegister(request):
    if request.method == 'POST':
        name = request.POST['username']
        district  = request.POST['district']
        city = request.POST['city']
        pincode = request.POST['pincode']
        address = request.POST['address']
        password = make_password(request.POST['password'])
        print(name, password, city, district, name, pincode, address)
        hosp = Hospitals(Hospital_Name = name, District = district, CityTown = city, Pincode = pincode, Address = address, Password = password, Available = True)
        hosp.save()
        messages.success(request,"Hospital Account Created Successfully")
        return redirect("hosLog")
    return render(request, 'hospitalRegister.html')


def HospitalLogin(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        try:
            hosp = Hospitals.objects.get(Hospital_Name=username)
            if check_password(password, hosp.Password):
                print("Login Success")
                request.session['hospital'] = hosp.Hospital_Name
                return redirect('HospHome')  
            else:
                messages.error(request, "Incorrect password")
        except Hospitals.DoesNotExist:
            messages.error(request, "Hospital not found")
    return render(request, 'hospitalLogin.html')

def hospitalLogout(request):
    logout(request) #delete sessions
    return redirect("home") 

def HospitalHome(request):
    return render(request, 'doctor/home.html')

def DoctorsView(request):
    hospital_name = request.session.get('hospital')
    docLists = Doctors.objects.all().filter(Hospital=hospital_name)
    print(hospital_name)
    context = {'doctors' : docLists}
    if request.method == 'POST':
        name = request.POST['name']
        spec = request.POST['spec']
        username = request.POST['username']
        password = request.POST['password']
        degree = request.POST['degree']
        password = make_password(password)
        print(name, username, password, degree, spec)
        doc = Doctors(Username = username, Name = name, Specification = spec, Password = password, Degree = degree, Hospital = hospital_name)
        doc.save()
    return render(request, 'doctor/doctors.html', context)

def get_doctors(request):
    hospital_name = request.GET.get('hospital_id')
    docLists = Doctors.objects.all().filter(Hospital = hospital_name).values('id', 'Name', 'Specification')
    docLists = list(docLists)
    return JsonResponse({'doctors': docLists})

def hospitalAppointments(request):
    hospital_name = request.session.get('hospital')
    apps = Ment.objects.all().filter(hospital = hospital_name)
    doctors = []
    patients =[]
    appoint = []
    data_list = []
    mode = []
    med = []
    pat = []
    for app in apps:
        doctor = Doctors.objects.get(id=app.doctor)
        patient = User.objects.get(id=app.patient)
        appoint.append(app.id)
        doctors.append(doctor.Name)
        patients.append(patient.username)
        mode.append(app.appointment)
        med.append(app.medical)
        pat.append(app.patient)
    for doctor, patient, appointment, mode, med, pat in zip(doctors, patients, appoint, mode, med, pat):
        data_dict = {'doctor': doctor, 'patient': patient, 'appointment': appointment, 'mode': mode, 'med': med, 'pat' :pat}
        data_list.append(data_dict)
    print(data_list)
    arr = zip(doctors, patients, appoint)
    context = {'apps': data_list }
    return render(request, 'doctor/appointments.html', context)

@csrf_exempt
def appointmentDetails(request, param1, param2, param3):
    med = Medical.objects.get(id = param1)
    user_profile = Profile.objects.filter(user_id=param2)
    app_id = param3
    a = Ment.objects.get(id = app_id)
    if request.method == 'POST':
        dateTime = request.POST.get( "datetime" )
        a.my_time_field = dateTime
        a.save()
    context = {'d' : med, 'p': user_profile, 'a' : a}
    return render(request,'doctor/appDetails.html', context)
