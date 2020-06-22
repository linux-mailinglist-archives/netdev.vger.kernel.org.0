Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEC12037EC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgFVN01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:26:27 -0400
Received: from relay-b01.edpnet.be ([212.71.1.221]:33778 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgFVN00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:26:26 -0400
X-ASG-Debug-ID: 1592832383-0a7ff575a81bd1840001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([213.219.130.186]) by relay-b01.edpnet.be with ESMTP id aOuD0TggWwZpQl9y; Mon, 22 Jun 2020 15:26:23 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.130.186]
X-Barracuda-Apparent-Source-IP: 213.219.130.186
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 04E7EF6A2C6;
        Mon, 22 Jun 2020 15:26:15 +0200 (CEST)
Date:   Mon, 22 Jun 2020 15:26:08 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200622132608.GD3077@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
 <20200617165902.GB14228@x1.vandijck-laurijssen.be>
 <2e80e2ed-d63d-5cc6-e1c6-e0c9e75c218e@pengutronix.de>
 <20200618123055.GA17496@x1.vandijck-laurijssen.be>
 <c8267280-e7a9-8171-d714-fa392ccb5537@pengutronix.de>
 <20200622102559.GA3077@x1.vandijck-laurijssen.be>
 <c5fc46c1-abaf-cf67-abb6-0077bafdff3a@pengutronix.de>
 <20200622123031.GB3077@x1.vandijck-laurijssen.be>
 <20200622124347.GC3077@x1.vandijck-laurijssen.be>
 <0ae54858-0eb5-b3b8-c793-00a8b99c8aa5@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ae54858-0eb5-b3b8-c793-00a8b99c8aa5@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[213.219.130.186]
X-Barracuda-Start-Time: 1592832383
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1081
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 1.0000 1.0000 4.3430
X-Barracuda-Spam-Score: 4.34
X-Barracuda-Spam-Status: No, SCORE=4.34 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.82729
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ma, 22 jun 2020 14:54:15 +0200, Marc Kleine-Budde wrote:
> On 6/22/20 2:43 PM, Kurt Van Dijck wrote:
> > I get RX-0: FIFO overflows in listen-only mode (back-to-back burst of
> > the single other node).
> 
> Single other node? Who's ACKing the CAN frames?

hence the back-to-back burst.

> 
> > The SPI peripheral does not use DMA :-(.
> 
> The SPI messages are quite small, so DMA wont help either. Getting rid of the
> IRQ and polling for completion is the way to go.
> 
> > Do you have, by accident, some freescale SPI fixes lying around?
> 
> nope
> 
> > It's not the biggest problem on my side, but is proves the system not
> > being guarded against load.
> 
> Do you have freq scaling activated?

Not yet.

The device tree needs upgrading ... grrr

> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
