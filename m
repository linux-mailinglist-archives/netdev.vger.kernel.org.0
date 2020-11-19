Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610962B8911
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgKSAcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:32:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSAcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:32:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXs3-007pal-0f; Thu, 19 Nov 2020 01:32:19 +0100
Date:   Thu, 19 Nov 2020 01:32:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 07/11] net: dsa: microchip: remove superfluous num_ports
 asignment
Message-ID: <20201119003219.GK1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-8-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-8-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:53PM +0100, Michael Grzeschik wrote:
> The variable num_ports is already assigned in the init function.
> This patch removes the extra assignment of the variable.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 2 --
>  drivers/net/dsa/microchip/ksz9477.c | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 7114902495a0ebb..17dc720df2340b0 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -992,8 +992,6 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
>  	u8 remote;
>  	int i;
>  
> -	ds->num_ports = dev->port_cnt + 1;
> -
>  	/* Switch marks the maximum frame with extra byte as oversize. */
>  	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
>  	ksz_cfg(dev, S_TAIL_TAG_CTRL, SW_TAIL_TAG_ENABLE, true);
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index abfd3802bb51706..2119965da10ae1e 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1267,8 +1267,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  	struct ksz_port *p;
>  	int i;
>  
> -	ds->num_ports = dev->port_cnt;

Please could you give a clue in the commit message that the init
function handles the difference between these two, the + 1 in ksz8795.

	 Andrew
