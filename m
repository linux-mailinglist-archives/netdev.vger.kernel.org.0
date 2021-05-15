Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504A4381A23
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhEORX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 13:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhEORXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 13:23:24 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 May 2021 10:22:11 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE34C061573
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 10:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f0k3lHKtG/ZkOly2oq7mc5cCa+BWDV/Ypd4A6WgvIC4=; b=RUZRKb/EqSt0rmyZX3ENGtmlZn
        CBz3NJkUmpcsIDxZSExaEFPUo83apS0TISknZ1PpPlxzJaXSNu1ZRJVNcJGfh0fMhh5DNXUju08w9
        npg6akZcqwT2w7gNwkBzEWnDMHW5YNnWBb45ySOfM44Xbn8lzKMMfkHcosQZ9DP6uqLgsIWQZXQ07
        4ObFDdT0DX9MsMVfJx0DWpWbji87SIhxLBcjUcw3MeABTnPFptlVlsRzNWhdKGqtVx6lC5PQjOfAI
        eNeUMiRhjGIbob6zi/hjgdsJYA1+E8VVzQwtl/NgWxrzuJtHYVCeug0iHCJtxzdWbeq/puFj0FNVx
        u/8jyRew==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1lhxeg-0004qI-Dd; Sat, 15 May 2021 18:00:46 +0100
Date:   Sat, 15 May 2021 18:00:46 +0100
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
Message-ID: <20210515170046.GA18069@earth.li>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > Fix mixed whitespace and tab for define spacing.
> > 
> > Please add a patch [0/28] which describes the big picture of what
> > these changes are doing.
> > 
> > Also, this series is getting big. You might want to split it into two,
> > One containing the cleanup, and the second adding support for the new
> > switch.
> > 
> > 	Andrew
> 
> There is a 0/28. With all the changes. Could be that I messed the cc?
> I agree think it's better to split this for the mdio part, the cleanup
> and the changes needed for the internal phy.

FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
today. I currently use the GPIO MDIO driver because I saw issues with
the IPQ8064 driver in the past, and sticking with the GPIO driver I see
both QCA8337 devices and traffic flows as expected, so no obvious
regressions from your changes.

I also tried switching to the IPQ8064 MDIO driver for my first device
(which is on the MDIO0 bus), but it's still not happy:

qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13

J.

-- 
One of the nice things about standards is that there are so many of
them.
