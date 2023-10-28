window.fbAsyncInit = function () {
  // FB JavaScript SDK configuration and setup
  FB.init({
    appId: "778357969950048", // FB App ID
    cookie: true, // enable cookies to allow the server to access the session
    xfbml: true, // parse social plugins on this page
    version: "v3.2", // use graph api version 2.8
  });
  document.getElementById("FBLogout").style.display = "none";

  // Check whether the user already logged in
  FB.getLoginStatus(function (response) {
    if (response.status === "connected") {
      //display user data
      getFbUserData();
    }
  });
};

// Load the JavaScript SDK asynchronously
(function (d, s, id) {
  var js,
    fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s);
  js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
})(document, "script", "facebook-jssdk");

// Facebook login with JavaScript SDK
function fbLogin() {
  FB.login(
    function (response) {
      if (response.authResponse) {
        // Get and display the user profile data
        getFbUserData();
      } else {
        document.getElementById("status").innerHTML =
          "User cancelled login or did not fully authorize.";
      }
    },
    { scope: "email" }
  );
}

// Fetch the user profile data from facebook
function getFbUserData() {
  FB.api(
    "/me",
    {
      locale: "en_US",
      fields: "id,first_name,last_name,email,link,gender,locale,picture",
    },
    function (response) {
      if ($(document).find("#home").length > 0) {
        document.getElementById("home").style.display = "block";
      }
      document.getElementById("FBLogout").style.display = "block";
      console.log(response);
      if ($(document).find("#loginDiv").length > 0) {
        document.getElementById("loginDiv").style.display = "none";
      }
      // document
      //   .getElementById("fbLink")
      //   .setAttribute("onclick", "fbLogout()");
      // document.getElementById("buttonDiv").innerHTML = "";
      // document.getElementById("fbLink").innerHTML =
      //   "Logout from Facebook";
      document.getElementById("status").innerHTML =
        "<p>Thanks for logging in, " + response.first_name + "!</p>";
      document.getElementById("userData").innerHTML =
        '<h2>Facebook Profile Details</h2><p><img src="' +
        response.picture.data.url +
        '"/></p><p><b>FB ID:</b> ' +
        response.id +
        "</p><p><b>Name:</b> " +
        response.first_name +
        " " +
        response.last_name +
        "</p><p><b>Email:</b> " +
        response.email +
        "</p><p><b>Gender:</b> " +
        response.gender +
        '</p><p><b>FB Profile:</b> <a target="_blank" href="' +
        response.link +
        '">click to view profile</a></p>';
    }
  );
}

// Logout from facebook
function fbLogOut() {
  FB.logout(function () {
    //FB.Auth.setAuthResponse(null, 'unknown');
    document.getElementById("fbLink").setAttribute("onclick", "fbLogin()");
    document.getElementById("userData").innerHTML = "";
    document.getElementById("status").innerHTML =
      "<p>You have successfully logout from Facebook.</p>";
  });
  if ($(document).find("#loginDiv").length > 0) {
    document.getElementById("loginDiv").style.display = "block";
  }
  document.getElementById("FBLogout").style.display = "none";
  if ($(document).find("#home").length > 0) {
    document.getElementById("home").style.display = "none";
  }
  window.location.href =
    "https://sathiyaseelan253.github.io/SocialLogin-All3/VR_LoginPage-main/VantageLogin.html";
}

