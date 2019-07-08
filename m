Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA461B99
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfGHIRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:17:35 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43127 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfGHIRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:17:34 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id CC8B540016;
        Mon,  8 Jul 2019 08:17:22 +0000 (UTC)
Date:   Mon, 8 Jul 2019 10:17:22 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v2 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190708081722.GA2932@kwain>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
 <20190705195213.22041-9-antoine.tenart@bootlin.com>
 <20190705220224.5i2uy4uxx5o4raaw@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190705220224.5i2uy4uxx5o4raaw@localhost>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Fri, Jul 05, 2019 at 03:02:24PM -0700, Richard Cochran wrote:
> On Fri, Jul 05, 2019 at 09:52:13PM +0200, Antoine Tenart wrote:
> > +static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
> > +{
> > +	struct ocelot *ocelot = arg;
> > +
> > +	do {
> 
> > +		/* Check if a timestamp can be retrieved */
> > +		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
> > +			break;
> 
> As in my reply on v1, I suggest adding a sanity check on this ISR's
> infinite loop.

That's a good idea. I'll fix this in v3.

> > +	} while (true);

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
