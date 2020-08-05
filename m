Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637CE23D390
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 23:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHEVZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 17:25:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgHEVZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 17:25:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k3Qu8-008Qez-Ev; Wed, 05 Aug 2020 23:24:56 +0200
Date:   Wed, 5 Aug 2020 23:24:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joe Perches <joe@perches.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
Message-ID: <20200805212456.GC2005851@lunn.ch>
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
 <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
 <20200805182250.GX1551@shell.armlinux.org.uk>
 <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 11:47:38AM -0700, Joe Perches wrote:
> On Wed, 2020-08-05 at 19:22 +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Aug 05, 2020 at 11:11:28AM -0700, Linus Torvalds wrote:
> > > On Wed, Aug 5, 2020 at 7:34 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > > Is this something you're willing to merge directly please?
> > > 
> > > Done.
> > > 
> > > That said:
> > > 
> > > > -K:     phylink
> > > > +K:     phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
> > > 
> > > That's a very awkward pattern. I wonder if there could be better ways
> > > to express this (ie "only apply this pattern to these files" kind of
> > > thing)
> > 
> > Yes, it's extremely awkward - I spent much of the morning with perl
> > testing it out on the drivers/ subtree.
> 
> There are a lot of phylink_<foo> in the kernel.
> Are those really the only uses you want to watch?

Hi Joe

I think Rusells intention here is to match on MAC drivers which make
use of the phylink API exported to them.

SFF/SFP/SFP+ MODULE SUPPORT
M:      Russell King <linux@armlinux.org.uk>
L:      netdev@vger.kernel.org
S:      Maintained
F:      drivers/net/phy/phylink.c
F:      drivers/net/phy/sfp*
F:      include/linux/phylink.h
F:      include/linux/sfp.h
K:      phylink

> $ git grep -P -oh 'phylink_\w+'| sort | uniq -c

Try that again, but skip files matched by the F: clauses.

I suspect the matches you get then more closely approximates the K:
Russell is suggesting.

   Andrew
