Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACC234A723
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:28:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCZM2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:28:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPlZF-00D80L-U0; Fri, 26 Mar 2021 13:27:57 +0100
Date:   Fri, 26 Mar 2021 13:27:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: FEC unbind/bind feature
Message-ID: <YF3TTZtJ1SLFkSpS@lunn.ch>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
 <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please wrap your lines at around 75 characters. Standard netiquette rules for
> > emails apply to all Linux lists.
> 
> Ok, thanks.

Please keep fighting with your email client, 

> Yes, you are right. It should be always fine for single FEC controller, and unbind/bind one by one should also be fine for dual FEC controllers which share one MDIO bus. I test on i.MX6UL, i.MX8MM/MP.
 
> > > It seems to abstract an independent MDIO bus for dual FEC instances. I
> > > look at the MDIO dt bindings, it seems support such case as it has
> > > "reg"
> > > property. (Documentation/devicetree/bindings/net/mdio.yaml)
> > 
> > You can have fully standalone MDIO bus drivers. You generally do this when the
> > MDIO bus registers are in their own address space, which you can ioremap()
> > separately from the MAC registers. Take a look in drivers/net/mdio/.
> > 
> > > From your opinions, do you think it is necessary to improve it?
> > 
> > What is you use case for unbinding/binding the FEC?
> 
> Users may want to unbind FEC driver, and then bind to FEC UIO driver, such as for DPDK use case to improve the throughput.

You could blacklist the FEC driver so it never loads. Or change the
compatible string so it only matches the DPDK driver. Or use XDP :-)

	   Andrew
