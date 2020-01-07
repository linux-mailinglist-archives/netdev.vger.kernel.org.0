Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214B1131F5E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgAGFeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:34:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30746 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgAGFeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:34:31 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200107053427epoutp037af384991c6db4548b7ea4b14839a0b4~ng-GDYCK13173531735epoutp03l
        for <netdev@vger.kernel.org>; Tue,  7 Jan 2020 05:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200107053427epoutp037af384991c6db4548b7ea4b14839a0b4~ng-GDYCK13173531735epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1578375267;
        bh=HlAqQtGTg+FoGkYrpVJLgYfHw9gE9j12+g+flN1GrYo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cteF8z9hf9ez0GBDvR+BP7HTw1YcOPlEOanowHGmaHo6Di6BdfFOoR2vJJjZ6Hn6d
         MnRg42IEyxZgtvq5TVseuV48nJP+ybzByNEyD8XWQSp2aSPAZ9NPeu9RFrJTWD18ky
         NDhMIO6op+a8q9pYil086EZxijUsUApe8Ll84a1M=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200107053426epcas5p14d573e40e17222a2249fc85a3688a885~ng-E54mgn0187701877epcas5p1U;
        Tue,  7 Jan 2020 05:34:26 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.72.19629.268141E5; Tue,  7 Jan 2020 14:34:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200107053425epcas5p14e2b99b27fd39c3cd49ec81b039ee74a~ng-ET9KmM1995119951epcas5p1U;
        Tue,  7 Jan 2020 05:34:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200107053425epsmtrp10b1d8ec0bef7676cdb698bdac38938bf~ng-ETIGo71588315883epsmtrp18;
        Tue,  7 Jan 2020 05:34:25 +0000 (GMT)
