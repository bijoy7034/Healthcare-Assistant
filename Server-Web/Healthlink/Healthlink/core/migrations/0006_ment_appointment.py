# Generated by Django 3.2 on 2024-03-06 19:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_alter_weightrecord_sleep'),
    ]

    operations = [
        migrations.AddField(
            model_name='ment',
            name='appointment',
            field=models.CharField(max_length=255, null=True),
        ),
    ]
