Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CB79C9EA
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbfHZHKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:10:50 -0400
Received: from mx.0dd.nl ([5.2.79.48]:40274 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729625AbfHZHKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 03:10:50 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id E15F95FB9C;
        Mon, 26 Aug 2019 09:10:48 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="pmf2jINY";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 932C11D9D97F;
        Mon, 26 Aug 2019 09:10:48 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 932C11D9D97F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566803448;
        bh=nldrHn+KAKeYnid1IIOCpT7MYz4xEwc91l3x6SgF+6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmf2jINYRJh9VPHOycLU+JkTVk84l9+SH0R5yT6L0GCIN5y13UkDQg8XU5gh7Z1rs
         a2fkMFSj33k6ov18h8wdC5FrcfKK2j+ZWMjHHlZTozWHTIVR+BQ638D3ZvN+DDzMo7
         hNba0C6plwDPWYmE473SdQ+YZZZdvpgixDMwIu8+sTrpadfo9e0gT0FSQhmMBvp+Ve
         Jv31tM4W27rQCcb6WjWVaTqDQUXI9Nea5lUy5q1X/J+QZL7pAfzQssZB0BvdlGukbI
         cdeNqWwE85V+YQAye2auaD937iGkIVCk0ssYmgk/6P3QTSczN7Q8v8VXgg/l4yTgno
         Zg2O3LDULsLIg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 26 Aug 2019 07:10:48 +0000
Date:   Mon, 26 Aug 2019 07:10:48 +0000
Message-ID: <20190826071048.Horde.gwS9nzceYYiYGJLnJ6-x2hz@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Mao Wenan <maowenan@huawei.com>, sr@denx.de
Cc:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, davem@davemloft.net,
        matthias.bgg@gmail.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] net: mediatek: remove set but not used
 variable 'status'
References: <20190824.142158.1506174328495468705.davem@davemloft.net>
 <20190826013118.22720-1-maowenan@huawei.com>
In-Reply-To: <20190826013118.22720-1-maowenan@huawei.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's add Stefan to the conversation.
He is the author of this commit.

Quoting Mao Wenan <maowenan@huawei.com>:

> Fixes gcc '-Wunused-but-set-variable' warning:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function mtk_handle_irq:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c:1951:6: warning:  
> variable status set but not used [-Wunused-but-set-variable]
>
> Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  v2: change format of 'Fixes' tag.
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 8ddbb8d..bb7d623 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1948,9 +1948,7 @@ static irqreturn_t mtk_handle_irq_tx(int irq,  
> void *_eth)
>  static irqreturn_t mtk_handle_irq(int irq, void *_eth)
>  {
>  	struct mtk_eth *eth = _eth;
> -	u32 status;
>
> -	status = mtk_r32(eth, MTK_PDMA_INT_STATUS);

Hi Stefan,

You added an extra MTK_PDMA_INT_STATUS read in mtk_handle_irq()
Is that read necessary to work properly?

Greats,

René


>  	if (mtk_r32(eth, MTK_PDMA_INT_MASK) & MTK_RX_DONE_INT) {
>  		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT)
>  			mtk_handle_irq_rx(irq, _eth);
> --
> 2.7.4




