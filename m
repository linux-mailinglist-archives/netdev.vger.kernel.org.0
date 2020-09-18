Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1934927010D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIRPcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:32:00 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:4825 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRPb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:31:59 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 56E3A24000C;
        Fri, 18 Sep 2020 15:31:57 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:31:57 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 09/11] net: mscc: ocelot: make
 ocelot_init_timestamp take a const struct ptp_clock_info
Message-ID: <20200918153157.GF9675@piout.net>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918105753.3473725-10-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 13:57:51+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It is a good measure to ensure correctness if the structures that are
> meant to remain constant are only processed by functions that thake
> constant arguments.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_ptp.c | 3 ++-
>  include/soc/mscc/ocelot_ptp.h          | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
> index 1e08fe4daaef..a33ab315cc6b 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
> @@ -300,7 +300,8 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  }
>  EXPORT_SYMBOL(ocelot_ptp_enable);
>  
> -int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info)
> +int ocelot_init_timestamp(struct ocelot *ocelot,
> +			  const struct ptp_clock_info *info)
>  {
>  	struct ptp_clock *ptp_clock;
>  	int i;
> diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
> index 4a6b2f71b6b2..6a7388fa7cc5 100644
> --- a/include/soc/mscc/ocelot_ptp.h
> +++ b/include/soc/mscc/ocelot_ptp.h
> @@ -53,6 +53,7 @@ int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
>  		      enum ptp_pin_function func, unsigned int chan);
>  int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>  		      struct ptp_clock_request *rq, int on);
> -int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info);
> +int ocelot_init_timestamp(struct ocelot *ocelot,
> +			  const struct ptp_clock_info *info);
>  int ocelot_deinit_timestamp(struct ocelot *ocelot);
>  #endif
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
