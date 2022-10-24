Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2072B609DFC
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJXJ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJXJ2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:28:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DED642F3;
        Mon, 24 Oct 2022 02:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4gNDBkWeK3fqQD5XJmUhalze+8WmGpvHX6OB+nR0wRQ=; b=Ovvp2kXM86EP77r6dL7TF3eEmw
        HIH5HJ4Ysg18Hnn2aeCisbTTSZ9eVwtmOH+KbRxkiVh/Du4wN293uiywsYbjlx5uXbtc+q/lNv+GM
        rnIjcBgVv9gRZgjmOXx0QzsTZ8/PckR/CxVgM+37UEWeUvU1SR3nQhqoNSBI2vIGfqVxFtcDJSTut
        zw1XpNf/KarJwcNH+eI+IlMBR1xXJXjO2KPjEqrA7L0s9uJY8qiVJ9n4DJG79IQDP5Hq0dqtwPxpf
        bc6qcK0KDRxyCEObbNX9GVvWbOO3EOc2V1p29Q3fO7EGUb2Npq3teZWEWTaRFN4H04nb/nsN9vRZ9
        hnZipl6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34926)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omtkL-0002on-7F; Mon, 24 Oct 2022 10:27:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omtk7-00070x-QD; Mon, 24 Oct 2022 10:27:35 +0100
Date:   Mon, 24 Oct 2022 10:27:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
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
Message-ID: <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
References: <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
 <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
 <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
 <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 09:09:23PM +0100, Russell King (Oracle) wrote:
> This is amazingly great news - we now know how to configure this
> hardware! Let me cook up a proper set of patches for tomorrow - if
> that's okay.

Here's the combined patch for where I would like mtk_sgmii to get to.

It looks like this PCS is similar to what we know as pcs-lynx.c, but
there do seem to be differences - the duplex bit for example appears
to be inverted.

Please confirm whether this still works for you, thanks.

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b52f3b0177ef..8ecf97bcfec6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -466,8 +466,10 @@
 #define ETHSYS_DMA_AG_MAP_PPE	BIT(2)
 
 /* SGMII subsystem config registers */
-/* Register to auto-negotiation restart */
+/* BMCR (low 16) BMSR (high 16) */
 #define SGMSYS_PCS_CONTROL_1	0x0
+#define SGMII_BMCR		GENMASK(15, 0)
+#define SGMII_BMSR		GENMASK(31, 16)
 #define SGMII_AN_RESTART	BIT(9)
 #define SGMII_ISOLATE		BIT(10)
 #define SGMII_AN_ENABLE		BIT(12)
@@ -477,9 +479,13 @@
 #define SGMII_PCS_FAULT		BIT(23)
 #define SGMII_AN_EXPANSION_CLR	BIT(30)
 
+#define SGMSYS_PCS_ADVERTISE	0x8
+#define SGMII_ADVERTISE		GENMASK(15, 0)
+#define SGMII_LPA		GENMASK(31, 16)
+
 /* Register to programmable link timer, the unit in 2 * 8ns */
 #define SGMSYS_PCS_LINK_TIMER	0x18
-#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & GENMASK(19, 0))
+#define SGMII_LINK_TIMER_MASK	GENMASK(19, 0)
 
 /* Register to control remote fault */
 #define SGMSYS_SGMII_MODE		0x20
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 736839c84130..e64c02a48449 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -19,110 +19,136 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
 	return container_of(pcs, struct mtk_pcs, pcs);
 }
 
-/* For SGMII interface mode */
-static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
+static void mtk_pcs_get_state(struct phylink_pcs *pcs,
+			      struct phylink_link_state *state)
 {
-	unsigned int val;
-
-	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
-		     SGMII_LINK_TIMER_DEFAULT);
-
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val |= SGMII_REMOTE_FAULT_DIS;
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
-
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
-
-	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
-	val &= ~SGMII_PHYA_PWD;
-	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
+	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int bm, adv;
 
-	return 0;
+	/* Read the BMSR and LPA */
+	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
+	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
 
+	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
+					 FIELD_GET(SGMII_LPA, adv));
 }
 
