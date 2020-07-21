Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83336228110
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUNg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:36:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgGUNg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 09:36:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxsRz-006B2n-IY; Tue, 21 Jul 2020 15:36:55 +0200
Date:   Tue, 21 Jul 2020 15:36:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        robh+dt@kernel.org, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com
Subject: Re: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Message-ID: <20200721133655.GA1472201@lunn.ch>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
 <20200721100234.1302910-4-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721100234.1302910-4-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -755,7 +765,6 @@ static int macb_mdiobus_register(struct macb *bp)
>  			 * decrement it before returning.
>  			 */
>  			of_node_put(child);
> -
>  			return of_mdiobus_register(bp->mii_bus, np);
>  		}

Please avoid white space changes like this.

Otherwise this looks O.K.

       Andrew
