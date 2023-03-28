Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF76CC556
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjC1PNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjC1PNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:13:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2586610427
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 08:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GZLw+UhEhtX8SbTe2vpo/uAbM57E5FtiIDBRJRJAgMA=; b=OHaterXgTLCPWoCWfCDjbhzSrz
        roSuCTRje2iQQv3pmkISgzPc3xbXThtCX0VFK27TlkqHxG4E2Eb5TBEzahtLz9sA4CHr5RoGIDfHA
        OWlgdIb4ggUBid/HeIhvjBpCWJ/e6f/3rduNS2EAZxFKRb2p+citoFAr55ji4h5OjWi4eb3PH8jew
        WJU2+WRbwi/XWpMJY0hidBEwQafNn+crdWNGxdaoYjq8L42mp4BoodZ6NzVsIIaUpNxRJJfwcx3Xu
        FTiO8dkvvXkyjvZEGA+y+BuoSqQTbcCp9mLS6jfGcrEeYp2SOCG6rpu3rO6WT6aZnZKqZ4wFtIXFQ
        8Jm3YLrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60064)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1phAyW-0006Xe-Hh; Tue, 28 Mar 2023 16:11:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1phAyQ-0006Zp-9L; Tue, 28 Mar 2023 16:10:58 +0100
Date:   Tue, 28 Mar 2023 16:10:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZCMDgqBSvHigTcbb@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org>
 <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Any feedback with this patch applied? Can't move forward without that.

Thanks.

On Sat, Mar 25, 2023 at 07:36:10PM +0000, Russell King (Oracle) wrote:
> On Sat, Mar 25, 2023 at 03:35:01PM +0000, Daniel Golle wrote:
> > On Sat, Mar 25, 2023 at 02:05:51PM +0000, Russell King (Oracle) wrote:
> > > On Sat, Mar 25, 2023 at 02:12:16AM +0000, Daniel Golle wrote:
> > > > Hi Russell,
> > > > 
> > > > On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> > > > > Add a quirk for a copper SFP that identifies itself as "OEM"
> > > > > "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> > > > > at 2500base-X with the host without negotiation. Add a quirk to
> > > > > enable the 2500base-X interface mode with 2500base-T support, and
> > > > > disable autonegotiation.
> > > > > 
> > > > > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > > > > Tested-by: Frank Wunderlich <frank-w@public-files.de>
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > 
> > > > I've tried the same fix also with my 2500Base-T SFP module:
> > > > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > > > index 4223c9fa6902..c7a18a72d2c5 100644
> > > > --- a/drivers/net/phy/sfp.c
> > > > +++ b/drivers/net/phy/sfp.c
> > > > @@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] = {
> > > >         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
> > > >         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
> > > >         SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
> > > > +       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
> > > >  };
> > > > 
> > > >  static size_t sfp_strlen(const char *str, size_t maxlen)
> > > 
> > > Thanks for testing.
> > > 
> > > > However, the results are a bit of a mixed bag. The link now does come up
> > > > without having to manually disable autonegotiation. However, I see this
> > > > new warning in the bootlog:
> > > > [   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn 12154J6000864    dc 210606  
> > > > ...
> > > > [   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440
> > > 
> > > This will be the result of issuing an ethtool command, and phylink
> > > doesn't know what to do with the advertising mask - which is saying:
> > > 
> > >    Autoneg, Fibre, Pause, AsymPause
> > > 
> > > In other words, there are no capabilities to be advertised, which is
> > > invalid, and suggests user error. What ethtool command was being
> > > issued?
> > 
> > This was simply adding the interface to a bridge and bringing it up.
> > No ethtool involved afaik.
> 
> If its not ethtool, then there is only one other possibility which I
> thought had already been ruled out - and that is the PHY is actually
> accessible, but either we don't have a driver for it, or when reading
> the PHY's "features" we don't know what it is.
> 
> Therefore, as the PHY is accessible, we need to identify what it is
> and have a driver for it.
> 
> Please apply the following patch to print some useful information
> about the PHY:
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index aec8e48bdd4f..6b67262d5706 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2978,9 +2978,37 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
>  
>  	iface = sfp_select_interface(pl->sfp_bus, config.advertising);
>  	if (iface == PHY_INTERFACE_MODE_NA) {
> +		const int num_ids = ARRAY_SIZE(phy->c45_ids.device_ids);
> +		u32 id;
> +		int i;
> +
> +		if (phy->is_c45) {
> +			for (i = 0; i < num_ids; i++) {
> +				id = phy->c45_ids.device_ids[i];
> +				if (id != 0xffffffff)
> +					break;
> +			}
> +		} else {
> +			id = phy->phy_id;
> +		}
> +		phylink_err(pl,
> +			    "Clause %s PHY [0x%04x:0x%04x] driver %s found but\n",
> +			    phy->is_c45 ? "45" : "22",
> +			    id >> 16, id & 0xffff,
> +			    phy->drv ? phy->drv->name : "[unbound]");
>  		phylink_err(pl,
>  			    "selection of interface failed, advertisement %*pb\n",
>  			    __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising);
> +
> +		if (phy->is_c45) {
> +			phylink_err(pl, "Further PHY IDs:\n");
> +			for (i = 0; i < num_ids; i++) {
> +				id = phy->c45_ids.device_ids[i];
> +				if (id != 0xffffffff)
> +					phylink_err(pl, "  MMD %d [0x%04x:0x%04x]\n",
> +						    i, id >> 16, id & 0xffff);
> +			}
> +		}
>  		return -EINVAL;
>  	}
>  
> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
