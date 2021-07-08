local ItemPowerUP = ModuleBase:createModule('itemPowerUp')
ItemPowerUP.migrations = {
  { version = 1, name = 'add item_LuaData', value = function()
    SQL.querySQL([[create table if not exists lua_itemData
(
    id varchar(50) not null
        primary key,
    data text null
) engine innodb;
]])
  end },
  { version = 2, name = 'add item_LuaData_create_time', value = function()
    SQL.querySQL([[alter table lua_itemData add create_time int default now() not null;]])
  end }
};

local MAX_CACHE_SIZE = 1000;

local WeaponType = {
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_ǹ,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_С��,
  CONST.ITEM_TYPE_������,
}

local ArmourType = {
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_ñ,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_��,
  CONST.ITEM_TYPE_ѥ,
  CONST.ITEM_TYPE_Ь,
}

local AccessoryType = {
  CONST.ITEM_TYPE_�ֻ�,
  CONST.ITEM_TYPE_����,
  CONST.ITEM_TYPE_����,
  CONST.ITEM_TYPE_��ָ,
  CONST.ITEM_TYPE_ͷ��,
  CONST.ITEM_TYPE_����,
  CONST.ITEM_TYPE_�����,
}

local CrystalType = CONST.ITEM_TYPE_ˮ��
local MAX_LEVEL = 20;
local SAVE_LEVEL2 = 10;
local SAVE_LEVEL = 7;
local LevelRate = { 0, 0, 0, 10, 20, 30, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 93, 93, 96, 96, 97, 97, 98, 98, 99, 99, 99, 99, 99, 99, 99, 99 }

local function isWeapon(type)
  return table.indexOf(WeaponType, type) > 0
end

local function isArmour(type)
  return table.indexOf(ArmourType, type) > 0
end

local function isAccessory(type)
  return table.indexOf(AccessoryType, type) > 0
end

function ItemPowerUP:setItemData(itemIndex, value)
  local args = Item.GetData(itemIndex, CONST.����_���ò���)
  if not string.match(args, '^luaData_') then
    local t = formatNumber(os.time(), 36) .. formatNumber(math.random(1, 36 * 36), 36);
    args = 'luaData_' .. t;
    Item.SetData(itemIndex, CONST.����_���ò���, args);
  end
  local sql = 'replace into lua_itemData (id, data) VALUES (' .. SQL.sqlValue(args) .. ',' .. SQL.sqlValue(JSON.encode(value)) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache.set(args, value);
end

function ItemPowerUP:getItemData(itemIndex)
  local args = Item.GetData(itemIndex, CONST.����_���ò���)
  if string.match(args, '^luaData_') then
    local data = self.cache.get(args)
    if not data then
      data = SQL.querySQL('select data from lua_itemdata where id = ' .. SQL.sqlValue(args))
      if type(data) == 'table' and data[1] then
        data = data[1][1]
        data = JSON.decode(data)
        self.cache.set(args, data);
        return data;
      end
    end
  end
  return { };
end

function ItemPowerUP:onLoad()
  logInfo(self.name, 'load')
  self.cache = LRU.new(MAX_CACHE_SIZE);
  self:regCallback('ItemOverLapEvent', function(...)
    return self:onItemOverLapEvent(...)
  end)
  --print(NL.RegDamageCalculateEvent)
  local fnName = self:regCallback('DamageCalculateEvent', function(...)
    return self:onDamageCalculateEvent(...)
  end)
  --NL.RegDamageCalculateEvent(nil, fnName);
end

local function getItemSlot(charIndex, itemIndex)
  local itemSlot = -1;
  for i = 0, 27 do
    if Char.GetItemIndex(charIndex, i) == itemIndex then
      itemSlot = i;
      break
    end
  end
  return itemSlot;
end

--CharIndex: ��ֵ�� ��Ӧ�¼��Ķ���index�������ߣ�����ֵ��Lua���洫�ݸ���������
--DefCharIndex: ��ֵ�� ��Ӧ�¼��Ķ���index�������ߣ�����ֵ��Lua���洫�ݸ���������
--OriDamage: ��ֵ�� δ�����˺�����ֵ��Lua���洫�ݸ���������
--Damage: ��ֵ�� �����˺�����ʵ�˺�������ֵ��Lua���洫�ݸ���������
--BattleIndex: ��ֵ�� ��ǰս��index����ֵ��Lua���洫�ݸ���������
--Com1: ��ֵ�� ������ʹ�õĄ�����̖����ֵ��Lua���洫�ݸ���������
--Com2: ��ֵ�� �����߹���������Ŀ�ˌ����λ�ã���ֵ��Lua���洫�ݸ���������
--Com3: ��ֵ�� ������ʹ�õ���������tech��ID����ֵ��Lua���洫�ݸ���������
--DefCom1: ��ֵ�� ������ʹ�õĄ�����̖����ֵ��Lua���洫�ݸ���������
--DefCom2: ��ֵ�� �����߹���������Ŀ�ˌ����λ�ã���ֵ��Lua���洫�ݸ���������
--DefCom3: ��ֵ�� ������ʹ�õ���������tech��ID����ֵ��Lua���洫�ݸ���������
--Flg: ��ֵ�� �˺�ģʽ������鿴�����ֵ˵������ֵ��Lua���洫�ݸ���������
--Flg ֵ˵��
--0: ��ͨ�����˺�
--1: �����˺�
--2: ���˺�
--3: ����
--4: ����
--5: ħ���˺�

