from .forms import *
from .models import *
from .serializers import *
from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import AuthenticationForm

from django.contrib.auth.views import LoginView
from django.views.generic.edit import CreateView
from django.urls import reverse_lazy,reverse
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.forms import PasswordChangeForm
from django.shortcuts import render, get_object_or_404, redirect
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView,TemplateView,RedirectView
from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status,views
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from django.utils.crypto import get_random_string
from django.contrib.auth.hashers import make_password
from django.core.mail import send_mail
from decouple import config
from .utils import send_email_to_client
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.response import Response
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login,logout
from django.urls import reverse_lazy
from django.views.generic import RedirectView
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.views import PasswordResetView
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.http import HttpResponseBadRequest
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView,RetrieveUpdateAPIView
from rest_framework.permissions import AllowAny
from django.db.models import F
from django.db.models import F
import qrcode
from rest_framework.response import Response
from rest_framework import status
from django.views import View
from .utils import generate_qr_code
import base64
from io import BytesIO
import json
from django.http import JsonResponse
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.decorators import api_view
from rest_framework.generics import UpdateAPIView
from rest_framework.authtoken.models import Token
from io import BytesIO
import base64
import qrcode


class StudentRegistrationView(CreateView):
    model = StudentProfile
    template_name = 'student_registration1.html'
    form_class = StudentProfileForm
    success_url = reverse_lazy('admin_student')
    print("heeee")

    def form_valid(self, form):
        # Get the desired username from the form
        custom_username = form.cleaned_data["custom_username"]
        custom_email = form.cleaned_data["custom_email"]
        custom_phoneno= form.cleaned_data["custom_phoneno"]

        # custom_password = form.cleaned_data["custom_password"]

        # Create a CustomUser instance with a random password
        password = get_random_string(length=6)
        hashed_password = make_password(password)
        user = CustomUser.objects.create(username=custom_username, password=hashed_password,email=custom_email,phoneno=custom_phoneno)

        # Associate the user with the StudentProfile
        form.instance.user = user

        # Save the form and call the parent form_valid method
        response = super().form_valid(form)

        subject = 'Your Registration Details'
        message = f'Hello {custom_username},\n\nYour username is: {custom_username}\n\nYour password is: {password}\n\nThank you for registering!'
          # Replace with your email address
        send_mail(subject, message, settings.EMAIL_HOST_USER, [user.email])
        # send_mail(subject, message, from_email, [user.email])

        # Optionally, you can display the generated password to the user
        self.extra_context = {'generated_password': password}


        return response

class StudentUpdateView(UpdateView):
    model = StudentProfile
    template_name = 'student_update.html'
    form_class = StudentProfileFormUpdate
    success_url = reverse_lazy('admin_student')

    def form_valid(self, form):
        # Update the associated CustomUser's username using the 'custom_username' field
        custom_phoneno = form.cleaned_data["custom_phoneno"]
        form.instance.user.phoneno = custom_phoneno
        # Update the password if a new one is provided
        # new_password = self.request.POST.get('new_password')
        # new_username = self.request.POST.get('new_username')
        # if new_username:
        #     form.instance.user.username = new_username
        # elif new_password:
        #     form.instance.user.password = make_password(new_password)
        # custom_email = form.cleaned_data["custom_email"]
        # form.instance.user.email = custom_email
        # Save the CustomUser and the form
        form.instance.user.save()
        return super().form_valid(form)

    # def get_success_url(self):
    #     return reverse_lazy('admin_student')

class CanteenRegistrationView(CreateView):
    model = CanteenProfile
    template_name = 'canteen_registration1.html'
    form_class = CanteenProfileForm
    success_url = reverse_lazy('admin_canteen')

    def form_valid(self, form):
        # Get the desired username from the form
        custom_username = form.cleaned_data["custom_username"]
        custom_email = form.cleaned_data["custom_email"]
        custom_phoneno = form.cleaned_data["custom_phoneno"]

        # Create a CustomUser instance with a random password
        password = get_random_string(length=12)
        hashed_password = make_password(password)
        user = CustomUser.objects.create(username=custom_username, password=hashed_password,email=custom_email,phoneno=custom_phoneno)

        # Associate the user with the StudentProfile
        form.instance.user = user

        # Save the form and call the parent form_valid method
        response = super().form_valid(form)
        subject = 'Your Registration Details'
        message = f'Hello {custom_username},\n\nYour username is: {custom_username}\n\nYour password is: {password}\n\nThank you for registering!'
        # Replace with your email address
        send_mail(subject, message, settings.EMAIL_HOST_USER, [user.email])

        # Optionally, you can display the generated password to the user
        self.extra_context = {'generated_password': password}

        return response

