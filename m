Return-Path: <netdev+bounces-2642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2CC702C95
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 671371C20B31
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67063C8D6;
	Mon, 15 May 2023 12:23:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF2C2F7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:23:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4144E10C9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LNOMCtonqR66xu5GSvqIV03s4e626a6yMu2jvYZUqVs=; b=oaakdRBLCYSulpQflSL51Xygk/
	pJs9wqAPzKjuEWQdGfMc09H6vM9NaiOyOnv3dD+lJ7DaZ17XoMKW6YJxESJXsJlgGQmRZadiyJXlr
	yqGU/vVASC4Mn2V9nk8A1fwZvfGxXB1ZH5JAxdCQpI4xoUgN4CMVpH/X2722cHc5efQxiPNOPv9df
	qEfWIHRDxeRW9eHeqeadfSB4QSU7DVhTgmw5ID8Hr9OpoPLWBpVmoZAkKMoTl3spp8Ki+zMKfXtkx
	pzzcghAICExfmJQgAhm+JIgvvnc9OjeOVuqEDKTb01e3w2dxNt3AWQRMyS9VeHpzJ9phO9gEKhrhX
	TT728CKg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58140)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pyXED-0003iY-7g; Mon, 15 May 2023 13:23:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pyXE2-0008Bi-54; Mon, 15 May 2023 13:22:50 +0100
Date: Mon, 15 May 2023 13:22:50 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>, Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC] Providing a helper for PCS inband negotiation
Message-ID: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

All,

One issue that seems to come up with PCS drivers is when should inband
negotiation be enabled. Some SFP modules have specific requirements when
it comes to whether inband AN should be enabled.

Having each network driver implement their own decision making is rather
sub-optimal as this doesn't lead to maximum inter-operability and a
consistent experience with SFP modules when used with different network
drivers.

This has been bugging me for a while, and I've had in my net-queue some
patches that introduced a simple helper that took the code in
phylink_mii_c22_pcs_config() and pulled that into an inline function:

        if (mode == MLO_AN_INBAND &&
            (interface == PHY_INTERFACE_MODE_SGMII ||
             interface == PHY_INTERFACE_MODE_QSGMII ||
             linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))

but I haven't been happy with this approach. I did this when working on
the mv88e6xxx conversion to phylink-PCS, because I didn't want to
duplicate that decision making in that driver.

Having been through all PCS drivers thus far, the majority of them are
concerned with "should some form of in-band signalling be enabled or
not?" and a simple boolean would suffice for that.

However, there are two (sparx5 and lan966x) which appear to want
slightly more information than that. These have a port configuration
structure that wants to know if we are using inband mode (in other
words, phylink is in MLO_AN_INBAND mode) and whether autoneg is
enabled (the Autoneg bit in the advertising bitmap.) See
lan966x_pcs_config().

This is further decoded in lan966x_port_pcs_set() such that if we're in
MLO_AN_INBAND mode, and:
 if we're using SGMII, or
 if the number of ports is four (QSGMII, QUSGMII), or
 if we're in 1000base-X mode and Autoneg is set,
then inband mode is enabled. However, if we aren't in MLO_AN_INBAND
mode, then an "outband" mode is used (driver's terminology, but the
comments about it seem to talk about "inband" here.)

It looks like Sparx5 is pretty similar to lan966x.

So, it seems that a boolean won't do, and we at least need a tristate
outband/inband-an-disabled/inband-an-enabled indication.

However, we also have to remember that there are protocols such as
10GBASE-R which do not have any inband capability. This suggests we
actually need a quad-state - none/outband/inband-an-disabled/
inband-an-enabled. That said, we have hardly any PCS that this would
end up returning "NONE" - but there are some (e.g. mvneta and mvpp2
which always provide a PCS, even for e.g. RGMII.)

So, to cover this, I'm proposing a series of steps:

1. introduce a new helper function - phylink_pcs_neg_mode() - as per
   the patch below
2. switch phylink_mii_c22_pcs_config() to use it
3. pull that helper into phylink_mii_c22_pcs_config() callers
4. convert all pcs_config() implementations that fiddle with inband AN
   configuration to use this helper
5. finally pull the helper up into phylink and change the pcs_config()
   method prototype:

-       int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
-                         phy_interface_t interface,
+       int (*pcs_config)(struct phylink_pcs *pcs, phy_interface_t interface,
                          const unsigned long *advertising,
+                         unsigned int neg_mode,
                          bool permit_pause_to_mac);

There are two questions that came up while creating the patches for the
above five steps:

1. Should 10GBASE-KR be included in the SGMII et.al. case in the code?
   Any other interface modes that should be there? Obviously,
   PHYLINK_PCS_NEG_NONE is not correct for 10GBASE-KR since it does use
   inband AN. Does it make sense for the user to disable inband AN for
   10GBASE-KR? If so, maybe it should be under the 1000base-X case.

