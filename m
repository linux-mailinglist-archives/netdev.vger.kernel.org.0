Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4427F6A6E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfKJRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:00:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJRAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:00:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uWWNSJqKsK4gx8+98KOhYrPNuK9UZ/+4RYLTF6up4H4=; b=aDWV7oe+GVGaauLXcjVZwyw7Rp
        zJkfdsDy5Oq9MxZvlVtXs6Q36b1i/jJFlB3M+TE5W/lt6o/I0XrEcLyjhW870rhXvpgyM95JebJ9Q
        eO6kAt73PfAYs9LZ9kfDkf3H9rr0iDTUGWcSB+qXtbtL73StQG2uzB40O6dU8ifM5Tho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTqZs-0006yf-5J; Sun, 10 Nov 2019 18:00:40 +0100
Date:   Sun, 10 Nov 2019 18:00:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191110170040.GG25889@lunn.ch>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch>
 <20191110164007.GC25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110164007.GC25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 04:40:07PM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Nov 10, 2019 at 05:13:07PM +0100, Andrew Lunn wrote:
> > On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> > > Add core phylib help for supporting SFP sockets on PHYs.  This provides
> > > a mechanism to inform the SFP layer about PHY up/down events, and also
> > > unregister the SFP bus when the PHY is going away.
> > 
> > Hi Russell
> > 
> > What does the device tree binding look like? I think you have SFP
> > proprieties in the PHYs node?
> 
> Correct, just the same as network devices.  Hmm, however, neither are
> documented... oh dear, it looks like I need to figure out how this
> yaml stuff works. :(

Yes, that would be good. I also assume you have at least one DT patch
for one of the Marvell boards? Seeing that would also help.

FYI: It is good to see this feature added. It has been blocked for a
long time, but this implementation is actually nice and simple.

Thanks
	Andrew
