---װ���忨ģ��
local ModuleCard = ModuleBase:createModule('mCard')

function ModuleCard:onBattleStartEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  if type == CONST.ս��_��ͨ then
    local enemyDataList = {};
    self.cache[battleIndex] = enemyDataList;
    for i = 10, 19 do
      local charIndex = Battle.GetPlayer(battleIndex, i);
      if charIndex >= 0 then
        enemyDataList[tostring(i)] = {
          PetId = Char.GetData(charIndex, CONST.PET_PetID),
          Level = Char.GetData(charIndex, CONST.CHAR_�ȼ�),
          Name = Char.GetData(charIndex, CONST.CHAR_����),
          Ethnicity = Char.GetData(charIndex, CONST.CHAR_����),
        };
      end
    end
  end
end
function ModuleCard:onBattleOverEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  if type == CONST.ս��_��ͨ then
    local enemyDataList = self.cache[battleIndex];
    self.cache[battleIndex] = nil;
    local winSide = Battle.GetWinSide(battleIndex);
    if winSide == 0 then
      for i, enemy in pairs(enemyDataList) do
        
      end
    end
  end
end

--- ����ģ�鹳��
function ModuleCard:onLoad()
  self:logInfo('load')
  self.cache = { }
end

--- ж��ģ�鹳��
function ModuleCard:onUnload()
  self:logInfo('unload')
end

return ModuleCard;
