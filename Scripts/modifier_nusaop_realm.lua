-- NusaOP: efek Pil Naik Ranah (Item_NusaOP_Dan_Realm).
-- Cara kerja: pil memasang Modifier_NusaOP_Dan_Realm pada murid yang memakannya.
-- Modifier itu terhubung ke kelas Lua "modifier_nusaop_realm" (LuaClassName).
-- Pada Step pertama, murid dinaikkan satu ranah lewat
--   npc.PropertyMgr.Practice:UpgradeStage(false, false)
-- lalu modifier dihapus (modifier:Kill()) agar tidak terpicu lagi setelah save dimuat.
-- Pola kelas modifier dan nama API berasal dari skrip bawaan game dan APIDoc resmi GSQStudio.
-- CATATAN: perilaku UpgradeStage di perangkat BELUM diuji (lihat README).

local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("modifier_nusaop_realm");

local function Say(text, title)
	pcall(function() WorldLua:ShowMsgBox(text, title); end);
end

local function StageName(practice)
	local ok, name = pcall(function() return practice.CurStage.DisplayName; end);
	if ok and name ~= nil then return tostring(name); end
	return "?";
end

function tbModifier:Ascend(npc)
	local practice = npc.PropertyMgr.Practice;
	if practice == nil or practice.Gong == nil then
		Say(npc:GetName() .. " belum memiliki kitab kultivasi, pil tidak berefek.", "Pil Naik Ranah");
		return;
	end
	if practice.NextStage == nil then
		Say(npc:GetName() .. " sudah berada di ranah tertinggi kitabnya. Tidak ada ranah berikutnya.", "Pil Naik Ranah");
		return;
	end
	local before = StageName(practice);
	practice:UpgradeStage(false, false);
	local after = StageName(practice);
	print("[NusaOP] " .. tostring(npc:GetName()) .. " naik ranah: " .. before .. " -> " .. after);
	Say(npc:GetName() .. " menembus ranah: " .. before .. " menjadi " .. after .. ".", "Pil Naik Ranah");
end

-- Jangan simpan data individu di luatable ini selain penanda sekali-pakai per modifier.
function tbModifier:Step(modifier, npc, dt)
	self.fired = self.fired or {};
	local id = modifier.ID;
	if self.fired[id] then return; end
	self.fired[id] = true;
	local ok, err = pcall(function() self:Ascend(npc); end);
	if not ok then
		print("[NusaOP] Pil Naik Ranah gagal: " .. tostring(err));
	end
	pcall(function() modifier:Kill(); end);
end
