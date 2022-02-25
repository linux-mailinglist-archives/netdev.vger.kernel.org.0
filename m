Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FD4C4D67
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 19:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiBYSMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 13:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiBYSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 13:12:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A09E1D6CA6
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 10:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dj2jcqipJCECW6kk37htHrvlk7NA1+PMDe6aZz9lpd0=; b=lFn++ljEguPYnVPTRjl20hxKrS
        /8YTyahr8wJU6gN4SfdQRREHESMarZz4w/A3QLGKg4IQHfdJmkufuzFzcyoabjZL1pUkQWYzJ4NBX
        OYaI30L+lQXoc1tlwiaFgdh1+bwhs5y+LXbdkq5p/OPMMBjkgHLgC19acUtyGvZfUkR6Vngr9wmZL
        O2bAaSZdqYorM7Eoh2YVD+D5gLaEBnCdEjudLhpzw7RcCrN9n2lphCsaR+yg66ogAjtyCizMPNLiC
        Zzdms0CsqaFL7CTbWeJhad9xJ+czH64T146xrzd1GN8uybzq85uvWcN/MiMamW5YaB8MZRQqEZWAx
        /Mvx1Veg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57508)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNf4E-0005xC-8l; Fri, 25 Feb 2022 18:11:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNf4C-0003Iy-BL; Fri, 25 Feb 2022 18:11:44 +0000
Date:   Fri, 25 Feb 2022 18:11:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Further phylink changes (was: [PATCH net-next 1/4] net: dsa:
 ocelot: populate supported_interfaces)
Message-ID: <Yhkb4Ll/oOpEceY5@shell.armlinux.org.uk>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
 <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
 <20220225162530.cnt4da7zpo6gxl4z@skbuf>
 <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
 <20220225181653.00708f13@thinkpad>
 <YhkUidpCbLjrdMAE@shell.armlinux.org.uk>
 <YhkYjTQfHT8MSyCe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhkYjTQfHT8MSyCe@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 06:57:33PM +0100, Andrew Lunn wrote:
> > ... changing the subject line to show we've drifted off topic ...
> > 
> > Yes, once we've worked out what the PCS interface should look like in
> > order to deal with the 88E6393 errata workaround that needs to be run
> > each time the interface changes or whenever we "power up" the PCS.
> 
> Hi Russell
> 
> The erratas are not limited to 6393. For the 6390 there is an errata
> where you need to "power up" the PCS before you change cmode,
> otherwise TX works, but RX just drops frames rather than pass them to
> the MAC.
> 
> I've not looked at the details of your proposal, and maybe it is a
> none issue, i just wanted to make sure you are aware of this.

Thanks - Marek has been keeping me on the straight and narrow with
these issues, but it's good to know that it's not necessary for the
other Marvell variants. That's been at the back of my mind a bit as
we're getting closer to the point that we need to sort this out.

I should also mention - once the mt7530 and mv88e6xxx drivers are
sorted, I believe we will then be in a position to kill off all the
"legacy_pre_march2020" stuff in DSA since DSA will no longer need the
legacy phylink behaviour.

Sadly, though, that doesn't mean "legacy_pre_march2020" can be removed,
we still have mtk_eth_soc reliant on the old behaviour.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
