import re
from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from .models import *
from django.contrib.auth import password_validation
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.forms import AuthenticationForm
from django import forms
from django.contrib.auth.forms import UserChangeForm
from django.contrib.auth import authenticate

# class CustomUserUpdateForm(UserChangeForm):
#     class Meta:
#         model = CustomUser
#         fields = ['username']
#
#     def clean_username(self):
#         username = self.cleaned_data.get('username')
#         if CustomUser.objects.exclude(pk=self.instance.pk).filter(username=username).exists():
#             raise forms.ValidationError('This username is already in use. Please choose a different one.')
#         return username



# class CustomAdminCreationForm(UserCreationForm):
#     password1 = forms.CharField(
#         label=_("Password"),
#         strip=False,
#         widget=forms.PasswordInput(attrs={'autocomplete': 'new-password'}),
#         help_text=password_validation.password_validators_help_text_html(),
#     )
#     password2 = forms.CharField(
#         label=_("Password confirmation"),
#         widget=forms.PasswordInput(attrs={'autocomplete': 'new-password'}),
#         strip=False,
#         help_text=_("Enter the same password as before, for verification."),
#     )
#
#     class Meta:
#         model = CustomUser
#         fields = ['username', 'email','user_type']
#
#     def clean_username(self):
#         username = self.cleaned_data.get('username')
#         # Add your custom username validation logic here
#         if len(username) < 8:
#             raise forms.ValidationError(_("Username must be at least 8 characters long."))
#         if not any(char.isupper() for char in username):
#             raise forms.ValidationError(_("Username must include at least one uppercase letter."))
#         if not any(char.islower() for char in username):
#             raise forms.ValidationError(_("Username must include at least one lowercase letter."))
#         if not re.search(r'[!@#$%^&*(),.?":{}|<>]', username):
#             raise forms.ValidationError(_("Username must include at least one special character."))
#         return username
#
#     def clean_password2(self):
#         password1 = self.cleaned_data.get('password1')
#         password2 = self.cleaned_data.get('password2')
#         if password1 and password2 and password1 != password2:
#             raise forms.ValidationError(_("The two password fields didn't match."))
#         return password2
#
#     def save(self, commit=True):
#         print("Saving user.")
#         user = super().save(commit=False)
#         user.set_password(self.cleaned_data['password1'])
#         if commit:
#             user.save()
#         return user
#     def form_valid(self, form):
#         print(form.errors)  # Add this line to print form errors to the console
#         return super().form_valid(form)

    # def form_valid(self, form):
    #     print("Form is valid and saving user.")
    #     return super().form_valid(form)

# class CustomAdminChangeForm(UserChangeForm):
#     class Meta:
#         model = CustomAdmin
#         fields = ['username', 'email']

# class CustomAdminForm(forms.ModelForm):
#     class Meta:
#         model = CustomAdmin
#         fields = ['username', 'email', 'groups', 'user_permissions']
#
#     def __init__(self, request=None, *args, **kwargs):
#         self.request = request
#         super().__init__(*args, **kwargs)
#         # You can customize the form widgets or add additional validation here if needed



    # def form_valid(self, form):
    #     print("Form is valid and saving user.")
    #     return super().form_valid(form)

from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(max_length=255)
    password = forms.CharField(widget=forms.PasswordInput)
