Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514C160697
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfGENaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 09:30:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49129 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfGENaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 09:30:24 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 24B5B6000B;
        Fri,  5 Jul 2019 13:30:17 +0000 (UTC)
Date:   Fri, 5 Jul 2019 15:30:16 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 1/8] Documentation/bindings: net: ocelot:
 document the PTP bank
Message-ID: <20190705133016.GD3926@kwain>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-2-antoine.tenart@bootlin.com>
 <20190701135214.GD25795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190701135214.GD25795@lunn.ch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 01, 2019 at 03:52:14PM +0200, Andrew Lunn wrote:
> On Mon, Jul 01, 2019 at 12:03:20PM +0200, Antoine Tenart wrote:
> > One additional register range needs to be described within the Ocelot
> > device tree node: the PTP. This patch documents the binding needed to do
> > so.
> 
> Are there any more register banks? Maybe just add them all?

I checked and there are (just a few) more. I also saw your other comment
about interrupts, and it's also true there.

Those definitions aren't related to the PHC so I'll prepare a patch for
a following series to add all the missing parts.

> Also, you should probably add a comment that despite it being in the
> Required part of the binding, it is actually optional.

I'm not sure about this: optional properties means some parts of the h/w
can be missing or not wired. It's not the case here, it's "optional" in
the driver only for dt compatibility (so that an older dt blob can work
with a newer kernel image), but it's now mandatory in the binding.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
