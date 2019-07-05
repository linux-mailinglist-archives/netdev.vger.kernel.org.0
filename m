Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB4160A5F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfGEQjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:39:39 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54247 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfGEQjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:39:39 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 37C4024000A;
        Fri,  5 Jul 2019 16:39:30 +0000 (UTC)
Date:   Fri, 5 Jul 2019 18:39:29 +0200
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
Message-ID: <20190705163929.GK3926@kwain>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-2-antoine.tenart@bootlin.com>
 <20190701135214.GD25795@lunn.ch>
 <20190705133016.GD3926@kwain>
 <20190705144517.GD4428@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190705144517.GD4428@lunn.ch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jul 05, 2019 at 04:45:17PM +0200, Andrew Lunn wrote:
> On Fri, Jul 05, 2019 at 03:30:16PM +0200, Antoine Tenart wrote:
> > 
> > I'm not sure about this: optional properties means some parts of the h/w
> > can be missing or not wired. It's not the case here, it's "optional" in
> > the driver only for dt compatibility (so that an older dt blob can work
> > with a newer kernel image), but it's now mandatory in the binding.
> 
> If the driver can work without it, it is clearly optional. You just
> get reduced functionality. That is the thing with DT. You can never
> add more required properties after the first commit without breaking
> backwards compatibility. To make the documentation fit the driver,
> somewhere you need to state they are optional. Either by placing the
> new properties in the optional section of the binding, or add a
> comment.

The documentation is unrelated to the driver. It's the documentation of
the binding itself, which is only describing the h/w.

But I discussed this with a someone and I got to the same conclusion as
your statement, because there can be old dt blobs in the wild and the
binding documentation can be used to make new code. That code should be
aware of required/optional properties.

I'll fix this in v2.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
