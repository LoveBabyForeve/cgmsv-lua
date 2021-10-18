---��ȡ��ɫ��ָ��
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, 0) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

---��ȡװ�������� ItemIndex��λ��
---@return number,number itemIndex, װ��λ��
function Char.GetWeapon(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.����_����)) then
    return ItemIndex, CONST.EQUIP_����;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.����_����)) then
    return ItemIndex, CONST.EQUIP_����;
  end
  return -1, -1;
end

local giveItem = Char.GiveItem;
Char.GiveItem = function(CharIndex, ItemID, Amount, ShowMsg)
  ShowMsg = type(ShowMsg) ~= 'boolean' and true or ShowMsg;
  if not ShowMsg then
    ffi.patch(0x0058223B, { 0x90, 0x90, 0x90, 0x90, 0x90, });
  end
  local ret = giveItem(CharIndex, ItemID, Amount)
  if not ShowMsg then
    ffi.patch(0x0058223B, { 0xE8, 0x90, 0x46, 0xEB, 0xFF, });
  end
  return ret;
end

local delItem = Char.DelItem;
Char.DelItem = function(CharIndex, ItemID, Amount, ShowMsg)
  ShowMsg = type(ShowMsg) ~= 'boolean' and true or ShowMsg;
  if not ShowMsg then
    ffi.patch(0x0058281B, { 0x90, 0x90, 0x90, 0x90, 0x90, });
  end
  local ret = delItem(CharIndex, ItemID, Amount)
  if not ShowMsg then
    ffi.patch(0x0058281B, { 0xE8, 0xB0, 0x40, 0xEB, 0xFF, });
  end
  return ret;
end

local cDeleteCharItem = ffi.cast('int (__cdecl*)(const char * str1, int lineNo, uint32_t charAddr, uint32_t slot)', 0x00428390)
local cRemoveItem = ffi.cast('void (__cdecl *)(int itemIndex, const char * str, int lineNo)', 0x004C8370)
---����λ��ɾ����Ʒ
function Char.DelItemBySlot(CharIndex, Slot)
  local charPtr = Char.GetCharPointer(CharIndex);
  if charPtr < Addresses.CharaTablePTR then
    return -1;
  end
  local itemIndex = Char.GetItemIndex(CharIndex, Slot);
  if itemIndex < 0 then
    return -2;
  end
  cDeleteCharItem('LUA cDeleteCharItem', 0, charPtr, Slot);
  cRemoveItem(itemIndex, 'LUA cDeleteCharItem', 0);
  Item.UpItem(CharIndex, Slot)
  return 0;
end

function Char.UnsetWalkPostEvent(charIndex)
  Char.SetData(charIndex, 1588, 0)
  Char.SetData(charIndex, 1663, 0)
  Char.SetData(charIndex, 1985, 0)
end

function Char.UnsetWalkPreEvent(charIndex)
  Char.SetData(charIndex, 1587, 0)
  Char.SetData(charIndex, 1631, 0)
  Char.SetData(charIndex, 1984, 0)
end

function Char.UnsetPostOverEvent(charIndex)
  Char.SetData(charIndex, 1759, 0)
  Char.SetData(charIndex, 0x1F10 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x30) / 4, 0)
end

function Char.UnsetLoopEvent(charIndex)
  Char.SetData(charIndex, 0x1C7C / 4, 0)
  Char.SetData(charIndex, 0x1F18 / 4, 0)
  Char.SetData(charIndex, 0x1F2C / 4, 0)
  Char.SetData(charIndex, 0x1F30 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x2C) / 4, 0)
end

function Char.UnsetTalkedEvent(charIndex)
  Char.SetData(charIndex, 0x1D7C / 4, 0)
  Char.SetData(charIndex, 0x1F20 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x18) / 4, 0)
end

