Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256831E02FE
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgEXV2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:28:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57578 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387830AbgEXV17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:27:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3E8EB1C02AB; Sun, 24 May 2020 23:27:58 +0200 (CEST)
Date:   Sun, 24 May 2020 23:27:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200524212757.GC1192@bug>
References: <AM0PR04MB7041E1F0913A90F40DFB31A386BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB7041E1F0913A90F40DFB31A386BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The SNR seems to be most universal value, when it comes to comparing
> > different situations (different links and different PHYs). The
> > resolution of BER is not that detailed, for the NXP PHY is says only
> > "BER below 1e-10" or not.
> 
> The point I was trying to make is that SQI is intentionally called SQI and NOT SNR, because it is not a measure for SNR. The standard only suggest a mapping of SNR to SQI, but vendors do not need to comply to that or report that. The only mandatory requirement is linking to BER. BER is also what would be required by a user, as this is the metric that determines what happens to your traffic, not the SNR.
> 
> So when it comes to KAPI parameters, I see the following options
> - SQI only
> - SQI + plus indication of SQI level at which BER<10^-10 (this is the only required and standardized information)
> - SQI + BER range (best for users, but requires input from the silicon vendors)

Last option looks best to me... and it will mean that hopefully silicon vendors standartize
something in future.

Best regards,

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
