Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3117627014C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRPqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:46:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33341 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRPqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:46:47 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6EAFD6000F;
        Fri, 18 Sep 2020 15:46:45 +0000 (UTC)
Date:   Fri, 18 Sep 2020 17:46:45 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 05/11] net: dsa: seville: remove unused defines
 for the mdio controller
Message-ID: <20200918154645.GG9675@piout.net>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918105753.3473725-6-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 13:57:47+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some definitions were likely copied from
> drivers/net/mdio/mdio-mscc-miim.c.
> 
> They are not necessary, remove them.

Seeing that the mdio controller is probably the same, couldn't
mdio-mscc-miim be reused?

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index dfc9a1b2a504..0b6ceec85891 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -16,23 +16,12 @@
>  #define VSC9953_VCAP_IS2_ENTRY_WIDTH		376
>  #define VSC9953_VCAP_PORT_CNT			10
>  
> -#define MSCC_MIIM_REG_STATUS			0x0
> -#define		MSCC_MIIM_STATUS_STAT_BUSY	BIT(3)
> -#define MSCC_MIIM_REG_CMD			0x8
>  #define		MSCC_MIIM_CMD_OPR_WRITE		BIT(1)
>  #define		MSCC_MIIM_CMD_OPR_READ		BIT(2)
>  #define		MSCC_MIIM_CMD_WRDATA_SHIFT	4
>  #define		MSCC_MIIM_CMD_REGAD_SHIFT	20
>  #define		MSCC_MIIM_CMD_PHYAD_SHIFT	25
>  #define		MSCC_MIIM_CMD_VLD		BIT(31)
> -#define MSCC_MIIM_REG_DATA			0xC
> -#define		MSCC_MIIM_DATA_ERROR		(BIT(16) | BIT(17))
> -
> -#define MSCC_PHY_REG_PHY_CFG		0x0
> -#define		PHY_CFG_PHY_ENA		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
> -#define		PHY_CFG_PHY_COMMON_RESET BIT(4)
> -#define		PHY_CFG_PHY_RESET	(BIT(5) | BIT(6) | BIT(7) | BIT(8))
> -#define MSCC_PHY_REG_PHY_STATUS		0x4
>  
>  static const u32 vsc9953_ana_regmap[] = {
>  	REG(ANA_ADVLEARN,			0x00b500),
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
