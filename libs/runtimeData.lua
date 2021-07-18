_G.Data = {}
Protocol = { Hooks = {}, _hooked = false }
FFI.cdef [[
    void Sleep(int ms);
]];

local function ps(...)
  print(table.unpack(table.map({ ... }, function(e)
    if type(e) == 'number' and e > 0 then
      return string.formatNumber(e, 16)
    end
    return e;
  end)))
end

local _OnDispatch;
local ItemIdMax = FFI.readMemoryDWORD(0x09205BE0);
print('ItemIdMax:', ItemIdMax)
local ItemIndexTblTPR = FFI.readMemoryDWORD(0x09205584);
ps('item_index_tbl', ItemIndexTblTPR)
local ItemTableMax = FFI.readMemoryDWORD(0x00687C80);
print('ItemTableMax:', ItemTableMax)
local ItemTablePTR = FFI.readMemoryDWORD(0x09205588);
ps('item_tbl', ItemTablePTR)
local CharaTablePTR = FFI.readMemoryDWORD(0x091A6E54);
print('CharaTablePTR:', CharaTablePTR)
local CharaTableSize = FFI.readMemoryDWORD(0x091A6E58);
print('CharaTableSize:', CharaTableSize)
local ConnectionTable = FFI.readMemoryDWORD(0x1125704);
print('ConnectionTable:', ConnectionTable)

local _proto_send = FFI.cast('int (__cdecl *)(int fd, const char *str)', 0x00559370)
local _makeEscapeStringBuff = FFI.cast('char*', 0x006818C0)
local _makeEscapeString = FFI.cast("char *(__cdecl *)(const char *Str, char *target, int len)", 0x00407E80);
local _makeStringFromEscaped = FFI.cast('char* (__cdecl *)(const char* str)', 0x00407DD0)
local _nrproto_escapeString = FFI.cast('char* (__cdecl *)(const char* str)', 0x000558F00)
local _nrproto_unescapeString = FFI.cast('char* (__cdecl *)(const char* str)', 0x00559040)

---���������ַ���������Ϣ���������
function Protocol.makeEscapeString(str)
  return FFI.string(_makeEscapeString(str, _makeEscapeStringBuff, 2048));
end

---���������ַ���������Ϣ���������
function Protocol.makeStringFromEscaped(str)
  return FFI.string(_makeStringFromEscaped(str));
end

---����ַ�������
function Protocol.nrprotoEscapeString(str)
  return FFI.string(_nrproto_escapeString(str));
end

---����ַ�������
function Protocol.nrprotoUnescapeString(str)
  return FFI.string(_nrproto_unescapeString(str));
end

---���ͷ�����ͻ���
---@param charIndex number
---@param header string ���ͷ
---@vararg number|string data�����ݷ�����ݶ��������ּ��ַ���������з�����룬��Ĭ�ϴ���
---@return number ��������0Ϊʧ�ܣ���������Ϊ�ɹ�
function Protocol.Send(charIndex, header, ...)
  local ptr = Char.GetCharPointer(charIndex)
  if ptr <= 0 then
    return -1;
  end
  local fd = FFI.readMemoryDWORD(ptr + 0x7DC);
  if fd < 0 then
    return -1;
  end
  local data = { ... }
  local package = header .. ' ';
  for i, v in ipairs(data) do
    if type(v) == 'number' then
      package = package .. string.formatNumber(v, 62) .. ' '
    elseif type(v) == 'string' then
      package = package .. Protocol.nrprotoEscapeString(v) .. ' '
    else
      return -2;
    end
  end
  return _proto_send(fd, package);
end

local function OnDispatch(fd, str)
  local s, e = pcall(function()
    local s = FFI.string(str);
    local list = string.split(s, ' ');
    local head = list[1];
    table.remove(list, 1);
    for i = 1, #list do
      list[i] = Protocol.nrprotoUnescapeString(list[i]);
    end
    if Protocol.Hooks[head] and _G[Protocol.Hooks[head]] then
      local ret = _G[Protocol.Hooks[head]](fd, head, list);
      if type(ret) == 'number' and ret < 0 then
        return -1;
      end
    end
    return _OnDispatch(fd, str);
  end)
  return s and e or _OnDispatch(fd, str);
end

---����fd��ȡ��ɫIndex
function Protocol.GetCharIndexFromFd(fd)
  local charAddr = FFI.readMemoryDWORD(ConnectionTable + 0x221E0 * fd + 0x22108);
  if charAddr < CharaTablePTR or charAddr >= CharaTablePTR + CharaTableSize then
    return -1;
  end
  return FFI.readMemoryInt32(charAddr + 4);
end

---���ط���ص�
---@param Dofile string �����ļ�
---@param FuncName string �ص�����
---@param PacketID string ���ͷ
function Protocol.OnRecv(Dofile, FuncName, PacketID)
  if Dofile and _G[FuncName] == nil then
    dofile(Dofile)
  end
  Protocol.Hooks[PacketID] = FuncName;
  if Protocol._hooked == false then
    Protocol._hooked = true;
    --00551800 ; int __cdecl nrproto_ServerDispatchMessage(int fd, char *encoded)
    _OnDispatch = FFI.hook.new('int (__cdecl *)(uint32_t fd, char *encoded)', OnDispatch, 0x00551800, 5);
  end
end

-- ---@param fd number
-- ---@param head string ���ͷ
-- ---@param data string[] �������
-- ---@return number ��������0Ϊ���ط��, 0Ϊ�������ͨ�� 
--local function DumpPackageCallback(fd, head, data)
--  print('�յ�', head, '���������: ', unpack(table.map()))
--  return 0;
--end
--_G.DumpPackageCallback = DumpPackageCallback;
--
--Protocol.OnRecv(nil, 'DumpPackageCallback', 'zA')

---��ȡ��ɫ��ָ��
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_����) == 1 then
    return CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

---��ȡItemsetIndex
function Data.ItemsetGetIndex(ItemID)
  if ItemID < 0 and ItemID >= ItemIdMax then
    return -1;
  end
  return FFI.readMemoryInt32(ItemIndexTblTPR + 4 * ItemID)
end

---��ȡItemset����
function Data.ItemsetGetData(ItemsetIndex, DataPos)
  if ItemsetIndex < 0 or ItemsetIndex >= ItemTableMax then
    return nil;
  end
  if DataPos >= 2000 then
    --string32 * 13 
    DataPos = DataPos - 2000;
    if DataPos >= 13 then
      return nil;
    end
    return FFI.readMemoryString(ItemTablePTR + ItemsetIndex * 1092 + 78 * 4 + DataPos * 32 + 4)
  end
  local baseValue = 0;
  if DataPos >= 78 then
    --ext data & function ptr
    if DataPos >= 92 then
      --random data
      baseValue = FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + (DataPos - 90) * 4 + 4)
    end
    DataPos = 8 * 13 + DataPos
    if DataPos >= 273 then
      return nil
    end
  end
  return FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + DataPos * 4 + 4) + baseValue
end