class CanteenUpdateView(UpdateView):
    model = CanteenProfile
    template_name = 'canteen_update.html'
    form_class = CanteenProfileFormUpdate
    success_url = reverse_lazy('admin_canteen')

    def form_valid(self, form):
        # Update the associated CustomUser's username using the 'custom_username' field
        custom_phoneno = form.cleaned_data["custom_phoneno"]
        form.instance.user.phoneno = custom_phoneno
        # Update the password if a new one is provided
        # new_password = self.request.POST.get('new_password')
        # new_username = self.request.POST.get('new_username')
        # if new_username:
        #     form.instance.user.username = new_username
        # elif new_password:
        #     form.instance.user.password = make_password(new_password)
        # custom_email = form.cleaned_data["custom_email"]
        # form.instance.user.email = custom_email
        # Save the CustomUser and the form
        form.instance.user.save()
        return super().form_valid(form)

    # On
    # the
    # other
    # hand, the
    # get_success_url
    # method
    # allows
    # for more dynamic behavior.You can use this method to determine the success URL based on the current state of the view or the submitted form.It gives you the flexibility to calculate the success URL dynamically.  #
    # def get_success_url(self):
    #     return reverse_lazy('canteen_list')

class StaffRegistrationView(CreateView):
    model = StaffProfile
    template_name = 'staff_registration1.html'
    form_class = StaffProfileForm
    success_url = reverse_lazy('admin_staff')

    def form_valid(self, form):
        # Get the desired username from the form
        custom_username = form.cleaned_data["custom_username"]
        custom_email = form.cleaned_data["custom_email"]
        custom_phoneno = form.cleaned_data["custom_phoneno"]

        # Create a CustomUser instance with a random password
        password = get_random_string(length=12)
        hashed_password = make_password(password)
        user = CustomUser.objects.create(username=custom_username, password=hashed_password,email=custom_email,phoneno=custom_phoneno)

        # Associate the user with the StudentProfile
        form.instance.user = user

        # Save the form and call the parent form_valid method
        response = super().form_valid(form)
        subject = 'Your Registration Details'
        message = f'Hello {custom_username},\n\nYour username is: {custom_username}\n\nYour password is: {password}\n\nThank you for registering!'
        # Replace with your email address
        send_mail(subject, message, settings.EMAIL_HOST_USER, [user.email])

        # Optionally, you can display the generated password to the user
        self.extra_context = {'generated_password': password}

        return response

class StaffUpdateView(UpdateView):
    model = StaffProfile
    template_name = 'staff_update.html'
    form_class = StaffProfileFormUpdate
    success_url = reverse_lazy('admin_staff')

    def form_valid(self, form):
        # Update the associated CustomUser's username using the 'custom_username' field
        custom_phoneno = form.cleaned_data["custom_phoneno"]
        form.instance.user.phoneno = custom_phoneno
        # Update the password if a new one is provided
        # new_password = self.request.POST.get('new_password')
        # new_username = self.request.POST.get('new_username')
        # if new_username:
        #     form.instance.user.username = new_username
        # elif new_password:
        #     form.instance.user.password = make_password(new_password)
        # custom_email = form.cleaned_data["custom_email"]
        # form.instance.user.email = custom_email
        # Save the CustomUser and the form
        form.instance.user.save()
        return super().form_valid(form)

    # def get_success_url(self):
    #     return reverse_lazy('admin_staff')

class StudentDeleteView(DeleteView):
    model = StudentProfile
    template_name = 'student_delete.html'
    success_url = reverse_lazy('admin_student')

class CanteenDeleteView(DeleteView):
    model = CanteenProfile
    template_name = 'canteen_delete.html'
    success_url = reverse_lazy('admin_canteen')

