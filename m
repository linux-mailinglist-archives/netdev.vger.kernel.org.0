Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33B6198484
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgC3Teh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:34:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57272 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgC3Teh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ouCCrxgpC9lrAW88GEI9j87liXixId89uU7gxnry/GA=; b=S/E+w9RAhZJEE41C/xlapLhbD
        5EwrWK+Ja5MMBJ1Vpvp0su+XGw1Qvgzo0VCBCUqMPv7GrJcasvY9X1ZYHG4H2JWYzVyLUqIVry0BE
        uT0g/GJCYzNuSBFlwqG8nEBY27219G3gxnummMJRcID00BGsW9rDMASRM/IGPPHxFjAQjbUbWMRjW
        o+w7y9CT1P5Jd78QCDLja9t6p1QUTqjlKWMcHjLhpsLYbajPriUaDdZeNg5ItMKdcbXA7i5SmRexM
        Zh0ttMV+3LGxLOtXAwkUkz+BURp96qxjELz3JmGolqQdEQ9uoEvdVqGrFkGjLyaOnkijwJvsBiRME
        bJYbrb2Rw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43466)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJ0AU-0003y8-St; Mon, 30 Mar 2020 20:33:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJ0AM-0007Nx-UP; Mon, 30 Mar 2020 20:33:46 +0100
Date:   Mon, 30 Mar 2020 20:33:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Update my email address in various drivers
Message-ID: <20200330193346.GI25745@shell.armlinux.org.uk>
References: <E1jIV26-0005X3-RS@rmk-PC.armlinux.org.uk>
 <20200330180444.GA16073@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330180444.GA16073@ravnborg.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 08:04:44PM +0200, Sam Ravnborg wrote:
> Hi Russell.
> 
> On Sun, Mar 29, 2020 at 11:19:10AM +0100, Russell King wrote:
> > Globally update my email address in six files scattered through the
> > tree.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/gpu/drm/armada/armada_drv.c                 | 2 +-
> >  drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c | 2 +-
> >  drivers/gpu/drm/etnaviv/etnaviv_drv.c               | 2 +-
> >  drivers/media/cec/cec-notifier.c                    | 2 +-
> >  drivers/net/phy/swphy.c                             | 2 +-
> >  include/media/cec-notifier.h                        | 2 +-
> >  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> This changes all cases of:
>    
>    rmk+kernel@arm.linux.org.uk
> 
> to
> 
>   rmk+kernel@armlinux.org.uk or no mail address.

Correct.  This is the address I sign off all my commits with, and this
is the one I use to associate with authorship because it uses my
initials.

> But I am confused.
> 
> The new address does not appear anywhere in MAINTAINERS and is used
> only in three other files.

MAINTAINERS lists the addresses I prefer email for the day to day
maintanence, which is my linux@ accounts.  The above addresses
also fall into _this_ mailbox too, rather than my rmk@ mailbox.
So, ultimately all that email comes to the same place.

However, the plain rmk@ address doesn't.

> And there are a few other mail addresses that would reach you.
> But no matter how confused I am the patch looks fine so:
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> And if the change is for private reaons then I do not have to know
> anyway so feel free to ignore my confusion.

The reason for the change is so I can drop the routing information
rmk+kernel@arm.linux.org.uk, thereby causing that address to start
bouncing, rather than being a spam inlet.  Sure, the new one will
be as well, but the point is that keeping both around indefinitely
gives a bigger attack surface for spam ingress.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
