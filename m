Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747F319852D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgC3UPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:15:21 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:44640 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3UPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:15:21 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 3484A804AF;
        Mon, 30 Mar 2020 22:15:14 +0200 (CEST)
Date:   Mon, 30 Mar 2020 22:15:12 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
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
Message-ID: <20200330201512.GA23451@ravnborg.org>
References: <E1jIV26-0005X3-RS@rmk-PC.armlinux.org.uk>
 <20200330180444.GA16073@ravnborg.org>
 <20200330193346.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330193346.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=XpTUx2N9 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=PHq6YzTAAAAA:8
        a=drOt6m5kAAAA:8 a=7gkXJVJtAAAA:8 a=IFATEmdhu-ErwIyn04kA:9
        a=mtL8tZnu2Jrx5SaM:21 a=DNgyL8e6fjdIsIrl:21 a=CjuIK1q_8ugA:10
        a=ZKzU8r6zoKMcqsNulkmm:22 a=RMMjzBEyIzXRtoq5n5K6:22
        a=E9Po1WZjFZOl8hwRPBS3:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell

On Mon, Mar 30, 2020 at 08:33:46PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Mar 30, 2020 at 08:04:44PM +0200, Sam Ravnborg wrote:
> > Hi Russell.
> > 
> > On Sun, Mar 29, 2020 at 11:19:10AM +0100, Russell King wrote:
> > > Globally update my email address in six files scattered through the
> > > tree.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/gpu/drm/armada/armada_drv.c                 | 2 +-
> > >  drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c | 2 +-
> > >  drivers/gpu/drm/etnaviv/etnaviv_drv.c               | 2 +-
> > >  drivers/media/cec/cec-notifier.c                    | 2 +-
> > >  drivers/net/phy/swphy.c                             | 2 +-
> > >  include/media/cec-notifier.h                        | 2 +-
> > >  6 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > This changes all cases of:
> >    
> >    rmk+kernel@arm.linux.org.uk
> > 
> > to
> > 
> >   rmk+kernel@armlinux.org.uk or no mail address.
> 
> Correct.  This is the address I sign off all my commits with, and this
> is the one I use to associate with authorship because it uses my
> initials.
> 
> > But I am confused.
> > 
> > The new address does not appear anywhere in MAINTAINERS and is used
> > only in three other files.
> 
> MAINTAINERS lists the addresses I prefer email for the day to day
> maintanence, which is my linux@ accounts.  The above addresses
> also fall into _this_ mailbox too, rather than my rmk@ mailbox.
> So, ultimately all that email comes to the same place.
> 
> However, the plain rmk@ address doesn't.
> 
> > And there are a few other mail addresses that would reach you.
> > But no matter how confused I am the patch looks fine so:
> > 
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > And if the change is for private reaons then I do not have to know
> > anyway so feel free to ignore my confusion.
> 
> The reason for the change is so I can drop the routing information
> rmk+kernel@arm.linux.org.uk, thereby causing that address to start
> bouncing, rather than being a spam inlet.  Sure, the new one will
> be as well, but the point is that keeping both around indefinitely
> gives a bigger attack surface for spam ingress.

Thanks for taking your time to explain the background.

The patch touches several files outside drivers/gpu/
so I do not feel confident to apply this to drm-misc-next.

	Sam

