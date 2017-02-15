function [data] = getCO2SIMPipe(FileName,PathName)

if nargin < 2
    %read file
    FileName = 'Case01.xml';
    file = ([PathName 'Case01.xml']);
end

file = ([PathName FileName]);

[ s ] = xml2struct( FileName );

%co2sim pipe structures

%get components
data.tagName = s.NET.PIPES.PIPE.name.Text;
for idx=1:length(s.NET.PIPES.PIPE.STREAM.COMPONENTS.COMPONENT)
    eval(['data.comp{idx}=' 's.NET.PIPES.PIPE.STREAM.COMPONENTS.COMPONENT{idx}.name.Text']);
    data.molfrac(idx) = str2num(s.NET.PIPES.PIPE.STREAM.COMPONENTS.COMPONENT{idx}.molfrac.Text);
end

for idx=1:length(s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM)
    if strcmp (s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.name.Text, 'temp')
        data.temp=str2double(s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.value.Text);
        %if in celcius, convert
        if strcmp((s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.unit.Text), 'C')
            data.temp = unitconverter(data.temp, 'C', []);
        end
    end
    
    if strcmp (s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.name.Text, 'press')
        data.press=str2double(s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.value.Text);
         %convert pressure
        if strcmp((s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.unit.Text), 'kPa')
            data.press = unitconverter(data.press, 'kpa', 'pa');
        end
        
    end
    if strcmp (s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.name.Text, 'flow')
        data.flow=str2double(s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.value.Text);
        if strcmp((s.NET.PIPES.PIPE.STREAM.PARAMS.PARAM{idx}.unit.Text), 'kmol/h')
            data.flow = unitconverter(data.flow,  'kmol/h', 'mol/s');
        end
        
    end
end

%xport data
a =1;

end%function