---@class GmsvData
local GmsvData = ModuleBase:createModule('gmsvData')

GmsvData.CONST = {};
--[["��͵ȼ�"	"��ߵȼ�"	"��ͳ�������"	"��߳�������"	"enemyai����"	"ս������"	"ս������"	"����ģʽ"	"1��׽0����׽"	"������Ʒitem����1"
--	"������Ʒitem����2"	"������Ʒitem����3"	"������Ʒitem����4"	"������Ʒitem����5"	"������Ʒitem����6"	"������Ʒitem����7"	"������Ʒitem����8"
--	"������Ʒitem����9"	"������Ʒitem����10"	"��Ʒ����1"	"��Ʒ����2"	"��Ʒ����3"	"��Ʒ����4"	"��Ʒ����5"	"��Ʒ����6"	"��Ʒ����7"	
--	"��Ʒ����8"	"��Ʒ����9"	"��Ʒ����10"	͵����Ʒitem����1	͵����Ʒitem����2	͵����Ʒitem����3	͵����Ʒitem����4	͵����Ʒitem����5	
--	"͵������1"	"͵������2"	"͵������3"	"͵������4"	"͵������5"	"0�ǹ�1��BOSS"	"0Ϊ1��1Ϊ2��"	"�ٻ�ħ���ٻ��Ĵ��루enemy��"	
--	"�ٻ�ħ���ٻ��Ĵ��루enemy��"	"enemytalk����"
--]]
GmsvData.CONST.Enemy = {};
GmsvData.CONST.Enemy.Name = 1;
GmsvData.CONST.Enemy.Param = 2;
GmsvData.CONST.Enemy.EnemyId = 3;
GmsvData.CONST.Enemy.BaseId = 4;
GmsvData.CONST.Enemy.MinLevel = 5;
GmsvData.CONST.Enemy.MaxLevel = 6;
GmsvData.CONST.Enemy.MinCount = 7;
GmsvData.CONST.Enemy.MaxCount = 8;
GmsvData.CONST.Enemy.EnemyAI = 9;
GmsvData.CONST.Enemy.Exp = 10;
GmsvData.CONST.Enemy.Dp = 11;
GmsvData.CONST.Enemy.AttackMode = 12;
GmsvData.CONST.Enemy.CanSeal = 13;
GmsvData.CONST.Enemy.DropItemId1 = 14;
GmsvData.CONST.Enemy.DropItemId2 = 15;
GmsvData.CONST.Enemy.DropItemId3 = 16;
GmsvData.CONST.Enemy.DropItemId4 = 17;
GmsvData.CONST.Enemy.DropItemId5 = 18;
GmsvData.CONST.Enemy.DropItemId6 = 19;
GmsvData.CONST.Enemy.DropItemId7 = 20;
GmsvData.CONST.Enemy.DropItemId8 = 21;
GmsvData.CONST.Enemy.DropItemId9 = 22;
GmsvData.CONST.Enemy.DropItemId10 = 23;
GmsvData.CONST.Enemy.DropItemPercent1 = 24;
GmsvData.CONST.Enemy.DropItemPercent2 = 25;
GmsvData.CONST.Enemy.DropItemPercent3 = 26;
GmsvData.CONST.Enemy.DropItemPercent4 = 27;
GmsvData.CONST.Enemy.DropItemPercent5 = 28;
GmsvData.CONST.Enemy.DropItemPercent6 = 29;
GmsvData.CONST.Enemy.DropItemPercent7 = 30;
GmsvData.CONST.Enemy.DropItemPercent8 = 31;
GmsvData.CONST.Enemy.DropItemPercent9 = 32;
GmsvData.CONST.Enemy.DropItemPercent10 = 33;
GmsvData.CONST.Enemy.StealItemId1 = 34;
GmsvData.CONST.Enemy.StealItemId2 = 35;
GmsvData.CONST.Enemy.StealItemId3 = 36;
GmsvData.CONST.Enemy.StealItemId4 = 37;
GmsvData.CONST.Enemy.StealItemId5 = 38;
GmsvData.CONST.Enemy.StealItemPercent1 = 39;
GmsvData.CONST.Enemy.StealItemPercent2 = 40;
GmsvData.CONST.Enemy.StealItemPercent3 = 41;
GmsvData.CONST.Enemy.StealItemPercent4 = 42;
GmsvData.CONST.Enemy.StealItemPercent5 = 43;
GmsvData.CONST.Enemy.IsBoss = 44;
GmsvData.CONST.Enemy.IsDoubleAction = 45;
GmsvData.CONST.Enemy.SummonEnemyId1 = 46;
GmsvData.CONST.Enemy.SummonEnemyId2 = 47;
GmsvData.CONST.Enemy.EnemyTalkId = 48;
--����	���	����BP	"������Χ"	����	"����BP"	"����BP"	"����BP"	"�ٶ�BP"	"ħ��BP"	"��׽�Ѷ�"	"ͼ���ȼ�"	"����Ҫ��"	
--����	����	������	ˮ����	������	������	����	�ƿ�	ʯ��	�쿹	˯��	����	"ͼ������"	? ��ɱ	����	"������λ"	ͼ�����	"���鱶��"	?	
--"ͼ�����"	?	"0��׽1����׽"	"1������λtech���"	"2������λtech���"	"3������λtech���"	"4������λtech���"	
--"5������λtech���"	"6������λtech���"	"7������λtech���"	"8������λtech���"	"9������λtech���"
--"10������λtech���"
GmsvData.CONST.EnemyBase = {};
GmsvData.CONST.EnemyBase.Name = 1;
GmsvData.CONST.EnemyBase.EnemyBaseId = 2;
GmsvData.CONST.EnemyBase.BaseBP = 3;
GmsvData.CONST.EnemyBase.BP������Χ = 4;
GmsvData.CONST.EnemyBase.���� = 5;
GmsvData.CONST.EnemyBase.����BP = 6;
GmsvData.CONST.EnemyBase.����BP = 7;
GmsvData.CONST.EnemyBase.����BP = 8;
GmsvData.CONST.EnemyBase.�ٶ�BP = 9;
GmsvData.CONST.EnemyBase.ħ��BP = 10;
GmsvData.CONST.EnemyBase.��׽�Ѷ� = 11;
GmsvData.CONST.EnemyBase.ͼ���ȼ� = 12;
GmsvData.CONST.EnemyBase.����Ҫ�� = 13;
GmsvData.CONST.EnemyBase.���� = 14;
GmsvData.CONST.EnemyBase.���� = 15;
GmsvData.CONST.EnemyBase.������ = 16;
GmsvData.CONST.EnemyBase.ˮ���� = 17;
GmsvData.CONST.EnemyBase.������ = 18;
GmsvData.CONST.EnemyBase.������ = 19;
GmsvData.CONST.EnemyBase.���� = 20;
GmsvData.CONST.EnemyBase.�ƿ� = 21;
GmsvData.CONST.EnemyBase.ʯ�� = 22;
GmsvData.CONST.EnemyBase.�쿹 = 23;
GmsvData.CONST.EnemyBase.˯�� = 24;
GmsvData.CONST.EnemyBase.���� = 25;
GmsvData.CONST.EnemyBase.ͼ������ = 26;
GmsvData.CONST.EnemyBase.��ɱ = 28;
GmsvData.CONST.EnemyBase.���� = 29;
GmsvData.CONST.EnemyBase.������λ = 30;
GmsvData.CONST.EnemyBase.ͼ����� = 31;
GmsvData.CONST.EnemyBase.���鱶�� = 32;
GmsvData.CONST.EnemyBase.ͼ����� = 34;
GmsvData.CONST.EnemyBase.����׽ = 36;
GmsvData.CONST.EnemyBase.TechId1 = 37;
GmsvData.CONST.EnemyBase.TechId2 = 38;
GmsvData.CONST.EnemyBase.TechId3 = 39;
GmsvData.CONST.EnemyBase.TechId4 = 40;
GmsvData.CONST.EnemyBase.TechId5 = 41;
GmsvData.CONST.EnemyBase.TechId6 = 42;
GmsvData.CONST.EnemyBase.TechId7 = 43;
GmsvData.CONST.EnemyBase.TechId8 = 44;
GmsvData.CONST.EnemyBase.TechId9 = 45;
GmsvData.CONST.EnemyBase.TechId10 = 46;

