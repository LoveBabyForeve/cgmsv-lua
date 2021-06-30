local Warp = ModuleBase:new('warp')

--��������������������
local warpPoints = {
    { "ʥ��³����", 0, 100, 134, 218 },
    { "������", 0, 100, 681, 343 },
    { "�����ش�", 0, 100, 587, 51 },
    { "άŵ�Ǵ�", 0, 100, 330, 480 },
    { "������", 0, 300, 273, 294 },
    { "���ɴ�", 0, 300, 702, 147 },
    { "��ŵ����", 0, 400, 217, 455 },
    { "���ȴ�", 0, 400, 570, 274 },
    { "������˹��", 0, 400, 248, 247 },
    { "����³����", 0, 33200, 99, 165 },
    { "���Ǳ�����", 0, 33500, 17, 76 },
    { "��������", 0, 43100, 120, 107 },
    { "³����˹��", 0, 43000, 322, 883 },
    { "��ŵ���Ǵ�", 0, 43000, 431, 823 },
    { "�׿�������", 0, 43000, 556, 313 },
    { "���׶ٴ�", 0, 32205, 127, 138 },
    { "�Ǽͳ�", 0, 322277, 33, 56 },
    { "ʥʮ�����ߵ���", 0, 32699, 50, 50 },
    { "���＼����", 0, 32104, 48, 16 },
    { "�ɼ�������", 0, 32130, 11, 8 },
}

local function calcwarp()
    local page = math.modf(#warpPoints / 8) + 1
    local remainder = math.fmod(#warpPoints, 8)
    return page, remainder
end

function Warp:new()
    local o = ModuleBase:new('warp');
    setmetatable(o, self)
    self.__index = self
    return o;
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
    Char.SetData(warpNPC, CONST.CHAR_Y, 88);
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
