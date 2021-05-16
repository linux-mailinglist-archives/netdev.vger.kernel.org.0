Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD97F381DAE
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhEPJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhEPJi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 05:38:28 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECFC061573;
        Sun, 16 May 2021 02:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rJh4Vdo5L1QIm502PoGYhFOjqJgCYsz59OFOfwGXTfM=; b=IHR5xqzX8OqoIC4Z7tfna9w4sW
        FYzgqfxjXOi3Sj90pGKtPXq0zx0UgUa16GNH0Fqkf1xVnCgX+1PvNUmxxztG14RMiESc3PmPoxcnH
        /Jxy6wTxLajsJuyxas/nAZO6LP+yQ6CLc37QvaC0T91A7V2ZllQp0lnbx9WijLuLDO+z8k06xab7G
        2JupSs8BWRWc0tCOLsTgUZZKBfeTyHEsR3nk52YhMe1BmMxdYyHLeRjemxL1nuJ9ICff/olgm3oxC
        O+YsM3HyjwiCjTi/J7zi8OVCld5ve4dElrUp1AyT6N16hwTWffMBmES3Qa59vIIG9yUDDfcnt0EHs
        os1CYyoA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1liDCt-0001UJ-5B; Sun, 16 May 2021 10:37:07 +0100
Date:   Sun, 16 May 2021 10:37:07 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <20210516093707.GL11733@earth.li>
References: <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
 <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
 <20210515194047.GJ11733@earth.li>
 <YKAlUEt/9MU8CwsQ@Ansuel-xps.localdomain>
 <YKBepW5Hu3FEG/JJ@lunn.ch>
 <YKBl9kK3AvG1wWXZ@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKBl9kK3AvG1wWXZ@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 02:23:18AM +0200, Ansuel Smith wrote:
> On Sun, May 16, 2021 at 01:52:05AM +0200, Andrew Lunn wrote:
> > > > They're on 2 separate sets of GPIOs if that makes a difference - switch0
> > > > is in gpio0/1 and switch1 is on gpio10/11. Is the internal MDIO logic
> > > > shared between these? Also even if that's the case it seems odd that
> > > > enabling the MDIO for just switch0 doesn't work?
> > > > 
> > > 
> > > The dedicated internal mdio on ipq8064 is unique and present on the
> > > gmac0 address so yes it's shared between them. And this seems to be the
> > > problem... As you notice the fact that different gpio are used for the
> > > different switch fix the problem. So think that to use the dedicated
> > > mdio bus with both switch we need to introduce some type of
> > > syncronization or something like that.
> > 
> > Please could you describe the hardware in a bit more details. Or point
> > me at a datasheet. It sounds like you have an MDIO mux? Linux has this
> > concept, so you might need to implement a mux driver.
> > 
> > 	 Andrew
> 
> Datasheet of ipq8064 are hard to find and pricey.
> Will try hoping I don't write something very wrong.
> Anyway on the SoC there are 4 gmac (most of the time 2 are used
> and represent the 2 cpu port) and one mdio bus present on the gmac0
> address. 

There's a suggestion of an additional mdio bus on the gmac1 address at:

https://github.com/adron-s/openwrt-rb3011/commit/dd63b3ef563fa77fd2fb7d6ca12ca9411cd18740

is that not accurate?

J.

-- 
   Funny how life imitates LSD.    |  .''`.  Debian GNU/Linux Developer
                                   | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
