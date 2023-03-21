[<h1>Aashray</h1>](https://github.com/adarshnagrikar14/Aashray/)
![Alt Text](https://github.com/adarshnagrikar14/Aashray/blob/main/assets/images/splash_logo.png)
---
> <h3>An approach to provide a source of light to the needy people during any pandemic situation. Basically, Aashray is a sanskrit word which means a shelter. As the name suggests, our app aims to provide shelter and food for the needy people stucked in any pandemic situation. By getting real-time location of the user, the app locates a self offered Aashray or shelter or a food source provided by the volunteer who offered by their consent.
</h3>
<br>
<h1>Download direct Apk from here</h1>

https://drive.google.com/file/d/1DYj2BDKP3dEn6XW9YIKRen8BCykYVNUS/view?usp=sharing

<h1>Steps to test the app</h1>
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
