Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760B725F426
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIGHh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgIGHh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:37:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E90AC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 00:37:27 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFBiN-0004tM-Ph; Mon, 07 Sep 2020 09:37:23 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFBiN-00056o-F0; Mon, 07 Sep 2020 09:37:23 +0200
Date:   Mon, 7 Sep 2020 09:37:23 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200907073723.oz6cvgohy37by4nk@pengutronix.de>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
 <20200904061821.h67rmeare4n6l4d3@pengutronix.de>
 <11e7a470-fabb-d679-e254-2a7acc354fc6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11e7a470-fabb-d679-e254-2a7acc354fc6@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:34:45 up 296 days, 22:53, 278 users,  load average: 0.10, 0.07,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-04 08:38, Florian Fainelli wrote:
> 
> 
> On 9/3/2020 11:18 PM, Marco Felsch wrote:
> > On 20-09-02 21:39, Florian Fainelli wrote:
> > > The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> > > drives its MDIO interface among other things, the driver now requests
> > > and manage that clock during .probe() and .remove() accordingly.
> > 
> > Hi Florian,
> > 
> > Seems like you added the same support here like I did for the smsc
> > driver. So should I go with my proposed patch which can be adapted later
> > after you guys figured out who to enable the required resources?
> 
> That seems fine to me, on your platform there appears to be an assumption
> that we will be able to probe the SMSC PHY because everything we need is
> already enabled, right? If so, this patch series does not change that state.

Unfortunately yes.. The imx-fec driver enables all DT-specified clock
and then the mdio-bus probe is initiated. The good point is that my
patchset do not require a clock-id so the generic way can replace my
work later.

Regards,
  Marco
