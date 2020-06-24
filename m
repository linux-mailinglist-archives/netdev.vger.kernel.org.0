Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996E9207B45
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405971AbgFXSMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405690AbgFXSMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:12:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CDFC061573;
        Wed, 24 Jun 2020 11:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z9HGbz+i6aHgJQXofmlkGLhFMu6I+bLstfwl+Ma+zic=; b=eRPnkRW6qklePwWdOAxb9JwS5
        xS/ipXvEOLPqG4rxDeMRcG82RsrzUCvlxUPV++hqZSGvg7m+0koWn+/qWbczE3ftK5VXsUmEKeGD7
        AB4a32kvTcbax4HOssHxQyYT21aJhimITT46A8sQ2LC7hG84yuxXWn9jNSI6eTwGmdMKwomXVoasZ
        L1BT/ft/Ds3U2spVpTR7SaMQJOdFywAQMXo4f5ky4Nci1Q+2ddqgLQNHxftwk7EY1I1mfp3helzVV
        UiDmm24VR+g4qSeYdmWzmuiiKB8eO9juK17D9oUR/dD5JJU/ICdldi21DUhuKE/ryuuYT36s4gOYJ
        ONsOu6V1g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59252)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo9sn-0003SY-Gh; Wed, 24 Jun 2020 19:12:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo9sh-0002BU-2m; Wed, 24 Jun 2020 19:12:19 +0100
Date:   Wed, 24 Jun 2020 19:12:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Fabien Parent <fparent@baylibre.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
Message-ID: <20200624181218.GC1551@shell.armlinux.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-15-brgl@bgdev.pl>
 <20200622132921.GI1551@shell.armlinux.org.uk>
 <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
 <20200623094252.GS1551@shell.armlinux.org.uk>
 <CAMpxmJVP9db-4-AA4e1JkEfrajvJ4s0T6zo5+oFzpJHRBcuSsg@mail.gmail.com>
 <20200623095646.GT1551@shell.armlinux.org.uk>
 <CAMRc=MeKE12sXZycyGA7vmjNai0JfDhRX+XDTp3r3YtrmLQj3A@mail.gmail.com>
 <20200624165719.GB1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200624165719.GB1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 05:57:19PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Jun 23, 2020 at 06:27:06PM +0200, Bartosz Golaszewski wrote:
> > wt., 23 cze 2020 o 11:56 Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> napisał(a):
> > >
> > > On Tue, Jun 23, 2020 at 11:46:15AM +0200, Bartosz Golaszewski wrote:
> > > > wt., 23 cze 2020 o 11:43 Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> napisał(a):
> > > > >
> > > > > On Tue, Jun 23, 2020 at 11:41:11AM +0200, Bartosz Golaszewski wrote:
> > > > > > pon., 22 cze 2020 o 15:29 Russell King - ARM Linux admin
> > > > > > <linux@armlinux.org.uk> napisał(a):
> > > > > > >
> > > > > >
> > > > > > [snip!]
> > > > > >
> > > > > > >
> > > > > > > This is likely to cause issues for some PHY drivers.  Note that we have
> > > > > > > some PHY drivers which register a temperature sensor in the probe
> > > > > > > function, which means they can be accessed independently of the lifetime
> > > > > > > of the PHY bound to the network driver (which may only be while the
> > > > > > > network device is "up".)  We certainly do not want hwmon failing just
> > > > > > > because the network device is down.
> > > > > > >
> > > > > > > That's kind of worked around for the reset stuff, because there are two
> > > > > > > layers to that: the mdio device layer reset support which knows nothing
> > > > > > > of the PHY binding state to the network driver, and the phylib reset
> > > > > > > support, but it is not nice.
> > > > > > >
> > > > > >
> > > > > > Regulators are reference counted so if the hwmon driver enables it
> > > > > > using mdio_device_power_on() it will stay on even after the PHY driver
> > > > > > calls phy_device_power_off(), right? Am I missing something?
> > > > >
> > > > > If that is true, you will need to audit the PHY drivers to add that.
> > > > >
> > > >
> > > > This change doesn't have any effect on devices which don't have a
> > > > regulator assigned in DT though. The one I'm adding in the last patch
> > > > is the first to use this.
> > >
> > > It's quality of implementation.
> > >
> > > Should we wait for someone else to make use of the new regulator
> > > support that has been added with a PHY that uses hwmon, and they
> > > don't realise that it breaks hwmon on it, and several kernel versions
> > > go by without it being noticed.  It will only be a noticable issue
> > > when the associated network device is down, and that network device
> > > driver detaches from the PHY, so _is_ likely not to be noticed.
> > >
> > > Or should we do a small amount of work now to properly implement
> > > regulator support, which includes a trivial grep for "hwmon" amongst
> > > the PHY drivers, and add the necessary call to avoid the regulator
> > > being shut off.
> > >
> > 
> > I'm not sure what the correct approach is here. Provide some helper
> > that, when called, would increase the regulator's reference count even
> > more to keep it enabled from the moment hwmon is registered to when
> > the driver is detached?
> 
> I think a PHY driver needs the utility to control this.  We need to be
> careful here with naming, because phylib is not the only code in the
> kernel that uses the phy_ prefix.
> 
> If we had runtime PM support for PHYs, with regulator support hooked
> into runtime PM, then we already have standard interfaces that drivers
> can use to control whether the device gets powered down.

Other ideas:

- using genpd outside of the SoC to provide power domain management.
  This is already hooked into runtime PM, but would need their
  agreement, a genpd provider written, and runtime PM added to phylib.

- if we're going for some core driver model approach, then the driver
  model only knows when devices are bound and unbound to their driver,
  it knows nothing of phylib's attach/detach from the network
  interface.  If we want to shut off power when a PHY is not attached,
  we would likely need some kind of interface to do that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
