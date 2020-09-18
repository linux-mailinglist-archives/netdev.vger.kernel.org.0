Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CB5270180
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRQAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:00:17 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:51306 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRQAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:00:16 -0400
Received: from relay11.mail.gandi.net (unknown [217.70.178.231])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 401483A3092
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:28:03 +0000 (UTC)
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id C030F100004;
        Fri, 18 Sep 2020 15:27:40 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:27:40 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net 3/8] net: dsa: seville: fix buffer size of the
 queue system
Message-ID: <20200918152740.GZ9675@piout.net>
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918010730.2911234-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 04:07:25+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
> Changes in v2:
> None.
> 
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 2d6a5f5758f8..83a1ab9393e9 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1018,7 +1018,7 @@ static const struct felix_info seville_info_vsc9953 = {
>  	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
>  	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
>  	.vcap			= vsc9953_vcap_props,
> -	.shared_queue_sz	= 128 * 1024,
> +	.shared_queue_sz	= 2048 * 1024,
>  	.num_mact_rows		= 2048,
>  	.num_ports		= 10,
>  	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
