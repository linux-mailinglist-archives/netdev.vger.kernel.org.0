Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3DB381A66
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 20:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhEOSKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 14:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbhEOSKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 14:10:15 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D857C061573;
        Sat, 15 May 2021 11:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wOlTOFE5n/0jneKlt+4o7nsjiy/2iB/M63oih0hfUss=; b=N4C0nmHmV5VOfitc32Uz/Lyat7
        Z8xcUhT+wiMywNCLHWA2LG0SuAzTjVGSXFIiYIMwcpaYjn9vdWMgES42u1FKuJKJkRy8PIAp1RN7U
        UYqzgH+Rh/3dyEhcjT/v4GjD7wlCgAVIXSemNKoTQh8DncvUH8WXMbF4tp4Ah2KJ+h3ulXBhFP6R0
        tCUI1K3ClL7qXM+AQ7x7OYBaQjvyvNyPi+tSoYEPRMgdvrtc/MRYga4OKvLveoWIc2bXnrvv+91b+
        b1sriIcOIx06QZw8DdEC4CVFzyuwZkYbm1utl9u9bNXWz40//crNM9V+O0RaEf2LOsuc9IYz4RaB+
        lUKw0aeg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1lhyif-0008I1-1N; Sat, 15 May 2021 19:08:57 +0100
Date:   Sat, 15 May 2021 19:08:57 +0100
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
Message-ID: <20210515180856.GI11733@earth.li>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> On Sat, May 15, 2021 at 06:00:46PM +0100, Jonathan McDowell wrote:
> > On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> > > On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > > > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > > > Fix mixed whitespace and tab for define spacing.
> > > > 
> > > > Please add a patch [0/28] which describes the big picture of what
> > > > these changes are doing.
> > > > 
> > > > Also, this series is getting big. You might want to split it into two,
> > > > One containing the cleanup, and the second adding support for the new
> > > > switch.
> > > > 
> > > > 	Andrew
> > > 
> > > There is a 0/28. With all the changes. Could be that I messed the cc?
> > > I agree think it's better to split this for the mdio part, the cleanup
> > > and the changes needed for the internal phy.
> > 
> > FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
> > today. I currently use the GPIO MDIO driver because I saw issues with
> > the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> > both QCA8337 devices and traffic flows as expected, so no obvious
> > regressions from your changes.
> > 
> > I also tried switching to the IPQ8064 MDIO driver for my first device
> > (which is on the MDIO0 bus), but it's still not happy:
> > 
> > qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13
> > 
> 
> Can you try the v6 version of this series?

Both the v6 qca8k series and the separate ipq806x mdio series, yes?

> Anyway the fact that 0 is produced instead of a wrong value let me
> think that there is some problem with the mdio read. (on other device
> there was a problem of wrong id read but nerver 0). Could be that the
> bootloader on your board set the mdio MASTER disabled. I experienced
> this kind of problem when switching from the dsa driver and the legacy
> swconfig driver. On remove of the dsa driver, the swconfig didn't work
> as the bit was never cleared by the dsa driver and resulted in your
> case. (id 0 read from the mdio)
> 
> Do you want to try a quick patch so we can check if this is the case?
> (about the cover letter... sorry will check why i'm pushing this
> wrong)

There's definitely something odd going on here. I went back to mainline
to see what the situation is there. With the GPIO MDIO driver both
switches work (expected, as this is what I run with). I changed switch0
over to use the IPQ MDIO driver and it wasn't detected (but switch1
still on the GPIO MDIO driver was fine).

I then tried putting both switches onto the IPQ MDIO driver and in that
instance switch0 came up fine, while switch1 wasn't detected.

If there's a simple patch that might give more debug I can try it out.

J.

-- 
   "Reality Or Nothing!" -- Cold   |  .''`.  Debian GNU/Linux Developer
              Lazarus              | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
