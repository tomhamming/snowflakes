(function () {

    var sheet = document.styleSheets.item(0);
    for (var i = 0; i < 350; i++) {     //TODO - base on window width?
        var ruleName = "falling" + i;
        var startX = (Math.random() * (window.innerWidth + 600)) - 300;
        var scale = 0.05 + (Math.random() * 0.05);
        sheet.insertRule(
            "@keyframes " + ruleName + " {"
            + "from {"
            + "transform: translate(" + startX + "px, -600px) scale(" + scale + ") rotate(" + (Math.random() * 360 - 180 << 0) + "deg);"
            + "}"
            + "to{"
            + "transform: translate(" + (startX + (Math.random() * 40 - 20)) + "px, " + window.innerHeight + "px) scale(" + scale + ") rotate(" + (Math.random() * 360 - 180 << 0) + "deg);"  //TODO - how to keep at window height?
            + "}"
            + "}"
        );

        var img = document.createElement("img");
        img.src = "images/flake.png";
        img.style.animation = ruleName + " " + (15 + Math.random() * 10) + "s linear infinite";
        document.body.appendChild(img);
    }

})();