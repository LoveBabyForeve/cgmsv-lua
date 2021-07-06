Char = {}

---@param charIndex number
---@param dataIndex number
---@return string | number
function Char.GetData(charIndex, dataIndex)
end

---@param charIndex number
---@param dataIndex number
---@param value string|number
---@return number
function Char.SetData(charIndex, dataIndex, value)
end

---��valueΪ0ʱ�������
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return void
function Char.NowEvent(charIndex, flag, value)
end
---��ȡ��ǰ����
---@param charIndex number
---@param flag number
---@return number
function Char.NowEvent(charIndex, flag)
end
---��valueΪ0ʱ�������
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return void
function Char.EndEvent(charIndex, flag, value)
end
---��ȡ��ǰ����
---@param charIndex number
---@param flag number
---@return number
function Char.EndEvent(charIndex, flag)
end

---@param charIndex number
---@param itemID number
---@return number ������򷵻ص�һ������ĵ�����λ�ã����û���򷵻�-1��
function Char.FindItemId(charIndex, itemID)
end

---@param charIndex number
---@param amount number
function Char.AddGold(charIndex, amount)
end

---@param charIndex number
---@param slot number
---@return number ���Ŀ����λ�е��ߣ��򷵻ص���index�����򷵻� -1: ����ָ����� -2: �������޵��� -3: ������Χ��
function Char.GetItemIndex(charIndex, slot)
end
---@param CharIndex number
---@param ItemID number
---@param Amount number
---@return number �ɹ�����1��ʧ���򷵻�0��
function Char.DelItem(CharIndex, ItemID, Amount)
end

---@param CharIndex number
---@param ItemID number
---@param Amount number
---@return number Ŀ�����index��ʧ���򷵻ظ�����
function Char.GiveItem(CharIndex, ItemID, Amount)
end

---@param CharIndex number
---@param ItemID number
---@return number ���Ŀ���иõ��ߣ��򷵻ظõ���index�����򷵻�-1��
function Char.HaveItem(CharIndex, ItemID)
end

---@param CharIndex number
---@param Slot number
---@return number ���Ŀ���У��򷵻�index�����򷵻�-1��
function Char.GetPet(CharIndex, Slot)
end

NLG = {}
function NLG.ShowWindowTalked(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data)
end

function NLG.CanTalk(CharIndex, TargetCharIndex)
end

function NLG.UpChar(CharIndex)
end

Pet = {}
function Pet.ReBirth(PlayerIndex, PetIndex)
end

function Pet.SetArtRank(PetIndex, ArtType, Value)
end

function Pet.GetArtRank(PetIndex, ArtType)
end

function Pet.UpPet(PlayerIndex, PetIndex)
end
