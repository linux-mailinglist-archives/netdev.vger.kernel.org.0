Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B111E0318
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbgEXV2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:28:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57740 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388370AbgEXV2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:28:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 715D61C02AB; Sun, 24 May 2020 23:28:37 +0200 (CEST)
Date:   Sun, 24 May 2020 23:28:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Michal Kubecek <mkubecek@suse.cz>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200524212836.GE1192@bug>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511145926.GC8503@lion.mk-sys.cz>
 <20200512064858.GA16536@pengutronix.de>
 <20200512130418.GF409897@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512130418.GF409897@lunn.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2020-05-12 15:04:18, Andrew Lunn wrote:
> > > As for getting / setting the threshold, perhaps ETHTOOL_MSG_LINKINFO_GET
> > > and ETHTOOL_MSG_LINKINFO_SET. Unless you expect more configurable
> > > parameters like this in which case we may want to consider adding new
> > > request type (e.g. link params or link management).
> > 
> > Currently in my short term todo are:
> > - SQI
> 
> 
> > - PHY undervoltage
> > - PHY overtemerature
> 
> Do you only have alarms? Or are current values available for voltage
> and temperature?
> 
> Both of these would fit hwmon. It even has the option to set the alarm
> thresholds. The advantage of hwmon is that they are then just more

> sensors. You could even include the temperature sensor into a thermal zone to influence 
> cooling. There are a couple of PHYs which already do hwmon, so there is code you can 
> copy.

Yes, hwmon can do a lot of stuff. OTOH figuring out "what hwmon device corresponds to what
network device is going to be tricky, and Im not sure if we want utilities like mii-tool to
start using hwmon interfaces...

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
