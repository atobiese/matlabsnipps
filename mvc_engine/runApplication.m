%  andrew.tobiesen@sintef.no 19.06.2015
function runApplication()
    %instansier milj� i mvc
    appmodel = model();
    %kj�r app
    app = controller(appmodel);
end