// Example arrays
const is_Teaching = ["CFAC"];
const Student_Roles = ["ASTU", "FSTU", "CSTU", "PSTU", "XSTU"];
const Staff_Roles = ["BAFF", "EAFF", "CEMP","SEMP"];
function areKeywordsInArray(keywords, array) {
    // return keywords.every(keyword => array.includes(keyword));
    return array.some(word => keywords.includes(word))
}

// Function to check the presence of keywords in array1, array2, or both
function checkKeywordPresence(keywords, array1, array2, array3) {
    switch (true) {
        case areKeywordsInArray(keywords, array1) && areKeywordsInArray(keywords, array2):
            console.log(`All keywords "${keywords}" are present in both array1 and array2.`);
             console.log("Keyword matched STAFF and STUDENT array with: "+keyword);
               alert('values indicate student and employee');
                // Add your code here to handle the event for array2
            $Address_Block.$visible = true;
            $Staff_Address.$load();
            $Personal.$load();
            $Advisor_Information.$visible = false;

            $Student_Block.$visible = false;
            $Courses_Block.$visible = false;
            $Faculty_Block.$visible = false;

            break;
        case areKeywordsInArray(keywords, array1):
            console.log(`All keywords "${keywords}" are present in array1.`);
            // Keyword matched words in array2
            console.log("Keyword matched STAFF array with:");
            alert('values indicate employee');
            // Add your code here to handle the event for array2
        $Address_Block.$visible = true;
        $Staff_Address.$load();
        $Personal.$load();
        $Advisor_Information.$visible = false;

        $Student_Block.$visible = false;
        $Courses_Block.$visible = false;
        $Faculty_Block.$visible = false;

        $Grad_Admission_Block.$visible = false;

        $Undergrad_Admission_Block.$visible = false;

        document.getElementById('pbid-Undergrad_Admission_Block').style.display = 'none';

        document.getElementById('pbid-Grad_Admission_Block').style.display = 'none';

        document.getElementById('pbid-Advisor_Information').style.display = 'none';

        document.getElementById('pbid-Student_Block').style.display = 'none';
        document.getElementById('pbid-Faculty_Block').style.display = 'none';
        document.getElementById('pbid-Courses_Block').style.display = 'none';



            break;
        case areKeywordsInArray(keywords, array2):
            console.log(`All keywords "${keywords}" are present in array2.`);
             // Keyword matched words in array1
                console.log("Keyword matched STUDENT array with: "+keyword);
                alert('values indicate student');
                // Add your code here to handle the event for array1
            $Address_Block.$visible = true;
            $Student_Address.$load();
            $Personal.$load();
            $Courses_Block.$visible = true;
            $Student_Block.$visible = true;
            $Advisor_Information.$visible = true;
            $Current_Courses_Taken.$load();
            $Faculty_Block.$visible = false;
            $Staff_Address.$visible = false;
            document.getElementById('pbid-Faculty_Block').style.display = 'none';
            document.getElementById('pbid-Staff_Address').style.display = 'none';
          

            break;
        case areKeywordsInArray(keywords, array3):
            console.log(`All keywords "${keywords}" are present in array2.`);
            // Keyword matched words in array3
                console.log("Keyword matched is_Teaching array with:"+keyword);
                alert('values indicate FACULTY');
                // Add your code here to handle the event for array2
            alert('CFAC found');
            $Address_Block.$visible = true;
            $Staff_Address.$load();
            $Personal.$load();

            $Student_Block.$visible = false;
            $Courses_Block.$visible = true;
            $Faculty_Block.$visible = true;
            $Current_Courses_Teaching.$load();
            document.getElementById('pbid-Student_Block').style.display = 'none';
            document.getElementById('pbid-Student_Address').style.display = 'none';
            document.getElementById('pbid-Advisor_information').style.display = 'none';
            document.getElementById('pbid-Current_Courses_Taken').style.display = 'none';
            /*
            document.getElementById('pbid-Undergrad_Admission_Block').style.display = 'none';
            document.getElementById('pbid-Grad_Admission_Block').style.display = 'none';
            */

            break;
        default:
            console.log(`Keywords "${keywords}" are not present in array1 or array2 or array3.`);
    }
}

// Test cases
checkKeywordPresence(["$P_Roles"], Staff_Roles, Student_Roles, is_Teaching);
// checkKeywordPresence(["$P_Roles"], array1, array2);
// checkKeywordPresence(["$P_Roles"], array1, array2);
// checkKeywordPresence(["$P_Roles"], array1, array2);



