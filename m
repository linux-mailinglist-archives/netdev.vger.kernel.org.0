Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D54608B2B
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJVJ7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 05:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJVJ6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 05:58:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432DB2CF491;
        Sat, 22 Oct 2022 02:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=poHtrY03Qj1uaCgy2tMXWbBOBTDeYOAF7VqGYA5e58o=; b=cMIqk3T9UifK1VIiOdH8OMnRBg
        hQMFRNWG9MKre4W8eWJKqyRpxnr9A2QfwjWRwafCdrb1WRitMGOZVeS5/F2+z0yGV6e6WqhcElZyC
        YBf9Sf84f6R9lAIUNVINYxmM+Bzshua65U/O8FhbCB+MvzEy1TYTouMWslJnej2axT+ug9eRBcVcn
        e+uh5iE+5dQ0ozVv2BSBTEztKMsN12uWaIWa/lbvoa0Hxybvw5GnNcJqI8h9mEiLXigo1sXuAR34x
        Vzdb5uKs6MdviSPeaAWbQZtkal42ZWTF1Rim5ymG1bipzYZK7noGyGwrr+zwM92tjW2WDMnUKT7ly
        yMHCaQaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34886)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omAX6-0001Al-Jh; Sat, 22 Oct 2022 10:11:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omAX1-00050m-At; Sat, 22 Oct 2022 10:11:03 +0100
Date:   Sat, 22 Oct 2022 10:11:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
 <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
 <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
 <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
 <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 08:25:26AM +0200, Frank Wunderlich wrote:
> Am 21. Oktober 2022 23:28:09 MESZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> >On Fri, Oct 21, 2022 at 09:52:36PM +0200, Frank Wunderlich wrote:
> >> > Gesendet: Freitag, 21. Oktober 2022 um 20:31 Uhr
> >> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> >> 
> >> > On Fri, Oct 21, 2022 at 07:47:47PM +0200, Frank Wunderlich wrote:
> >> > > > Gesendet: Freitag, 21. Oktober 2022 um 11:06 Uhr
> >> > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> >> 
> >> > > > Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BMCR in
> >> > > > the low 16 bits, and BMSR in the upper 16 bits, so:
> >> > > >
> >> > > > At address 4, I'd expect the PHYSID.
> >> > > > At address 8, I'd expect the advertisement register in the low 16 bits
> >> > > > and the link partner advertisement in the upper 16 bits.
> >> > > >
> >> > > > Can you try an experiment, and in mtk_sgmii_init() try accessing the
> >> > > > regmap at address 0, 4, and 8 and print their contents please?
> >> > >
> >> > > is this what you want to see?
> >> 
> >> > > [    1.083359] dev: 0 offset:0 0x840140
> >> > > [    1.083376] dev: 0 offset:4 0x4d544950
> >> > > [    1.086955] dev: 0 offset:8 0x1
> >> > > [    1.090697] dev: 1 offset:0 0x81140
> >> > > [    1.093866] dev: 1 offset:4 0x4d544950
> >> > > [    1.097342] dev: 1 offset:8 0x1
> >> >
> >> > Thanks. Decoding these...
> >> >
> >> > dev 0:
> >> >  BMCR: fixed, full duplex, 1000Mbps, !autoneg
> >> >  BMSR: link up
> >> >  Phy ID: 0x4d54 0x4950
> >> >  Advertise: 0x0001 (which would correspond with the MAC side of SGMII)
> >> >  Link partner: 0x0000 (no advertisement received, but we're not using
> >> >     negotiation.)
> >> >
> >> > dev 1:
> >> >  BMCR: autoneg (full duplex, 1000Mbps - both would be ignored)
> >> >  BMSR: able to do autoneg, no link
> >> >  Phy ID: 0x4d54 0x4950
> >> >  Advertise: 0x0001 (same as above)
> >> >  Link partner: 0x0000 (no advertisement received due to no link)
> >> >
> >> > Okay, what would now be interesting is to see how dev 1 behaves when
> >> > it has link with a 1000base-X link partner that is advertising
> >> > properly. If this changes to 0x01e0 or similar (in the high 16-bits
> >> > of offset 8) then we definitely know that this is an IEEE PHY register
> >> > set laid out in memory, and we can program the advertisement and read
> >> > the link partner's abilities.
> >> 
> >> added register-read on the the new get_state function too
> >> 
> >> on bootup it is now a bit different
> >> 
> >> [    1.086283] dev: 0 offset:0 0x40140 #was previously 0x840140
> >> [    1.086301] dev: 0 offset:4 0x4d544950
> >> [    1.089795] dev: 0 offset:8 0x1
> >> [    1.093584] dev: 1 offset:0 0x81140
> >> [    1.096716] dev: 1 offset:4 0x4d544950
> >> [    1.100191] dev: 1 offset:8 0x1
> >> 
> >> root@bpi-r3:~# ip link set eth1 up
> >> [  172.037519] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/1000base-x link mode
> >> root@bpi-r3:~#
> >> [  172.102949] offset:0 0x40140 #still same value
> >
> >If this is "dev: 1" the value has changed - the ANENABLE bit has been
> >turned off, which means it's not going to bother receiving or sending
> >the 16-bit control word. Bit 12 needs to stay set for it to perform
> >the exchange.
> 
> Your right,was confused that dev 0 (fixed link to switch chip) had different value.
> 
> offset:0 0x81140 => 0x40140
> 
> So i should change offset 8 (currently 0x1) to at least 0x1 | BIT(12)? I can try to set this in the get_state callback,but i'm unsure i can read out it on my switch (basic mode changes yes,but not the value directly)...if mode is not autoneg i will see no change there.

