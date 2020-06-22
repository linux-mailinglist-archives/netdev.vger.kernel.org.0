Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C423F2034C8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgFVK0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:26:18 -0400
Received: from relay-b02.edpnet.be ([212.71.1.222]:44110 "EHLO
        relay-b02.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgFVK0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:26:17 -0400
X-ASG-Debug-ID: 1592821574-0a7b8d7b58395dd0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be ([213.219.130.186]) by relay-b02.edpnet.be with ESMTP id 7mCYZTARDg2OtGBc; Mon, 22 Jun 2020 12:26:14 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.130.186]
X-Barracuda-Apparent-Source-IP: 213.219.130.186
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 93BBAF69EFE;
        Mon, 22 Jun 2020 12:26:06 +0200 (CEST)
Date:   Mon, 22 Jun 2020 12:25:59 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200622102559.GA3077@x1.vandijck-laurijssen.be>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c8267280-e7a9-8171-d714-fa392ccb5537@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: UNKNOWN[213.219.130.186]
X-Barracuda-Start-Time: 1592821574
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1248
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: SPAM GLOBAL 0.9857 1.0000 4.1774
X-Barracuda-Spam-Score: 4.18
X-Barracuda-Spam-Status: No, SCORE=4.18 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.82726
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Marc,

On do, 18 jun 2020 14:35:28 +0200, Marc Kleine-Budde wrote:
> On 6/18/20 2:30 PM, Kurt Van Dijck wrote:
> > On do, 18 jun 2020 00:36:29 +0200, Marc Kleine-Budde wrote:
> >> On 6/17/20 6:59 PM, Kurt Van Dijck wrote:
> >>> I'm in the process of getting a Variscite imx8m mini SOM online, with
> >>
> >> Have your heard about the imx8m plus? It has CAN cores! We have a board in the
> >> office to play with. :)
> >>
> >>> MCP2517FD. The 4.19 kernel that comes with it, has a driver that is
> >>
> >> You shall not start projects with 1,5 years old kernel.
> >> And you probably shall not use vendor kernel for new projects.
> >> :D
> > 
> > your rpi kernel starts of v4.19.119 (or so), where the variscite starts
> > of v4.19.35.
> 
> You're missing some stable backports for the kernel then.
> 
> > The result was quite some list of merge conflicts, on top of a vendor
> > kernel, so I took your advise and switched to the latest and greatest
> > 5.7.3.
> 
> \o/

I got my board up with a 5.7, despite device-tree problems completely
unrelated to CAN.
It seems to work well with a fully-loaded CAN bus (cangen -g0 ...).
So that is a real improvement.
I will need to add the listen-only mode soon.

Kurt
