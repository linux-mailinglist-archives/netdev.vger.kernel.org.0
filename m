Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4289381DD2
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhEPKOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 06:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhEPKOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 06:14:17 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3319FC061573;
        Sun, 16 May 2021 03:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g8QB6yztG+5GVE6Co+uxFUz4jHrahIGfUrGLMnquTHY=; b=U3juSUgcNxvCZEhiyEwIPI6wVK
        TjbgnSwZlPkNc6Q3KOIJ4jrpzYeLY4UXbAh/vPeMYnbzuWTcxrMoYecz1SyCbvdbHe4MVUWe7V1AB
        d9nt4EpMIIwN36E/dPK4UhPYNRHWfnkSZnmsrTEz63T6WOflCToXHNDuPNiRTaMdR+wbF6KpRbd/O
        pHxsT0YABfNU1gfofWDljGmva5WhdCuIhZr9x0RGwyvRewi0FAQyov90Fm6UD5FPWkT/ayS56xPJ1
        agpb8+IuNcDtRchKLCIe+5qYCWIkhh7YxExU1Sq8H6dCvc/hbWawnTZVtyz00Mn5vflkMOkHoHhUT
        XcchVfew==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1liDla-0002cQ-U2; Sun, 16 May 2021 11:12:58 +0100
Date:   Sun, 16 May 2021 11:12:58 +0100
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
Message-ID: <20210516101258.GN11733@earth.li>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210516094959.GM11733@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516094959.GM11733@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 10:49:59AM +0100, Jonathan McDowell wrote:
> On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> > On Sat, May 15, 2021 at 06:00:46PM +0100, Jonathan McDowell wrote:
> > > On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> > > > On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > > > > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > > > > Fix mixed whitespace and tab for define spacing.
> > > > > 
> > > > > Please add a patch [0/28] which describes the big picture of what
> > > > > these changes are doing.
> > > > > 
> > > > > Also, this series is getting big. You might want to split it into two,
> > > > > One containing the cleanup, and the second adding support for the new
> > > > > switch.
> > > > > 
> > > > > 	Andrew
> > > > 
> > > > There is a 0/28. With all the changes. Could be that I messed the cc?
> > > > I agree think it's better to split this for the mdio part, the cleanup
> > > > and the changes needed for the internal phy.
> > > 
> > > FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
> > > today. I currently use the GPIO MDIO driver because I saw issues with
> > > the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> > > both QCA8337 devices and traffic flows as expected, so no obvious
> > > regressions from your changes.
> > > 
> > > I also tried switching to the IPQ8064 MDIO driver for my first device
> > > (which is on the MDIO0 bus), but it's still not happy:
> > > 
> > > qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13
> > > 
> > Can you try the v6 version of this series?
> 
> FWIW I tried v6 without altering my DT at all (so still using the GPIO
> MDIO driver, and not switching to use the alternate PHY support) and got
> an oops due to a NULL pointer dereference, apparently in the mdio_bus
> locking code. I'm back porting to 5.10.37 (because I track LTS on the
> device) so I might be missing something, but the v4 version I tried
> previously worked ok.

I dropped patches 20-25 of the series (i.e. the piece that adds the
internal phy/mdio support) and tried again and that works fine, so it
does look like I either managed to mismerge them somehow (and those
pieces weren't the ones with conflicts) or there's a problem (possibly
only when the DT hasn't been updated to use the internal bus?).

J.

-- 
   101 things you can't have too   |  .''`.  Debian GNU/Linux Developer
     much of : 45 - Toblerone.     | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
