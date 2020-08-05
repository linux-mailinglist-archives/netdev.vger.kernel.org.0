Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F5023D3CC
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 00:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHEWJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 18:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgHEWJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 18:09:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3C3C061575;
        Wed,  5 Aug 2020 15:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SBHrjyLZMwHHEwy1XJ0fg8T/SoluE+ttqZKDd2I3toA=; b=soXwZXHhjkb4m97fY0jjWEy2L
        zwf1lqPIm3S4bC1kdSkIu1dWH2U9mBJUsdTLE8NzeIoTzUPSiYtQV/6D8K2o2kmkr1Q9TyLZOL1Cl
        Jl87to4yZcvFMu+ByfmHUdCtz2Y94u7C3jPbGHN4dfuQOQZdVq4vHouzcyZ6jqL0CzgAWK/dt1N6H
        6s2f+jDLLA5QfHonrKHQmnWlqTZdQ53Bc6cLgLEc8zU/WmELdw7sMAFaA+ZpOHgiJoX5QNX6LAwwT
        RRBhqCOrsSouqf50jVavsZtbjXEZqkFVn7wQ2wf8vd7PkEIJh6SJ0pe1L/880bsEXTWc29elYoQyT
        a6eJZCbXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48806)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k3Rb4-0003y7-BF; Wed, 05 Aug 2020 23:09:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k3Rb3-0005Ut-QK; Wed, 05 Aug 2020 23:09:17 +0100
Date:   Wed, 5 Aug 2020 23:09:17 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joe Perches <joe@perches.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
Message-ID: <20200805220917.GZ1551@shell.armlinux.org.uk>
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
 <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
 <20200805182250.GX1551@shell.armlinux.org.uk>
 <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

It is sufficient; as I said, I've spent a morning running this:

#!/usr/bin/perl
$re = 'phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)';
foreach $f (@ARGV) {
        open F, $f;
        $l = 1;
        while (<F>) {
                chomp;
                print "$f:$l: $_\n" if /$re/;
                $l++;
        }
        close F;
}

through:

$ find drivers -type f -print0 | xargs -0 ./check.pl | diff -u pl-ref.out - |less

where pl-ref.out is the original K: matching of just "phylink" and
looking at the differences to ensure I'm excluding just stuff that
doesn't concern me, while getting a high hit rate on the stuff
that I do want.

Now, I'm not saying that there isn't a better way, but this is not
something I want to spend days on.  So I got something that works
for me, and that's what I've sent Linus.

Going through your list...

>       4 phylink_add

Not sure what this is.  Doesn't seem to be anything to do with what
I maintain.

>       7 phylink_an_mode_str

static function.

>       4 phylink_apply_manual_flow

static function.

>       3 phylink_attach_phy

static function.

>      26 phylink_autoneg_inband

This one public and included.

>       4 phylink_bringup_phy

static function.

>       3 phylink_change_inband_advert

static function.

>       6 phylink_clear

This one public and included.

>       4 phylink_complete
>       2 phylink_complete_evt

Nothing to do with phylink.

>     145 phylink_config

Included.

>       3 phylink_connect
>       8 phylink_connect_phy

Both included under one.

>      39 phylink_create

Included.

>      10 phylink_dbg

static function.

... shall I go on?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
