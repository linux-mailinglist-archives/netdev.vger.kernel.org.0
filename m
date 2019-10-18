Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31FEDBCA3
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394811AbfJRFId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:08:33 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43145 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfJRFId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:08:33 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iLKFZ-00046M-Le; Fri, 18 Oct 2019 06:52:29 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iLKFW-0006rT-3o; Fri, 18 Oct 2019 06:52:26 +0200
Date:   Fri, 18 Oct 2019 06:52:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1 4/4] net: dsa: add support for Atheros AR9331 build-in
 switch
Message-ID: <20191018045226.hi2nybxkwopclajy@pengutronix.de>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-5-o.rempel@pengutronix.de>
 <2ad26bdc-e099-ded6-1337-5793aba0958d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ad26bdc-e099-ded6-1337-5793aba0958d@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:42:51 up 153 days, 11:01, 96 users,  load average: 0.03, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:35:48AM -0700, Florian Fainelli wrote:
> 
> 
> On 10/13/2019 11:15 PM, Oleksij Rempel wrote:
> > Provide basic support for Atheros AR9331 build-in switch. So far it
> > works as port multiplexer without any hardware offloading support.
> 
> I glanced through the functional parts of the code, and it looks pretty
> straight forward, since there is no offloading done so far, do you plan
> on adding bridge offload eventually if nothing more?

Currently not. There are following reasons:
- I do it for the Freifunk project. It is currently not clear, what
  functionality has higher priority.
- there are not many ar9331 based devices with enough RAM to run any
  thing modern. There is even less devices using more then one switch
  port.
- IPv6 support is important for this project, but old Atheros switches have some
  known issues with IPv6 packages in hardware bridge mode. So, this
  functionality will need more testing.

> When you submit v2, I would suggest splitting the tagger code from the
> switch driver code, just to make them easier to review.

ok.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
