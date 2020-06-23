Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8A204E3C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbgFWJm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731935AbgFWJm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:42:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A799C061573;
        Tue, 23 Jun 2020 02:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XwLVMpP6cYtFVBzdSro7PxdncqYRVnLMVLk9It8eSnA=; b=tf+1p30e2HRfibZvcGIgWdm64
        euHfgRqyIfJz7Z14X4KDLhvTmozwXi1YqbRvoVo5SQkM7ggoaV/Y99/dRdEZJaIHh1OnwrAB5srvi
        I+Z+7oavGotEH8SpPoeiEwilvM+NIuGKNEj9LXSqjUbxmSAMmwY36mKHP1OwNJv6N0MgpyjPjnLHK
        7id5NOZoBZntIPhqMq/OB8L+PQXSRAfl0F7MQ7v62+dbKk/6t+O8J/TRocgljM3EdK3rF0C/MZ+Ba
        qESqMzjrtcNDj6/wB9iNZwTzSWmBf55iojTnVK+9yICH6SxlweILkm7rh3VkkSvgCobKe9Cr5ZrC9
        nmscJw74Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59010)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnfSA-0001aO-Th; Tue, 23 Jun 2020 10:42:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnfS8-0000vV-68; Tue, 23 Jun 2020 10:42:52 +0100
Date:   Tue, 23 Jun 2020 10:42:52 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        devicetree <devicetree@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
Message-ID: <20200623094252.GS1551@shell.armlinux.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-15-brgl@bgdev.pl>
 <20200622132921.GI1551@shell.armlinux.org.uk>
 <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:41:11AM +0200, Bartosz Golaszewski wrote:
> pon., 22 cze 2020 o 15:29 Russell King - ARM Linux admin
> <linux@armlinux.org.uk> napisał(a):
> >
> 
> [snip!]
> 
> >
> > This is likely to cause issues for some PHY drivers.  Note that we have
> > some PHY drivers which register a temperature sensor in the probe
> > function, which means they can be accessed independently of the lifetime
> > of the PHY bound to the network driver (which may only be while the
> > network device is "up".)  We certainly do not want hwmon failing just
> > because the network device is down.
> >
> > That's kind of worked around for the reset stuff, because there are two
> > layers to that: the mdio device layer reset support which knows nothing
> > of the PHY binding state to the network driver, and the phylib reset
> > support, but it is not nice.
> >
> 
> Regulators are reference counted so if the hwmon driver enables it
> using mdio_device_power_on() it will stay on even after the PHY driver
> calls phy_device_power_off(), right? Am I missing something?

If that is true, you will need to audit the PHY drivers to add that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