-/* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
- * fixed speed.
- */
-static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
-				    phy_interface_t interface)
+static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			  phy_interface_t interface,
+			  const unsigned long *advertising,
+			  bool permit_pause_to_mac)
 {
-	unsigned int val;
+	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int rgc3, sgm_mode, bmcr;
+	int advertise, link_timer;
+	bool changed, use_an;
 
-	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
-	val &= ~RG_PHY_SPEED_MASK;
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		val |= RG_PHY_SPEED_3_125G;
-	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
+		rgc3 = RG_PHY_SPEED_3_125G;
+	else
+		rgc3 = 0;
+
+	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
+							     advertising);
+	if (advertise < 0)
+		return advertise;
+
+	link_timer = phylink_get_link_timer_ns(interface);
+	if (link_timer < 0)
+		return link_timer;
+
+	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
+	 * we assume that fixes it's speed at bitrate = line rate (in
+	 * other words, 1000Mbps or 2500Mbps).
+	 */
+	if (interface == PHY_INTERFACE_MODE_SGMII) {
+		sgm_mode = SGMII_IF_MODE_BIT0;
+		if (phylink_autoneg_inband(mode)) {
+			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
+				    SGMII_SPEED_DUPLEX_AN;
+			use_an = true;
+		} else {
+			use_an = false;
+		}
+	} else if (phylink_autoneg_inband(mode)) {
+		/* 1000base-X or 2500base-X autoneg */
+		sgm_mode = SGMII_REMOTE_FAULT_DIS;
+		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   advertising);
+	} else {
+		/* 1000base-X or 2500base-X without autoneg */
+		sgm_mode = 0;
+		use_an = false;
+	}
 
-	/* Disable SGMII AN */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val &= ~SGMII_AN_ENABLE;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
+	if (use_an) {
+		/* FIXME: Do we need to set AN_RESTART here? */
+		bmcr = SGMII_AN_RESTART | SGMII_AN_ENABLE;
+	} else {
+		bmcr = 0;
+	}
 
-	/* Set the speed etc but leave the duplex unchanged */
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val &= SGMII_DUPLEX_FULL | ~SGMII_IF_MODE_MASK;
-	val |= SGMII_SPEED_1000;
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
+	/* Configure the underlying interface speed */
+	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+			   RG_PHY_SPEED_3_125G, rgc3);
 
-	/* Release PHYA power down state */
-	regmap_read(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, &val);
-	val &= ~SGMII_PHYA_PWD;
-	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
+	/* Update the advertisement, noting whether it has changed */
+	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
+				 SGMII_ADVERTISE, advertise, &changed);
 
-	return 0;
-}
+	/* Setup the link timer and QPHY power up inside SGMIISYS */
+	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
 
-static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			  phy_interface_t interface,
-			  const unsigned long *advertising,
-			  bool permit_pause_to_mac)
-{
-	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	int err = 0;
+	/* Update the sgmsys mode register */
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
+			   SGMII_IF_MODE_BIT0, sgm_mode);
+
+	/* Update the BMCR */
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);
 
-	/* Setup SGMIISYS with the determined property */
-	if (interface != PHY_INTERFACE_MODE_SGMII)
-		err = mtk_pcs_setup_mode_force(mpcs, interface);
-	else if (phylink_autoneg_inband(mode))
-		err = mtk_pcs_setup_mode_an(mpcs);
+	/* Release PHYA power down state */
+	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+			   SGMII_PHYA_PWD, 0);
 
-	return err;
+	return changed ? 1 : 0;
 }
 
 static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int val;
 
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
-	val |= SGMII_AN_RESTART;
-	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART, SGMII_AN_RESTART);
 }
 
 static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int val;
-
-	if (!phy_interface_mode_is_8023z(interface))
-		return;
-
-	/* SGMII force duplex setting */
-	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
-	val &= ~SGMII_DUPLEX_FULL;
-	if (duplex == DUPLEX_FULL)
-		val |= SGMII_DUPLEX_FULL;
-
-	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
+	unsigned int sgm_mode;
+
+	if (!phylink_autoneg_inband(mode)) {
+		/* Force the speed and duplex setting */
+		if (speed == SPEED_10)
+			sgm_mode = SGMII_SPEED_10;
+		else if (speed == SPEED_100)
+			sgm_mode = SGMII_SPEED_100;
+		else
+			sgm_mode = SGMII_SPEED_1000;
+
+		if (duplex == DUPLEX_FULL)
+			sgm_mode |= SGMII_DUPLEX_FULL;
+
+		regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+				   SGMII_DUPLEX_FULL | SGMII_SPEED_MASK,
+				   sgm_mode);
+	}
 }
 
 static const struct phylink_pcs_ops mtk_pcs_ops = {
+	.pcs_get_state = mtk_pcs_get_state,
 	.pcs_config = mtk_pcs_config,
 	.pcs_an_restart = mtk_pcs_restart_an,
 	.pcs_link_up = mtk_pcs_link_up,
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 63800bf4a7ac..7a3eb46b38c1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -616,6 +616,22 @@ int phylink_speed_up(struct phylink *pl);
 
 void phylink_set_port_modes(unsigned long *bits);
 
+static inline int phylink_get_link_timer_ns(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		return 1600000;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return 10000000;
+
+	default:
+		return -EINVAL;
+	}
+}
+
 void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 				      u16 bmsr, u16 lpa);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