class StudentProfileForm(forms.ModelForm):
    custom_username = forms.CharField(max_length=50, required=True)
    custom_email = forms.EmailField(max_length=50, required=True)
    custom_phoneno = forms.CharField(max_length=50,required=True)

    class Meta:
        model = StudentProfile
        fields = ['student_admno', 'name', 'student_place']
    def clean_student_admno(self):
        student_admno = self.cleaned_data['student_admno']

        # Check if the input contains only digits
        if not student_admno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for admission number.')

        return student_admno
    def clean_name(self):
        name = self.cleaned_data['name']

        # Check if the input contains only alphabets
        if not name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the name.')

        return name
    def clean_student_place(self):
        student_place = self.cleaned_data['student_place']

        # Check if the input contains only alphabets
        if not student_place.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the student place.')

        return student_place
    def clean_custom_username(self):
        custom_username = self.cleaned_data['custom_username']
        if CustomUser.objects.filter(username=custom_username).exists():
            raise forms.ValidationError("This username is already taken. Please choose a different one.")
        return custom_username

    def clean_custom_email(self):
        custom_email = self.cleaned_data['custom_email']
        if CustomUser.objects.filter(email=custom_email).exists():
            raise forms.ValidationError("This email is already registered. Please use a different one.")
        return custom_email
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno
class StudentProfileFormUpdate(forms.ModelForm):
    # custom_email = forms.EmailField(max_length=50, required=True)
    custom_phoneno=forms.CharField(max_length=20,required=True)
    class Meta:
        model = StudentProfile
        fields = ['student_admno', 'name', 'student_place']

    def clean_student_admno(self):
        student_admno = self.cleaned_data['student_admno']

        # Check if the input contains only digits
        if not student_admno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for admission number.')

        return student_admno

    def clean_name(self):
        name = self.cleaned_data['name']

        # Check if the input contains only alphabets
        if not name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the name.')

        return name

    def clean_student_place(self):
        student_place = self.cleaned_data['student_place']

        # Check if the input contains only alphabets
        if not student_place.isalpha():
            raise ValidationError('Only alphabet characters are allowed for the student place.')

        return student_place
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno
    # def clean_custom_username(self):
    #     custom_username = self.cleaned_data['custom_username']
    #     if CustomUser.objects.filter(username=custom_username).exists():
    #         raise forms.ValidationError("This username is already taken. Please choose a different one.")
    #     return custom_username

    # def clean_custom_email(self):
    #     custom_email = self.cleaned_data['custom_email']
    #     if CustomUser.objects.filter(email=custom_email).exists():
    #         raise forms.ValidationError("This email is already registered. Please use a different one.")
    #     return custom_email
