---��ȡ��ɫ��ָ��
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_����) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

function Char.GetWeapon(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.����_����)) then
    return ItemIndex, CONST.EQUIP_����;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.����_����)) then
    return ItemIndex, CONST.EQUIP_����;
  end
  return -1, -1;
end
