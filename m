Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70DF118BB1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfLJOyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:54:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36983 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfLJOyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:54:03 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 650D260006;
        Tue, 10 Dec 2019 14:54:00 +0000 (UTC)
Date:   Tue, 10 Dec 2019 15:53:59 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix condition for setting up link
 interrupt
Message-ID: <20191210145359.GA90089@kwain>
References: <20190124131803.14038-1-tbogendoerfer@suse.de>
 <20190124155137.GD482@lunn.ch>
 <20190124160741.jady3r2e4dme7c4m@e5254000004ec.dyn.armlinux.org.uk>
 <20190125083720.GK3662@kwain>
 <20191208164235.GT1344@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191208164235.GT1344@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Sun, Dec 08, 2019 at 04:42:36PM +0000, Russell King - ARM Linux admin wrote:
> 
> Today, I received an email from Willy Tarreau about this issue which
> persists to this day with mainline kernels.
> 
> Willy reminded me that I've been carrying a fix for this, but because
> of your concerns as stated above, I haven't bothered submitting it
> through fear of causing regressions (which you seem to know about):
> 
>    http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=mvpp2&id=67ef3bff255b26cc0d6def8ca99c4e8ae9937727
> 
> Just like Thomas' case, the current code is broken for phylink when
> in-band negotiation is being used - such as with the 1G/2.5G SFP
> slot on the Macchiatobin.
> 
> It seems that resolving the issue has stalled.  Can I merge my patch,
> or could you state exactly what the problems are with it so that
> someone else can look into the issues please?

Yes, please merge your patch (the one dropping the check on
'!port->phylink'), I've been using it for months. I answered that patch
submission back then[1] but it seems it was lost somehow :)

Thanks!
Antoine

[1] https://www.spinics.net/lists/netdev/msg555697.html

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
