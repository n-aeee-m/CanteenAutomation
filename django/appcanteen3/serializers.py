from rest_framework import serializers
from .models import *
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers
from .models import StudentProfile, CanteenProfile


class StudentProfileLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
class MenuListSerializer(serializers.ModelSerializer):
    class Meta:
        model = MenuList
        fields = '__all__'
class MenuListSerializer1(serializers.ModelSerializer):
    class Meta:
        model = MenuList
        fields = ['mitem_id','mitem_name','mcanteen_id','mprice','mdiscountprice','mimage','categories','quantity','availability_status']
class OrderPlacedSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderPlaced
        fields = '__all__'

class RatingAndReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = RatingAndReview
        fields = '__all__'


class PasswordChangeSerializer(serializers.Serializer):
    email = serializers.CharField()
    otp = serializers.CharField()
    new_password = serializers.CharField()

class StudentProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentProfile
        fields = '__all__'

class CanteenProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = CanteenProfile
        fields = '__all__'

class StaffProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = StaffProfile
        fields = '__all__'

from rest_framework.generics import UpdateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password

from .serializers import PasswordChangeSerializer, StudentProfileSerializer, CanteenProfileSerializer

CustomUser = get_user_model()

class PasswordChangeView(UpdateAPIView):
    serializer_class = PasswordChangeSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            old_password = serializer.validated_data.get('old_password')
            new_password = serializer.validated_data.get('new_password')

            if not instance.check_password(old_password):
                return Response({'detail': 'Old password is incorrect.'}, status=status.HTTP_400_BAD_REQUEST)

            instance.set_password(new_password)
            instance.save()
            return Response({'detail': 'Password successfully changed.'}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class StudentProfileView(UpdateAPIView):
    queryset = StudentProfile.objects.all()
    serializer_class = StudentProfileSerializer
    permission_classes = [IsAuthenticated]

class CanteenProfileView(UpdateAPIView):
    queryset = CanteenProfile.objects.all()
    serializer_class = CanteenProfileSerializer
    permission_classes = [IsAuthenticated]

class StaffProfileView(UpdateAPIView):
    queryset = StaffProfile.objects.all()
    serializer_class = StaffProfileSerializer
    permission_classes = [IsAuthenticated]

#
# class OrderPlacedSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = OrderPlaced
#         fields = '__all__'
# serializers.py
from rest_framework import serializers
from django.contrib.auth import authenticate
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class CustomTokenObtainSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)

        # The access token is directly available in the validated_data
        access_token = data['access']

        data['access'] = str(access_token)
        data['refresh'] = str(data['refresh'])
        data['user'] = self.user

        return data


#profile updationupdation
class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['username', 'password']
        extra_kwargs = {'password': {'write_only': True}}




class CustomUserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        # model= CustomUser
        # fields = ['username', 'password']
        fields = ['password']

        extra_kwargs = {
            'password': {'write_only': True},
        }

    def update(self, instance, validated_data):
        # instance.username = validated_data.get('username', instance.username)
        instance.set_password(validated_data.get('password', instance.password))
        instance.save()
        return instance
from rest_framework import serializers


from rest_framework import serializers

from rest_framework import serializers

# class OrderItemSerializer(serializers.Serializer):
#     item_id = serializers.IntegerField(source='itemid')
#     item_price = serializers.FloatField(source='itemPrice')
#     quantity = serializers.IntegerField(source='itemcount')
#     total_price = serializers.FloatField(source='subtotal')
#     image = serializers.URLField(source='itemImage')
#     name = serializers.CharField(source='itemname')
class OrderItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItems
        fields = ['itemImage', 'itemname','itemcount', 'itemid', 'itemprice', 'subtotal']
class MySerializer(serializers.ModelSerializer):
    orderitem = OrderItemsSerializer(many=True)
    class Meta:
        model=OrderPlaced
        fields=['order_date','order_time','order_id','user','mcanteen_id','payment','total_price','orderitem']

    def create(self, validated_data):
        orderitems_data = validated_data.pop('orderitem')
        order_placed_instance = OrderPlaced.objects.create(**validated_data)
        return order_placed_instance
class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = '__all__'

class OrderUserPlacedSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderPlaced
        fields = '__all__'

class OrderUserItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItems
        fields = '__all__'

class OrderItemsSerializer1(serializers.ModelSerializer):
    class Meta:
        model = OrderItems
        fields = ['itemImage', 'itemname','itemcount', 'itemid', 'itemprice', 'subtotal']
class MySerializer1(serializers.ModelSerializer):
    orderitem = OrderItemsSerializer1(many=True)
    class Meta:
        model=OrderPlaced
        fields=['order_date','order_time','order_id','user','mcanteen_id','payment','total_price','orderitem']

class ForgotPasswordSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    class Meta:
        model=CustomUser
        fields=['email']

class OrderPlacedSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderPlaced
        fields = '__all__'

class OrderStatusPlacedSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderPlaced
        fields = ['order_status']