2. XLGMII.. Looking at the XPCS driver, it's unclear whether Clause 73
   AN gets used for this. A quick scan of IEEE 802.3 suggests that
   XLGMII doesn't have any support for any inband signalling, and it's
   just an intermediary protocol between the MAC (more specifically the
   RS, but for the purposes of this I'll just refer to MAC) and the
   attached PCS, and any autonegotiation happens after the XLGMII link.

   In terms of PCS, until PHY_INTERFACE_MODE_XLGMII was introduced, the
   PHY interface mode for serdes based protocols described the protocol
   used on the media side of the PCS and the next part of the system
   towards the media, but XLGMII describes the MAC-to-PCS protocol
   (which could equally be GMII, XGMII etc). For example, in 802.3, the
   stack for 1000BASE-X describes the MAC-to-PCS link as GMII, but we
   have omitted that detail, and we just call it
   PHY_INTERFACE_MODE_1000BASEX.

   PHY_INTERFACE_MODE_XLGMII has as much meaning whether the PCS uses
   media-facing inband AN as PHY_INTERFACE_MODE_GMII would do if it
   were to be used with a PCS operating in SGMII or 1000BASE-X mode.

   If XLGMII is used with a PCS that supports clause 73 AN, then there
   is obviously AN involved. However, XLGMII can also be used with a
   PCS/PMA/PMD that ends up producing 40GBASE-R which has no inband AN.

   So, I'm not sure what the behaviour of phylink_pcs_neg_mode() should
   be when faced with PHY_INTERFACE_MODE_XLGMII - does this need yet
   another state?

3. Should the pcs_link_up() method also be passed this "neg_mode" state
   and should the existing "mode" argument be dropped?

Finally, there's the obvious question whether this approach is even a
good idea.

Please let me have some thoughts.

8<===
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: phylink: add phylink_pcs_neg_mode()

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 8968094503d6..465248818276 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,18 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* PCS "negotiation" mode.
+	 *  PHYLINK_PCS_NEG_NONE - protocol has no inband capability
+	 *  PHYLINK_PCS_NEG_OUTBAND - some out of band or fixed link setting
+	 *  PHYLINK_PCS_NEG_INBAND_DISABLED - inband mode disabled, e.g.
+	 *				      1000base-X with autoneg off
+	 *  PHYLINK_PCS_NEG_INBAND_ENABLED - inband mode enabled
+	 */
+	PHYLINK_PCS_NEG_NONE = 0,
+	PHYLINK_PCS_NEG_OUTBAND,
+	PHYLINK_PCS_NEG_INBAND_DISABLED,
+	PHYLINK_PCS_NEG_INBAND_ENABLED,
+
 	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our
 	 * autonegotiation advertisement. They correspond to the PAUSE and
 	 * ASM_DIR bits defined by 802.3, respectively.
@@ -79,6 +91,67 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
 	return mode == MLO_AN_INBAND;
 }
 
+/**
+ * phylink_pcs_neg_mode() - helper to determine PCS inband mode
+ * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @interface: interface mode to be used
+ * @advertising: adertisement ethtool link mode mask
+ *
+ * Determines the negotiation mode to be used by the PCS, and returns
+ * one of:
+ * %PHYLINK_PCS_NEG_NONE: interface mode does not support inband
+ * %PHYLINK_PCS_NEG_OUTBAND: an out of band mode (e.g. reading the PHY,
+ *   or fixed link) will be used.
+ * %PHYLINK_PCS_NEG_INBAND_DISABLED: inband mode selected but autoneg disabled
+ * %PHYLINK_PCS_NEG_INBAND_ENABLED: inband mode selected and autoneg enabled
+ */
+static inline unsigned int phylink_pcs_neg_mode(unsigned int mode,
+						phy_interface_t interface,
+						const unsigned long *advertising)
+{
+	unsigned int neg_mode;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+		/* These protocols are designed for use with a PHY which
+		 * communicates its negotiation result back to the MAC via
+		 * inband communication. Note: there exist PHYs that run
+		 * with SGMII but do not send the inband data.
+		 */
+		if (!phylink_autoneg_inband(mode))
+			neg_mode = PHYLINK_PCS_NEG_OUTBAND;
+		else
+			neg_mode = PHYLINK_PCS_NEG_INBAND_ENABLED;
+		break;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* 1000base-X is designed for use media-side for Fibre
+		 * connections, and thus the Autoneg bit needs to be
+		 * taken into account. We also do this for 2500base-X
+		 * as well, but drivers may not support this, so may
+		 * need to override this.
+		 */
+		if (!phylink_autoneg_inband(mode))
+			neg_mode = PHYLINK_PCS_NEG_OUTBAND;
+		else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   advertising))
+			neg_mode = PHYLINK_PCS_NEG_INBAND_ENABLED;
+		else
+			neg_mode = PHYLINK_PCS_NEG_INBAND_DISABLED;
+		break;
+
+	default:
+		neg_mode = PHYLINK_PCS_NEG_NONE;
+		break;
+	}
+
+	return neg_mode;
+}
+
 /**
  * struct phylink_link_state - link state structure
  * @advertising: ethtool bitmask containing advertised link modes
-- 
2.30.2


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