function Char.UnsetWindowTalkedEvent(charIndex)
  Char.SetData(charIndex, 0x1E7C / 4, 0)
  Char.SetData(charIndex, 0x1F28 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x28) / 4, 0)
end

function Char.UnsetItemPutEvent(charIndex)
  Char.SetData(charIndex, 0x1CFC / 4, 0)
  Char.SetData(charIndex, 0x1F1C / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x20) / 4, 0)
end

function Char.UnsetWatchEvent(charIndex)
  Char.SetData(charIndex, 0x1A7C / 4, 0)
  Char.SetData(charIndex, 0x1F08 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0xC) / 4, 0)
end

local checkPartyMemberCount = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x00437C10);
local joinParty_A = ffi.cast('uint32_t (__cdecl*)(uint32_t source, uint32_t target)', 0x00438140);
local sendJoinPartyResult = ffi.cast('int (__cdecl*)(uint32_t fd, int a2, int a3)', 0x005564D0);

---������ӣ�������ӿ��ؼ�����
function Char.JoinParty(sourceIndex, targetIndex)
  if Char.GetData(targetIndex, CONST.CHAR_����) ~= CONST.��������_�� then
    return -1;
  end
  if Char.GetData(sourceIndex, CONST.CHAR_����) ~= CONST.��������_�� then
    return -2;
  end

  if checkPartyMemberCount(Char.GetCharPointer(targetIndex)) < 0 then
    return -3;
  end
  joinParty_A(Char.GetCharPointer(sourceIndex), Char.GetCharPointer(targetIndex));
  return sendJoinPartyResult(Char.GetData(sourceIndex, CONST.CHAR_PlayerFD), 1, 1);
end

local _moveChara = ffi.cast('int (__cdecl *)(uint32_t charAddr, int x, int y, const char *walkArray, int leader_mb)', 0x00447370)
local walkDirection = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'e' }

---�ƶ���ɫ��NPC
---@param charIndex number
---@param walkArray number[] �ƶ��б�ȡֵ0-7��Ӧ CONST����ķ��򣬲����鳬��5���ƶ�
function Char.MoveArray(charIndex, walkArray)
  if Char.GetData(charIndex, 0) ~= 1 then
    return -1;
  end
  local charPtr = Char.GetCharPointer(charIndex);
  if Char.PartyNum(charIndex) > 0 and Char.GetPartyMember(charIndex, 0) ~= charIndex then
    return -2;
  end
  if type(walkArray) ~= 'table' then
    walkArray = '';
  else
    walkArray = table.join(table.map(walkArray, function(n)
      n = tonumber(n)
      if n == nil then
        return ''
      end
      return walkDirection[tonumber(n) + 1] or ''
    end), '')
  end
  _moveChara(charPtr, Char.GetData(charIndex, CONST.CHAR_X), Char.GetData(charIndex, CONST.CHAR_Y), walkArray, 1);
  return 1;
end

local leaveParty = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x00438B70);

---�뿪����
function Char.LeaveParty(charIndex)
  if Char.GetData(charIndex, 0) ~= 1 then
    return -1;
  end
  local charPtr = Char.GetCharPointer(charIndex);
  return leaveParty(charPtr);
end

local _moveItem = ffi.cast('int (__cdecl*)(uint32_t a1, int itemSlot, int targetSlot, int amount)', 0x00449E80)

---�ƶ���Ʒ
---@param charIndex number
---@param fromSlot number �ƶ��Ǹ���Ʒ��ȡֵ0-27
---@param toSlot number �ƶ����Ǹ�λ��, ȡֵ0-27
---@param amount number �����������ƶ�ȡֵ��Ϊ-1
function Char.MoveItem(charIndex, fromSlot, toSlot, amount)
  local charPtr = Char.GetCharPointer(charIndex)
  if charPtr <= 0 then
    return -1;
  end
  return _moveItem(charPtr, fromSlot, toSlot, amount)
end

