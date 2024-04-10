from django.core.mail import send_mail
from django.conf import settings

def send_email_to_client():
    subject="this"
    message="hello"
    from_email=settings.EMAIL_HOST_USER
    recipient_list=[sharafu769@gmail.com]
    send_mail(subject,message,from_email,recipient_list)
# utils.py
import qrcode

def generate_qr_code(data):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    return img