X-AuditID: b6c32a4b-32dff70000014cad-ac-5e141862d254
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.90.10238.168141E5; Tue,  7 Jan 2020 14:34:25 +0900 (KST)
Received: from sriramdash03 (unknown [107.111.85.29]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200107053422epsmtip14b599e4d21758783755461ac0fdb89ed~ng-BKzBuw1857318573epsmtip1w;
        Tue,  7 Jan 2020 05:34:22 +0000 (GMT)
From:   "Sriram Dash" <sriram.dash@samsung.com>
To:     =?iso-8859-1?Q?'Heiko_St=FCbner'?= <heiko@sntech.de>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>
Cc:     <linux-arm-kernel@lists.infradead.org>,
        "'David Miller'" <davem@davemloft.net>, <p.rajanbabu@samsung.com>,
        <pankaj.dubey@samsung.com>, <Jose.Abreu@synopsys.com>,
        <jayati.sahu@samsung.com>, <alexandre.torgue@st.com>,
        <rcsekar@samsung.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <peppe.cavallaro@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
In-Reply-To: <1599392.7x4dJXGyiB@diego>
Subject: RE: [PATCH] net: stmmac: platform: Fix MDIO init for platforms
 without PHY
Date:   Tue, 7 Jan 2020 11:04:20 +0530
Message-ID: <011901d5c51c$1f93be30$5ebb3a90$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQHLzAO/yISlXyWkyxclgJwcl7iTGwGwvbPnApU1MP0CKNLZ9qe/HwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+3bO2Y6j5ecUfdWKWoVkaJZWJ7I0MjlSRCD5R9h06WFJOm2b
        VkJkphbmJUW7DK9RooKmc6Wtm1qZZRejNG8JukmkVpYW2gXreCb43+99v+f5vueBjybkI5Qb
        HaPRc1qNKlYhlpK3H6319DoMTkqf1K8uTL21AzFFr9NI5teXxxJmdniMYh4/vy5iBv9MUIzR
        0k0xb81FYiaz20oxbWXOzJP6UObaran/0rFbiDF0NlFMWf0wCrRnTVW9IvaO4YOEbbh+ms0x
        VSO2sbuEYFsebGBHpu8TrOnhJGInjcv32x2U+kdzsTFJnHb9jkjpkdm2GUnCxPYT7TcryRRU
        6p+J7GjAfjAwPY0ykZSW47sIBqeMtuE7gtm6cyJeJcc/EeSbtsw72qabRILoPoKzBR0SYRhF
        8PnuDcSrxNgLXvakijMRTTthNZx/GcVrCHyZgNmhbDGvscMeYP39Q8KzIz4AFWPlFM8kXg1V
        qRkU75XhrZAyFM6vZdgBnl21kjwT2Bt6CgvEAq+DivIxQgi3AmZGKihh7wJPZrLm9k44GCwz
        lrnQgNskYKlOkwiGIJg0p9vYEUafmmzsBp9yM2x8FN7mfLQ9oIcro+WkwAHQ/K7IFmgJZP+2
        ivjMgGVwPkMuSNbAaH+D7Rp3aK7pEAnMQlZXHXkRrTQsqGZYUM2woJphQZ0yRFYjVy5BF6fm
        dJsSfDXccW+dKk6XqFF7R8XHGdHc5/Pc04SMr/a2IkwjxWLZxaWOSjmlStKdjGtFQBMKJ9mZ
        YAelXBatOpnMaeMjtImxnK4VudOkwkWWT3WFy7FapeeOclwCp50/FdF2bilIuTE577hrfu2y
        kEAyeXhP3rbiwkqP9G9I/MlMlWxSK8dPpb9oD0sKmEp7EHmoM2RX0DkNDr2gX6q/ty+ofGDV
        6WPfnCPDe3z6zA1hk296T20e6Bu071/f71K4eecSv4nS9zXjdMoi845S37/m3cU/otoLMmqK
        bz+0RDTWWlou5UoJBak7otrgSWh1qn+fBwfaeAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWy7bCSnG6ihEicwcV+XYuNT04zWsw538Ji
        8evdEXaL/49es1ocObWEyeLenw+sFpseX2O1uLxrDptF17UnrBbHFohZHN0YbLFo6xeg0tdb
        GS1mXdjBarFg4yNGB36PLStvMnnsnHWX3WPzknqPvi2rGD22X5vH7HFwn6HH0x97mT227P/M
        6PF5k1wAZxSXTUpqTmZZapG+XQJXxutD59kLnmlUPFx6jbmBcbN8FyMnh4SAicSxHzuYuhi5
        OIQEdjNKvF18gbmLkQMoIS3x864uRI2wxMp/z9khal4wSjx5M5kFJMEmoCtx9kYTG4gtIpAu
        MefqNbBBzAKLmSU+vznNDNFxhFFi258FjCBVnALqEk9+f2UHsYUFgiVuTz8A1s0ioCKxsqmN
        FWQzr4ClRMPDGJAwr4CgxMmZT8CWMQsYSNw/1MEKYWtLLFv4mhniOgWJn0+XQcXFJY7+7GGG
        OMhN4vHPx0wTGIVnIRk1C8moWUhGzULSvoCRZRWjZGpBcW56brFhgWFearlecWJucWleul5y
        fu4mRnD8amnuYLy8JP4QowAHoxIPr4WUcJwQa2JZcWXuIUYJDmYlEd5GN8E4Id6UxMqq1KL8
        +KLSnNTiQ4zSHCxK4rxP845FCgmkJ5akZqemFqQWwWSZODilGhhj3e1k0/o/1Ap2Fi+s+mDE
        xR8as1g3MKCvoWzJmUuX6jzNjor8enhuwdpTkje1pY64/9r/KfYyy/LC803q57atSXv7YdW/
        LV9LeRncAhWvMM+w2WH15srRLJ3G2w1L7HcY2l73da1ax6979MqVjqspa641hp2Q1nP9e+Ld
        Dp6G7zUNpww0pR4psRRnJBpqMRcVJwIAhOBWH9sCAAA=
X-CMS-MailID: 20200107053425epcas5p14e2b99b27fd39c3cd49ec81b039ee74a
X-Msg-Generator: CA
CMS-TYPE: 105P
X-CMS-RootMailID: 20191219102407epcas5p103b26e6fb191f7135d870a3449115c89
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com>
        <1700835.tBzmY8zkgn@diego> <c25fbdb3-0e60-6e54-d58a-b05e8b805a58@gmail.com>
        <1599392.7x4dJXGyiB@diego>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Heiko St=FCbner=20<heiko=40sntech.de>=0D=0A>=20Subject:=20Re:=20=5B=
PATCH=5D=20net:=20stmmac:=20platform:=20Fix=20MDIO=20init=20for=20platforms=
=0D=0Awithout=0D=0A>=20PHY=0D=0A>=20=0D=0A>=20Hi=20Florian,=0D=0A>=20=0D=0A=
>=20Am=20Sonntag,=205.=20Januar=202020,=2023:22:00=20CET=20schrieb=20Floria=
n=20Fainelli:=0D=0A>=20>=20On=201/5/2020=2012:43=20PM,=20Heiko=20St=FCbner=
=20wrote:=0D=0A>=20>=20>=20Am=20Samstag,=2021.=20Dezember=202019,=2006:29:1=
8=20CET=20schrieb=20David=20Miller:=0D=0A>=20>=20>>=20From:=20Padmanabhan=
=20Rajanbabu=20<p.rajanbabu=40samsung.com>=0D=0A>=20>=20>>=20Date:=20Thu,=
=2019=20Dec=202019=2015:47:01=20+0530=0D=0A>=20>=20>>=0D=0A>=20>=20>>>=20Th=
e=20current=20implementation=20of=20=22stmmac_dt_phy=22=20function=20initia=
lizes=0D=0A>=20>=20>>>=20the=20MDIO=20platform=20bus=20data,=20even=20in=20=
the=20absence=20of=20PHY.=20This=20fix=0D=0A>=20>=20>>>=20will=20skip=20MDI=
O=20initialization=20if=20there=20is=20no=20PHY=20present.=0D=0A>=20>=20>>>=
=0D=0A>=20>=20>>>=20Fixes:=207437127=20(=22net:=20stmmac:=20Convert=20to=20=
phylink=20and=20remove=20phylib=0D=0A>=20>=20>>>=20logic=22)=0D=0A>=20>=20>=
>>=20Acked-by:=20Jayati=20Sahu=20<jayati.sahu=40samsung.com>=0D=0A>=20>=20>=
>>=20Signed-off-by:=20Sriram=20Dash=20<sriram.dash=40samsung.com>=0D=0A>=20=
>=20>>>=20Signed-off-by:=20Padmanabhan=20Rajanbabu=20<p.rajanbabu=40samsung=
.com>=0D=0A>=20>=20>>=0D=0A>=20>=20>>=20Applied=20and=20queued=20up=20for=
=20-stable,=20thanks.=0D=0A>=20>=20>=0D=0A>=20>=20>=20with=20this=20patch=
=20applied=20I=20now=20run=20into=20issues=20on=20multiple=20rockchip=0D=0A=
>=20>=20>=20platforms=20using=20a=20gmac=20interface.=0D=0A>=20>=0D=0A>=20>=
=20Do=20you=20have=20a=20list=20of=20DTS=20files=20that=20are=20affected=20=
by=20any=20chance?=20For=0D=0A>=20>=20the=2032-bit=20platforms=20that=20I=
=20looked=20it,=20it=20seems=20like:=0D=0A>=20>=0D=0A=0D=0AHi=20Florian,=20=
=0D=0AWe=20have=20listed=20down=20the=20platforms=20which=20will=20break=20=
for=20as=20they=20don=92t=20have=0D=0Athe=20mdio=20/=20snps,dwmac-mdio=20no=
de.=0D=0AArm32=20spear*=20,=20Arm32=20ox820*,=20arm32=20rv1108,=20arc=20abi=
lis*=20,=20arc=20axs10x*,=20arc=0D=0Avdk_axs10x*,=20mips=20pistachio,=20arm=
64=20rockchip/px30*=20There=20might=20be=20more=0D=0Aplatforms.=0D=0A=0D=0A=
>=20>=20arch/arm/boot/dts/rk3228-evb.dts=20is=20OK=20because=20it=20has=20a=
=20MDIO=20bus=20node=0D=0A>=20>=20arch/arm/boot/dts/rk3229-xms6.dts=20is=20=
also=20OK=0D=0A>=20>=0D=0A>=20>=20arch/arm/boot/dts/rk3229-evb.dts=20is=20p=
robably=20broken,=20there=20is=20no=0D=0A>=20>=20phy-handle=20property=20or=
=20MDIO=20bus=20node,=20so=20it=20must=20be=20relying=20on=0D=0A>=20>=20aut=
o-scanning=20of=20the=20bus=20somehow=20that=20this=20patch=20broke.=0D=0A>=
=20>=0D=0A>=20>=20And=20likewise=20for=20most=2064-bit=20platforms=20except=
=20a1=20and=20nanopi4.=0D=0A>=20=0D=0A>=20I=20primarily=20noticed=20that=20=
on=20the=20px30-evb.dts=20and=20the=20internal=20board=20I'm=0D=0Aworking=
=0D=0A>=20on=20right=20now.=20Both=20don't=20have=20that=20mdio=20bus=20nod=
e=20right=20now.=0D=0A>=20=0D=0A>=20=0D=0A>=20>=20>=20When=20probing=20the=
=20driver=20and=20trying=20to=20establish=20a=20connection=20for=20a=0D=0A>=
=20>=20>=20nfsroot=20it=20always=20runs=20into=20a=20null=20pointer=20in=20=
mdiobus_get_phy():=0D=0A>=20>=20>=0D=0A>=20>=20>=20=5B=20=20=2026.878839=5D=
=20rk_gmac-dwmac=20ff360000.ethernet:=20IRQ=20eth_wake_irq=20not=0D=0A>=20f=
ound=0D=0A>=20>=20>=20=5B=20=20=2026.886322=5D=20rk_gmac-dwmac=20ff360000.e=
thernet:=20IRQ=20eth_lpi=20not=20found=0D=0A>=20>=20>=20=5B=20=20=2026.8945=
05=5D=20rk_gmac-dwmac=20ff360000.ethernet:=20PTP=20uses=20main=20clock=0D=
=0A>=20>=20>=20=5B=20=20=2026.908209=5D=20rk_gmac-dwmac=20ff360000.ethernet=
:=20clock=20input=20or=20output?=0D=0A>=20(output).=0D=0A=0D=0A...=20snip=
=20...=0D=0A=0D=0A>=20>=20>=0D=0A>=20>=20>=0D=0A>=20>=20>=20This=20is=20tor=
valds=20git=20head=20and=20it=20was=20still=20working=20at=20-rc1=20and=20a=
ll=0D=0A>=20>=20>=20kernels=20before=20that.=20When=20I=20just=20revert=20t=
his=20commit,=20things=20also=0D=0A>=20>=20>=20start=20working=20again,=20s=
o=20I=20guess=20something=20must=20be=20wrong=20here?=0D=0A>=20>=0D=0A>=20>=
=20Yes,=20this=20was=20also=20identified=20to=20be=20problematic=20by=20the=
=20kernelci=20boot=0D=0A>=20>=20farms=20on=20another=20platform,=20see=20=
=5B1=5D.=0D=0A>=20>=0D=0A>=20>=20=5B1=5D:=0D=0A>=20>=20https://lore.kernel.=
org/linux-arm-kernel/5e0314da.1c69fb81.a7d63.29c1=40=0D=0A>=20>=20mx.google=
.com/=0D=0A>=20>=0D=0A>=20>=20Do=20you=20mind=20trying=20this=20patch=20and=
=20letting=20me=20know=20if=20it=20works=20for=20you.=0D=0A>=20>=20Sriram,=
=20please=20also=20try=20it=20on=20your=20platforms=20and=20let=20me=20know=
=20if=20solves=0D=0A>=20>=20the=20problem=20you=20were=20after.=20Thanks=0D=
=0A>=20=0D=0A>=20Works=20on=20both=20boards=20I=20had=20that=20were=20affec=
ted,=20so=0D=0A>=20Tested-by:=20Heiko=20Stuebner=20<heiko=40sntech.de>=0D=
=0A=0D=0ANacked-by=20:=20Sriram=20Dash=20<Sriram.dash=40samsung.com>=0D=0A=
=0D=0A>=20=0D=0A>=20=0D=0A>=20Thanks=0D=0A>=20Heiko=0D=0A>=20=0D=0A>=20>=0D=
=0A>=20>=20diff=20--git=20a/drivers/net/ethernet/stmicro/stmmac/stmmac_plat=
form.c=0D=0A>=20>=20b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c=
=0D=0A>=20>=20index=20cc8d7e7bf9ac..e192b8e0809e=20100644=0D=0A>=20>=20---=
=20a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c=0D=0A>=20>=20+++=
=20b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c=0D=0A>=20>=20=40=
=40=20-320,7=20+320,7=20=40=40=20static=20int=20stmmac_mtl_setup(struct=20p=
latform_device=0D=0A>=20>=20*pdev,=20=20static=20int=20stmmac_dt_phy(struct=
=20plat_stmmacenet_data=20*plat,=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20struct=20device_node=20*np,=
=20struct=20device=20*dev)=0D=0A>=20>=20=7B=0D=0A>=20>=20-=20=20=20=20=20=
=20=20bool=20mdio=20=3D=20false;=0D=0A>=20>=20+=20=20=20=20=20=20=20bool=20=
mdio=20=3D=20true;=0D=0A>=20>=20=20=20=20=20=20=20=20=20static=20const=20st=
ruct=20of_device_id=20need_mdio_ids=5B=5D=20=3D=20=7B=0D=0A>=20>=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=7B=20.compatible=20=3D=20=22snps=
,dwc-qos-ethernet-4.10=22=20=7D,=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=7B=7D,=0D=0A>=20>=20=40=40=20-341,8=20+341,9=20=40=40=
=20static=20int=20stmmac_dt_phy(struct=0D=0A>=20>=20plat_stmmacenet_data=20=
*plat,=0D=0A>=20>=20=20=20=20=20=20=20=20=20=7D=0D=0A>=20>=0D=0A>=20>=20=20=
=20=20=20=20=20=20=20if=20(plat->mdio_node)=20=7B=0D=0A=0D=0AFor=20the=20pl=
atforms=20which=20neither=20have=20mdio=20nor=20snps,dwmac-mdio=20property=
=20in=0D=0Adt,=20they=20will=20not=20enter=20the=20block.=0D=0Aplat->mdio_n=
ode=20will=20always=20be=20false=20for=20them.=20Which,=20essentially,=20pr=
eserves=0D=0Athe=20mdio=20variable=20Boolean=20value=20defined=20at=20the=
=20start=20of=20the=20function.=0D=0A=0D=0A>=20>=20-=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20dev_dbg(dev,=20=22Found=20MDIO=20subnode=5Cn=22);=
=0D=0A>=20>=20-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20mdio=20=3D=20tr=
ue;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20mdio=20=3D=
=20of_device_is_available(plat->mdio_node);=0D=0A>=20>=20+=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20dev_dbg(dev,=20=22Found=20MDIO=20subnode,=20s=
tatus:=20%sabled=5Cn=22,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20mdio=20?=20=22en=22=20:=20=22dis=22);=0D=
=0A>=20>=20=20=20=20=20=20=20=20=20=7D=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=
=20=20=20=20if=20(mdio)=20=7B=0D=0A>=20>=0D=0A>=20=0D=0A>=20=0D=0A>=20=0D=
=0A=0D=0AThere=20is=20a=20proposal=20for=20this=20problem=20solution.=20You=
=20can=20refer=20it=20at=20:=0D=0Ahttps://lkml.org/lkml/2020/1/7/14=0D=0A=
=0D=0A=0D=0A
