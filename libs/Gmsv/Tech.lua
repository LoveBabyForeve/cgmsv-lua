_G.Tech = _G.Tech or {}

local TECH_getTechIndex = ffi.cast('int (__cdecl*)(int a1)', 0x004F80A0);

function Tech.GetTechIndex(techId)
  if tonumber(techId) == nil then
    return -1;
  end
  return TECH_getTechIndex(tonumber(techId))
end

local TECH_getInt = ffi.cast('int (__cdecl*) (int a1, int a2)', 0x004F78B0);
local TECH_getChar = ffi.cast('char* (__cdecl*) (int a1, int a2)', 0x004F79D0);

function Tech.GetData(techIndex, dataLine)
  if techIndex < 0 then
    return nil
  end
  if dataLine < 0 then
    return nil
  end
  if dataLine > 2000 then
    if dataLine > 2002 then
      return nil
    end
    return ffi.string(TECH_getChar(techIndex, dataLine - 2000));
  end
  if dataLine > 0xB then
    return nil
  end
  return TECH_getInt(techIndex, dataLine);
end

