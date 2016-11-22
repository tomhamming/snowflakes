(function () {

    function translate(x, y) { return "translate(" + x + "px, " + y + "px)"; }
    function scale(s) { return "scale(" + s + ")"; }
    function rotateX(r) { return "rotateX(" + r + "deg)"; }
    function rotateZ(r) { return "rotateZ(" + r + "deg)"; }

    var sheet = document.styleSheets.item(0);
    for (var i = 0; i < 700; i++) {     //TODO - base on window width?
        var ruleName = "falling" + i;
        var startX = (Math.random() * (window.innerWidth + 100)) - 50;

        var s = 0.15 + (Math.random() * 0.50);
        var rx = Math.random() * 360;
        var rz = Math.random() * 70 - 35;

        var animation = "@keyframes " + ruleName + " {"
            + "from {"
            + "transform:" + [
                translate(startX, -100),
                scale(s),
                rotateX(rx),
                rotateZ(rz)].join(" ") + ";"
            + "}"
            + "to{"
            + "transform:" + [
                translate(startX + (Math.random() * 40 - 20), window.innerHeight),
                scale(s),
                rotateX(rx + (180 + Math.random() * 540) * (Math.random() < 0.5 ? -1 : 1)),
                rotateZ(rz + (180 + Math.random() * 180) * (Math.random() < 0.5 ? -1 : 1))].join(" ") + ";"  //TODO - how to keep at window height?
            + "}"
            + "}";
        sheet.insertRule(animation);

        var img = document.createElement("img");
        img.src = "images/flake.png";
        img.style.animation = ruleName + " " + (15 + Math.random() * 10) + "s linear infinite";
        document.body.insertBefore(img, document.body.childNodes[0]);
    }

})();