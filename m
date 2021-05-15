Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A76381BC3
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 01:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhEOXxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 19:53:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230102AbhEOXx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 19:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RP7yGAEHZlhCRQ2Dd9FV88IXokX2WkuH4I1RMy1fDuA=; b=wmE93zq4qsXp62qUP9gyku4vin
        jJZ5XJx3eBfJfB1dYbWETZylRioIp9dgyqQsatqaSCftXhIU4+HTdr5eDsZIio8viOBLMjJW05pga
        sL60/Bdj4Qad7tSdU6eqXm+8M6pzA8wYotI/wVs0c1O2IT7szUa5hsEBbwvqoj+BZhgo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1li44j-004NOO-Q4; Sun, 16 May 2021 01:52:05 +0200
Date:   Sun, 16 May 2021 01:52:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <YKBepW5Hu3FEG/JJ@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
 <20210515180856.GI11733@earth.li>
 <YKAQ+BggTCzc7aZW@Ansuel-xps.localdomain>
 <20210515194047.GJ11733@earth.li>
 <YKAlUEt/9MU8CwsQ@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKAlUEt/9MU8CwsQ@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > They're on 2 separate sets of GPIOs if that makes a difference - switch0
> > is in gpio0/1 and switch1 is on gpio10/11. Is the internal MDIO logic
> > shared between these? Also even if that's the case it seems odd that
> > enabling the MDIO for just switch0 doesn't work?
> > 
> 
> The dedicated internal mdio on ipq8064 is unique and present on the
> gmac0 address so yes it's shared between them. And this seems to be the
> problem... As you notice the fact that different gpio are used for the
> different switch fix the problem. So think that to use the dedicated
> mdio bus with both switch we need to introduce some type of
> syncronization or something like that.

Please could you describe the hardware in a bit more details. Or point
me at a datasheet. It sounds like you have an MDIO mux? Linux has this
concept, so you might need to implement a mux driver.

	 Andrew
