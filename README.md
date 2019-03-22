<h2> CATACLYSM 1.0 Elearning platform API</h2>
   
<b>Introduction</b>

This RESTAPI is the API i build and we are using for our learning platform. The Cataclysm API is build with Vapor and Swift and is build to accommodate all information required to start a learning platform.

<b>What does it do</b>

The API is build to accomendate learning material like videos, courses, users, blogposts and more. With this API it is really easy for you as a provider of courses or videos. Everything is able to work as parent or as a child so ordering and sorting is made really easy

<b>Models</b>

The API contains 9 usable models which can be used for displaying and storing Data into the PostgreSQL Database

- Usermodel
- BlogModel
- CourseModel
- VideoModel
- CategoryModel
- CourseSectionModel
- TokenModel
- Blog CategoryModel
- Pivot Model

UserModel is used for storing all Userinformation
Blogmodel is used for storing the Blog information
Coursemodel is used for storing all course information and is a child of the Category Model
VideoModel is used for storing the video information and is a child of the Section Model
CourseSectionModel is used for sotring section information and is the child of CategoryModel and parent of VideoModel
TokenModel is the model for creating a users Sign in Token
BlogCategoryModel is the parent of Blogmodel.
Pivot Model is for creating parent relations between different models

<b>Controller routes</b>

The API uses different routers

Users and user related content route: the /cataclysm/users 
Courses and Course related content Route: /cataclysm/courses
Course categories related content Route: /cataclysm/categories
Blog related content Route: cataclysm/blog

These are the main routes used for adding and retrieving information. 

Other routes can be found in the COntroller files

<b>CORS</b>

The API is updated with CORS settings and should not give any problem when using the API on external servers while the used website is running on another server or domain.

<b>Tested with</b>

I tested the API with LEAF templating package and i tested it with Angular 7 as well. Theoretically the API will work with all frontend packages like Angular, VueJS and React. 

I also tested the API with a IOS app and theoretically the API should work just fine using a Android or a Windows app.

<b>Running the API on a Ubuntu Server</b>

Running the API will only work on a Ubuntu server running a Ubuntu based Distro or a MacOS device. It is till now not possible to run Vapor based API's on Windows

For installing and running a Vapor application i want to share this tutorial with you
https://www.digitalocean.com/community/tutorials/how-to-install-swift-and-vapor-on-ubuntu-16-04

Good luck and have fun with this API

Sincerely

Johan



