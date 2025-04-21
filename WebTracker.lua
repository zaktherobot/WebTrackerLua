   local function exportstring( s )
      return string.format("%q", s)
   end

   --// The Save Function
   function table.save(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE )
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                  end
               end
            end
         end
         file:write( "},"..charE )
      end
      file:write( "}" )
      file:close()
   end
   
   --// The Load Function
   function table.load( sfile )
      local ftables,err = loadfile( sfile )
      if err then return _,err end
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end


local trackerTable = {}

function _OnInit()
    StaticPointersLoaded = false
    prevContinue = 0
    wroteStartFile = false
    trackerTable.Report1 = 0
    trackerTable.Report2 = 0
    trackerTable.Report3 = 0
    trackerTable.Report4 = 0
    trackerTable.Report5 = 0
    trackerTable.Report6 = 0
    trackerTable.Report7 = 0
    trackerTable.Report8 = 0
    trackerTable.Report9 = 0
    trackerTable.Report10 = 0
    trackerTable.Report11 = 0
    trackerTable.Report12 = 0
    trackerTable.Report13 = 0
    trackerTable.Fire = 0
    trackerTable.Blizzard = 0
    trackerTable.Thunder = 0
    trackerTable.Cure = 0
    trackerTable.Magnet = 0
    trackerTable.Reflect = 0
    trackerTable.Valor = 0
    trackerTable.Wisdom = 0
    trackerTable.Limit = 0
    trackerTable.Master = 0
    trackerTable.Final = 0
    trackerTable.ProofOfPeace = 0
    trackerTable.ProofOfConnection = 0
    trackerTable.ProofOfNonexistence = 0
    trackerTable.PromiseCharm = 0
    trackerTable.TwilightThorn = 0
    trackerTable.Axel2 = 0
    trackerTable.FuturePete = 0
    trackerTable.Demyx = 0
    trackerTable.Scar = 0
    trackerTable.Groundshaker = 0
    trackerTable.VolcanoBlizzardLord = 0
    trackerTable.Jafar = 0
    trackerTable.DarkThorn = 0
    trackerTable.Xaldin = 0
    trackerTable.Roxas = 0
    trackerTable.Xigbar = 0
    trackerTable.Luxord = 0
    trackerTable.Saix = 0
    trackerTable.Xemnas = 0
    trackerTable.ShanYu = 0
    trackerTable.Stormrider = 0
    trackerTable.OogieBoogie = 0
    trackerTable.Experiment = 0
    trackerTable.Hydra = 0
    trackerTable.Hades = 0
    trackerTable.Barbossa = 0
    trackerTable.GrimReaper2 = 0
    trackerTable.HostileProgram = 0
    trackerTable.MCP = 0
    trackerTable.YeetTheBear = 0
    CanExecute = false
    kh2libstatus,kh2lib = pcall(require,"kh2lib")
    if not kh2libstatus then
        print("ERROR (Web Tracker): KH2-Lua-Library not installed")
        return
    end

    RequireKH2LibraryVersion(1)

    CanExecute = kh2lib.CanExecute
    if not CanExecute then
        return
    end

    OnPC = kh2lib.OnPC
    Now = kh2lib.Now
    Continue = kh2lib.Continue
    WriteLogic = kh2lib.WriteLogic
    Save = kh2lib.Save
    Sys3Pointer = kh2lib.Sys3Pointer
    MSN = kh2lib.MSN
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
    end

function BAR(File,Subfile,Offset) --Get address within a BAR file
    local Subpoint = File + 0x08 + 0x10*Subfile
    local Address
    --Detect errors
    if ReadInt(File,OnPC) ~= 0x01524142 then --Header mismatch
        return
    elseif Subfile > ReadInt(File+4,OnPC) then --Subfile over count
        return
    elseif Offset >= ReadInt(Subpoint+4,OnPC) then --Offset exceed subfile length
        return
    end
    --Get address
    Address = File + (ReadInt(Subpoint,OnPC) - ReadInt(File+8,OnPC)) + Offset
    return Address
end

function write_new_bingo_line(line)
    print(line)
    local f = io.open("bingo_squares.txt", "r")
    local lines = {}
    for line in f:lines() do
        print(line)
        table.insert(lines, line)
    end
    f:close()
    table.insert(lines, 1, line)
    f = io.open("tmp_bingo_squares.txt","w")
    for _, line in ipairs(lines) do
        f:write(line)
        f:write("\n")
    end
    f:close()
    os.remove('bingo_squares.txt')
    os.rename('tmp_bingo_squares.txt', 'bingo_squares.txt')
    print(ok)
    print(err)
end

function write_inventory()
    table.save(trackerTable,"inventory.lua")
end

function bitChange(table,tableEntry,inv,mask,outstring)
    if table[tableEntry] == 0 and inv & mask ~=0 then
        table[tableEntry] = 1
        write_new_bingo_line(outstring)
    end
end

function magicUpdate(table,tableEntry,inv,outstring)
    if table[tableEntry] < inv then
        table[tableEntry] = inv
        if inv == 3 then
            write_new_bingo_line(outstring)
        end
    end
end

function keyItemUpdate(table,tableEntry,inv,outstring)
    if table[tableEntry] == 0 and inv == 1 then
        table[tableEntry] = 1
        write_new_bingo_line(outstring)
    end
end

