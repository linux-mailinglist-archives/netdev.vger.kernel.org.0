Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDB823A82E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgHCOPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:15:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgHCOPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:15:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2bFV-00836v-3T; Mon, 03 Aug 2020 16:15:33 +0200
Date:   Mon, 3 Aug 2020 16:15:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 2/3] net: phy: Move into subdirectories
Message-ID: <20200803141533.GC1843538@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <20200727204731.1705418-3-andrew@lunn.ch>
 <AM6PR04MB3976B8E1672E74D127BAD833EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB3976B8E1672E74D127BAD833EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 02:11:10PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Andrew Lunn
> > Sent: 27 July 2020 23:48
> > To: netdev <netdev@vger.kernel.org>
> > Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Florian Fainelli
> > <f.fainelli@gmail.com>; Russell King <rmk+kernel@armlinux.org.uk>; Heiner
> > Kallweit <hkallweit1@gmail.com>; Andrew Lunn <andrew@lunn.ch>
> > Subject: [PATCH RFC net-next 2/3] net: phy: Move into subdirectories
> > 
> > Move the PHY drivers into the phy subdirectory
> 
> We could keep the PHY drivers in the base drivers/net/phy/ folder, move
> only mdio to introduce lesser changes.

Hi Madalin

Please trim irrelevant text when replying.

If you keep reading in this thread, you will see this suggestion has
been made by others. I've got an implementation which moved MDIO and
PCS drivers into new directories. But it has a few 0-day issues at the
moment, so i don't know if i will get it ready before David closes
net-next.

	Andrew
