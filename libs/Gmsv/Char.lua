---��ȡ��ɫ��ָ��
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_����) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end
