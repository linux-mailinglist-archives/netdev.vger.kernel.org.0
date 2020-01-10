Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29646136F84
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgAJOcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:32:45 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:35641 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgAJOco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:32:44 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id EFC75240002;
        Fri, 10 Jan 2020 14:32:38 +0000 (UTC)
Date:   Fri, 10 Jan 2020 15:32:38 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Claudiu.Beznea@microchip.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        Nicolas.Ferre@microchip.com, Ludovic.Desroches@microchip.com,
        vkoul@kernel.org, Eugen.Hristev@microchip.com, jic23@kernel.org,
        knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        mchehab@kernel.org, lee.jones@linaro.org, richard.genoud@gmail.com,
        radu_nicolae.pirea@upb.ro, Tudor.Ambarus@microchip.com,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        wg@grandegger.com, mkl@pengutronix.de, a.zummo@towertech.it,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org
Subject: Re: [PATCH 03/16] dt-bindings: atmel-tcb: add microchip,<chip>-tcb
Message-ID: <20200110143238.GG1027187@piout.net>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
 <1578488123-26127-4-git-send-email-claudiu.beznea@microchip.com>
 <20200110134001.GD1027187@piout.net>
 <da99fbce-8341-19d2-12c9-144564d70726@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da99fbce-8341-19d2-12c9-144564d70726@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 14:29:27+0000, Claudiu.Beznea@microchip.com wrote:
> 
> 
> On 10.01.2020 15:40, Alexandre Belloni wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On 08/01/2020 14:55:10+0200, Claudiu Beznea wrote:
> >> Add microchip,<chip>-tcb to DT bindings documentation. This is for
> >> microchip,sam9x60-tcb.
> >>
> >> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> >> ---
> >>  Documentation/devicetree/bindings/mfd/atmel-tcb.txt | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/mfd/atmel-tcb.txt b/Documentation/devicetree/bindings/mfd/atmel-tcb.txt
> >> index c4a83e364cb6..e1713e41f6e0 100644
> >> --- a/Documentation/devicetree/bindings/mfd/atmel-tcb.txt
> >> +++ b/Documentation/devicetree/bindings/mfd/atmel-tcb.txt
> >> @@ -1,6 +1,7 @@
> >>  * Device tree bindings for Atmel Timer Counter Blocks
> >> -- compatible: Should be "atmel,<chip>-tcb", "simple-mfd", "syscon".
> >> -  <chip> can be "at91rm9200" or "at91sam9x5"
> >> +- compatible: Should be "atmel,<chip>-tcb", "microchip,<chip>-tcb",
> >> +  "simple-mfd", "syscon".
> >> +  <chip> can be "at91rm9200", "at91sam9x5" or "sam9x60"
> > 
> > atmel,sam9x60-tcb, microchip,at91rm9200-tcb and microchip,at91sam9x5-tcb
> > are not allowed and the documentation should reflect that.
> 
> OK! I'll double check it.
> 
> > 
> > It would probably be easier to do that on top of the yaml conversion
> > here:
> > https://lore.kernel.org/lkml/20191009224006.5021-2-alexandre.belloni@bootlin.com/
> 
> I don't see this integrated in next-20200110. Am I looking at the wrong branch?
> 

I had a few comments and I need to resend.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
