-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["11"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -448.5, -33  ,  -640, 287.5  ,  -640.5, -96  ,  -449, -96.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   639.5, 287  ,  511.5, 223  ,  639, 223.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -256.5, 31  ,  -640, 287.5  ,  -447, -32.5  ,  -257, -32.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -64.5, 95  ,  -640, 287.5  ,  -255, 31.5  ,  -65, 31.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   127.5, 159  ,  -640, 287.5  ,  -63, 95.5  ,  127, 95.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   511.5, 223  ,  129, 159.5  ,  511, 159.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   639.5, 287  ,  -640, 287.5  ,  129, 159.5  ,  511.5, 223  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -447, -32.5  ,  -640, 287.5  ,  -448.5, -33  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -255, 31.5  ,  -640, 287.5  ,  -256.5, 31  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -63, 95.5  ,  -640, 287.5  ,  -64.5, 95  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 100, friction = 20, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -640, 287.5  ,  127.5, 159  ,  129, 159.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   512.5, -32  ,  577, -32.5  ,  576.5, 31  ,  513, 31.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   639.5, -33  ,  512.5, -32  ,  447.5, -288  ,  449, -288.5  ,  639, -288.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "", density = 10, friction = 2, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   447.5, -288  ,  512.5, -32  ,  448, -32.5  }
                    }
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M