class StaffDeleteView(DeleteView):
    model = StaffProfile
    template_name = 'staff_delete.html'
    success_url = reverse_lazy('admin_staff')

def canteen_admin_list(request):
    canteens = CanteenProfile.objects.all()
    return render(request, 'canteen_admin_list.html', {'canteens': canteens})

def canteen_orders(request, canteen_id):
    selected_canteen = CanteenProfile.objects.get(pk=canteen_id)
    orders = OrderPlaced.objects.filter(mcanteen_id=canteen_id)
    return render(request, 'canteen_orders.html', {'selected_canteen': selected_canteen, 'orders': orders})


def login_admin(request):
    form = LoginForm()

    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = authenticate(request, username=username, password=password)

            if user is not None and user.is_superuser:
                login(request, user)

                # No need to check for adminProfile for superusers
                # return render(request, 'admin_payment.html')
                return redirect('admin_payment')
            else:
                # Handle invalid login credentials
                return render(request, 'login2.html', {'form': form, 'error': 'Invalid login credentials'})

    return render(request, 'login2.html', {'form': form})


from django.contrib.auth.decorators import user_passes_test


def logout_admin(request):
    logout(request)
    return redirect('loginadmin')

class MenuListView(generics.ListCreateAPIView):
    # print(request.data)
    queryset = MenuList.objects.all()

    serializer_class = MenuListSerializer

    authentication_classes = []
    permission_classes = [AllowAny]

    def perform_create(self, serializer):
            print("Data being entered:", self.request.data)
            serializer.save()


class MenuListViewByMitemid(generics.ListCreateAPIView):
    queryset = MenuList.objects.all()


    serializer_class = MenuListSerializer
    authentication_classes = []
    permission_classes = [AllowAny]
    # print(data)
    def get_queryset(self):
        mitem_id = self.kwargs.get('data')  # Retrieve the mitem_id from kwargs
        queryset = MenuList.objects.all()
        if mitem_id is not None:
            queryset = queryset.filter(mitem_id=mitem_id)
        return queryset
class CanteenMenuListViewByMitemid(generics.RetrieveUpdateDestroyAPIView):
    queryset = MenuList.objects.all()
    serializer_class = MenuListSerializer1
    authentication_classes = []
    permission_classes = [AllowAny]

    def get_queryset(self):

        mitem_id = self.kwargs.get('data')  # Retrieve the mitem_id from kwargs
        print("Incoming data - mitem_id:", mitem_id)
        queryset = MenuList.objects.all()

        if mitem_id is not None:
            queryset = queryset.filter(mitem_id=mitem_id)
        return queryset
class MenuListCategoryView(generics.ListCreateAPIView):
    serializer_class = MenuListSerializer
    authentication_classes = []
    permission_classes = [AllowAny]

    def get_queryset(self):
        category = self.request.query_params.get('category')  # Assuming the category is passed as a query parameter
        queryset = MenuList.objects.all()
        if category:
            queryset = queryset.filter(categories=category)
        return queryset

class MenuItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = MenuList.objects.all()
    serializer_class = MenuListSerializer
    authentication_classes = []
    permission_classes = [AllowAny]

class MenuListByCanteenView(generics.ListCreateAPIView):
    serializer_class = MenuListSerializer

    def get_queryset(self):
        canteen_id = self.kwargs['canteen_id']
        return MenuList.objects.filter(mcanteen_id=canteen_id)

class MenuListByCanteenDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = MenuListSerializer

    def get_queryset(self):
        canteen_id = self.kwargs['canteen_id']
        return MenuList.objects.filter(mcanteen_id=canteen_id)

    def get_object(self):
        queryset = self.get_queryset()
        obj = generics.get_object_or_404(queryset, pk=self.kwargs['pk'])
        self.check_object_permissions(self.request, obj)
        return obj
#


class RatingAndReviewListView(APIView):
    authentication_classes = []  # No authentication required for this endpoint
    permission_classes = [AllowAny]  # Allow any user to access this endpoint

    def get(self, request):
        # Retrieve all RatingAndReview objects
        ratings_and_reviews = RatingAndReview.objects.all()
        serializer = RatingAndReviewSerializer(ratings_and_reviews, many=True)
        return Response(serializer.data)

    def post(self, request):
        # Create a new RatingAndReview object based on the provided data
        print(request.data)
        serializer = RatingAndReviewSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # Save the new RatingAndReview object
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class RatingAndReviewDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = RatingAndReview.objects.all()
    serializer_class = RatingAndReviewSerializer
    authentication_classes = []
    permission_classes = [AllowAny]

