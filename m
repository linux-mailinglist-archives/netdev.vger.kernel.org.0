Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64AF325038
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhBYNPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:15:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBYNPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 08:15:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFGTA-008PLw-E7; Thu, 25 Feb 2021 14:14:16 +0100
Date:   Thu, 25 Feb 2021 14:14:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <YDeiqACL9Rtja6tH@lunn.ch>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YDZOMpUYZrijdFli@lunn.ch>
 <DB8PR04MB6795FAE4C1736AABDCA75FA7E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YDcMgr2rvcFvs746@lunn.ch>
 <DB8PR04MB679510F099C88F6B4BA10970E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679510F099C88F6B4BA10970E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> Thanks for you explanation, I still don't quite understand what the use case it is, could you give me more details, thanks a lot!
> AFAIK now, there are two connections methods, we can abstract the layer:
> 	MAC <-> MAC, there is no PHY attached. It seems to know as Fixed link, right?

Yes, this is the most common way of connecting a switch.

> 	MAC+PHY <-> PHY+MAC

Switches can be connected like this, but not often. Why pay for two
PHYs which you do not need?

> From your expression, you should use an external Ethernet switch, if
> yes, why Ethernet switch needs to use MDIO bus to access another
> MAC's(STMMAC) PHY?

The switch is on the same board as the MAC. Take a look at:
https://netdevconf.info/2.1/papers/distributed-switch-architecture.pdf

It explains the DSA architecture.

   Andrew
