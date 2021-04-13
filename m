Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9510C35DB7F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhDMJnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhDMJna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:43:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B3CC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:43:10 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lWFZa-0000ey-I8; Tue, 13 Apr 2021 11:43:06 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lWFZZ-0002qD-8B; Tue, 13 Apr 2021 11:43:05 +0200
Date:   Tue, 13 Apr 2021 11:43:05 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
Message-ID: <20210413094305.kvjgaiseppg5hrzh@pengutronix.de>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
 <CAOMZO5CYquzd4BBZBUM6ufWkPqfidctruWmaDROwHKVmi3NX2A@mail.gmail.com>
 <YGM2AGfawEFTKOtE@lunn.ch>
 <CAOMZO5CRFHh5vv3vQqaatDnq55ZMmO5DfJH1VtZ1n0DBgf5Whg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOMZO5CRFHh5vv3vQqaatDnq55ZMmO5DfJH1VtZ1n0DBgf5Whg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:41:25 up 131 days, 23:47, 48 users,  load average: 0.14, 0.07,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Mar 30, 2021 at 12:04:50PM -0300, Fabio Estevam wrote:
> Hi Andrew,
> 
> On Tue, Mar 30, 2021 at 11:30 AM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > Hi Fabio
> >
> > I think it should be merged, and we fixup anything which does break.
> > We are probably at the point where more is broken by not merging it
> > than merging it.
> 
> Thanks for your feedback. I agree.
> 
> Shawn wants to collect some Acked-by for this series.
> 
> Could you please give your Acked-by for this series?

Andrew, can you please add you ACK?

Shawn will it be enough or you need more ACKs?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
