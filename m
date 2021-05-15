Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D845381824
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhEOLHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:07:35 -0400
Received: from gloria.sntech.de ([185.11.138.130]:58440 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhEOLHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 07:07:32 -0400
Received: from p508fc690.dip0.t-ipconnect.de ([80.143.198.144] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1lhs7Y-0008V8-0W; Sat, 15 May 2021 13:06:12 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org,
        Yang Shen <shenyang39@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Shen <shenyang39@huawei.com>
Subject: Re: [PATCH 01/34] net: arc: Demote non-compliant kernel-doc headers
Date:   Sat, 15 May 2021 13:06:11 +0200
Message-ID: <22968170.EfDdHjke4D@phil>
In-Reply-To: <1621076039-53986-2-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com> <1621076039-53986-2-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Samstag, 15. Mai 2021, 12:53:26 CEST schrieb Yang Shen:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/arc/emac_rockchip.c:18: warning: expecting prototype for emac(). Prototype was for DRV_NAME() instead
> 
> Cc: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/net/ethernet/arc/emac_rockchip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
> index 48ecdf1..1c9ca3b 100644
> --- a/drivers/net/ethernet/arc/emac_rockchip.c
> +++ b/drivers/net/ethernet/arc/emac_rockchip.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
> -/**
> +/*
>   * emac-rockchip.c - Rockchip EMAC specific glue layer
>   *
>   * Copyright (C) 2014 Romain Perier <romain.perier@gmail.com>
> 




