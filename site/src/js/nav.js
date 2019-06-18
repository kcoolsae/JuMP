function menuToggle() {
    var menuElement = document.getElementById("menu");
    var contentElement = document.getElementById("content");
    var logoElement = document.getElementById("logo");
    var menuIconSpan = document.getElementById("menu-icon").firstElementChild;
    if (menuElement.style.display === "block") {
        // hide menu
        menuElement.style.display = "none";
        //contentElement.style.clear = "none";
        logoElement.style.display= "block";
        menuIconSpan.innerHTML = "\uf0c9"; /* bars (hamburger) */
    } else {
        // display menu
        menuElement.style.display = "block";
        //contentElement.style.clear = "left";
        logoElement.style.display= "none";
        menuIconSpan.innerHTML = "\uf00d"; /* times (cross) */
    }
    return false;
}
