% a simple example of an object model. principally co2sim is based on this
% concept. pointer based, inherited from handle, passed by reference.
% copy of structs can be done with the clone function, located in the base abstract
% class.


%Create the component objects (Instance of the Component and Solvent class)
component = Component('methane','hydrocarbons',100.7, 'Variable', 3);
component1 = Component('co2','inert',10.7, 'Variable', 3);
parameter  = Parameter('Temperature','Param',10.7, 'Variable', 3);
parameter1  = Parameter('Pressure','Param',10.7, 'Variable', 3);

%Create the collection object (Instance of the ComponentCollection class)
collection = Collection('Pipe1');
collection.AddComponents(component);
collection.AddComponents(component1);
collection.AddParameter(parameter);
collection.AddParameter(parameter1);

%write in alternative way (for code serialization), objects are dynamically
%added to the collection, set and get routines are handled to build structs
%at all levels
collection.AddComponents([ 
	Component('ethane','hydrocarbons',10.7, 'Variable', 3), ...
    Component('octane','hydrocarbons',10.7, 'Variable', 3) ...
    Component('octane1','hydrocarbons',10.7, 'Variable', 3) ...
    Component('octane2','hydrocarbons',10.7, 'Variable', 3) ...
    Component('octane3','hydrocarbons',10.7, 'Variable', 3) ...
    Component('octane4','hydrocarbons',10.7, 'Variable', 3) ...
    Component('octane5','hydrocarbons',10.7, 'Variable', 3) ...
    ]);


% pause
%Call some property on each component - (how simple polymorphism is)
fprintf('Identification: \n');
for i=1:length(collection.Components)
    collection.Components(i).Identifier();
end
for i=1:length(collection.Parameters)
    collection.Parameters(i).Identifier();
end
fprintf('\n');

% pause
fprintf('Component decay:\n');
for k=1:length(collection.Components)
    fprintf(['Start Reaction ' collection.Components(k).Name ': ' num2str(collection.Components(k).Value) '\n']);
end

% pause
for i=0.1:0.1:1
    fprintf(['Time passed: ' num2str(i) ' years \n']);
    for k=1:length(collection.Components)
        collection.Components(k).Value = collection.Components(k).Value - 1.1;
    end
%     pause(1)
end
% pause
% test event funksjonalitet
for i=0.1:0.1:1 
    fprintf(['Time passed: ' num2str(i) ' years \n']);
    for k=1:length(collection.Components)
        collection.Components(k).Unit = collection.Components(k).Unit - 0.1;
    end
     pause(.1)
end





