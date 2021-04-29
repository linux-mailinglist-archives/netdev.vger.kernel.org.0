Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF15836F21D
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbhD2Vdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:33:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233293AbhD2Vda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 17:33:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcEGv-001iO4-7z; Thu, 29 Apr 2021 23:32:33 +0200
Date:   Thu, 29 Apr 2021 23:32:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Message-ID: <YIsl8TRuVkU5B2kD@lunn.ch>
References: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
 <YIlUdprPfqa5d2ez@lunn.ch>
 <DB8PR04MB6795286E3C03699616C8C5C4E65F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795286E3C03699616C8C5C4E65F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -	if (!priv->plat->pmt) {
> > > +	/* First check if can WoL from PHY */
> > > +	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
> > 
> > This could return an error. In which case, you probably should not trust
> > wol_phy.
> phylink_ethtool_get_wol() is a void function

Upps. Yes, you are correct. Ignore what i said!

     Andre
