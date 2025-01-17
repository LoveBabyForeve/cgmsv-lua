ffi.patch(0x00438B89, {
  0x8B, 0x45, 0xE4,
  0xC7, 0x44, 0x24, 0x04, 0x39, 0x02, 0x00, 0x00,
  0xC7, 0x04, 0x24, 0x80, 0x36, 0x61, 0x00,
  0x89, 0x44, 0x24, 0x08,
  0xE8, 0x0C, 0xEC, 0xFE, 0xFF,
  0x85, 0xC0,
  0x74, 0x15,
  0x89, 0xD8, 
  0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,
  0xBA, 0x01, 0x00, 0x00, 0x00,
  0x90, 0x90, })

local fnLeaveParty = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x00438B70)
local NPC_Lua_NL_PartyEventCallBack = ffi.cast('int (__cdecl*) (uint32_t a1, uint32_t a2, int a3)', 0x005779E0);
local function hookLeaveParty(charPtr)
  if Char.IsValidCharPtr(charPtr) then
    if ffi.readMemoryDWORD(0x09613C88) ~= 0 then
      local targetCharPtr = ffi.readMemoryDWORD(charPtr + 0x7bc + 0x24C);
      local res = NPC_Lua_NL_PartyEventCallBack(charPtr, targetCharPtr, 1);
      if res == 0 then
        return 1;
      end
    end
    return fnLeaveParty(charPtr);
  end
  return 1;
end

local fnPtr = ffi.cast('int (__cdecl*)(uint32_t a1)', hookLeaveParty)
local fnPtr1 = ffi.new('uint32_t[?]', 2);
fnPtr1[0] = ffi.cast('uint32_t', ffi.cast('void*', fnPtr)) - 0x0040EE50;
fnPtr1 = ffi.cast('uint8_t*', fnPtr1);
local s = {}
table.insert(s, fnPtr1[0]);
table.insert(s, fnPtr1[1]);
table.insert(s, fnPtr1[2]);
table.insert(s, fnPtr1[3]);
ffi.patch(0x0040EE4C, s)
_G.___script_buffer_RegPartyEvent = { fnPtr, hookLeaveParty };
print('[DEBUG] NL_RegPartyEvent_Patch done')
