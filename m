Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9231FFDA7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgFRWDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:03:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbgFRWDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:03:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm2d9-001B89-SQ; Fri, 19 Jun 2020 00:03:31 +0200
Date:   Fri, 19 Jun 2020 00:03:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618220331.GA279339@lunn.ch>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618165510.GG1551@shell.armlinux.org.uk>
 <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Are there really instances where the ethernet driver has to manage multiple
> different types of PCSs? I am not sure this type of snippet of code is really
> going to occur.

Hi Ioana

The Marvell mv88e6390 family has three PCS's, one for SGMII/1000BaseX,
a 10Gbase-X4/X2 and a 10GBAse-R. So this sort of code could appear.

  Andrew
