Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4486381ACC
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhEOTmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 15:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEOTmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 15:42:06 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC812C061573;
        Sat, 15 May 2021 12:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IjqDp8O5NJ+zoGq0FQ1xKCJFm8mUR8j3GDLhuG65CYA=; b=Sg74buj71+LkuXDL/yyQ1e0wfS
        A6AfR4YDMBAEYW68nTpqxiBmImx1iyfPEnoFb/NPlWTWITxHWBn0vuLtLk26z3NlGV3dQ5SDjOM4V
        h6gb/8WA1PlE8VR34UpcavemuUDk7vZ7WnOki3Tp8VlipGdPNV5VFiES4gOm5TW0tfhwdAASJfi6V
        fvGg7vF6/O1B0nD+E45m8k98+5s9XEGTUrPNU0X1iWON8byYVd02kv9xAp7ex1Ps92tkodIWWuNOT
        bIyukQxEF5QXO76lWoxN7OEMl6LcuGSikvg+RRKbgBF+6TQX3nbvpQq27s5pwZ9GcvTBJvABOJX0o
        y82PLi0w==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1li09X-0004CR-9o; Sat, 15 May 2021 20:40:47 +0100
Date:   Sat, 15 May 2021 20:40:47 +0100
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
Message-ID: <20210515194047.GJ11733@earth.li>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
 <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 08:20:40PM +0200, Ansuel Smith wrote:
> On Sat, May 15, 2021 at 07:08:57PM +0100, Jonathan McDowell wrote:
> > On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> > > Do you want to try a quick patch so we can check if this is the case?
> > > (about the cover letter... sorry will check why i'm pushing this
> > > wrong)
> > 
> > There's definitely something odd going on here. I went back to mainline
> > to see what the situation is there. With the GPIO MDIO driver both
> > switches work (expected, as this is what I run with). I changed switch0
> > over to use the IPQ MDIO driver and it wasn't detected (but switch1
> > still on the GPIO MDIO driver was fine).
> > 
> > I then tried putting both switches onto the IPQ MDIO driver and in that
> > instance switch0 came up fine, while switch1 wasn't detected.
> > 
> 
> Oh wait, your board have 2 different switch? So they both use the master
> bit when used... Mhhh I need to think about this if there is a clean way
> to handle this. The idea would be that one of the 2 dsa switch should
> use the already defined mdio bus.
> 
> The problem here is that to use the internal mdio bus, a bit must be
> set or 0 is read on every value (as the bit actually disable the internal
> mdio). This is good if one dsa driver is used but when 2 or more are
> used I think this clash and only one of them work. The gpio mdio path is
> not affected by this. Will check if I can find some way to address this.

They're on 2 separate sets of GPIOs if that makes a difference - switch0
is in gpio0/1 and switch1 is on gpio10/11. Is the internal MDIO logic
shared between these? Also even if that's the case it seems odd that
enabling the MDIO for just switch0 doesn't work?

J.

-- 
101 things you can't have too much of : 3 - Sleep.
