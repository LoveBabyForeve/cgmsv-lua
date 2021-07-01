--ģ������
local moduleName = 'welcome'
--ģ����
local Welcome = ModuleBase:new()
--Ǩ�ƶ���
Welcome.migrations = {
  {
    --�汾��
    version = 1,
    --˵������
    name = 'initial module',
    --Ǩ�ƾ��幤��
    value = function()
      print('run migration version: 1');
    end
  }
};


--���캯��
function Welcome:new()
    local o = ModuleBase:new(moduleName);
    setmetatable(o, self)
    self.__index = self
    return o;
end

-- ����ģ�鹳��
function Welcome:onLoad()
    logInfo(self.name, 'load')
end

-- ж��ģ�鹳��
function Welcome:onUnload()
    logInfo(self.name, 'unload')
end

return Welcome;
