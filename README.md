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

Each 


