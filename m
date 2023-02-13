Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280CE693F84
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjBMIXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjBMIW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:22:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227DE9EE8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 00:22:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD436B80E15
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17CCC433EF;
        Mon, 13 Feb 2023 08:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676276572;
        bh=whCk9yzq6VKAju0T+r+k6dBYabp1iAcMQBEfZiNPBMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9EX3JNeCXECpOSZ9uCC2DK+hDvDyrXg8ljH2cCP94gvNKjx3g2zZeysxYpnKkGo4
         bfDx6Q3637ozehb5yw/7sKXVk0y5/zwYkCTgByctCTSO6ZOULZz4hVSX9l7s+gc9uJ
         bbnz+28YRwIDMpldUl9Ghpz5Dcv4PlUeRDPNp+6PGIBmIsUhpJoxLm2lPXW5I28vuS
         cpdYQkeh7tr2VIJgB5JiJ02uTIetGv212nJaLLVMfZ6ymFzumZA/PmAM/Z+ribq36y
         8RTYlakot0tbV08MjZ9mH1SmsmKhxpRk05pJaP5htJ2Yj1aaMcXaeDSvzHjxn2jNti
         7UoL7JwO09r/w==
Date:   Mon, 13 Feb 2023 10:22:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: wangxun: Add base ethtool ops.
Message-ID: <Y+nzWMEBJ+3bqAci@unreal>
References: <20230213080949.52370-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213080949.52370-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 04:09:49PM +0800, Mengyuan Lou wrote:
> Add base ethtool ops get_drvinfo for ngbe and txgbe.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/Makefile   |  2 +-
>  .../net/ethernet/wangxun/libwx/wx_ethtool.c   | 29 +++++++++++++++++++
>  .../net/ethernet/wangxun/libwx/wx_ethtool.h   |  9 ++++++
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  5 ++++
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  3 ++
>  6 files changed, 48 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
>  create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h

Please remove dot in the patch subject.

> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/Makefile b/drivers/net/ethernet/wangxun/libwx/Makefile
> index 850d1615cd18..42ccd6e4052e 100644
> --- a/drivers/net/ethernet/wangxun/libwx/Makefile
> +++ b/drivers/net/ethernet/wangxun/libwx/Makefile
> @@ -4,4 +4,4 @@
>  
>  obj-$(CONFIG_LIBWX) += libwx.o
>  
> -libwx-objs := wx_hw.o wx_lib.o
> +libwx-objs := wx_hw.o wx_lib.o wx_ethtool.o
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
> new file mode 100644
> index 000000000000..e83235aa6ff2
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/pci.h>
> +#include <linux/phy.h>
> +
> +#include "wx_type.h"
> +#include "wx_ethtool.h"
> +
> +static void wx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
> +{
> +	struct wx *wx = netdev_priv(netdev);
> +
> +	strscpy(info->driver, wx->driver_name, sizeof(info->driver));
> +	strscpy(info->fw_version, wx->eeprom_id, sizeof(info->fw_version));
> +	strscpy(info->bus_info, pci_name(wx->pdev), sizeof(info->bus_info));
> +}
> +
> +static const struct ethtool_ops wx_ethtool_ops = {
> +	.get_drvinfo		= wx_get_drvinfo,
> +};
> +
> +void wx_set_ethtool_ops(struct net_device *netdev)
> +{
> +	netdev->ethtool_ops = &wx_ethtool_ops;
> +}
> +EXPORT_SYMBOL(wx_set_ethtool_ops);
> +
> +MODULE_LICENSE("GPL");

You don't need to put MODULE_LICENSE() in every libwx/*.c file.

Thanks
