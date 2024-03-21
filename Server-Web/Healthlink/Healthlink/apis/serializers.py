from rest_framework import serializers
from core.models import User, Medical, Profile, WeightRecord, Ment


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class MedicalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medical
        fields = '__all__'
        
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'
class WeightSeializer(serializers.ModelSerializer):
    class Meta:
        model = WeightRecord
        fields = '__all__'

class MentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ment
        fields = '__all__'