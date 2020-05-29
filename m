Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD11E83C6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgE2Qdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:33:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2Qdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 12:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kj8QWZuKpt6K2mv0dyf3jA1S8ZK8klAJXGcqBjNLHFw=; b=3nF+HtN70czA2ZUrlO8RvfT7ZY
        LM1+wj23jWGpb9yCNquZLmigo7UjP5/D7lTURFkKIZmSwwcoCA+oK3N4zrH1+McODCf3I8nhVWg+e
        WzHm5DGc616VMuWnQOmFuisu/RI9NUUunCizXF4ehZHT/EyHrPCVKfGzSE9UhBLjWURU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jehwy-003f86-S4; Fri, 29 May 2020 18:33:40 +0200
Date:   Fri, 29 May 2020 18:33:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200529163340.GI869823@lunn.ch>
References: <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > By propagated, you mean if the external link is down, the link between
> > the switch and node 1 will also be forced down, at the SERDES level?
> 
> yes
> 
> > And if external ports are down, the nodes cannot talk to each other?
> 
> correct
> 
> > External link down causes the whole in box network to fall apart? That
> > seems a rather odd design.
> 
> as I'm not an expert in ceph, I can't judge. But I'll bring it up.

I guess for a single use appliance this is O.K. But it makes the
hardware unusable as a general purpose server.

Is there a variant of the hardware to be used as a general purpose
server, rather than as a Ceph appliance? If so, does it share the same
DT files?

> > What you are actually interested in is the sync state of the SERDES?
> > The link is up if the SERDES has sync.
> 
> yes, that's what I need. How can I do that ?

Given the current code, you cannot. Now we understand the
requirements, we can come up with some ideas how to do this properly.

      Andrew
