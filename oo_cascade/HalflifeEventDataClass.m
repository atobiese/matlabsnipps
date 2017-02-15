
classdef HalflifeEventDataClass < event.EventData
   properties
      Value = 0;
   end
   methods
      function eventData = HalflifeEventDataClass(value)
            eventData.Value = value;
      end
   end
end

