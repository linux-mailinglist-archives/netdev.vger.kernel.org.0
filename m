Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB02EA369
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 03:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbhAECkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 21:40:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbhAECkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 21:40:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwcFr-00G4Zi-QU; Tue, 05 Jan 2021 03:39:27 +0100
Date:   Tue, 5 Jan 2021 03:39:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        pantelis.antoniou@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Message-ID: <X/PRX+RziaU3IJGi@lunn.ch>
References: <20210105022229.54601-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105022229.54601-1-mpe@ellerman.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 01:22:29PM +1100, Michael Ellerman wrote:
> Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
> into error") the ppc32_allmodconfig build fails with:
> 
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o
> 
> Add the missing MODULE_LICENSEs to fix the build. Both files include a
> copyright header indicating they are GPL v2.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c | 1 +
>  drivers/net/ethernet/freescale/fs_enet/mii-fec.c     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
> index c8e5d889bd81..76ac1a9eab58 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
> @@ -223,3 +223,4 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
>  };
>  
>  module_platform_driver(fs_enet_bb_mdio_driver);
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> index 8b51ee142fa3..407c330b432f 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
> @@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
>  };
>  
>  module_platform_driver(fs_enet_fec_mdio_driver);
> +MODULE_LICENSE("GPL v2");

Hi Michael

The use of "GPL v2" has been deprecated. Please use just "GPL". There
is a discussion about this here:

https://lore.kernel.org/patchwork/patch/1036331/

https://www.kernel.org/doc/html/latest/process/license-rules.html#id1

	Andrew
