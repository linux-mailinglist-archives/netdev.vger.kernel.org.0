Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C889315F88
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 10:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEGIjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 04:39:23 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:53132 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfEGIjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 04:39:23 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id C739A5D6B;
        Tue,  7 May 2019 10:39:20 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 878559c4;
        Tue, 7 May 2019 10:39:19 +0200 (CEST)
Date:   Tue, 7 May 2019 10:39:18 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Message-ID: <20190507083918.GI81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
 <20190507071914.GJ2269@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507071914.GJ2269@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> [2019-05-07 10:19:14]:

Hi,

> On Mon, May 06, 2019 at 11:24:43PM +0200, Petr Štetiar wrote:
> > 
> > this patch series is an attempt to fix the mess, I've somehow managed to
> > introduce.
> > 
> > First patch in this series is defacto v5 of the previous 05/10 patch in the
> > series, but since the v4 of this 05/10 patch wasn't picked up by the
> > patchwork for some unknown reason, this patch wasn't applied with the other
> > 9 patches in the series, so I'm resending it as a separate patch of this
> > fixup series again.
> 
> I feel sort of ridiculous asking this over and over...  Maybe your spam
> filter is eating my emails?

nope, I've read your email, that's the only reason I've sent out this v2 which
added Fixes: tag you've suggested in your email.

> This bug was introduced in https://patchwork.ozlabs.org/patch/1094916/
> "[v4,01/10] of_net: add NVMEM support to of_get_mac_address" but it
> looks like no one applied it.

this patch series is against net-next, and I've added Fixes: tag as you've
requested in this v2 series[1] (which expands to commit[2] in net-next):

 Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")

> You're acting as if it *was* applied but you refuse to answer my
> question who applied it and which to which tree so I can figure out what
> went wrong.

it was applied[2] to David's net-next tree, but unfortunately partialy, just 9
patches out of 10, as the patch 05/10 in that series (which is patch 1/4 in
this series) never reached netdev mailing list and patchwork, probably because
of some netdev mailing list software and/or patchwork hiccup, very likely due
to the long list of recipients in that patch and as I'm not subscribed to the
netdev (due to the high traffic) I'm probably treaten somehow differently.

So to sum it up, I've simply thought, that it was enough to send out v2 with
that Fixes: tag and considered it done.

> I only see comments from last Friday that it shouldn't be applied...

I'm sorry, but which comments do you mean exactly? Those about the
`nvmem-mac-address` DT (sysfs) entry? If that is the case, from my point of
view, I've provided reasonable arguments and nobody told me, that I'm wrong
with my reasoning or NACKed this explicitly, so David probably considered my
arguments good enough and merged it as it is? I don't have any other
explanation.

> I also told you on Friday in a different thread that that patch shouldn't be
> applied.  Breaking git bisect is a bug, and we never do that. 

Yes, and I agree with you, but I've simply thought, that if any of the
maintainers who previously reviewed the series didn't objected about this,
that they're possibly going to squash those patches by themselves during the
merging process or that they're going to tell me to do so and I would address
this in the latest interation of the patchset before merge.

Anyway, is there any possibility how to fix that now?

> I'm just very confused right now.  What I'm trying to do is figure out in
> my head how this process failed so we can do better next time.

I'm just occasional contributor, so I'm sorry, but I can hardly provide any
input.

1. https://patchwork.ozlabs.org/patch/1096054/
2. https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=d01f449c008a3f41fa44c603e28a7452ab8f8e68

Cheers,

Petr