function detect_changes()
    -- determine if we found any new items
    ItemSet1 = ReadByte(kh2lib.ItemSet1)
    ItemSet5 = ReadByte(kh2lib.ItemSet5)
    ItemSet6 = ReadByte(kh2lib.ItemSet6)
    ItemSet7 = ReadByte(kh2lib.ItemSet7)
    ItemSet11 = ReadByte(kh2lib.ItemSet11)
    
    -- Drives
    bitChange(trackerTable,"Valor",ItemSet1,0x02,"Valor Form\n")
    bitChange(trackerTable,"Wisdom",ItemSet1,0x04,"Wisdom Form\n")
    bitChange(trackerTable,"Final",ItemSet1,0x10,"Final Form\n")
    bitChange(trackerTable,"Master",ItemSet1,0x40,"Master Form\n")
    bitChange(trackerTable,"Limit",ItemSet11,0x08,"Limit Form\n")

    -- Reports
    bitChange(trackerTable,"Report1",ItemSet5,0x40,"Ansem Report 1\n")
    bitChange(trackerTable,"Report2",ItemSet5,0x80,"Ansem Report 2\n")
    bitChange(trackerTable,"Report3",ItemSet6,0x01,"Ansem Report 3\n")
    bitChange(trackerTable,"Report4",ItemSet6,0x02,"Ansem Report 4\n")
    bitChange(trackerTable,"Report5",ItemSet6,0x04,"Ansem Report 5\n")
    bitChange(trackerTable,"Report6",ItemSet6,0x08,"Ansem Report 6\n")
    bitChange(trackerTable,"Report7",ItemSet6,0x10,"Ansem Report 7\n")
    bitChange(trackerTable,"Report8",ItemSet6,0x20,"Ansem Report 8\n")
    bitChange(trackerTable,"Report9",ItemSet6,0x40,"Ansem Report 9\n")
    bitChange(trackerTable,"Report10",ItemSet6,0x80,"Ansem Report 10\n")
    bitChange(trackerTable,"Report11",ItemSet7,0x01,"Ansem Report 11\n")
    bitChange(trackerTable,"Report12",ItemSet7,0x02,"Ansem Report 12\n")
    bitChange(trackerTable,"Report13",ItemSet7,0x04,"Ansem Report 13\n")

    -- magic
    magicUpdate(trackerTable,"Fire",ReadByte(kh2lib.Fire),"Firaga\n")
    magicUpdate(trackerTable,"Blizzard",ReadByte(kh2lib.Blizzard),"Blizzaga\n")
    magicUpdate(trackerTable,"Thunder",ReadByte(kh2lib.Thunder),"Thundaga\n")
    magicUpdate(trackerTable,"Cure",ReadByte(kh2lib.Cure),"Curaga\n")
    magicUpdate(trackerTable,"Magnet",ReadByte(kh2lib.Magnet),"Magnega\n")
    magicUpdate(trackerTable,"Reflect",ReadByte(kh2lib.Reflect),"Reflega\n")

    -- proofs
    keyItemUpdate(trackerTable,"ProofOfPeace",ReadByte(kh2lib.ProofOfPeace),"Proof of Peace\n")
    keyItemUpdate(trackerTable,"ProofOfConnection",ReadByte(kh2lib.ProofOfConnection),"Proof of Connection\n")
    keyItemUpdate(trackerTable,"ProofOfNonexistence",ReadByte(kh2lib.ProofOfNonexistence),"Proof of Nonexistence\n")
    keyItemUpdate(trackerTable,"PromiseCharm",ReadByte(kh2lib.PromiseCharm),"Promise Charm\n")

    -- trackerTable.TwilightThorn = 0
    -- trackerTable.Axel2 = 0
    -- trackerTable.FuturePete = 0
    -- trackerTable.Demyx = 0
    -- trackerTable.Scar = 0
    -- trackerTable.Groundshaker = 0
    -- trackerTable.VolcanoBlizzardLord = 0
    -- trackerTable.Jafar = 0
    -- trackerTable.DarkThorn = 0
    -- trackerTable.Xaldin = 0
    -- trackerTable.Roxas = 0
    -- trackerTable.Xigbar = 0
    -- trackerTable.Luxord = 0
    -- trackerTable.Saix = 0
    -- trackerTable.Xemnas = 0
    -- trackerTable.ShanYu = 0
    -- trackerTable.Stormrider = 0
    -- trackerTable.OogieBoogie = 0
    -- trackerTable.Experiment = 0
    -- trackerTable.Hydra = 0
    -- trackerTable.Hades = 0
    -- trackerTable.Barbossa = 0
    -- trackerTable.GrimReaper2 = 0
    -- trackerTable.HostileProgram = 0
    -- trackerTable.MCP = 0
    -- trackerTable.YeetTheBear = 0

end

function _OnFrame()
    if not CanExecute then
        return
    end

    if not StaticPointersLoaded then
        if not OnPC then
            Sys3 = ReadInt(Sys3Pointer)
        else
            Sys3 = ReadLong(Sys3Pointer)
        end
        StaticPointersLoaded = true
    end

	World  = ReadByte(Now+0x00)
	Room   = ReadByte(Now+0x01)
	Place  = ReadShort(Now+0x00)
	Door   = ReadShort(Now+0x02)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)
    if Place == 0x2002 and Events(0x01,Null,0x01) then --Station of Serenity Weapons
        if not wroteStartFile then
            wroteStartFile = true
            f = io.open("bingo_squares.txt","w")
            f:close()
        end
        detect_changes()
    end


    if ReadInt(Continue+0xC) ~= prevContinue and ReadByte(WriteLogic) == 0 then -- we room saved
        detect_changes()
        write_inventory()
    end
    prevContinue = ReadInt(Continue+0xC)

end
