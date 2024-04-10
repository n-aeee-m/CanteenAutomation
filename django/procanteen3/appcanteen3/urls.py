from django.urls import path,include
from .views import *
from django.contrib.auth.views import LoginView, LogoutView
from django.urls import path, include
from rest_framework.routers import DefaultRouter
# from appcanteen.views import ProductViewSet, CartItemViewSet, CartViewSet
# from .views import CartItemViewSet, CartViewSet
from django.contrib.auth.views import LoginView




urlpatterns = [
    path('canteen/register/', CanteenRegistrationView.as_view(), name='canteen_register'),

    path('canteen/<int:pk>/update/', CanteenUpdateView.as_view(), name='canteen_update'),
    path('canteen/<int:pk>/delete/', CanteenDeleteView.as_view(), name='canteen_delete'),
    path('staff/register/', StaffRegistrationView.as_view(), name='staff_register'),

    path('staff/<int:pk>/update/', StaffUpdateView.as_view(), name='staff_update'),
    path('staff/<int:pk>/delete/', StaffDeleteView.as_view(), name='staff_delete'),
    path('student/register/', StudentRegistrationView.as_view(), name='student_register'),

    path('student/<int:pk>/update/', StudentUpdateView.as_view(), name='student_update'),
    path('student/<int:pk>/delete/', StudentDeleteView.as_view(), name='student_delete'),

    path('canteen_admin_list/', canteen_admin_list, name='canteen_admin_list'),
    path('canteen_orders/<int:canteen_id>/', canteen_orders, name='canteen_orders'),
    # Add other URL patterns as needed


    path('', login_admin, name='loginadmin'),  # Regular login view
    #api login
    path('api_login/', CustomLoginView.as_view(), name='api-login'),
    path('api_logout/', CustomLogoutView.as_view(), name='api-logout'),
    path('logout/', logout_admin, name='logoutadmin'),
    path('forgotpassword/',ForgotPasswordAPIView.as_view(), name='api-forgotpassword'),
    path('changepassword/',PasswordChangeAPIView.as_view(), name='changepassword'),

    #add items to menulist
    path('menu/', MenuListView.as_view(), name='menu-list'),
    #menulistby item id
    path('menuitembyitemid/<int:data>', MenuListViewByMitemid.as_view(), name='menu-list-itemid'),
    #menulistby item id for canteen
    path('canteenmenuitembyitemid/<int:pk>', CanteenMenuListViewByMitemid.as_view(), name='menu-list-itemid'),
    #menu listby category
    path('menu/<str:data>/',MenuListCategoryView.as_view(),name='menu-list-category'),
    # update items of menulist by giving canteen id as intpk
    path('menu/<int:pk>/', MenuItemDetailView.as_view(), name='menu-detail'),
    #menu list by canteen
    path('menu/canteen/<int:canteen_id>/', MenuListByCanteenView.as_view(), name='menu-list-by-canteen'),
    #menu update by canteen id
    path('menu/canteen/<int:canteen_id>/<int:pk>/', MenuListByCanteenDetailView.as_view(), name='menu-detail-by-canteen'),




    #add reviews
    path('reviews/', RatingAndReviewListView.as_view(), name='review-list'),
    #update review
    path('reviews/<int:pk>/', RatingAndReviewDetailView.as_view(), name='review-detail'),
    path('password/change/', PasswordChangeView.as_view(), name='password-change'),








    #update password using user id
    path('update-user/<int:pk>/', CustomUserUpdateView.as_view(), name='update-user'),
    path('admin_canteen/',Admin_canteenview.as_view(),name='admin_canteen'),
    path('admin_staff/',Admin_staffview.as_view(),name='admin_staff'),
    path('admin_student/',Admin_studentview.as_view(),name='admin_student'),
    path('admin_payment/', Admin_paymentview.as_view(), name='admin_payment'),

    #update order status by passing order_id
    path('update-order-status/<str:order_id>/', UpdateOrderStatusAPIView.as_view(), name='update-order-status'),
    #orderplaced
    path('myendpoint/', OrderPlacedCreateAPIView.as_view(), name='my-view'),

    # orderplacednyuser
    path('orders/<int:user_id>',UserOrdersAPIView.as_view(), name='order-placed-by-user'),
    # orderplacedtocanteen
    path('canteenorders/<str:mcanteen_id>', CanteenOrdersAPIView.as_view(), name='order-placed-to-canteen'),
    #api to get orderdetails by order_id
    path('orderid/<int:order_id>',CanteenUserOrdersAPIView.as_view(), name='order-placed-by-orderid'),
    #view orders based on month day year by canteen_id
    path('orderspermonthperday/<int:year>/<int:month>/<int:canteen_id>/',UserOrdersMonthDayAPIView.as_view(), name='order-placed-by-perday-canteenid'),
]