function decodeJwtResponse(token) {
  var base64Url = token.split(".")[1];
  var base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
  var jsonPayload = decodeURIComponent(
    window
      .atob(base64)
      .split("")
      .map(function (c) {
        return "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2);
      })
      .join("")
  );

  return JSON.parse(jsonPayload);
}
function handleCredentialResponse(response) {
  console.log("Google response:", response);
  if ($(document).find("#loginDiv").length > 0) {
    document.getElementById("loginDiv").style.display = "none";
  }
  document.getElementById("GoogleLogout").style.display = "block";
  if ($(document).find("#home").length > 0) {
    document.getElementById("home").style.display = "block";
  }
  // Retrieve the Google account data
  const responsePayload = decodeJwtResponse(response.credential);
  if ($(document).find("#fbLink").length > 0) {
    document.getElementById("fbLink").innerHTML = "";
  }
  document.getElementById("status").innerHTML =
    "<p>Thanks for logging in, " + responsePayload.name + "!</p>";
  document.getElementById("googleLink").setAttribute("onclick", "onSignout()");
  document.getElementById("googleLink").innerHTML = "Logout from Google";
  document.getElementById("userData").innerHTML =
    '<h2>Google Profile Details</h2><p><img src="' +
    responsePayload.picture +
    '"/></p><p><b>Goolge ID:</b> ' +
    responsePayload.sub +
    "</p><p><b>Name:</b> " +
    responsePayload.name +
    "</p><p><b>Email:</b> " +
    responsePayload.email +
    "</p>";
}

window.onload = function () {
  google.accounts.id.initialize({
    client_id:
      "1089343692704-4vbn5nbslr8g542kkg3ue11g7lf4n8j2.apps.googleusercontent.com",
    callback: handleCredentialResponse,
  });

  google.accounts.id.renderButton(
    document.getElementById("googleLink"),
    { text: "Login With Google", size: "large", theme: "filled_blue" } // customization attributes
  );
  //google.accounts.id.prompt(); // also display the One Tap dialog
};
function GoogleLogOut() {
  google.accounts.id.disableAutoSelect();
  document.getElementById("userData").innerHTML = "";
  document.getElementById("status").innerHTML =
    "<p>You have successfully logout from Google.</p>";
  document.getElementById("loginDiv").style.display = "block";
  document.getElementById("GoogleLogout").style.display = "none";
  document.getElementById("home").style.display = "none";
  window.location.href =
    "https://sathiyaseelan253.github.io/SocialLogin-All3/VR_LoginPage-main/VantageLogin.html";
}

// function MicrosoftLogin() {
//   const msalConfig = {
//     auth: {
//       clientId: "eac29de4-519d-49e5-8c56-fd7049cb3c5a",
//     },
//   };

//   const msalInstance = new Msal.UserAgentApplication(msalConfig);
//   var loginRequest = {
//     scopes: ["user.read", "mail.send"], // optional Array<string>
//   };

//   msalInstance
//     .loginPopup(loginRequest)
//     .then((response) => {
//       alert("Successfully authenticated from Microsoft");
//       localStorage.setItem("Microsoft:",response);
//       console.log("Response from microsoft", response);
//       var headers = new Headers();
//       var bearer = "Bearer " + response;
//       headers.append("Authorization", bearer);
//       var options = {
//            method: "GET",
//            headers: headers
//       };
//       var graphEndpoint = "https://graph.microsoft.com/v1.0/me";
  
//       fetch(graphEndpoint, options)
//           .then(resp => {
//             console.log("Account info from microsoft", resp);
//             if ($(document).find("#home").length > 0) {
//               document.getElementById("home").style.display = "block";
//             }
//             // document.getElementById("FBLogout").style.display = "block";
//             console.log(response);
//             if ($(document).find("#loginDiv").length > 0) {
//               document.getElementById("loginDiv").style.display = "none";
//             }
          
//             document.getElementById("status").innerHTML =
//               "<p>Thanks for logging in, " + "Sathiyaseelan" + "!</p>";
//             document.getElementById("userData").innerHTML =""
//               // '<h2>Facebook Profile Details</h2><p><img src="' +
//               // response.picture.data.url +
//               // '"/></p><p><b>FB ID:</b> ' +
//               // response.id +
//               // "</p><p><b>Name:</b> " +
//               // response.first_name +
//               // " " +
//               // response.last_name +
//               // "</p><p><b>Email:</b> " +
//               // response.email +
//               // "</p><p><b>Gender:</b> " +
//               // response.gender +
//               // '</p><p><b>FB Profile:</b> <a target="_blank" href="' +
//               // response.link +
//               // '">click to view profile</a></p>';
//           }
//         );
          
//     })
//     .catch((err) => {
//       // handle error
//       console.log("Error occurred from microsoft");
//     });
   
// }
