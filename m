Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AEC4D545
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFTRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:32:53 -0400
Received: from mout.gmx.net ([212.227.15.19]:56057 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfFTRcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 13:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1561051945;
        bh=b/EYg7frIiOEmVO+jC5QgzH+HdXi9h+6Yrw5OYnfDig=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=Gu7nyI4deTxSMkboNCOlV0EYjr3oPehMyPRdOXDKzcN8QkXUXKPUmRd6EX2nQ20l0
         WMy7LHs8Bqw+Y3C48WSSoiEnVCkqCFAjqu3IiScIJvbO48s+cjaSvZMOiD7ImPADKO
         WAWt4Ylf+6RPN8R8k/t4eloIF3U9xzsV4y6x8SUU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.218.201.146] ([88.128.81.70]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MhAAr-1hzgXg1GXR-00MMgv; Thu, 20
 Jun 2019 19:32:25 +0200
Date:   Thu, 20 Jun 2019 19:32:19 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20190620122155.32078-3-opensource@vdorst.com>
References: <20190620122155.32078-1-opensource@vdorst.com> <20190620122155.32078-3-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: mt7530: Add MT7621 TRGMII mode support
Reply-to: frank-w@public-files.de
To:     =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
CC:     netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <E48021B2-3B82-4630-A9D1-290479988806@public-files.de>
X-Provags-ID: V03:K1:6VMlnX0wvZhaTY+S0ue9uKAasb97bCR4UAmPo4NG4svsppHAHCd
 Dx3o7Giw8H2uGj4oh6BqbOU30jlj7Jw6fhlHvsfaQNtR+0FQRgLzrdjjGWon/Z2VKVyiqMT
 6ip/DMzMbQTXACvHiAZyGXhUOfgnDLwX2dwnO8IGmzKlY8LY9c5EnsVbB1iSHZKL7viJDh6
 4tMJu0uhKNbkGhkK9N+Fw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qnjLQTpK8m4=:4zXdyWggRS2y6JkYb8I8+c
 y7SdBphUSX7GIXnlTBAGdfkXL17yqbiPMVNF+wfSMISe8tv3Kw+5A8QUGC//PVbLE+RuLeQ1o
 QFixWkMGCpJ2EXpNThrnwJWLtq+FYWSjYY8sphsE0ZuMj9cEnhjc5BRc9h9/r3VGb/IvlcaFt
 ivmzCDy6F8+n04iwJDG4frTWWIZKiGZeYmsCluHYNqcYgeYWF6m2+NArFy+4TqmSnoeeasyO3
 Occi1esioOwh71QK01at9jJsWUlIfkkmMi3KG0TAzlxtdHT1URZWfDZNCxNpkuxfwnB2+VWTN
 iNbaA7homH5KKQym5DIGx2345boXhPgmX2aReep7YF1F3koLAmeBG9CLPlvkiSrTIzmntZHkn
 wFvbVUB4Oqgv+hBrCaiNMJnT0q0wxe+q2RApI9tXrGVkjgDsH2Xmkf3g8At/7fDlWTsgw1PPs
 FapN+qk4aVgQGMp9DvRKWNPz/ImcnMVEPpe4UxNsv/zcOO4FwV2d23xLf+1ySyB/xymuyDv1c
 6+dZIEYxsacHPwdQE56XH7LHBH8vtCQxexztqbBVVVcAgXS0XBR6n/OwcWJyFJ0aRENV5rGr9
 wUBYZggIFLbv7b1wkLd//b0xhITRiuw1tzzEkISVm/uDyjNOSTYN7JMDHOcA/9mTNdfhwa+yi
 z1FXEDMebJD8k3fljeugk5pSuUTPHziCNthXNXuVnga2KmHzQQXkpjX0O0IfJ9O1a/wIHQS3+
 0xtuEfe5su5UYE0d64Gr+XXoJLd7xcL9rQzHbq/zdglGzVeyxLyRUiazQ/xxctFpnUcv8VKw/
 kzcqH0GqVZjS77XVTj3zAL+KxxywfW5XWC3WqhXYvdsczsoKMAaJ2xOUSQbUQK/gGZ+c+RUeF
 649mLTV1PE/gCBovx0JaejSolsuFCtqGGA8lfVFYS2AKUvo0ubZKJS2w0ZMznGd5WcFyoxZnI
 HkkCq/3O65r3ZgVQ1J3+gxWxnTWwM5IWEhw4gHsVtMIjZXINP3twW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on Bananapi R2 (mt7623) with 5=2E2-rc5 + net-next

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Am 20=2E Juni 2019 14:21:55 MESZ schrieb "Ren=C3=A9 van Dorst" <opensource=
@vdorst=2Ecom>:
>This patch add support TRGMII mode for MT7621 internal MT7530 switch=2E
>MT7621 TRGMII has only one fix speed mode of 1200MBit=2E
>
>Also adding support for mt7530 25MHz and 40MHz crystal clocksource=2E
>Values are based on Banana Pi R2 bsp [1]=2E
>
>Don't change MT7623 registers on a MT7621 device=2E
>
>[1]
>https://github=2Ecom/BPI-SINOVOIP/BPI-R2-bsp/blob/master/linux-mt/drivers=
/net/ethernet/mediatek/gsw_mt7623=2Ec#L769
>
>Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst=2Ecom>
>---
> drivers/net/dsa/mt7530=2Ec | 46 +++++++++++++++++++++++++++++++---------
> drivers/net/dsa/mt7530=2Eh |  4 ++++
> 2 files changed, 40 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/net/dsa/mt7530=2Ec b/drivers/net/dsa/mt7530=2Ec
>index c7d352da5448=2E=2E3181e95586d6 100644
>--- a/drivers/net/dsa/mt7530=2Ec
>+++ b/drivers/net/dsa/mt7530=2Ec
>@@ -428,24 +428,48 @@ static int
> mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
> {
> 	struct mt7530_priv *priv =3D ds->priv;
>-	u32 ncpo1, ssc_delta, trgint, i;
>+	u32 ncpo1, ssc_delta, trgint, i, xtal;
>+
>+	xtal =3D mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
>+
>+	if (xtal =3D=3D HWTRAP_XTAL_20MHZ) {
>+		dev_err(priv->dev,
>+			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
>+			__func__);
>+		return -EINVAL;
>+	}
>=20
> 	switch (mode) {
> 	case PHY_INTERFACE_MODE_RGMII:
> 		trgint =3D 0;
>+		/* PLL frequency: 125MHz */
> 		ncpo1 =3D 0x0c80;
>-		ssc_delta =3D 0x87;
> 		break;
> 	case PHY_INTERFACE_MODE_TRGMII:
> 		trgint =3D 1;
>-		ncpo1 =3D 0x1400;
>-		ssc_delta =3D 0x57;
>+		if (priv->id =3D=3D ID_MT7621) {
>+			/* PLL frequency: 150MHz: 1=2E2GBit */
>+			if (xtal =3D=3D HWTRAP_XTAL_40MHZ)
>+				ncpo1 =3D 0x0780;
>+			if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
>+				ncpo1 =3D 0x0a00;
>+		} else { /* PLL frequency: 250MHz: 2=2E0Gbit */
>+			if (xtal =3D=3D HWTRAP_XTAL_40MHZ)
>+				ncpo1 =3D 0x0c80;
>+			if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
>+				ncpo1 =3D 0x1400;
>+		}
> 		break;
> 	default:
> 		dev_err(priv->dev, "xMII mode %d not supported\n", mode);
> 		return -EINVAL;
> 	}
>=20
>+	if (xtal =3D=3D HWTRAP_XTAL_25MHZ)
>+		ssc_delta =3D 0x57;
>+	else
>+		ssc_delta =3D 0x87;
>+
> 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
> 		   P6_INTF_MODE(trgint));
>=20
>@@ -507,7 +531,9 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int
>mode)
> 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
> 				   RD_TAP_MASK, RD_TAP(16));
> 	else
>-		mt7623_trgmii_set(priv, GSW_INTF_MODE, INTF_MODE_TRGMII);
>+		if (priv->id !=3D ID_MT7621)
>+			mt7623_trgmii_set(priv, GSW_INTF_MODE,
>+					  INTF_MODE_TRGMII);
>=20
> 	return 0;
> }
>@@ -613,13 +639,13 @@ static void mt7530_adjust_link(struct dsa_switch
>*ds, int port,
> 	struct mt7530_priv *priv =3D ds->priv;
>=20
> 	if (phy_is_pseudo_fixed_link(phydev)) {
>-		if (priv->id =3D=3D ID_MT7530) {
>-			dev_dbg(priv->dev, "phy-mode for master device =3D %x\n",
>-				phydev->interface);
>+		dev_dbg(priv->dev, "phy-mode for master device =3D %x\n",
>+			phydev->interface);
>=20
>-			/* Setup TX circuit incluing relevant PAD and driving */
>-			mt7530_pad_clk_setup(ds, phydev->interface);
>+		/* Setup TX circuit incluing relevant PAD and driving */
>+		mt7530_pad_clk_setup(ds, phydev->interface);
>=20
>+		if (priv->id =3D=3D ID_MT7530) {
> 			/* Setup RX circuit, relevant PAD and driving on the
> 			 * host which must be placed after the setup on the
> 			 * device side is all finished=2E
>diff --git a/drivers/net/dsa/mt7530=2Eh b/drivers/net/dsa/mt7530=2Eh
>index 4331429969fa=2E=2Ebfac90f48102 100644
>--- a/drivers/net/dsa/mt7530=2Eh
>+++ b/drivers/net/dsa/mt7530=2Eh
>@@ -244,6 +244,10 @@ enum mt7530_vlan_port_attr {
>=20
> /* Register for hw trap status */
> #define MT7530_HWTRAP			0x7800
>+#define  HWTRAP_XTAL_MASK		(BIT(10) | BIT(9))
>+#define  HWTRAP_XTAL_25MHZ		(BIT(10) | BIT(9))
>+#define  HWTRAP_XTAL_40MHZ		(BIT(10))
>+#define  HWTRAP_XTAL_20MHZ		(BIT(9))
>=20
> /* Register for hw trap modification */
> #define MT7530_MHWTRAP			0x7804