CustomUser = get_user_model()

class PasswordChangeView(UpdateAPIView):
    serializer_class = PasswordChangeSerializer
    # permission_classes = [IsAuthenticated]
    permission_classes = [AllowAny]
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


class CustomLoginView(TokenObtainPairView):
    """
    Custom login view that includes additional information about the user's profile type.
    """
    serializer_class = TokenObtainPairSerializer  # Using TokenObtainPairSerializer by default

    def post(self, request, *args, **kwargs):
        # Custom authentication and token generation logic
        serializer = self.get_serializer(data=request.data)
        username = request.data.get('username')
        password = request.data.get('password')
        print(username)
        print(password)

        # Authenticating the user
        user = authenticate(username=username, password=password)

        if user is None:
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        # If the user is authenticated, generate the tokens
        tokens_data = serializer.validate(request.data)
        token = Token.objects.create(user=user, key=tokens_data['access'])
        # Add additional information based on the user's profile type
        user_profile = None
        if hasattr(user, 'studentprofile'):
            user_profile = user.studentprofile
        if hasattr(user, 'canteenprofile'):
            user_profile = user.canteenprofile
        if hasattr(user, 'staffprofile'):
            user_profile = user.staffprofile

        response_data = {
            'access': str(tokens_data['access']),
            'refresh': str(tokens_data['refresh']),
            'user_type': user_profile.user_type if user_profile else None,
            'username':user.username if user.username else None,
            'email':user.email if user.email else None,
            'user_id':user.id
        }

        return Response(response_data, status=status.HTTP_200_OK)


class CustomUserUpdateView(RetrieveUpdateAPIView):
    serializer_class = CustomUserUpdateSerializer
    queryset = CustomUser.objects.all()
    permission_classes = [AllowAny]
    # based on currently authenticated user
    # def get_object(self):
    #     return self.request.user
    def get_object(self):
        pk = self.kwargs.get('pk')
        return CustomUser.objects.get(pk=pk)
class Admin_canteenview(ListView):
    model = CanteenProfile
    template_name = "admin_canteen.html"
    context_object_name = 'canteens'
class Admin_staffview(ListView):
    model = StaffProfile
    template_name = "admin_staff.html"
    context_object_name = 'staffs'

class Admin_studentview(ListView):
    model = StudentProfile
    template_name = "admin_student.html"
    context_object_name = 'students'

class Admin_paymentview(View):
    def get(self,request):
        payment=OrderPlaced.objects.all()
        return render(request,'admin_payment.html',{'payments':payment})







class CustomLogoutView(APIView):
    """
    Custom logout view to delete the user's token.
    permission_classes = [AllowAny]
    """
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        # Get the user's token
        token = request.data.get('token')


        # Check if the token exists
        if not token:
            return Response({"error": "Token is required"}, status=status.HTTP_400_BAD_REQUEST)

        # Try to get the token instance
        try:
            token_obj = Token.objects.get(key=token)
        except Token.DoesNotExist:
            return Response({"error": "Invalid token"}, status=status.HTTP_404_NOT_FOUND)

        # Delete the token
        token_obj.delete()

        return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)



User = get_user_model()


