--ģ������
local moduleName = 'petLottery'
--ģ����
local PetLottery = ModuleBase:createModule(moduleName)

local pets = {
  { 3004, 1000, },
  { 41382, 1000, },
  { 1009, 1000, },
  { 16003, 1000, },
  { 16005, 1000, },
  { 206, 1000, },
  { 245, 1000, },
  { 246, 1000, },
  { 10088, 500, '����������' },
  { 103106, 500, '��˿����' },
  { 10006, 300, 'Ӱ����' },
  { 10007, 300, 'Ӱ����' },
  { 10008, 300, 'Ӱ����' },
  { 10009, 300, 'Ӱ����' },
  { 511, 300, 'x��' },
  { 512, 300, 'x��' },
  { 513, 300, 'x��' },
  { 514, 300, 'x��' },
  { 41220, 300, '����' },
  { 103132, 50, '�󹫼�' },
  { 103342, 30, '��˹����' },
  { 103316, 20, '��ͷ��ʿ' },
  { 103317, 20, '��ս����' },
  { 103318, 20, 'Ѫ����ʿ' },
  { 103319, 20, '������ʿ' },
  { 103320, 20, '��������' },
  { 103321, 15, '÷��' },
  { 103136, 15, '������' },
  { 103327, 8, 'ѩ�ٽ�' },
  { 103326, 8, '¶��' },
}

local MAX_N = table.reduce(pets, function(t, e)
  return t + e[2]
end, 0);

-- ����ģ�鹳��
function PetLottery:onLoad()
  self:logInfo('load')
  self:read();
  self:regCallback('ItemUseEvent', function(...)
    self:onItemUsed(...)
  end)
  --59999	137	123
  self.npc = self:NPC_createNormal('PetLottery', 10000, { x = 137, y = 123, mapType = 0, map = 59999, direction = 0, })
  self:NPC_regWindowTalkedEvent(self.npc, function(...)
    self:onWindowTalked(...)
  end)
end

local data = {};
function PetLottery:read()
  local t = {}
  local file = io.open('data/enemy.txt')
  for line in file:lines() do
    if line then
      local name, enemyId, baseId = string.match(line, '^(%S+)\t%S+\t(%d+)\t(%d+)\t1\t');
      --print(name, enemyId)
      if name and enemyId and baseId then
        t[baseId] = { name, enemyId, baseId };
      end
    end
  end
  file:close();
  file = io.open('data/enemybase.txt')
  for line in file:lines() do
    if line then
      local name, baseId = string.match(line, '^(%S+)\t(%d+)\t');
      --print(name, enemyId)
      if name and baseId and t[baseId] then
        data[t[baseId][2]] = name;
      end
    end
  end
  file:close();
  for i, v in pairs(data) do
    print(i, v)
  end
end

function PetLottery:onWindowTalked(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_�� then
    Char.GivePet(player, tonumber(seqNo));
  end
  NLG.UpChar(player);
end

function PetLottery:onItemUsed(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
  if tonumber(Item.GetData(itemIndex, CONST.����_ID)) == 47763 then
    --NLG.ShowWindowTalked(charIndex, charIndex, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 0, "\\n\\n    �Ƿ�")
    --Char.DelItem(charIndex, 47763, 1);
    local n = math.random(0, MAX_N)
    local k = n;
    for i, v in ipairs(pets) do
      if n <= v[2] then
        NLG.ShowWindowTalked(charIndex, self.npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, v[1], "\\n\\n    (" .. k .. ")��ƷΪ�� " .. (data[tostring(v[1])] or '???') .. " һֻ���Ƿ���ȡ��")
        return 1;
      end
      n = n - v[2]
    end
    NLG.SystemMessage(charIndex, "ʲô��û��������")
    return 1;
  end
  return 1;
end

-- ж��ģ�鹳��
function PetLottery:onUnload()
  self:logInfo('unload')
end

return PetLottery;
