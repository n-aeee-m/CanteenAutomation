from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.utils.translation import gettext_lazy as _
from django.conf import settings
from django.db.models.signals import post_delete,post_save
from django.dispatch import receiver



class CustomUser(AbstractUser):
    otp=models.CharField(max_length=20,null=True,blank=True)
    phoneno=models.CharField(max_length=20,null=True,blank=True)
    status = models.CharField(max_length=20,null=True,default='ACTIVE',blank=True)
    is_active =models.BooleanField(default=True,null=True,blank=True)
    created_at =models.DateTimeField(auto_now_add=True,null=True,blank=True)
    updates_at =models.DateTimeField(auto_now=True,null=True,blank=True)

    def __str__(self):
        return f"(PK: {self.pk}) {self.phoneno}"

# class AdminProfile(models.Model):
#     user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
#     user_type = models.CharField(max_length=50, default='admin')
#     # Add additional fields for admin profile
#     def __str__(self):
#         return self.user.username

class StudentProfile(models.Model):
    USER_TYPE_STUDENT = 'student'
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=50, default=USER_TYPE_STUDENT)
    student_admno = models.CharField(max_length=10, default='',null=True,blank=True)
    name = models.CharField(max_length=50, default='',null=True,blank=True)
    student_place = models.CharField(max_length=40, default='',null=True,blank=True)
    status = models.CharField(max_length=20,null=True,default='ACTIVE',blank=True)
    is_active =models.BooleanField(default=True,null=True,blank=True)
    created_at =models.DateTimeField(auto_now_add=True,null=True,blank=True)
    updates_at =models.DateTimeField(auto_now=True,null=True,blank=True)
    def __str__(self):
        return f"{self.name} (PK: {self.pk})"
@receiver(post_delete, sender=StudentProfile)
def delete_user(sender, instance, **kwargs):
    # Delete the associated CustomUser when a StudentProfile is deleted
    instance.user.delete()

class CanteenProfile(models.Model):
    USER_TYPE_CANTEEN = 'canteen'
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=50, default=USER_TYPE_CANTEEN)
    canteen_id = models.CharField(max_length=20, default='',null=True,blank=True)
    # canteen_id = models.ForeignKey(CustomUser,on_delete=models.CASCADE,related_name='canteen_profile_canteen',null=True,blank=False)
    canteen_name = models.CharField(max_length=50, default='',null=True,blank=True)
    canteen_place = models.CharField(max_length=50, default='',null=True,blank=True)
    status = models.CharField(max_length=20,default='ACTIVE',null=True,blank=True)
    is_active =models.BooleanField(default=True,null=True,blank=True)
    created_at =models.DateTimeField(auto_now_add=True,null=True,blank=True)
    updates_at =models.DateTimeField(auto_now=True,null=True,blank=True)

    def __str__(self):

        return f"{self.canteen_name} (PK: {self.pk})"
@receiver(post_delete, sender=CanteenProfile)
def delete_user(sender, instance, **kwargs):
    # Delete the associated CustomUser when a CanteenProfile is deleted
    instance.user.delete()
class StaffProfile(models.Model):
    USER_TYPE_STAFF = 'staff'
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=50, default=USER_TYPE_STAFF)
    staff_id = models.CharField(max_length=10,unique='True',null=True,blank=True)
    staff_name = models.CharField(max_length=50, default='',null=True,blank=True)
    staff_place = models.CharField(max_length=50, default='',null=True,blank=True)
    status = models.CharField(max_length=20,default='ACTIVE',null=True,blank=True)
    is_active =models.BooleanField(default=True,null=True,blank=True)
    created_at =models.DateTimeField(auto_now_add=True,null=True,blank=True)
    updates_at =models.DateTimeField(auto_now=True,null=True,blank=True)

    def __str__(self):
        return f"{self.staff_name} (PK: {self.pk})"
@receiver(post_delete, sender=StaffProfile)
def delete_user(sender, instance, **kwargs):
    # Delete the associated CustomUser when a StaffProfile is deleted
    instance.user.delete()


# from django.contrib.auth import get_user_model

# User = get_user_model()


class MenuList(models.Model):
    mitem_id = models.AutoField(primary_key=True)
    mitem_name = models.CharField(max_length=50)
    mcanteen_id = models.IntegerField(null=True,blank=True)
    mprice = models.FloatField()
    mdiscountprice = models.FloatField()
    mimage = models.ImageField(upload_to='media/', blank=True, null=True)
    description = models.CharField(max_length=55)
    categories = models.CharField(max_length=55)
    quantity = models.IntegerField()
    availability_status = models.BooleanField(default=True)
    mrating = models.IntegerField(default=0,null=True,blank=True)
    # Assuming it represents availability
    def __str__(self):
        return f"{self.mitem_id} - {self.mitem_name} - {self.mcanteen_id} - {self.mprice} - {self.description} -  {self.categories} -{self.quantity} - {self.availability_status}"





