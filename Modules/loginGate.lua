---ԭ�ص�½
local LoginModule = ModuleBase:createModule('loginGate')
local LoginPoints = {};
-- �����ǵ�½������ LoginPoint = 1
LoginPoints[1] = {
  { 0, 1000, 233, 78 },
  { 0, 1000, 233, 78 },
  { 0, 1000, 233, 78 },
  { 0, 1000, 233, 78 },
  { 0, 1000, 233, 78 },
  { 0, 1000, 233, 78 },
};
-- ����³�����¼������ LoginPoint = 2
LoginPoints[2] = {
  { 0, 33200, 99, 165 },
};
-- ��������½������ LoginPoint = 3
LoginPoints[3] = {
  { 0, 43100, 120, 107 },
};
-- �³ǵ�½������ LoginPoint = 4
LoginPoints[4] = {
  { 0, 59520, 140, 105 },
};

function LoginModule:GetLoginPointEvent(charIndex, mapID, floorID, x, y)
  local json = Field.Get(charIndex, 'LastLogoutPoint');
  local ret, lastPoint;
  if json and json ~= 'null' then
    ret, lastPoint = pcall(JSON.decode, json)
    if ret and lastPoint then
      if lastPoint[1] == 1 then
        local expire = Map.GetDungeonExpireAt(lastPoint[2])
        if expire ~= lastPoint[5] then
          mapID, floorID, x, y = Map.FindDungeonEntry(lastPoint[6])
          lastPoint = { mapID, floorID, x, y }
        end
      end
    else
      lastPoint = { mapID, floorID, x, y }
    end
  end
  if lastPoint == nil then
    lastPoint = LoginPoints[Char.GetData(charIndex, CONST.CHAR_��½��)] or LoginPoints[1];
    lastPoint = lastPoint[math.random(1, #lastPoint)]
  end
  Field.Set(charIndex, 'LastLogoutPoint', 'null');
  Char.SetData(charIndex, CONST.CHAR_��ͼ����, lastPoint[1]);
  Char.SetData(charIndex, CONST.CHAR_��ͼ, lastPoint[2]);
  Char.SetData(charIndex, CONST.CHAR_X, lastPoint[3]);
  Char.SetData(charIndex, CONST.CHAR_Y, lastPoint[4]);
end

function LoginModule:LogoutEvent(charIndex)
  local lastPoint = {
    Char.GetData(charIndex, CONST.CHAR_��ͼ����),
    Char.GetData(charIndex, CONST.CHAR_��ͼ),
    Char.GetData(charIndex, CONST.CHAR_X),
    Char.GetData(charIndex, CONST.CHAR_Y),
  };
  if lastPoint[1] == 1 then
    local expire = Map.GetDungeonExpireAt(lastPoint[2])
    lastPoint[5] = expire;
    lastPoint[6] = Map.GetDungeonId(lastPoint[2]);
  end
  if lastPoint[1] > 1 then
    lastPoint = nil
  end
  Field.Set(charIndex, 'LastLogoutPoint', JSON.encode(lastPoint));
end

--- ����ģ�鹳��
function LoginModule:onLoad()
  self:logInfo('load')
  self:regCallback('GetLoginPointEvent', Func.bind(self.GetLoginPointEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
end

--- ж��ģ�鹳��
function LoginModule:onUnload()
  self:logInfo('unload')
end

return LoginModule;