class ForgotPasswordAPIView(views.APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        if serializer.is_valid():
            # username = serializer.validated_data['username']
            email = serializer.validated_data['email']
            print(email)
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

            # Generate OTP
            otp = get_random_string(length=4, allowed_chars='0123456789')

            # Save OTP to user model (you may need to add a field for this)
            user.otp = otp
            user.save()

            # Send OTP through email
            send_mail(
                'Forgot Password OTP',
                f'Canteen Management System Your OTP is: {otp}',
                'from@example.com',
                [email],
                fail_silently=False,
            )

            return Response({'detail': 'OTP sent successfully.'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

User = get_user_model()

class PasswordChangeAPIView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = PasswordChangeSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            new_password = serializer.validated_data['new_password']

            # Check if the user exists and OTP is valid
            try:
                user = User.objects.get(email=email, otp=otp)
            except User.DoesNotExist:
                return Response({'error': 'Invalid user ID or OTP'}, status=status.HTTP_400_BAD_REQUEST)

            # Change the password
            user.set_password(new_password)
            user.save()

            return Response({'message': 'Password changed successfully'}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)









class OrderPlacedCreateAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        # Extract data from request
        order_date = request.data.get('order_date')
        order_time = request.data.get('order_time')
        order_id = request.data.get('order_id')
        mcanteen_id = request.data.get('mcanteen_id')
        user_id = request.data.get('user')
        payment = request.data.get('payment')
        total_price = request.data.get('total_price')

        # Extract orderitem_data
        orderitem_data = request.data.get('orderitem')
        print(request.data.get('orderitem'))

        order_placed = OrderPlaced.objects.create(
            order_date=order_date,
            order_time=order_time,
            order_id=order_id,
            mcanteen_id=int(mcanteen_id),
            user_id=user_id,
            payment=payment,
            total_price=total_price
        )
        qr_data = f"{order_id}"
        qr = qrcode.make(qr_data)
        qr_image = qr.get_image()
        buffer = BytesIO()
        qr_code_path = f"media/qrcodes/order_qr_code_{order_id}.png"
        qr.save(qr_code_path)
        qr_image.save(buffer, format="PNG")
        qr_image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")

        try:
            orderitem_data = json.loads(orderitem_data)
        except json.JSONDecodeError:
            return Response({"message": "Invalid orderitem data format"}, status=status.HTTP_400_BAD_REQUEST)

        # Create OrderItems instances and associate them with OrderPlaced
        for item_data in orderitem_data:
            print(orderitem_data)
            # image_data = item_data.get('image', '')
            #
            # # Check if image data exists
            # if image_data:
            #     # Decode base64 image data
            #     image_data = base64.b64decode(image_data)
            #
            #     # Save image to a FileField
            #     image_name = f"item_image_{order_id}.png"  # Unique filename
            #     item_image = OrderItems.itemImage.field.upload_to(None, image_name)
            #     with open(item_image, 'wb') as f:
            #         f.write(image_data)
            # else:
            #     item_image = None

            c = OrderItems.objects.create(
                order_id=order_placed,
                itemid=int(item_data.get('itemid')),
                itemprice=item_data.get('itemprice'),
                itemcount=item_data.get('itemcount'),
                subtotal=item_data.get('subtotal'),
                itemImage=item_data.get('image'),
                itemname=item_data.get('name')
            )

        return Response({"message": "Data saved successfully","qrcode":qr_image_base64}, status=status.HTTP_201_CREATED)



class UpdateOrderStatusAPIView(APIView):
    permission_classes = [AllowAny]
    def put(self, request, order_id, *args, **kwargs):
        try:
            order = OrderPlaced.objects.get(order_id=order_id)
        except OrderPlaced.DoesNotExist:
            return Response({"error": "Order not found"}, status=status.HTTP_404_NOT_FOUND)

        # Update the order_status based on request data
        serializer = OrderStatusPlacedSerializer(order, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CanteenUserOrdersAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, order_id):
        orders = OrderPlaced.objects.filter(order_id=order_id).all()
        response_data = []

        for order in orders:
             # Define with default value

            order_data = {
                "order_id": order.order_id,
                "order_date": order.order_date,
                "order_status":order.order_status,
                "total_price": order.total_price,
                "orderitems": []
            }

            order_items = OrderItems.objects.filter(order_id=order)
            for item in order_items:
                order_item_data = {
                    "itemid": item.itemid,
                    "itemname": item.itemname,
                    "itemcount": item.itemcount,
                    "itemprice": item.itemprice,
                    "itemImage": str(item.itemImage) if item.itemImage else ""

                }
                order_data["orderitems"].append(order_item_data)

            response_data.append(order_data)

        return Response(response_data)



class UserOrdersAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, user_id):
        orders = OrderPlaced.objects.filter(user_id=user_id).all()
        response_data = []

        for order in orders:
            qr_image_base64 = ""  # Define with default value

            if order.order_status != "delivered":
                qr_data = f"Order ID: {order.order_id}"  # Note: should this be order.order_id?
                qr = qrcode.make(qr_data)
                qr_image = qr.get_image()
                buffer = BytesIO()
                qr_image.save(buffer, format="PNG")  # Save image to buffer
                qr_image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")
            order_data = {
                "order_id": order.order_id,
                "mcanteen_id":order.mcanteen_id,
                "order_date": order.order_date,
                "order_status":order.order_status,
                "total_price": order.total_price,
                "qrcode": qr_image_base64,
                "orderitems": []
            }

            order_items = OrderItems.objects.filter(order_id=order)
            for item in order_items:
                order_item_data = {
                    "itemid": item.itemid,
                    "mcanteen_id": order.mcanteen_id,
                    "itemname": item.itemname,
                    "itemcount": item.itemcount,
                    "itemprice": item.itemprice,
                    "itemImage": str(item.itemImage) if item.itemImage else ""
                }
                order_data["orderitems"].append(order_item_data)

            response_data.append(order_data)

        return Response(response_data)

class CanteenOrdersAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, mcanteen_id):
        orders = OrderPlaced.objects.filter(mcanteen_id=mcanteen_id).all()
        response_data = []

        for order in orders:
            qr_image_base64 = ""  # Define with default value
            if order.order_status != "delivered":
                qr_data = f"Order ID: {order.order_id}"  # Note: should this be order.order_id?
                qr = qrcode.make(qr_data)
                qr_image = qr.get_image()
                buffer = BytesIO()
                qr_image.save(buffer, format="PNG")  # Save image to buffer
                qr_image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")
            order_data = {
                "order_id": order.order_id,
                "order_date": order.order_date,
                "order_status":order.order_status,
                "total_price": order.total_price,
                "qrcode": qr_image_base64,
                "orderitems": []
            }

            order_items = OrderItems.objects.filter(order_id=order)
            for item in order_items:
                order_item_data = {
                    "itemid": item.itemid,
                    "itemname": item.itemname,
                    "itemcount": item.itemcount,
                    "itemprice": item.itemprice,
                    "itemImage": str(item.itemImage) if item.itemImage else ""
                }
                order_data["orderitems"].append(order_item_data)

            response_data.append(order_data)

        return Response(response_data)



class OrderListAPIView(APIView):
    def get(self, request, user_id):
        # Retrieve orders based on the user_id
        orders = OrderPlaced.objects.filter(user_id=user_id)
        order_data = []
        for order in orders:
            # Serialize each order
            order_serializer = OrderPlacedSerializer(order)

            # Serialize order items for the current order
            order_items = OrderItems.objects.filter(orderitem=order)
            order_items_data = OrderItemsSerializer(order_items, many=True).data

            # Append order data along with order items to the list
            order_data.append({
                "order": order_serializer.data,
                "order_items": order_items_data
            })

        return Response(order_data)
class UserOrdersMonthDayAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, year, month, canteen_id):
        orders = OrderPlaced.objects.filter(order_date__year=year, order_date__month=month, mcanteen_id=canteen_id)
        response_data = []
        totalexpenditure = 0
        for order in orders:
            totalexpenditure += order.total_price
            # qr_image_base64 = ""
            # if order.order_status != "delivered":
            #     qr_data = f"Order ID: {order.order_id}"
            #     qr = qrcode.make(qr_data)
            #     qr_image = qr.get_image()
            #     buffer = BytesIO()
            #     qr_image.save(buffer, format="PNG")
            #     qr_image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")

            order_data = {
                "order_id": order.order_id,
                "order_date": order.order_date,
                "order_status": order.order_status,
                "total_price": order.total_price,
                # "qrcode": qr_image_base64,
                "orderitems": []
            }

            order_items = OrderItems.objects.filter(order_id=order)
            for item in order_items:
                order_item_data = {
                    "itemid": item.itemid,
                    "itemname": item.itemname,
                    "itemcount": item.itemcount,
                    "itemprice": item.itemprice,
                    "itemImage": str(item.itemImage) if item.itemImage else ""
                }
                order_data["orderitems"].append(order_item_data)

            response_data.append(order_data)

        response_data = {"totalexpenditure": float(totalexpenditure),"items": response_data}
        return Response(response_data)