---���ptr�Ƿ���ȷ
function Char.IsValidCharPtr(charPtr)
  return charPtr >= Addresses.CharaTablePTR and charPtr <= Addresses.CharaTablePTRMax and ffi.readMemoryInt32(charPtr) == 1
end

---���index�Ƿ���ȷ
function Char.IsValidCharIndex(charIndex)
  return Char.GetData(charIndex, 0) == 1;
end

---ͨ��ptr��ȡ����
function Char.GetDataByPtr(charPtr, dataLine)
  if Char.IsValidCharPtr(charPtr) then
    return Char.GetData(ffi.readMemoryInt32(charPtr + 4), dataLine);
  end
  return nil
end

local calcConsumeFp = ffi.cast('int (__cdecl*)(uint32_t charAddr)', 0x00478F30);

function Char.CalcConsumeFp(charIndex, techId)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  local oCom3 = Char.GetData(charIndex, CONST.CHAR_BattleCom3);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local charPtr = Char.GetCharPointer(charIndex);
  local flg = ffi.readMemoryInt32(charPtr + 0x21E8);
  --if battleIndex >= 0 and Battle.GetTurn(battleIndex) >= 0 then
  --else
  ffi.setMemoryInt32(charPtr + 0x21E8, -1);
  --end
  Char.SetData(charIndex, CONST.CHAR_BattleCom3, techId);
  local fp = calcConsumeFp(charPtr);
  Char.SetData(charIndex, CONST.CHAR_BattleCom3, oCom3);
  ffi.setMemoryInt32(charPtr + 0x21E8, flg);
  return fp;
end

function Char.GetEmptySlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  for i = 8, 27 do
    if Char.GetItemIndex(charIndex, i) == -1 then
      return i;
    end
  end
  return -2;
end

function Char.TradeItem(fromChar, slot, toChar)
  slot = tonumber(slot);
  if not Char.IsValidCharIndex(fromChar) then
    return -1;
  end
  if not Char.IsValidCharIndex(toChar) then
    return -2;
  end
  if slot < 7 or slot > 27 then
    return -3;
  end
  local itemIndex = Char.GetItemIndex(fromChar, slot);
  if itemIndex < 0 then
    return -4;
  end
  local toSlot = Char.GetEmptySlot(toChar);
  if toSlot < 0 then
    return -5;
  end
  Char.SetData(fromChar, CONST.CHAR_ItemIndexes + slot, -1);
  Char.SetData(toChar, CONST.CHAR_ItemIndexes + toSlot, itemIndex);
  Item.SetData(itemIndex, CONST.����_������, toChar);
  Item.UpItem(fromChar, slot);
  Item.UpItem(toChar, toSlot);
  return toSlot;
end

function Char.GetEmptyPetSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  for i = 0, 4 do
    if Char.GetPet(charIndex, i) >= 0 then
      return i;
    end
  end
  return -2;
end

local AssignPetToChara = ffi.cast('int (__cdecl*)(uint32_t a1, uint32_t a2)', 0x00433F80);

function Char.TradePet(fromChar, slot, toChar)
  slot = tonumber(slot);
  if not Char.IsValidCharIndex(fromChar) then
    return -1;
  end
  if not Char.IsValidCharIndex(toChar) then
    return -2;
  end
  if slot < 0 or slot > 4 then
    return -3;
  end
  local petIndex = Char.GetPet(fromChar, slot);
  if petIndex < 0 then
    return -4;
  end
  local petPtr = Char.GetCharPointer(petIndex);
  local fromPtr = Char.GetCharPointer(fromChar);
  local toPtr = Char.GetCharPointer(toChar);
  local fromPtrAddon = ffi.readMemoryDWORD(fromPtr + 0x0000053C);
  ffi.setMemoryInt32(fromPtrAddon + 4 * slot, 0);
  local toSlot = AssignPetToChara(toPtr, petPtr);
  if toSlot < 0 then
    return -5;
  end
  return toSlot;
end
