%  andrew.tobiesen@sintef.no 19.06.2015
function runApplication()
    %instansier miljø i mvc
    appmodel = model();
    %kjør app
    app = controller(appmodel);
end