from rest_framework.response import Response
from rest_framework.decorators import api_view
from core.models import Medical, User, Ment, Profile, Hospitals, WeightRecord, Doctors
from django.views.decorators.csrf import csrf_exempt
from .serializers import UserSerializer, MedicalSerializer, ProfileSerializer, WeightSeializer, MentSerializer
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework import status
from datetime import datetime

@api_view(['GET'])
def getUsers(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many= True)
    return Response(serializer.data)

@api_view(['GET'])
def getMedical(request):
    med = Medical.objects.all()
    serializer = MedicalSerializer(med, many=True)
    return Response(serializer.data)


@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(username=username, password=password)
    if user:
        refresh = RefreshToken.for_user(user)
        return Response({'id': user.id, 'refresh': str(refresh), 'access': str(refresh.access_token)}, status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['POST'])
def getProfile(request):
    userId = request.data.get('id')
    profile = Profile.objects.get(user_id = userId)
    user = User.objects.get(id = userId)
    serializer = UserSerializer(user, many=False)
    serializer2 = ProfileSerializer(profile, many= False)
    responseData = {
        'users' :  serializer.data , 
        'profile' : serializer2.data
    }
    return Response(responseData)

  
@api_view(['POST'])
def dailyAnalysis(request):
    userId = request.data.get('id')
    weight = WeightSeializer()
    today = WeightRecord.objects.filter(date = datetime.now().date(), user = userId).exists()
    if today:
        return Response({'res': '1'})
    return Response({'res': '0'})

@api_view(['POST'])
def addWeight(request):
    userId = request.data.get('id')
    weight = request.data.get('weight')
    low = request.data.get('low')
    high = request.data.get('high')
    sleep = request.data.get('sleep')
    try:
        w = WeightRecord(user = userId, weight= weight, sleep = sleep, blood_low = low, blood_high = high)
        w.save()
        return Response({'status' : 'Success'})
    except Exception as e:
        return Response({'status' : 'Failed', 'error' : e})
    

@api_view(['POST'])
def ments(request):
    userId = request.data.get('id')
    ment = Ment.objects.all().filter(patient = userId)
    serializer = MentSerializer(ment,many=True)
    return Response(serializer.data)