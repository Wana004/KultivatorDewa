-- NusaOP: membuat Cermin Bagua Pembalik Nasib (Item_NusaOP_FengShui) langsung aktif.
-- Relik feng shui bawaan punya status FSItemState: 1 = belum dibuka (perlu sihir
-- "Magic_FSItemOpen"), 2 = sudah dibuka. Skrip ini memeriksa tiap ~2 satuan waktu semua
-- cermin yang ada dan mengubah status 0/1 menjadi 2, sehingga tidak perlu sihir pembuka.
-- Nama API: ThingMgr:GetThingList(g_emThingType.Item, nama) dan ItemThing.FSItemState,
-- dipakai pola yang sama dengan skrip bawaan (Magic_ClearHanyu.lua, Magic_FSItemOpen.lua).
-- CATATAN: apakah status 2 cukup agar efek aktif BELUM diuji di perangkat.

local FS = GameMain:NewMod("NusaOP_FengShui");

local ITEM_NAME = "Item_NusaOP_FengShui";
local CHECK_INTERVAL = 2;

function FS:OnInit()
	self.acc = 0;
end

function FS:OnEnter()
	self.acc = 0;
end

function FS:OpenAll()
	local ok, err = pcall(function()
		local list = ThingMgr:GetThingList(g_emThingType.Item, ITEM_NAME);
		if list == nil then return; end
		for i = 0, list.Count - 1 do
			local it = list[i];
			local s = it.FSItemState;
			if s == 0 or s == 1 then
				it.FSItemState = 2;
				print("[NusaOP] Cermin feng shui diaktifkan, status sebelumnya " .. tostring(s));
			end
		end
	end);
	if not ok and not self.errShown then
		self.errShown = true;
		print("[NusaOP] gagal mengaktifkan cermin feng shui: " .. tostring(err));
	end
end

function FS:OnStep(dt)
	self.acc = (self.acc or 0) + dt;
	if self.acc < CHECK_INTERVAL then return; end
	self.acc = 0;
	self:OpenAll();
end
