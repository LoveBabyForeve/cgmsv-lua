# cgmsv lua

## ģ��ϵͳ

֧�ֶ�̬���ء�ж���Լ��汾����������Ǩ�ơ�����ͨ��Moduleע��Ļص�ж��ʱ�Զ�����

### ModuleBase��

#### ����

1. `name` ��ǰģ������, string����
2. `migrations` ����Ǩ���б� �������ͣ� ÿ��Ԫ����Ҫ��`version`��`name`��`value` ��������
    - `version` �汾�� number����
    - `name` ���� string����
    - `value` sql���߾��巽�� string��function����

#### ����

1. `ModuleBase:regCallback(eventNameOrCallbackKeyOrFn, fn)`  ע��ص�
    - ���� `eventNameOrCallbackKeyOrFn`
      - ���Դ���NL.Reg*��Ӧ���¼����ƣ���NL.RegLoginEvent ���� `LoginEvent`
      - �Զ�����������ڷ�ȫ�ֻص�����NPC�����ص���
      - �����ص�����NPC�����ص���

    - ���� `fn`
      - �ص����������eventNameOrCallbackKeyOrFn�������ص���fn���Դ�nil

    - ����ֵ `eventNameOrCallbackKeyOrFn`, `lastIx`, `fnIndex`
      - `eventNameOrCallbackKeyOrFn` ������ȫ��Key�����ڴ���NL.Reg*
      - `lastIx` ��ǰģ���µ�ע������
      - `fnIndex` ȫ��ע������

2. `ModuleBase:unRegCallback(eventNameOrCallbackKey, fnOrFnIndex)`  ��ע��ص�
    - ���� `eventNameOrCallbackKey`
      - ���Դ���NL.Reg*��Ӧ���¼����ƣ���NL.RegLoginEvent ���� `LoginEvent`
      - �Զ�����������ڷ�ȫ�ֻص�����NPC�����ص���

    - ���� `fnOrFnIndex`
      - ���봫��ע���õĻص�����
      - Ҳ����fnIndex ȫ��ע������
3. `ModuleBase:onLoad()`  ģ��ע�ṳ�ӣ��ɾ���ʵ��ģ��ʵ��
4. `ModuleBase:onUnload()`  ģ��ж�ع��ӣ��ɾ���ʵ��ģ��ʵ��
5. `ModuleBase:logInfo(msg, ...)`  ��ӡ��־
6. `ModuleBase:logDebug(msg, ...)`  ��ӡ��־
7. `ModuleBase:logWarn(msg, ...)`  ��ӡ��־
8. `ModuleBase:logError(msg, ...)`  ��ӡ��־
9. `ModuleBase:log(level, msg, ...)`  ��ӡ��־
10. `ModuleBase:addMigration(version, name, sqlOrFunction)` ����һ����Ǩ��

## ģ�����
����ģ�������ModuleConfig.lua
### loadModule 
����`Modules`�µ�Module��Module���������໥�����������ֶ�ָ��ȫ�ֱ��������򲻻�Ӱ������Module�������������Module��ͨ��getModule��ȡ
```
loadModule('admin') --����adminģ��
```
### useModule 
����`Module`Ŀ¼�µ���ͨlua, ��ͨlua������һ����������������ִ�С������ֶ�ָ��Ϊȫ�ֱ���������ֻ��Ӱ����ͨlua��module���ܷ�����ر���/����
```
useModule('Welcome') --����Welcome
```
### getModule
��ȡ��Ӧ��Module

### unloadModule
ж��Module

### Ŀǰ���õ�ģ��
1. admin �ڹ���ء�ģ�鶯̬�����
2. shop �����̵�NPC����
3. warp ���䴫��
4. warp2 �����㴫��
5. welcome ʾ��ģ��
6. itemPowerUp.lua װ��ǿ��
7. manaPool Ѫħ��
8. bag �����л�
9. autoRegister �Զ�ע��
10. petExt/charExt/itemExt ������չģ��
11. petLottery ����齱
12. petRebirth ����ת��
   
### �����е�ģ��
- AI��չ

## GMSV ��չģ��
1. BattleEx.lua ս�������չ
2. Char.lua  ���������չ
3. DamageHook.lua �˺��޸Ĳ���
4. Data.lua Data���
5. Item.lua ��Ʒ���
6. LowCpuUsage.lua ����cpuʹ�ò���
7. Protocol.lua ����������
8. Recipe.lua �䷽���
9. DummyChar.lua �������
10. NL.lua ��չ�¼����
11. NLG_ShowWindowTalked_Patch.lua NLG.ShowWindowTalked ���Ȳ���
12. Addresses.lua ������ַ
13. Field.lua Field���

## ��չ�¼�/�ӿ�
- `NL.RegEnemyCommandEvent`
- `NL.RegCharaDeletedEvent`
- `NL.RegResetCharaBattleStateEvent`
- `NL.RegBattleDamageEvent`
- `NL.RegDamageCalculateEvent` 
- `NL.RegBattleHealCalculateEvent` 
- `NL.RegDeleteDummyEvent` 
- `Char.GetCharPointer`
- `Char.GetWeapon`
- `Char.GiveItem`
- `Char.DelItem`
- `Char.DelItemBySlot`
- `Char.UnsetWalkPostEvent`
- `Char.UnsetWalkPreEvent`
- `Char.UnsetPostOverEvent`
- `Char.UnsetLoopEvent`
- `Char.UnsetTalkedEvent`
- `Char.UnsetWindowTalkedEvent`
- `Char.UnsetItemPutEvent`
- `Char.UnsetWatchEvent`
- `Char.MoveArray`
- `Char.JoinParty`
- `Char.LeaveParty`
- `Char.MoveItem`
- `Char.IsValidCharPtr`
- `Char.IsValidCharIndex`
- `Char.GetDataByPtr`
- `Char.IsDummy`
- `Char.CreateDummy`
- `Char.DelDummy`
- `Battle.UnsetWinEvent`
- `Battle.UnsetPVPWinEvent`
- `Battle.GetNextBattle`
- `Battle.SetNextBattle`
- `Battle.GetTurn`
- `Data.ItemsetGetIndex`
- `Data.ItemsetGetData`
- `Data.GetEncountData`
- `Data.SetMessage`
- `Data.GetMessage`
- `Item.GetSlot`
- `Protocol.makeEscapeString`
- `Protocol.makeStringFromEscaped`
- `Protocol.nrprotoEscapeString`
- `Protocol.nrprotoUnescapeString`
- `Protocol.Send`
- `Protocol.GetCharIndexFromFd`
- `Protocol.OnRecv`
- `Recipe.GiveRecipe`
- `Recipe.RemoveRecipe`
