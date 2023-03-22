[<h1>Aashray</h1>](https://github.com/adarshnagrikar14/Aashray/)
![Alt Text](https://github.com/adarshnagrikar14/Aashray/blob/main/assets/images/splash_logo.png)
---
> <h3>An approach to provide a source of light to the needy people during any pandemic situation. Basically, Aashray is a sanskrit word which means a shelter. As the name suggests, our app aims to provide shelter and food for the needy people stucked in any pandemic situation. By getting real-time location of the user, the app locates a self offered Aashray or shelter or a food source provided by the volunteer who offered by their consent.
</h3>
<br>
<h1>Download direct Apk from here</h1>

https://drive.google.com/file/d/1DYj2BDKP3dEn6XW9YIKRen8BCykYVNUS/view?usp=sharing

<h1>Steps to Run the App</h1>
<br>

1. As we assume that flutter is properly installed on the machine, please do follow the below steps to test the App.
```
Note: The App is currently built for Android only.
```
2. Git clone the project into the directory of your choice.
```
git clone https://github.com/adarshnagrikar14/Aashray.git
```
3. Change directory to Aashray
```
cd ./Aashray
```
4. We need to add the required ***Directions API key and Maps API key*** at the specified locations.
```
Read here:
i. https://developers.google.com/maps/documentation/directions/get-api-key
ii. https://developers.google.com/maps/documentation/geocoding/get-api-key
```

5. Add the Google Map API key in the ***AndriodManifest.xml*** file in android/app/src/main/AndroidManifest.xml directory on line 42
```
<meta-data android:name="com.google.android.geo.API_KEY"
            android:value="Google API key"/>
```
6. Add the Directions API key in the ***locate_aashray.dart*** file in lib/Classes/locate_aashray/locate_aashray.dart on line 32
```
final String googleAPiKey = "Directions API key";
```
7. Run the following commands to download all required dependancies.
```
flutter clean
flutter pub get
```
7. Now after doing all the necessary steps, we are ready to run the App. 
```
flutter run
```

<br>
<h1>Feature tour:</h1>
<h5>Basic 4 Functionalities are available in case of any non emergency or an emergency situation.</h5>

Default Screen | Aashray Screen
-------------- | --------------
Content from cell 1 | Content from cell 2
<img src="https://firebasestorage.googleapis.com/v0/b/app-aashray.appspot.com/o/AppScreenshots%2FScreen1.jpg?alt=media&token=7b085e23-0a36-44a8-8215-e41beefd22e3" alt = "One" width="720" height="1080"> | <img src="https://firebasestorage.googleapis.com/v0/b/app-aashray.appspot.com/o/AppScreenshots%2FScreen%20Home.jpg?alt=media&token=0cdd3e65-c02a-40a5-90c4-8ae1110f5dd1" alt = "Two" width="720" height="1080">

Food Provider Screen | Emergency Screen
-------------------- | ----------------
Content from cell 3 | Content from cell 4
<img src="https://firebasestorage.googleapis.com/v0/b/app-aashray.appspot.com/o/AppScreenshots%2FScreen%20Food.jpg?alt=media&token=c53e5626-2cff-4094-b69c-71518eb38807" alt = "Three" width="720" height="1080"> | <img src="https://firebasestorage.googleapis.com/v0/b/app-aashray.appspot.com/o/AppScreenshots%2Femergency%20screen.gif?alt=media&token=f65920cf-8d02-46f1-91ed-51c4dbde951d" alt = "Four" width="720" height="1080">

<br>
<h1>Steps to Test the App</h1>
<h5>You need to create a testing location for emergency screen</h5>
<br>
