Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2011BB7E9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD1HpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgD1HpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:45:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EE7C03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 00:45:02 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jTKvD-0000hA-Tc; Tue, 28 Apr 2020 09:44:51 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jTKvA-0007AL-Tl; Tue, 28 Apr 2020 09:44:48 +0200
Date:   Tue, 28 Apr 2020 09:44:48 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "joe.hershberger@ni.com" <joe.hershberger@ni.com>,
        "u-boot@lists.denx.de" <u-boot@lists.denx.de>
Subject: Re: [PATCH] arm64: dts: ls1046ardb: Set aqr106 phy mode to usxgmii
Message-ID: <20200428074448.GW5877@pengutronix.de>
References: <20200423102212.5412-1-s.hauer@pengutronix.de>
 <DB8PR04MB6985EB9D28A17723C8C061CCECD30@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985EB9D28A17723C8C061CCECD30@DB8PR04MB6985.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:42:22 up 68 days, 15:12, 94 users,  load average: 0.13, 0.15,
 0.12
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Thu, Apr 23, 2020 at 12:59:16PM +0000, Madalin Bucur wrote:
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Thursday, April 23, 2020 1:22 PM
> > To: linux-arm-kernel@lists.infradead.org
> > Cc: Madalin Bucur <madalin.bucur@nxp.com>; Shawn Guo
> > <shawnguo@kernel.org>; Leo Li <leoyang.li@nxp.com>; Sascha Hauer
> > <s.hauer@pengutronix.de>
> > Subject: [PATCH] arm64: dts: ls1046ardb: Set aqr106 phy mode to usxgmii
> > 
> > The AQR107 family of phy devices do not support xgmii, but usxgmii
> > instead. Since ce64c1f77a9d ("net: phy: aquantia: add USXGMII support
> > and warn if XGMII mode is set") the kernel warns about xgmii being
> > used. Change device tree to usxgmii.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > index d53ccc56bb63..02fbef92b96a 100644
> > --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > @@ -151,7 +151,7 @@ ethernet@ea000 {
> > 
> >  	ethernet@f0000 { /* 10GEC1 */
> >  		phy-handle = <&aqr106_phy>;
> > -		phy-connection-type = "xgmii";
> > +		phy-connection-type = "usxgmii";
> >  	};
> > 
> >  	ethernet@f2000 { /* 10GEC2 */
> > --
> > 2.26.1
> 
> Hi Sascha,
> 
> thank you for trying to correct this problem. Unfortunately
> "usxgmii" here is incorrect too, as that mode is not supported
> by the LS1046A SoC. The connection mode used, as documented
> by the SoC and PHY datasheets, is XFI. Unfortunately there was
> resistance against including this connection type in the list
> supported by the kernel (please note the distinction between
> connection type and connection mode). At a certain moment the
> two were aliased and the kernel uses connection mode, not
> connection type. While we should describe here the hardware,
> the board connection type (XFI), in the kernel the connection
> mode was lately preferred (10G-BaseR). So, today we cannot use
> "xfi" here, as the hardware description property should read.
> The closest thing we can use is "10gbase-r". Unfortunately, in
> u-boot support for "xfi" is already in place [1] and the device
> tree should be different for the two for this reason - this goes
> against the spirit of the device tree that should not depend on
> the software using it...
> 
> I had on my agenda to fix this problem, had to stop when "xfi"
> was rejected, at the time not even "10gbase-r" was an option.
> Also worth noting here is that, while we change "xgmii" to a
> correct/better value, we should also tolerate the old variant,
> as there are users in the wild unable/unwilling to update the
> device tree and backwards compatibility should be ensured,
> further complicating the matter.

Thanks for the explanation. It looked like one of those simple patch
opportunities at first, apparently it isn't.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
