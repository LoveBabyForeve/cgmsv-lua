local getOnlineChar = ffi.cast('uint32_t (__cdecl*)(const char* cdkey, int regId)', 0x0046D920);

---@param cdkey string
---@param regId number
function NLG.FindUser(cdkey, regId)
  if regId == nil then
    local ret = SQL.querySQL("select RegistNumber from tbl_lock where CdKey = " .. SQL.sqlValue(cdkey), true)
    regId = tonumber(ret[1][1])
  end
  local charPtr = getOnlineChar(cdkey, regId);
  if Char.IsValidCharPtr(charPtr) then
    return ffi.readMemoryInt32(charPtr + 4);
  end
  return -1;
end

local enablePetRandomShot = nil;
function NLG.SetPetRandomShot(enable)
  if enablePetRandomShot == nil then
    ffi.hook.inlineHook("int (__cdecl *)(uint32_t a)", function(charPtr)
      if enablePetRandomShot ~= true or Char.GetDataByPtr(charPtr, CONST.CHAR_����) ~= 3 then
        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom3, -1);
      else
        ffi.setMemoryDWORD(0x09202B10, 4);
      end
      return 0;
    end, 0x0048612D, 0x14, {
      0x60,
      0x52, --push edx
    }, {
      0x58, --pop eax
      0x61,
    }, { ignoreOriginCode = true })
  end
  enablePetRandomShot = enable == true;
end

local disableCriticalDmg = nil;
---@param enable boolean
function NLG.SetCriticalDamageAddition(enable)
  if disableCriticalDmg == nil then
    ffi.hook.inlineHook("int (__cdecl *)(int a, uint32_t b, uint32_t c)", function(dmg, attacker, defence)
      if disableCriticalDmg ~= true then
        local lvA = Char.GetDataByPtr(attacker, CONST.CHAR_�ȼ�)
        local def = Char.GetDataByPtr(defence, CONST.CHAR_������)
        local lvD = Char.GetDataByPtr(defence, CONST.CHAR_�ȼ�)
        print(dmg);
        dmg = dmg + tonumber(tostring(math.floor(def / 2 * lvA / lvD)));
        printAsHex(dmg);
        print(dmg);
      end
      return dmg;
    end, 0x0049E268, 0x37, {
      --0x60,
      0x51, --push ecx
      0x56, --push esi
      0x53, --push ebx
      0x50, --push eax
    }, {
      0x59, --pop ecx
      0x59, --pop ecx
      0x59, --pop ecx
      0x59, --pop ecx
      --0x61,
    }, { ignoreOriginCode = true })
  end
  disableCriticalDmg = enable == true;
end
NLG.SetPetRandomShot(true);
NLG.SetCriticalDamageAddition(true);
