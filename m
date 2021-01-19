Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C73C2FBB8B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbhASPrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:47:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389864AbhASPrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:47:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1tD2-001TD1-D5; Tue, 19 Jan 2021 16:46:20 +0100
Date:   Tue, 19 Jan 2021 16:46:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: Re: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <YAb+zI71+d67mlwz@lunn.ch>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <YADN77NvrpnZYUVo@lunn.ch>
 <OSAPR01MB3844F07254AB8B1164086D7FDFA40@OSAPR01MB3844.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB3844F07254AB8B1164086D7FDFA40@OSAPR01MB3844.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:17:04AM +0000, ashiduka@fujitsu.com wrote:
> Hi Andrew
> 
> > > Do you know how to switch between master/slave?
> > 
> > There was a patch to ethtool merged for this:
> > 
> > commit 558f7cc33daf82f945af432c79db40edcbe0dad0
> > Author: Oleksij Rempel <o.rempel@pengutronix.de>
> > Date:   Wed Jun 10 10:37:43 2020 +0200
> > 
> >     netlink: add master/slave configuration support
> 
> I know this.
> --
> # ./ethtool --version
> ethtool version 5.10
> # ./ethtool -s eth1 master-slave slave-force 
> ethtool (-s): invalid value 'slave-force' for parameter 'master-slave'

The parameter is called 'forced-slave'. See the man page:

       ethtool -s devname [speed N] [duplex half|full] [port tp|aui|bnc|mii]
              [mdix auto|on|off] [autoneg on|off] [advertise N[/M] |
              advertise mode on|off ...]  [phyad N] [xcvr internal|external]
              [wol N[/M] | wol p|u|m|b|a|g|s|f|d...]
              [sopass xx:yy:zz:aa:bb:cc] [master-slave preferred-
              master|preferred-slave|forced-master|forced-slave] [msglvl
              N[/M] | msglvl type on|off ...]

sudo ethtool -s eth10 master-slave forced-master
netlink error: master/slave configuration not supported by device (offset 36)
netlink error: Operation not supported

	Andrew
