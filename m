Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF78324B3
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfFBUBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 16:01:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBUBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 16:01:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B8EE1400F7B4;
        Sun,  2 Jun 2019 13:01:21 -0700 (PDT)
Date:   Sun, 02 Jun 2019 13:01:18 -0700 (PDT)
Message-Id: <20190602.130118.1624703340305098863.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.com, boon.leong.ong@intel.com,
        andrew@lunn.ch
Subject: Re: [RESEND, PATCH 1/4] net: stmmac: dwmac-mediatek: enable
 Ethernet power domain
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559209398-3607-2-git-send-email-biao.huang@mediatek.com>
References: <1559209398-3607-1-git-send-email-biao.huang@mediatek.com>
        <1559209398-3607-2-git-send-email-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 13:01:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Thu, 30 May 2019 17:43:15 +0800

> @@ -364,6 +371,15 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static int mediatek_dwmac_remove(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	ret = stmmac_pltfr_remove(pdev);
> +
> +	return ret;
> +}
> +
>  static const struct of_device_id mediatek_dwmac_match[] = {
>  	{ .compatible = "mediatek,mt2712-gmac",
>  	  .data = &mt2712_gmac_variant },
> @@ -374,7 +390,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
>  
>  static struct platform_driver mediatek_dwmac_driver = {
>  	.probe  = mediatek_dwmac_probe,
> -	.remove = stmmac_pltfr_remove,
> +	.remove = mediatek_dwmac_remove,
>  	.driver = {
>  		.name           = "dwmac-mediatek",
>  		.pm		= &stmmac_pltfr_pm_ops,

This half of your patch has no effect and seems completely unnecessary.

Please remove it.
