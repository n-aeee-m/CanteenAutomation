# Generated by Django 5.0.3 on 2024-03-14 10:14

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('appcanteen3', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='ratingandreview',
            name='r_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='canteenid', to=settings.AUTH_USER_MODEL),
        ),
    ]
