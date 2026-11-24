-- NusaOP: efek Pil Restu Sekte saat di-trade.
-- Cara kerja: tiap ~0,5 detik, baca stok pil di data trade tiap sekte
-- (TradeMgr:GetSchoolTrade(id):GetCount(nama_item)). Jika stok naik, berarti
-- pil baru saja diserahkan ke sekte itu, lalu relasi sekte dinaikkan.
-- Semua nama API di bawah berasal dari dokumentasi resmi GSQStudio (APIDoc).
-- CATATAN: asumsi "stok sekte naik saat pil dijual" BELUM diuji di perangkat.

local NusaOP = GameMain:NewMod("NusaOP");

local PILL_NAME = "Item_NusaOP_Dan_Favor";
local TARGET_RELATION = 2000;   -- nilai relasi yang dituju; ubah bila perlu
local CHECK_INTERVAL = 0.5;     -- jeda cek (satuan sama dengan dt OnStep)
local SCHOOL_IDS = {1,2,3,4,5,6,7,8,9,10,11,12,13}; -- ID sekte dari Settings/Trade/SchoolTrade

local function GetPillCount(id)
	local ok, data = pcall(function() return TradeMgr:GetSchoolTrade(id); end);
	if (not ok) or data == nil then return nil; end
	local ok2, count = pcall(function() return data:GetCount(PILL_NAME); end);
	if ok2 then return count; end
	return nil;
end

function NusaOP:Snapshot()
	self.last = {};
	for _, id in ipairs(SCHOOL_IDS) do
		self.last[id] = GetPillCount(id);
	end
end

function NusaOP:BoostSchool(id)
	local ok, err = pcall(function()
		local cur = SchoolMgr:GetSchoolRelation(id);
		if cur < TARGET_RELATION then
			SchoolMgr:AddSchoolRelation(id, TARGET_RELATION - cur);
		end
		print("[NusaOP] relasi sekte " .. tostring(id) .. " dinaikkan, sebelumnya " .. tostring(cur));
	end);
	if not ok and not self.errShown then
		self.errShown = true;
		print("[NusaOP] gagal menaikkan relasi: " .. tostring(err));
	end
end

function NusaOP:OnInit()
	self.last = {};
	self.acc = 0;
end

function NusaOP:OnEnter()
	self.acc = 0;
	self:Snapshot();
end

function NusaOP:OnAfterLoad()
	-- Setelah load save/pindah peta: ambil ulang patokan agar tidak salah memicu.
	self:Snapshot();
end

function NusaOP:OnStep(dt)
	self.acc = (self.acc or 0) + dt;
	if self.acc < CHECK_INTERVAL then return; end
	self.acc = 0;
	for _, id in ipairs(SCHOOL_IDS) do
		local now = GetPillCount(id);
		local before = self.last[id];
		if now ~= nil and before ~= nil and now > before then
			self:BoostSchool(id);
		end
		self.last[id] = now;
	end
end
