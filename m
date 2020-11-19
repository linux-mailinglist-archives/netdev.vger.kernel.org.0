Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB902B8914
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgKSAf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:35:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSAf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:35:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXvY-007pcO-2F; Thu, 19 Nov 2020 01:35:56 +0100
Date:   Thu, 19 Nov 2020 01:35:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 08/11] net: dsa: microchip: ksz8795: align port_cnt usage
 with other microchip drivers
Message-ID: <20201119003556.GL1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-9-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-9-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:54PM +0100, Michael Grzeschik wrote:
> The ksz8795 driver is using port_cnt differently to the other microchip
> DSA drivers. It sets it to the external physical port count, than the
> whole port count (including the cpu port). This patch is aligning the
> variables purpose with the other microchip drivers.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 17dc720df2340b0..10c9b301833dd59 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1183,7 +1183,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
>  		.num_alus = 0,
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
> -		.port_cnt = 4,		/* total physical port count */
> +		.port_cnt = 5,

Rather than remove the comment, please could you update the
comment. port_cnt is too generic to know its exact meaning without a
helpful comment. And this might be why this driver is different...

	Andrew
