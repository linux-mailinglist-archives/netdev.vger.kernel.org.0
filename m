Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D82527ADF5
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgI1Mho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 08:37:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI1Mho (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 08:37:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMsPK-00GXDC-Tw; Mon, 28 Sep 2020 14:37:30 +0200
Date:   Mon, 28 Sep 2020 14:37:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200928123730.GA3940833@lunn.ch>
References: <20200928124608.2f527504@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928124608.2f527504@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 28 Sep 2020 12:42:10 +1000
> Subject: [PATCH] merge fix for "mdio: fix mdio-thunder.c dependency & build error"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/mdio/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 840727cc9499..27a2a4a3d943 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -164,6 +164,7 @@ config MDIO_THUNDER
>  	depends on 64BIT
>  	depends on PCI
>  	select MDIO_CAVIUM
> +	select MDIO_DEVRES
>  	help
>  	  This driver supports the MDIO interfaces found on Cavium
>  	  ThunderX SoCs when the MDIO bus device appears as a PCI
> -- 
> 2.28.0

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

