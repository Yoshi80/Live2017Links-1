--星遺物へと至る鍵
--Key to World Legacy
function c2930675.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c2930675.target)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c2930675.discon)
	e2:SetOperation(c2930675.disop)
	c:RegisterEffect(e2)
	--Double Snare
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(3682106)
	c:RegisterEffect(e3)
end
function c2930675.thfilter(c)
	return ((c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xfe)) and c:IsFaceup() and c:IsAbleToHand()
end
function c2930675.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c2930675.thfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c2930675.thfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(2930675,0)) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c2930675.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c2930675.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c2930675.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c2930675.cfilter(c,seq,p)
	return c:IsFaceup() and c:IsSetCard(0x10c) and c:IsColumn(seq,p,LOCATION_SZONE)
end
function c2930675.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_TRAP) then return false end
	local rc=re:GetHandler()
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE==0 or rc:IsControler(1-p) then
		if rc:IsLocation(LOCATION_SZONE) and rc:IsControler(p) then
			seq=rc:GetSequence()
		else
			seq=rc:GetPreviousSequence()
		end
	end
	return Duel.IsExistingMatchingCard(c2930675.cfilter,tp,LOCATION_MZONE,0,1,nil,seq,p)
end
function c2930675.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