local DmgType = {
  Normal = 0,
  Crit = 1,
  NoDmg = 2,
  Miss = 3,
  Defence = 4,
  Magic = 5,
}

function ItemPowerUP:onDamageCalculateEvent(
  charIndex, defCharIndex, oriDamage, damage,
  battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
  if Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_�� then
    for i = 0, 7 do
      local itemIndex = Char.GetItemIndex(charIndex, i);
      if itemIndex >= 0 then
        local data = self:getItemData(itemIndex)
        if (data.level or 0) > 0 then
          local itemType = Item.GetData(itemIndex, CONST.����_����);
          if isWeapon(itemType) then
            local weaponDmg = Item.GetData(itemIndex, CONST.����_����);
            if Item.GetData(itemIndex, CONST.����_ħ��) > 0 and flg == DmgType.Magic then
              weaponDmg = weaponDmg + tonumber(Item.GetData(itemIndex, CONST.����_ħ��));
            end
            local dmg = math.ceil((data.level * data.level / 100 + data.level / 100) * weaponDmg);
            self:logDebug('add damage' .. dmg)
            damage = damage + dmg;
          end
        end
      end
    end
  end
  if Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_�� then
    for i = 0, 7 do
      local itemIndex = Char.GetItemIndex(defCharIndex, i);
      if itemIndex >= 0 then
        local data = self:getItemData(itemIndex)
        if (data.level or 0) > 0 then
          local itemType = Item.GetData(itemIndex, CONST.����_����);
          if isArmour(itemType) then
            self:logDebug('dec damage' .. (data.level * 2))
            damage = damage - data.level * 3;
          end
        end
      end
    end
  end
  if damage < 1 then
    return 1;
  end
  return damage;
end

function ItemPowerUP:onItemOverLapEvent(charIndex, fromItemIndex, targetItemIndex, num)
  if Item.GetData(fromItemIndex, CONST.����_����) == 'ħʯ' then
    self:logDebug('onItemOverLapEvent', charIndex, fromItemIndex, targetItemIndex, num);
    --if not Item.GetData(targetItemIndex, CONST.����_��װ��) then
    --  return 0
    --end
    --local fromSlot = getItemSlot(charIndex, fromItemIndex);
    local type = Item.GetData(targetItemIndex, CONST.����_����);
    local data = self:getItemData(targetItemIndex);
    if not (isArmour(type) or isWeapon(type)) then
      return 0
    end
    local rate = math.random(0, 100);
    local rawLv = data.level or 0;
    if rate < LevelRate[rawLv + 1] then
      if (data.level or 0) > 0 then
        if data.level >= SAVE_LEVEL2 then
          if math.random(0, 2) == 1 then
            data.level = 0;
          else
            data.level = data.level - math.random(1, data.level / 2)
          end
        elseif data.level > SAVE_LEVEL then
          data.level = data.level - 1;
        end
        self:setItemData(targetItemIndex, data);
      end
      NLG.SystemMessage(charIndex, "[ϵͳ] ǿ����" .. Item.GetData(targetItemIndex, CONST.����_����) .. "��ʧ�ܡ���" .. rate .. '/' .. LevelRate[rawLv + 1] .. "��");
      if data.level > 0 then
        Item.SetData(targetItemIndex, CONST.����_����, data.name .. ' +' .. data.level);
      else
        Item.SetData(targetItemIndex, CONST.����_����, data.name);
      end
      Char.DelItem(charIndex, Item.GetData(fromItemIndex, CONST.����_ID), 1);
      Item.UpItem(charIndex, -1);
      return 0;
    end
    data.level = rawLv + 1;
    if data.level > MAX_LEVEL then
      data.level = MAX_LEVEL;
    end
    data.name = data.name or Item.GetData(targetItemIndex, CONST.����_����);
    Item.SetData(targetItemIndex, CONST.����_����, data.name .. ' +' .. data.level);
    if isWeapon(type) then
    elseif isArmour(type) then
    end
    NLG.SystemMessage(charIndex, "[ϵͳ] ǿ����" .. Item.GetData(targetItemIndex, CONST.����_����) .. "���ɹ�����" .. rate .. '/' .. LevelRate[rawLv + 1] .. "��");
    self:setItemData(targetItemIndex, data);
    Char.DelItem(charIndex, Item.GetData(fromItemIndex, CONST.����_ID), 1);
    Item.UpItem(charIndex, -1);
    return 1;
  end
end

function ItemPowerUP:onUnload()
  logInfo(self.name, 'unload')
end

return ItemPowerUP;
