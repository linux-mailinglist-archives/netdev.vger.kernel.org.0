Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300CA1FF1D6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgFRMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:31:19 -0400
Received: from relay-b03.edpnet.be ([212.71.1.220]:39862 "EHLO
        relay-b03.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFRMbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 08:31:15 -0400
X-ASG-Debug-ID: 1592483469-0a88187a02148760001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([213.219.130.186]) by relay-b03.edpnet.be with ESMTP id ExykPAQwiLraKI9y; Thu, 18 Jun 2020 14:31:09 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.130.186]
X-Barracuda-Apparent-Source-IP: 213.219.130.186
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id B9D1FF616B8;
        Thu, 18 Jun 2020 14:31:02 +0200 (CEST)
Date:   Thu, 18 Jun 2020 14:30:55 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200618123055.GA17496@x1.vandijck-laurijssen.be>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e80e2ed-d63d-5cc6-e1c6-e0c9e75c218e@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[213.219.130.186]
X-Barracuda-Start-Time: 1592483469
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1156
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 1.0000 1.0000 4.3430
X-Barracuda-Spam-Score: 4.34
X-Barracuda-Spam-Status: No, SCORE=4.34 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.82637
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On do, 18 jun 2020 00:36:29 +0200, Marc Kleine-Budde wrote:
> On 6/17/20 6:59 PM, Kurt Van Dijck wrote:
> > I'm in the process of getting a Variscite imx8m mini SOM online, with
> 
> Have your heard about the imx8m plus? It has CAN cores! We have a board in the
> office to play with. :)
> 
> > MCP2517FD. The 4.19 kernel that comes with it, has a driver that is
> 
> You shall not start projects with 1,5 years old kernel.
> And you probably shall not use vendor kernel for new projects.
> :D

your rpi kernel starts of v4.19.119 (or so), where the variscite starts
of v4.19.35.
The result was quite some list of merge conflicts, on top of a vendor
kernel, so I took your advise and switched to the latest and greatest
5.7.3.
Luckily, we need no sound (yet) and no video. :-)

> 
> Not much, some bus off cleanups, however I've backported all changes to
> v4.19-rpi/mcp25xxfd-20200429-41 (debug and log is still included).
> 
> When you port this to your mx8 take all from (including)
> 
>     097701d1ea4f can: dev: avoid long lines
> to
>     v4.19-rpi/mcp25xxfd-20200429-41
> 

I'll merge one of your latest ...

Kurt
