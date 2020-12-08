Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069442D20C2
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgLHCXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:23:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgLHCXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:23:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmSdz-00AjoS-OR; Tue, 08 Dec 2020 03:22:23 +0100
Date:   Tue, 8 Dec 2020 03:22:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: vlan_filtering=1 breaks all traffic
Message-ID: <20201208022223.GF2475764@lunn.ch>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205190310.wmxemhrwxfom3ado@skbuf>
 <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
 <20201206194516.adym47b4ppohiqpl@skbuf>
 <f47bd572-7d0a-c763-c3b2-20c89cba9e7c@prevas.dk>
 <20201207201527.nbo4jz5bga26celo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207201527.nbo4jz5bga26celo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 08:15:28PM +0000, Vladimir Oltean wrote:
> On Mon, Dec 07, 2020 at 08:43:18PM +0100, Rasmus Villemoes wrote:
> > # uname -a
> > Linux (none) 5.10.0-rc7-00035-g66d777e1729d #194 Mon Dec 7 16:00:30 CET
> > 2020 ppc GNU/Linux
> > # devlink dev
> > mdio_bus/mdio@e0102120:10
> > # mv88e6xxx_dump --device mdio_bus/mdio@e0102120:10 --vtu
> > VTU:
> > Error: devlink: The requested region does not exist.
> > devlink answers: Invalid argument
> > Unable to snapshot vtu

VTU dumping is new. It is in net-next, but not 5.10-rc7.  atu, global1
and global2 are part for 5.10-rc7.

     Andrew
