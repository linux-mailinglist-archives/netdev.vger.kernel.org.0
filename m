Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C473C445E7A
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 04:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhKEDRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 23:17:53 -0400
Received: from mx22.baidu.com ([220.181.50.185]:51272 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229685AbhKEDRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 23:17:52 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id C3C0EC946A3D56BAE9FE;
        Fri,  5 Nov 2021 11:15:09 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 5 Nov 2021 11:15:09 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 5
 Nov 2021 11:15:09 +0800
Date:   Fri, 5 Nov 2021 11:15:08 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Xu Wang <vulab@iscas.ac.cn>
CC:     <joel@jms.id.au>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: litex: Remove unnecessary print function
 dev_err()
Message-ID: <20211105031508.GA817@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20211105014217.38681-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211105014217.38681-1-vulab@iscas.ac.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex24.internal.baidu.com (172.31.51.18) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 11月 21 01:42:17, Xu Wang wrote:
> The print function dev_err() is redundant because
> platform_get_irq() already prints an error.
>
Reviewed-by: Cai Huoqing <caihuoqing@baidu.com>
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/net/ethernet/litex/litex_liteeth.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
> index 3d9385a4989b..ab9fa1525053 100644
> --- a/drivers/net/ethernet/litex/litex_liteeth.c
> +++ b/drivers/net/ethernet/litex/litex_liteeth.c
> @@ -242,10 +242,8 @@ static int liteeth_probe(struct platform_device *pdev)
>  	priv->dev = &pdev->dev;
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0) {
> -		dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
> +	if (irq < 0)
>  		return irq;
> -	}
>  	netdev->irq = irq;
>  
>  	priv->base = devm_platform_ioremap_resource_byname(pdev, "mac");
> -- 
> 2.25.1
> 
