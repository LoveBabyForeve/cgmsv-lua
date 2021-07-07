---����ת����ȫbp+3��������+1
local moduleName = 'petRebirth'
local PetRebirth = ModuleBase:createModule(moduleName)

-- ����ģ�鹳��
function PetRebirth:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('����ת��', 101024, { map = 1000, x = 225, y = 83, direction = 4, mapType = 0 });
  self:NPC_regTalkedEvent(npc, function(...)
    self:onTalked(...)
  end)
  self:NPC_regWindowTalkedEvent(npc, function(...)
    self:onSelected(...)
  end)
end

function PetRebirth:onTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_��ȡ��, 1, '\\n\\n   ����150���ĳ������ת��\\n   ת����bp+5,������+1,ȫ����+1,����+5,����/����/����/����+5\\n   ����: 10��ħ��')
  end
end

function PetRebirth:firstPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_��һҳ then
    if Char.GetData(player, CONST.CHAR_���) < 100000 then
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   ��Ҳ���')
      return
    end
    local list = { }
    for i = 0, 4 do
      local pIndex = Char.GetPet(player, i);
      if pIndex >= 0 then
        local lv = Char.GetData(pIndex, CONST.CHAR_�ȼ�)
        if lv > 150 then
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_����) .. ' lv.' .. lv);
        else
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_����) .. ' lv.' .. lv .. '���ȼ����㣩');
        end
      else
        table.insert(list, '[��]');
      end
    end
    if table.isEmpty(list) then
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   û�к��ʵĳ���')
      return
    end
    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 2, self:NPC_buildSelectionText('ѡ��ת���ĳ���', list));
  else
    return
  end
end

function PetRebirth:selectPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_�ر� then
    return
  end
  local pIndex = Char.GetPet(player, tonumber(data) - 1);
  if pIndex < 0 then
    NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   ��λ��û�г���')
    return
  end
  if Char.GetData(pIndex, CONST.CHAR_�ȼ�) < 150 then
    NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3,
      '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_����) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_�ȼ�) .. ' �ȼ�����150')
    return
  end
  NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 10 + pIndex,
    '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_����) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_�ȼ�) .. '\\n\\n   ȷ��ת����')
end

function PetRebirth:confirmPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_�� then
    return
  end
  local pIndex = seqNo - 10;
  if Char.GetData(player, CONST.CHAR_���) < 100000 then
    NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   ��Ҳ���')
    return
  end
  for i = 0, 4 do
    local pIndex2 = Char.GetPet(player, i);
    if pIndex2 == pIndex then
      if Char.GetData(pIndex, CONST.CHAR_�ȼ�) < 150 then
        NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3,
          '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_����) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_�ȼ�) .. ' �ȼ�����150')
        return
      end
      Char.AddGold(player, -100000);
      local arts = { CONST.PET_���, CONST.PET_����, CONST.PET_ǿ��, CONST.PET_����, CONST.PET_ħ�� };
      arts = table.map(arts, function(v)
        return { v, math.min(62, Pet.GetArtRank(pIndex, v) + 5) };
      end)
      Pet.ReBirth(player, pIndex);
      table.forEach(arts, function(v)
        Pet.SetArtRank(pIndex, v[1], v[2]);
      end);
      Char.SetData(pIndex, CONST.CHAR_������, math.min(10, Char.GetData(pIndex, CONST.CHAR_������) + 1));
      Char.SetData(pIndex, CONST.CHAR_ˮ����, math.min(10, Char.GetData(pIndex, CONST.CHAR_ˮ����) + 1));
      Char.SetData(pIndex, CONST.CHAR_������, math.min(10, Char.GetData(pIndex, CONST.CHAR_������) + 1));
      Char.SetData(pIndex, CONST.CHAR_������, math.min(10, Char.GetData(pIndex, CONST.CHAR_������) + 1));
      Char.SetData(pIndex, CONST.PET_������, math.min(10, Char.GetData(pIndex, CONST.PET_������) + 1));
      arts = { CONST.CHAR_����, CONST.CHAR_��˯, CONST.CHAR_��ʯ, CONST.CHAR_����, 
               CONST.CHAR_����, CONST.CHAR_����, CONST.CHAR_��ɱ, CONST.CHAR_����,
               CONST.CHAR_����, CONST.CHAR_����, }
      table.forEach(arts, function(e)
        Char.SetData(pIndex, e, math.min(100, Char.GetData(pIndex, e) + 5));
      end)
      Pet.UpPet(player, pIndex);
      NLG.UpChar(player);
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   �ѳɹ�ת��');
      return
    end
  end
  NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 3, '\\n\\n   ��λ��û�г���')
  return
end

function PetRebirth:onSelected(npc, player, seqNo, select, data)
  if seqNo == 1 then
    self:firstPage(npc, player, seqNo, select, data)
  elseif seqNo == 2 then
    self:selectPage(npc, player, seqNo, select, data)
  elseif seqNo >= 10 then
    self:confirmPage(npc, player, seqNo, select, data)
  end
end

-- ж��ģ�鹳��
function PetRebirth:onUnload()
  self:logInfo('unload')
end

return PetRebirth;