Hi Frank,

Please try this untested patch, which should setup the PCS to perform
autonegotiation when using in-band mode for 1000base-X, write the
correct to offset 8, and set the link timer correctly.

Thanks.

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b52f3b0177ef..1a3eb3ecf7e3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -479,7 +479,7 @@
 
 /* Register to programmable link timer, the unit in 2 * 8ns */
 #define SGMSYS_PCS_LINK_TIMER	0x18
-#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & GENMASK(19, 0))
+#define SGMII_LINK_TIMER_MASK		GENMASK(19, 0)
 
 /* Register to control remote fault */
 #define SGMSYS_SGMII_MODE		0x20
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 736839c84130..973275c8e29e 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -20,19 +20,35 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
 }
 
 /* For SGMII interface mode */
-static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
+static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs,
+				 phy_interface_t interface,
+				 const unsigned long *advertising)
 {
 	unsigned int val;
+	int advertise;
+
+	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
+							     advertising);
+	if (advertise < 0)
+		advertise = 0;
+
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		val = 16000000 / 2 / 8;
+	else
+		val = 10000000 / 2 / 8;
 
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
-		     SGMII_LINK_TIMER_DEFAULT);
+	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, val);
 
 	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
 	val |= SGMII_REMOTE_FAULT_DIS;
 	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
 
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, 0xffff,
+			   advertise);
+
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
+	val |= SGMII_AN_ENABLE;
 	val |= SGMII_AN_RESTART;
 	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
 
@@ -52,12 +68,6 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 {
 	unsigned int val;
 
-	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
-	val &= ~RG_PHY_SPEED_MASK;
-	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		val |= RG_PHY_SPEED_3_125G;
-	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
-
 	/* Disable SGMII AN */
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
 	val &= ~SGMII_AN_ENABLE;
@@ -83,13 +93,20 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int val;
 	int err = 0;
 
+	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
+	val &= ~RG_PHY_SPEED_MASK;
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val |= RG_PHY_SPEED_3_125G;
+	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
+
 	/* Setup SGMIISYS with the determined property */
-	if (interface != PHY_INTERFACE_MODE_SGMII)
+	if (phylink_autoneg_inband(mode))
+		err = mtk_pcs_setup_mode_an(mpcs, interface, advertising);
+	else if (interface != PHY_INTERFACE_MODE_SGMII)
 		err = mtk_pcs_setup_mode_force(mpcs, interface);
-	else if (phylink_autoneg_inband(mode))
-		err = mtk_pcs_setup_mode_an(mpcs);
 
 	return err;
 }


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
