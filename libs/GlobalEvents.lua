local chained = {
  TalkEvent = function(list, ...)
    local res = 1;
    for i, v in ipairs(list) do
      res = v(...)
      if res ~= 1 then
        return res;
      end
    end
    return res
  end,
  BeforeBattleTurnEvent = function(list, ...)
    local res = false;
    for i, v in ipairs(list) do
      res = v(...) or res;
    end
    return res
  end,
  GetExpEvent = function(list, CharIndex, Exp)
    local res = Exp;
    for i, v in ipairs(list) do
      res = v(CharIndex, Exp);
      if res == nil then
        res = Exp;
      end
      Exp = res;
    end
    return res
  end,
  ProductSkillExpEvent = function(list, CharIndex, SkillID, Exp)
    local res = Exp;
    for i, v in ipairs(list) do
      res = v(CharIndex, SkillID, Exp);
      if res == nil then
        res = Exp;
      end
      Exp = res;
    end
    return res
  end,
  BattleSkillExpEvent = function(list, CharIndex, SkillID, Exp)
    local res = Exp;
    for i, v in ipairs(list) do
      res = v(CharIndex, SkillID, Exp);
      if res == nil then
        res = Exp;
      end
      Exp = res;
    end
    return res
  end,
  BattleDamageEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
    local dmg = Damage;
    for i, v in ipairs(list) do
      dmg = v(CharIndex, DefCharIndex, OriDamage, dmg, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
      if type(dmg) ~= 'number' or dmg <= 0 then
        dmg = 1
      end
    end
    return dmg
  end
}

local defaultChain = function(fnList, ...)
  fnList = table.copy(fnList)
  local res;
  for i, v in ipairs(fnList) do
    res = v(...)
  end
  --logDebug('ModuleSystem', 'callback', name, res, ...)
  return res
end

local function makeEventHandle(name)
  local list = {}
  list.map = {};
  return Func.bind(chained[name] or defaultChain, list), list
end

local eventCallbacks = {}
local ix = 0;

local function takeCallbacks(eventName, extraSign, shouldInit)
  local name = eventName .. (extraSign or '')
  if eventCallbacks[name] then
    return eventCallbacks[name], name, _G[name]
  end
  if shouldInit then
    local fn1, list = makeEventHandle(eventName);
    _G[name] = fn1;
    eventCallbacks[name] = list;
    if NL['Reg' .. eventName] then
      logInfo('GlobalEvent', 'NL.Reg' .. eventName, extraSign)
      if extraSign == '' then
        NL['Reg' .. eventName](nil, eventName .. extraSign);
      else
        NL['Reg' .. eventName](nil, eventName .. extraSign, extraSign);
      end
    end
    return list, name, fn1;
  end
  return nil;
end

--- 注册全局事件
---@param eventName string
---@param fn function
---@param moduleName string
---@param extraSign string|nil
---@return number 全局注册Index
function _G.regGlobalEvent(eventName, fn, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('GlobalEvent', 'regGlobalEvent', eventName, moduleName, ix + 1, eventCallbacks[eventName .. extraSign])
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign, true)
  ix = ix + 1;
  callbacks.map[ix] = #callbacks + 1;
  callbacks[#callbacks + 1] = function(...)
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, ...)
    local success, result = pcall(fn, ...)
    if not success then
      logError(moduleName, name .. ' event callback error: ', result)
      return nil;
    end
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, result, ...)
    return result;
  end
  return ix;
end

--- 移除全局事件
---@param eventName string
---@param fnIndex number 全局注册Index
---@param moduleName string
---@param extraSign string|nil
function _G.removeGlobalEvent(eventName, fnIndex, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('GlobalEvent', 'removeGlobalEvent', eventName .. extraSign, moduleName, fnIndex)
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign)
  --logInfo('GlobalEvent', 'callbacks', eventCallbacks[eventName .. extraSign])
  if not callbacks then
    return true;
  end
  --logInfo('GlobalEvent', 'fnIndex', fnIndex, eventCallbacks[eventName .. extraSign][fnIndex])
  if callbacks.map[fnIndex] ~= nil then
    table.remove(callbacks, callbacks.map[fnIndex]);
    callbacks.map[fnIndex] = nil;
  end
  if #callbacks == 0 then
    if not NL['Reg' .. eventName] then
      eventCallbacks[name] = nil;
      _G[name] = nil;
    end
  end
  return true;
end
