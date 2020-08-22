Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0460724E8EC
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgHVQsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:48:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVQsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 12:48:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9Wge-00AlgF-H4; Sat, 22 Aug 2020 18:48:12 +0200
Date:   Sat, 22 Aug 2020 18:48:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add support for
 88E6393X from Amethyst family
Message-ID: <20200822164812.GH2347062@lunn.ch>
References: <20200819153816.30834-1-marek.behun@nic.cz>
 <20200819153816.30834-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819153816.30834-4-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
>  static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
>  				      bool up)
> @@ -678,8 +699,8 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
>  	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
>  		err = mv88e6390_serdes_power_sgmii(chip, lane, up);
>  		break;
> -	case MV88E6XXX_PORT_STS_CMODE_XAUI:
> -	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
> +	case MV88E6XXX_PORT_STS_CMODE_XAUI: /* also MV88E6393_PORT_STS_CMODE_5GBASER */
> +	case MV88E6XXX_PORT_STS_CMODE_RXAUI: /* also MV88E6393_PORT_STS_CMODE_10GBASER */
>  		err = mv88e6390_serdes_power_10g(chip, lane, up);
>  		break;
>  	}

Not so nice. Maybe add a m88e6393_serdes_power() function to avoid
this?

	Andrew
	