function GmsvData:loadData()
  self.enemy = {}
  self.enemyBase = {}
  local file = io.open('data/enemy.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local enemy = string.split(line, '\t');
      if enemy and #enemy == 48 then
        self.enemy[enemy[self.CONST.Enemy.EnemyId]] = enemy;
      end
    end
    :: continue ::
  end
  file:close();
  file = io.open('data/enemybase.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local enemyBase = string.split(line, '\t');
      if enemyBase and #enemyBase == 46 then
        self.enemyBase[enemyBase[self.CONST.EnemyBase.EnemyBaseId]] = enemyBase;
      end
    end
    :: continue ::
  end
  file:close();
  --for i, v in pairs(data) do
  --  print(i, v)
  --end
  --print(MAX_N);
end

---@param enemyId string|number
---@return string
function GmsvData:getEnemyName(enemyId)
  local enemy = self.enemy[tostring(enemyId)];
  if enemy then
    local base = self.enemyBase[enemy[GmsvData.CONST.Enemy.BaseId]];
    if base then
      return base[GmsvData.CONST.EnemyBase.Name];
    end
  end
  return nil
end

--- ����ģ�鹳��
function GmsvData:onLoad()
  self:logInfo('load')
  self:loadData();
end

--- ж��ģ�鹳��
function GmsvData:onUnload()
  self:logInfo('unload')
end

return GmsvData;
