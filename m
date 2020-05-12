Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031581CEC53
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgELFOM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 May 2020 01:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgELFOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:14:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0247C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 22:14:11 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYNEx-0002YZ-Py; Tue, 12 May 2020 07:14:03 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYNEp-0004Gp-LX; Tue, 12 May 2020 07:13:55 +0200
Date:   Tue, 12 May 2020 07:13:55 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Herber <christian.herber@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Re: signal quality and cable diagnostic
Message-ID: <20200512051355.GA16269@pengutronix.de>
References: <AM0PR04MB70410EA61C984E45615CCF8B86A10@AM0PR04MB7041.eurprd04.prod.outlook.com>
 <20200511195435.GF413878@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200511195435.GF413878@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:13:26 up 243 days, 18:01, 450 users,  load average: 1.10, 0.58,
 0.56
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 09:54:35PM +0200, Andrew Lunn wrote:
> On Mon, May 11, 2020 at 07:32:05PM +0000, Christian Herber wrote:
> > On May 11, 2020 4:33:53 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > Are the classes part of the Open Alliance specification? Ideally we
> > > want to report something standardized, not something proprietary to
> > > NXP.
> > >
> > >        Andrew
> > 
> > Hi Andrew,
> > 
> 
> > Such mechanisms are standardized and supported by pretty much all
> > devices in the market. The Open Alliance specification is publicly
> > available here:
> > http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
> > 
> > As the specification is newer than the 100BASE-T1 spec, do not
> > expect first generation devices to follow the register definitions
> > as per Open Alliance. But for future devices, also registers should
> > be same across different vendors.
> 
> Hi Christian
> 
> Since we are talking about a kernel/user API definition here, i don't
> care about the exact registers. What is important is the
> naming/representation of the information. It seems like NXP uses Class
> A - Class H, where as the standard calls them SQI=0 - SQI=7. So we
> should name the KAPI based on the standard, not what NXP calls them.

OK, sounds good for me.

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
