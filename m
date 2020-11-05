Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28662A821A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgKEPW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:22:26 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:8483 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731204AbgKEPW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1604589745; x=1636125745;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8Nee0VCzpk0Vgp0nXh8FG89MS98QQe0yg6mbF5jma2Q=;
  b=C1C75RdWAhR01vy01CP5fDyakF2YC/M4Z9El5QXrcwyVnQHWhi+2UzAu
   /8AjLzxrLVDRZpDW8el1pI1o+UaNugZ9XD+KzVumWP7yCBOjOKzngi0HB
   1joQxoDf3zXa7d5X78HIHlOzZ3Pnxg6PDHXA4nTgRn663bGvN/u7vJZZt
   2WasOPeGYoRqAJIuGPnQYXmSehTTIOMdSHwUfhMu6eBJcrjdC+X3uBlHX
   N1aZ53rTxkzD6sdBB6g3kZLvhTgfg5d6TvN0+0JCBZNJYBeYtXHNtHprX
   vXkJ0t7KZZcZpQucy7t5o8JtnFZ5FiOSvLYFLYv4NDD1hWeFiFARrWTuR
   A==;
IronPort-SDR: YEpKQPsDcnaR5QPmdVQeMheN9WFfnUtorYWNbGEfQOvcKZFyiOWnugCGRND5AuUStOGEKzGAEk
 fzRFhdf/x7+zS4bDx2HZy5xzG/V/OKXa29ptuQ5lAWaAHTncNQNgIYJiDbIrgqUej0SsVvvDjV
 pk5ak9f81gQqDqNi8bsngbf74STF0R2ONX0otRj6U5iUHhedMmLYEn0Gw5lib4xOhWU8XldXSQ
 Pz/IpXLwuSxS7o4COwvnlKXUib7JNDE25UwgBzBgB9Ens4P5CIG8QFcWJ+xtFhoJmVKHt67LYb
 Lec=
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="32571915"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Nov 2020 08:22:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 5 Nov 2020 08:22:24 -0700
Received: from [10.171.246.99] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 5 Nov 2020 08:22:19 -0700
Subject: Re: [PATCH] net: macb: fix NULL dereference due to no pcs_config
 method
To:     Parshuram Thombare <pthombar@cadence.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux@armlinux.org.uk>
CC:     <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <harini.katakam@xilinx.com>,
        <michal.simek@xilinx.com>
References: <1604587039-5646-1-git-send-email-pthombar@cadence.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <6873cf12-456b-c121-037b-d2c5a6138cb3@microchip.com>
Date:   Thu, 5 Nov 2020 16:22:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604587039-5646-1-git-send-email-pthombar@cadence.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2020 at 15:37, Parshuram Thombare wrote:
> This patch fixes NULL pointer dereference due to NULL pcs_config
> in pcs_ops.
> 
> Fixes: e4e143e26ce8 ("net: macb: add support for high speed interface")

What is this tag? In linux-next? As patch is not yet in Linus' tree, you 
cannot refer to it like this.

> Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> Link: https://lkml.org/lkml/2020/11/4/482

You might need to change this to a "lore" link:
https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/

> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

This fix looks a bit weird to me. What about proposing a patch to 
Russell like the chunk that you already identified in function 
phylink_major_config()?


> ---
>   drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index b7bc160..130a5af 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
>          /* Not supported */
>   }
> 
> +static int macb_pcs_config(struct phylink_pcs *pcs,
> +                          unsigned int mode,
> +                          phy_interface_t interface,
> +                          const unsigned long *advertising,
> +                          bool permit_pause_to_mac)
> +{
> +       return 0;
> +}

Russell, is the requirement for this void function intended?

> +
>   static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>          .pcs_get_state = macb_usx_pcs_get_state,
>          .pcs_config = macb_usx_pcs_config,
> @@ -642,6 +651,7 @@ static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>   static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
>          .pcs_get_state = macb_pcs_get_state,
>          .pcs_an_restart = macb_pcs_an_restart,
> +       .pcs_config = macb_pcs_config,
>   };
> 
>   static void macb_mac_config(struct phylink_config *config, unsigned int mode,
> @@ -776,10 +786,13 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
> 
>          if (interface == PHY_INTERFACE_MODE_10GBASER)
>                  bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
> -       else
> +       else if (interface == PHY_INTERFACE_MODE_SGMII)
>                  bp->phylink_pcs.ops = &macb_phylink_pcs_ops;

Do you confirm that all SGMII type interfaces need phylink_pcs.ops?

> +       else
> +               bp->phylink_pcs.ops = NULL;
> 
> -       phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> +       if (bp->phylink_pcs.ops)
> +               phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> 
>          return 0;
>   }

Regards,
   Nicolas

-- 
Nicolas Ferre
