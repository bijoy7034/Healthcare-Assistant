# Generated by Django 3.2 on 2024-03-06 18:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0002_doctors_hospitals_medical_profile_weightrecord'),
    ]

    operations = [
        migrations.CreateModel(
            name='Ment',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('patient', models.BooleanField(default=False)),
                ('doctor', models.BooleanField(default=False)),
                ('medical', models.BooleanField(default=False)),
            ],
        ),
    ]
