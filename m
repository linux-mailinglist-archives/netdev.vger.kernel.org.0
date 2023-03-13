Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1246B74FC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCMLAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCMK76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:59:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5DA3646C;
        Mon, 13 Mar 2023 03:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O3FD0vzHt3JrLF9veBne7WsgoaPrHJaK9x+MbUdxVfM=; b=UEyD6dAm73IB1ECkQrVap24JDu
        hTrdEpEMZaOMIZ+mxsredAZNENAmujF3Z2ZfAgdR9IvDWJMYGoBXNnRyFWbcU4Jr2gl50uQ83oY3q
        VdlBi5yEs36XmA4RLG6dvhPdWVyVrABO4oxnkpawfgHVeaEpYOQNc/dAnEnQx9LjRNqPKIVq7UPr3
        /9Kd3Cu5Vw+40McdcT0GFTreMLN6S43oKcJ/PdsSJ9GyrrG9PqS0jnXh9G56tj5FfKeqCNXujuUnm
        J+eHz6Dh/O0hpdlAVYBfFWf7QRnTStpOn22HYd/SNAYxsgpBIOav5nfTz9OOad5E+BvYRN2G5scKM
        cBtrJOLg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49632)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pbftf-0002mf-1t; Mon, 13 Mar 2023 10:59:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pbftW-0007g1-GX; Mon, 13 Mar 2023 10:59:10 +0000
Date:   Mon, 13 Mar 2023 10:59:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc:
 fix 1000Base-X and 2500Base-X modes
Message-ID: <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
References: <ZAiciK5fElvLXYQ9@makrotopia.org>
 <ZAijM91F18lWC80+@shell.armlinux.org.uk>
 <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 08:05:41PM +0000, Russell King (Oracle) wrote:
> On Sun, Mar 12, 2023 at 01:40:36PM +0100, Frank Wunderlich wrote:
> > > Gesendet: Samstag, 11. März 2023 um 21:30 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > 
> > > On Sat, Mar 11, 2023 at 09:21:47PM +0100, Frank Wunderlich wrote:
> > > > Am 11. März 2023 21:00:20 MEZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> > > > >On Sat, Mar 11, 2023 at 01:05:37PM +0100, Frank Wunderlich wrote:
> > > > 
> > > > >> i got the 2.5G copper sfps, and tried them...they work well with the v12 (including this patch), but not in v13... 
> > > > 
> > > > >> how can we add a quirk to support this?
> > > > >
> > > > >Why does it need a quirk?
> > > > 
> > > > To disable the inband-mode for this 2.5g copper
> > > > sfp. But have not found a way to set a flag which i
> > > > can grab in phylink.
> > > 
> > > We could make sfp_parse_support() set Autoneg, Pause, and Asym_Pause
> > > in "modes" at the top of that function, and then use the SFP modes
> > > quirk to clear the Autoneg bit for this SFP. Would that work for you?
> > 
> > i already tried this (without moving the autoneg/pause to sfp_parse_support):
> > 
> > static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
> > 				unsigned long *modes,
> > 				unsigned long *interfaces)
> > {
> > 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
> > }
> > 
> > quirk was executed, but no change (no link on 2g5 sfp).
> 
> It won't have any effect on its own - because sfp_parse_support() does
> this:
> 
>         if (bus->sfp_quirk && bus->sfp_quirk->modes)
>                 bus->sfp_quirk->modes(id, modes, interfaces);
> 
>         linkmode_or(support, support, modes);
> 
>         phylink_set(support, Autoneg);
>         phylink_set(support, Pause);
>         phylink_set(support, Asym_Pause);
> 
> Which means clearing Autoneg in "modes" via the modes SFP quirk will
> have *absolutely* *no* *effect* what so ever.
> 
> The fact that you replied having *not* followed my suggestion and then
> itimiating that it doesn't work is very frustrating.
> 
> > i guess you mean moving code handling the dt-property for inband-mode in phylink_parse_mode (phylink.c) to the sfp-function (drivers/net/phy/sfp-bus.c)
> 
> No.
> 
> [rest of email cut because I can't be bothered to read it after this]
> 
> Please try what I suggested. You might find that it works.

Since describing what I wanted you to test didn't work, here's a patch
instead, based upon the quirk that you provided (which is what I'd have
written anyway). Add a "#define DEBUG" to the top of
drivers/net/phy/phylink.c in addition to applying this patch, and please
test the resulting kernel, sending me the resulting kernel messages, and
also reporting whether this works or not.

Thanks.

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index daac293e8ede..1dd50f2ca05d 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -151,6 +151,10 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	unsigned int br_min, br_nom, br_max;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 
+	phylink_set(modes, Autoneg);
+	phylink_set(modes, Pause);
+	phylink_set(modes, Asym_Pause);
+
 	/* Decode the bitrate information to MBd */
 	br_min = br_nom = br_max = 0;
 	if (id->base.br_nominal) {
@@ -329,10 +333,6 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		bus->sfp_quirk->modes(id, modes, interfaces);
 
 	linkmode_or(support, support, modes);
-
-	phylink_set(support, Autoneg);
-	phylink_set(support, Pause);
-	phylink_set(support, Asym_Pause);
 }
 EXPORT_SYMBOL_GPL(sfp_parse_support);
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 39e3095796d0..b054360bf636 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -360,6 +360,13 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
 }
 
+static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
+				      unsigned long *modes,
+				      unsigned long *interfaces)
+{
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
+}
+
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 				      unsigned long *modes,
 				      unsigned long *interfaces)
@@ -401,6 +408,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_disable_autoneg),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
