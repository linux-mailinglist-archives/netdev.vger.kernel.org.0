Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E360203716
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgFVMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:44:05 -0400
Received: from relay-b03.edpnet.be ([212.71.1.220]:38204 "EHLO
        relay-b03.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgFVMoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:44:05 -0400
X-ASG-Debug-ID: 1592829841-0a8818764c3f730001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([213.219.130.186]) by relay-b03.edpnet.be with ESMTP id mMlQkBHN7OIDwHyk; Mon, 22 Jun 2020 14:44:02 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.130.186]
X-Barracuda-Apparent-Source-IP: 213.219.130.186
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 78A2DF6A211;
        Mon, 22 Jun 2020 14:43:54 +0200 (CEST)
Date:   Mon, 22 Jun 2020 14:43:47 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200622124347.GC3077@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
 <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
 <20200617165902.GB14228@x1.vandijck-laurijssen.be>
 <2e80e2ed-d63d-5cc6-e1c6-e0c9e75c218e@pengutronix.de>
 <20200618123055.GA17496@x1.vandijck-laurijssen.be>
 <c8267280-e7a9-8171-d714-fa392ccb5537@pengutronix.de>
 <20200622102559.GA3077@x1.vandijck-laurijssen.be>
 <c5fc46c1-abaf-cf67-abb6-0077bafdff3a@pengutronix.de>
 <20200622123031.GB3077@x1.vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200622123031.GB3077@x1.vandijck-laurijssen.be>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[213.219.130.186]
X-Barracuda-Start-Time: 1592829841
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 907
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 1.0000 1.0000 4.3430
X-Barracuda-Spam-Score: 4.34
X-Barracuda-Spam-Status: No, SCORE=4.34 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.82728
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc,

I get RX-0: FIFO overflows in listen-only mode (back-to-back burst of
the single other node).
The SPI peripheral does not use DMA :-(.
Do you have, by accident, some freescale SPI fixes lying around?

It's not the biggest problem on my side, but is proves the system not
being guarded against load.

Kurt

On ma, 22 jun 2020 14:30:31 +0200, Kurt Van Dijck wrote:
> 
> On ma, 22 jun 2020 12:55:41 +0200, Marc Kleine-Budde wrote:
> > On 6/22/20 12:25 PM, Kurt Van Dijck wrote:
> > > I got my board up with a 5.7, despite device-tree problems completely
> > > unrelated to CAN.
> > 
> > \o/
> > 
> > > It seems to work well with a fully-loaded CAN bus (cangen -g0 ...).
> > > So that is a real improvement.
> > 
> > Can I add your Tested-by?
> yes.
> > 
> > > I will need to add the listen-only mode soon.
> > 
> > Patches are always welcome!
> > 
> > regards,
> > Marc