class OrderPlaced(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE,related_name='user_orders')
    # mcanteen_id = models.ForeignKey(CustomUser, on_delete=models.CASCADE,related_name='canteen_orders')
    mcanteen_id = models.IntegerField()

    order_id = models.CharField(max_length=40, null=False, blank=True, default='')

    total_price = models.FloatField()
    payment = models.CharField(max_length=55)
    order_status = models.CharField(max_length=55,default="undelivered")
    order_date = models.DateField()
    order_time = models.TimeField()


    # def save(self, *args, **kwargs):
    #     super().save(*args, **kwargs)
    #
    #     # Update MenuList quantity and availability status
    #     if self.orderitem:
    #         menu_item = MenuList.objects.get(mitem_id=self.orderitem.itemid)
    #         menu_item.quantity -= int(self.orderitem.itemcount)
    #         if menu_item.quantity <= 0:
    #             menu_item.availability_status = False
    #         menu_item.save()
class OrderItems(models.Model):
    order_id=models.ForeignKey(OrderPlaced,on_delete=models.CASCADE,null=True,blank=True)
    itemid = models.CharField(max_length=45)
    itemprice = models.DecimalField(max_digits=10, decimal_places=2)
    itemcount = models.IntegerField(null=True, blank=True)
    subtotal = models.FloatField()
    itemImage = models.ImageField(upload_to='orderimages/', blank=True, null=True)
    itemname = models.CharField(max_length=45, null=False, blank=True)

@receiver(post_save, sender=OrderItems)
def reduce_menu_quantity(sender, instance, created, **kwargs):
    if created:
        # Retrieve the MenuList object based on the itemid
        menu_item = MenuList.objects.get(mitem_id=instance.itemid)

        # Update the quantity
        menu_item.quantity -= instance.itemcount
        if menu_item.quantity <= 0:
            menu_item.availability_status = False
        menu_item.save()


class RatingAndReview(models.Model):  # Corrected class name
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    r_id = models.ForeignKey(CustomUser, on_delete=models.CASCADE,related_name='canteenid')
    ritem_id = models.ForeignKey(MenuList, to_field='mitem_id', on_delete=models.CASCADE)
    rating = models.FloatField()
    review = models.CharField(max_length=100)

    def save(self, *args, **kwargs):
        # Call the superclass's save method to perform the actual save operation
        super().save(*args, **kwargs)

        # After saving the rating, update the aggregate rating of the associated MenuList item
        item = self.ritem_id
        ratings = RatingAndReview.objects.filter(ritem_id=item)
        total_ratings = sum(rating.rating for rating in ratings)
        num_ratings = ratings.count()

        # Calculate the average rating, handling division by zero if there are no ratings yet
        average_rating = total_ratings / num_ratings if num_ratings > 0 else 0
        scaled_rating = (average_rating / 5) * 5
        # Update the aggregate rating of the MenuList item
        item.mrating = scaled_rating
        item.save()


 # Import your CustomUser model here

class Token(models.Model):
    key = models.CharField(max_length=50, unique=True)
    user = models.OneToOneField(
        CustomUser,
        related_name="auth_tokens",
        on_delete=models.CASCADE,
        verbose_name="user",
        unique=True,
        null=True,
        blank=True,
    )
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    session_dict = models.TextField(null=False, default="{}")

    dict_ready = False
    data_dict = None

    def __init__(self, *args, **kwargs):  # Fix the initialization method name
        self.dict_ready = False
        self.data_dict = None
        super(Token, self).__init__(*args, **kwargs)

    def generate_key(self):
        return "".join(
            random.choice(
                string.ascii_lowercase + string.digits + string.ascii_uppercase
            )
            for i in range(40)
        )

    def save(self, *args, **kwargs):
        if not self.key:
            new_key = self.generate_key()
            while type(self).objects.filter(key=new_key).exists():
                new_key = self.generate_key()
            self.key = new_key
        return super(Token, self).save(*args, **kwargs)

    def read_session(self):
        if self.session_dict == "null":
            self.data_dict = {}
        else:
            self.data_dict = json.loads(self.session_dict)
        self.dict_ready = True

    def update_session(self, tdict, save=True, clear=False):
        if not clear and not self.dict_ready:
            self.read_session()
        if clear:
            self.data_dict = tdict
            self.dict_ready = True
        else:
            for key, value in tdict.items():
                self.data_dict[key] = value
        if save:
            self.write_back()

    def set(self, key, value, save=True):
        if not self.dict_ready:
            self.read_session()
        self.data_dict[key] = value
        if save:
            self.write_back()

    def write_back(self):
        self.session_dict = json.dumps(self.data_dict)
        self.save()

    def get(self, key, default=None):
        if not self.dict_ready:
            self.read_session()
        return self.data_dict.get(key, default)

    def __str__(self):  # Fix the string representation method name
        return str(self.user) if self.user else str(self.id)


