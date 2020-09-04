Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB8F25D12A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIDGSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgIDGSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9D0C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 23:18:24 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kE53F-0007wE-GJ; Fri, 04 Sep 2020 08:18:21 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kE53F-0005Vf-4S; Fri, 04 Sep 2020 08:18:21 +0200
Date:   Fri, 4 Sep 2020 08:18:21 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200904061821.h67rmeare4n6l4d3@pengutronix.de>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903043947.3272453-4-f.fainelli@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:16:02 up 293 days, 21:34, 275 users,  load average: 0.18, 0.10,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-02 21:39, Florian Fainelli wrote:
> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> drives its MDIO interface among other things, the driver now requests
> and manage that clock during .probe() and .remove() accordingly.

Hi Florian,

Seems like you added the same support here like I did for the smsc
driver. So should I go with my proposed patch which can be adapted later
after you guys figured out who to enable the required resources?

Regards,
  Marco
