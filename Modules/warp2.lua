local mName = 'warp2'
local Warp = ModuleBase:createModule(mName)

--��������������������
local warpPoints = {
  { "����", 0, 1538, 15, 18 },
  { "ѩɽ", 0, 402, 84, 193 },
  { "ج����Lv49", 0, 33120, 33, 40 },
  { "ˮ֮����Lv65", 0, 15542, 10, 8 },
  { "��֮����Lv40", 0, 15595, 24, 8 },
  { "��֮����Lv30", 0, 15564, 23, 5 },
  { "��֮����Lv20", 0, 11034, 6, 5 },
  { "��������", 0, 15507, 29, 12 },
  { "�ͱ����ľ�ͷ", 0, 32115, 54, 21 },
  { "����", 0, 16511, 26, 68 },
  { "�̴�", 0, 24001, 15, 8 },
  { "��綴", 0, 300, 402, 304 },
  { "��ö���", 0, 32222, 30, 35 },
  { "��Ҷԭ-lv60", 0, 32216, 20, 40 },
  { "��Ҷԭ-lv100", 0, 32217, 55, 41 },
  { "��Ҷԭ-lv140", 0, 32215, 36, 19 },
}

local function calcwarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  logInfo(self.name, 'load')
  self.npc = {}
  local initFn = self:regCallback(function()
    return true;
  end)
  local warpNPC = NL.CreateNpc(nil, initFn);
  Char.SetData(warpNPC, CONST.CHAR_����, 103010);
  Char.SetData(warpNPC, CONST.CHAR_ԭ��, 103010);
  Char.SetData(warpNPC, CONST.CHAR_X, 242);
  Char.SetData(warpNPC, CONST.CHAR_Y, 86);
  Char.SetData(warpNPC, CONST.CHAR_��ͼ, 1000);
  Char.SetData(warpNPC, CONST.CHAR_����, 6);
  Char.SetData(warpNPC, CONST.CHAR_����, "������");
  NLG.UpChar(warpNPC);
  table.insert(self.npc, warpNPC);

  local warpNPCWinTalked = self:regCallback(function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warppage = page;
    local winmsg = "1\\n��������ȥ����\\n"
    local winbutton = CONST.BUTTON_�ر�;
    local totalpage, remainder = calcwarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.BUTTON_��һҳ then
        warppage = warppage + 1
        if (warppage == totalpage) or ((warppage == (totalpage - 1) and remainder == 0)) then
          winbutton = CONST.BUTTON_��ȡ��
        else
          winbutton = CONST.BUTTON_����ȡ��
        end
      elseif _select == CONST.BUTTON_��һҳ then
        warppage = warppage - 1
        if warppage == 1 then
          winbutton = CONST.BUTTON_��ȡ��
        else
          winbutton = CONST.BUTTON_��ȡ��
        end
      elseif _select == 2 then
        warppage = 1
        return
      end
      local count = 8 * (warppage - 1)
      if warppage == totalpage then
        for i = 1 + count, remainder + count do
          winmsg = winmsg .. warpPoints[i][1] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
          winmsg = winmsg .. warpPoints[i][1] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winbutton, warppage, winmsg);
    else
      local count = 8 * (warppage - 1) + column
      local short = warpPoints[count]
      Char.Warp(player, short[2], short[3], short[4], short[5])
    end
  end)
  Char.SetWindowTalkedEvent(nil, warpNPCWinTalked, warpNPC);

  local talkedFn = self:regCallback(function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n��������ȥ����\\n";
      for i = 1, 8 do
        msg = msg .. warpPoints[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 1, msg);
    end
    return
  end)
  Char.SetTalkedEvent(nil, talkedFn, warpNPC);
end

function Warp:onUnload()
  logInfo(self.name, 'unload')

  for i, v in pairs(self.npc) do
    NL.DelNpc(v)
  end
end

return Warp;