$(document).ready(function() {
  $("#pbid-ID_Text_Field").keypress(function(event) {
    if (event.which === 13) { // Check if the Enter key is pressed (keyCode 13)
      $("#pbid-Submit").click(); // Trigger a click event on the search button
    }
  });

  $("#searchButton").click(function() {
    // Your search button click event code here
    alert("Search button clicked!");
  });
});



function handleRowClick() {

for (var i = 0; i < $Current_Courses_TakenDS.data.length; i++){
     $Current_Courses_TakenDS.data[i].Subject  = '(' + i + ') Data Origin Testing';
    console.log('SETTING (' + i + ') Data Origin Testing');
  }
}
console.log("Attempting to populate modal dialog from grid selection click");
   // var Subj_Code = currentSelection.SSBSECT_SUBJ_CODE;
   
//document.getElementById('pbid-subject').value =currentSelection.SSBSECT_SUBJ_CODE;
//console.log('value for term code: ' + currentSelection.SSBSECT_SUBJ_CODE);


























































console.log("+++++ Education Level Code: On Load");
console.log('ED LOOK UP P-ROLE: ' + $P_Roles);

//let code = $Education_Level_Lookup.SARADAP_LEVL_CODE;
var is_Teaching = ["CFAC","BAFF", "EAFF"];
var Student_Roles = ["ASTU", "FSTU", "CSTU", "PSTU", "XSTU"];
var Staff_Roles = ["CEMP","SEMP"];

var isKeywordInArray = is_Teaching.includes($P_Roles);

 if( typeof $Education_Level_Lookup!== 'undefined'){  console.log("Data: " + 
$Education_Level_Lookup.SARADAP_LEVL_CODE);
let code = $Education_Level_Lookup.SARADAP_LEVL_CODE;

switch (code){
case 'G':            
$Courses_Block.$visible = true;
$Faculty_Block.$visible = true;

            $Current_Courses_Teaching.$load();
//$Faculty_Block.$visible = false;

$Student_Block.$visible = true;
$Advisor_Information.$visible = true;

                        
$Undergrad_Admission_Block.$visible = false;
//document.getElementById('pbid-Undergrad_Admission_Block').style.display = 'none';

$Grad_Admission_Block.$visible = true;
$Registration_Block.$visible = true;
$Registration_Status.$load();

$G_Current_Student_Information.$load();

$Current_Courses_Taken.$load();
break;

case 'U':

$Faculty_Block.$visible = false;

$Student_Block.$visible = true;
$Advisor_Information.$visible = true;
                        
$Grad_Admission_Block.$visible = false;
//document.getElementById('pbid-Grad_Admission_Block').style.display = 'none';

$Courses_Block.$visible = true;

$Current_Courses_Taken.$load();
$Registration_Block.$visible = true;
$Registration_Status.$load();

$Undergrad_Admission_Block.$visible = true;
$U_Current_Student_Information.$load();

break;

}
else {

if (isKeywordInArray){

console.log('ED LOOK UP P-ROLE: ' + $P_Roles);


$Registration_Block.$visible = false;

$Undergrad_Admission_Block.$visible = false;


$Grad_Admission_Block.$visible = false;

$Address_Block.$visible = true;
$Advisor_Information.$visible = false;
             
            document.getElementById('pbid-Advisor_Information').style.display = 'none';
            $Courses_Block.$visible = true; 
            $Current_Courses_Teaching.$load();
            $Faculty_Block.$visible = true;
            document.getElementById('pbid-Faculty_Block').style.display = 'block';
            
           $Student_Block.$visible = false;
           document.getElementById('pbid-Student_Block').style.display = 'none';
}
else {

            $Address_Block.$visible = true;
            $Registration_Block.$visible = false;

$Undergrad_Admission_Block.$visible = false;


$Grad_Admission_Block.$visible = false;

            $Advisor_Information.$visible = false;
             
            document.getElementById('pbid-Advisor_Information').style.display = 'none';
            $Courses_Block.$visible = false; 
            $Faculty_Block.$visible = false;
            document.getElementById('pbid-Faculty_Block').style.display = 'none';
            
           $Student_Block.$visible = false;
           document.getElementById('pbid-Student_Block').style.display = 'none';


}
}
}
