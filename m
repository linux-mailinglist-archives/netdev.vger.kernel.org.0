Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B5230EDE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgG1QIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:08:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbgG1QIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:08:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0S94-007Ixs-Jy; Tue, 28 Jul 2020 18:08:02 +0200
Date:   Tue, 28 Jul 2020 18:08:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Message-ID: <20200728160802.GI1705504@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think that the MAINTAINERS file should also be updated to mention the new
> path to the drivers. Just did a quick grep after 'drivers/net/phy':
> F:      drivers/net/phy/adin.c      
> F:      drivers/net/phy/mdio-xgene.c
> F:      drivers/net/phy/            
> F:      drivers/net/phy/marvell10g.c
> F:      drivers/net/phy/mdio-mvusb.c
> F:      drivers/net/phy/dp83640*    
> F:      drivers/net/phy/phylink.c   
> F:      drivers/net/phy/sfp*        
> F:      drivers/net/phy/mdio-xpcs.c

Hi Ioana

Thanks, I will take care of that.

> Other than that, the new 'drivers/net/phy/phy/' path is somewhat repetitive but
> unfortunately I do not have another better suggestion.

Me neither.

I wonder if we are looking at the wrong part of the patch.
drivers/net/X/phy/
drivers/net/X/mdio/
drivers/net/X/pcs/

Question is, what would X be?

   Andrew
