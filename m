Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5772C2307
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbfI3OSZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 10:18:25 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35691 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfI3OSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:18:25 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iEwVM-0005dv-18; Mon, 30 Sep 2019 16:18:24 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iEwVK-0006DO-B7; Mon, 30 Sep 2019 16:18:22 +0200
Date:   Mon, 30 Sep 2019 16:18:22 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] net: phy: at803x: add ar9331 support
Message-ID: <20190930141822.ny5m42qaoccpf5ek@pengutronix.de>
References: <20190930092710.32739-1-o.rempel@pengutronix.de>
 <20190930132041.GE13301@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190930132041.GE13301@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:14:08 up 135 days, 20:32, 87 users,  load average: 0.08, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 03:20:41PM +0200, Andrew Lunn wrote:
> On Mon, Sep 30, 2019 at 11:27:10AM +0200, Oleksij Rempel wrote:
> > Mostly this hardware can work with generic PHY driver, but this change
> > is needed to provided interrupt handling support.
> > Tested with dsa ar9331-switch driver.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/at803x.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > index 6ad8b1c63c34..d62a77adb8e7 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -53,6 +53,7 @@
> >  #define AT803X_DEBUG_REG_5			0x05
> >  #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
> >  
> > +#define AR9331_PHY_ID 0x004dd041
> >  #define ATH8030_PHY_ID 0x004dd076
> >  #define ATH8031_PHY_ID 0x004dd074
> >  #define ATH8035_PHY_ID 0x004dd072
> 
> Hi Oleksij
> 
> I wonder if we should call this ATH9331_PHY_ID, to keep with the
> naming convention? Why did you choose AR, not ATH?

Hi Andrew,

i have no strong opinion here. Taking what ever name was on the SoC
package, was safe enough for me. If you say, it should be ATH9331, i'll
rename it. Should i?

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
