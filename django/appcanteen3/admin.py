from django.contrib import admin
from .models import *
# Register your models here.
admin.site.register(CustomUser)
# admin.site.register(AdminProfile)
admin.site.register(CanteenProfile)
admin.site.register(StudentProfile)
admin.site.register(StaffProfile)
# admin.site.register(Token)
admin.site.register(MenuList)
admin.site.register(OrderPlaced)
admin.site.register(OrderItems)
admin.site.register(RatingAndReview)