class CanteenProfileForm(forms.ModelForm):
    custom_username = forms.CharField(max_length=50, required=True)
    custom_email = forms.EmailField(max_length=50, required=True)
    custom_phoneno = forms.CharField(max_length=50, required=True)
    class Meta:
        model = CanteenProfile
        fields = ['canteen_id','canteen_name', 'canteen_place']
    def clean_canteen_name(self):
        canteen_name = self.cleaned_data['canteen_name']
        if not canteen_name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the canteen name.')
        return canteen_name
    def clean_canteen_place(self):
        canteen_place = self.cleaned_data['canteen_place']
        if not canteen_place.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the place.')
        return canteen_place

    def clean_custom_username(self):
        custom_username = self.cleaned_data['custom_username']
        if CustomUser.objects.filter(username=custom_username).exists():
            raise forms.ValidationError("This username is already taken. Please choose a different one.")
        return custom_username

    def clean_custom_email(self):
        custom_email = self.cleaned_data['custom_email']
        if CustomUser.objects.filter(email=custom_email).exists():
            raise forms.ValidationError("This email is already registered. Please use a different one.")
        return custom_email
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno
class CanteenProfileFormUpdate(forms.ModelForm):
    # custom_email = forms.EmailField(max_length=50, required=True)
    custom_phoneno = forms.CharField(max_length=20, required=True)
    class Meta:
        model = CanteenProfile
        fields = ['canteen_id','canteen_name', 'canteen_place']
    def clean_canteen_name(self):
        canteen_name = self.cleaned_data['canteen_name']
        if not canteen_name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the canteen name.')
        return canteen_name
    def clean_canteen_place(self):
        canteen_place = self.cleaned_data['canteen_place']
        if not canteen_place.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the place.')
        return canteen_place

    # def clean_custom_email(self):
    #     email = self.cleaned_data['email']
    #     if CustomUser.objects.filter(email=email).exists():
    #         raise forms.ValidationError("This email is already registered. Please use a different one.")
    #     return custom_email
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno
class StaffProfileForm(forms.ModelForm):
    custom_username = forms.CharField(max_length=50, required=True)
    custom_email = forms.EmailField(max_length=50, required=True)
    custom_phoneno = forms.CharField(max_length=50, required=True)
    class Meta:
        model = StaffProfile
        fields = ['staff_id','staff_name', 'staff_place']
    def clean_staff_id(self):
        staff_id = self.cleaned_data['staff_id']

        # Check if the input contains only digits
        if not staff_id.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for staff id.')

        return staff_id
    def clean_staff_name(self):
        staff_name = self.cleaned_data['staff_name']
        if not staff_name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the  staff name.')
        return staff_name
    def clean_staff_place(self):
        staff_place = self.cleaned_data['staff_place']
        if not staff_place.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the staff place.')
        return staff_place
    def clean_custom_username(self):
        custom_username = self.cleaned_data['custom_username']
        if CustomUser.objects.filter(username=custom_username).exists():
            raise forms.ValidationError("This username is already taken. Please choose a different one.")
        return custom_username

    def clean_custom_email(self):
        custom_email = self.cleaned_data['custom_email']
        if CustomUser.objects.filter(email=custom_email).exists():
            raise forms.ValidationError("This email is already registered. Please use a different one.")
        return custom_email
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno
class StaffProfileFormUpdate(forms.ModelForm):
    custom_phoneno = forms.CharField(max_length=20, required=True)
    # custom_email = forms.EmailField(max_length=50, required=True)
    class Meta:
        model = StaffProfile
        fields = ['staff_id','staff_name', 'staff_place']
    # def clean_staff_id(self):
    #     staff_id = self.cleaned_data['staff_id']

        # Check if the input contains only digits
        # if not staff_id.isdigit():
        #     raise forms.ValidationError('Only numeric characters are allowed for staff id.')

        # return staff_id
    def clean_staff_name(self):
        staff_name = self.cleaned_data['staff_name']
        if not staff_name.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the  staff name.')
        return staff_name
    def clean_staff_place(self):
        staff_place = self.cleaned_data['staff_place']
        if not staff_place.isalpha():
            raise forms.ValidationError('Only alphabet characters are allowed for the staff place.')
        return staff_place
    # def clean_custom_username(self):
    #     custom_username = self.cleaned_data['custom_username']
    #     if CustomUser.objects.filter(username=custom_username).exists():
    #         raise forms.ValidationError("This username is already taken. Please choose a different one.")
    #     return custom_username
    #
    # def clean_custom_email(self):
    #     custom_email = self.cleaned_data['custom_email']
    #     if CustomUser.objects.filter(email=custom_email).exists():
    #         raise forms.ValidationError("This email is already registered. Please use a different one.")
    #     return custom_email
    def clean_custom_phoneno(self):
        custom_phoneno = self.cleaned_data['custom_phoneno']

        # Check if the input contains only digits
        if not custom_phoneno.isdigit():
            raise forms.ValidationError('Only numeric characters are allowed for phone number.')

        # Check if the length of phone number is not more than 10
        if len(custom_phoneno) != 10:
            raise forms.ValidationError('Phone number should be 10 digits.')

        return custom_phoneno

class MenuListForm(forms.ModelForm):
    class Meta:
          model = MenuList
          fields = '__all__'
# from django import forms
# from django.contrib.auth.forms import AuthenticationForm, UserChangeForm
# from .models import CustomUser
# class LoginForm(AuthenticationForm):
#     class Meta:
#         model = CustomUser
#         fields = ('username', 'password')

# class CustomUserChangeForm(UserChangeForm):
#     class Meta:
#         model = CustomUser
#         fields = UserChangeForm.Meta.fields