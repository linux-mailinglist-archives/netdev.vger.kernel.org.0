Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78963E999F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhHKUWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:22:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhHKUWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 16:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LDjEdO9P0ODxsLGsG2JcyGHngVPH34DX96d4EXhJCzg=; b=GOQk2HR6UcDpW3ZKkS7Hcwo0SW
        8yP0ywd6OorJGYKHJaETX6+mJ8G6r5Auj19zbSywz8JJEUWNinRa7iVOylK0hvKC8eKb1fHouxEzG
        lp5FQ5S5m2Lh4fqNlSyEX/oy0INEcgt36Ah5bQT+aKCl1uD9m1D/pOdItj7c2Kt3oakA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDuk0-00HBEE-9l; Wed, 11 Aug 2021 22:22:20 +0200
Date:   Wed, 11 Aug 2021 22:22:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YRQxfJT/RjpL8JOZ@lunn.ch>
References: <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <YQ6pc6EZRLftmRh3@lunn.ch>
 <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
 <YRQViFYGsoG3OUCc@lunn.ch>
 <20210811201414.GX22278@shell.armlinux.org.uk>
 <20210811202019.seskua7bzagxis7u@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811202019.seskua7bzagxis7u@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 11:20:19PM +0300, Vladimir Oltean wrote:
> On Wed, Aug 11, 2021 at 09:14:14PM +0100, Russell King (Oracle) wrote:
> > On Wed, Aug 11, 2021 at 08:23:04PM +0200, Andrew Lunn wrote:
> > > > I hope that using "*-internal-delay-ps" for Mac would be the right option.
> > > > Shall i include these changes as we discussed in next revision of the patch? 
> > > 
> > > Yes, that seems sensible. But please limit them to the CPU port. Maybe
> > > return -EINVAL for other ports.
> > 
> > Hmm. Don't we want ports that are "MAC like" to behave "MAC like" ?
> > In other words, shouldn't a DSA port that can be connected to an
> > external PHY should accept the same properties as a conventional
> > Ethernet MAC e.g. in a SoC device?
> 
> +1, I thought the whole purpose of the discussion was to stop singling
> out the CPU port as being special in any way w.r.t. RGMII delays.

Yes, sorry.

What we don't want is it acting upon phy-mode.

     Andrew
