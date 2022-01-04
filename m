Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1250E48471F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiADRl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbiADRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:41:22 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F64CC06179C;
        Tue,  4 Jan 2022 09:41:16 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so1844692wmd.5;
        Tue, 04 Jan 2022 09:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=p7d4ATVOqgVJzPZhbhfgXdi7JK3IlTXgeAj0xIpqxpQ=;
        b=E0qK5PRMm7iO1cNCfybAmbXBv3ez9jHa4YRyj0t2Mu9Y09oBKtcRJhk3ikKZ2X3Fru
         LrCZzujfGiIsd7303DWnJCqz+/AIebOAvVnmo4MPcLjVXD5eYYR5YQWxQ/0kZgCz1NCt
         uyexMGGq2sXUlqi9S0a2WacdszOWkijoLJFqkNlYR3q45qMuOmyawPPRhsmQALybmHU4
         5kPzZ+s31itdC3BHQ7/QXCGRyRpoNtdVHSdGL3LMZG6iDe4onTjOlN1ZD+8XPjKFpdkP
         udIpmUKuBYydqynCk1pzUDWjUhE61SaNkrnwy1LmnaUd6Ko2qirdjE6/+5Od57ZjiP6c
         IKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p7d4ATVOqgVJzPZhbhfgXdi7JK3IlTXgeAj0xIpqxpQ=;
        b=FWYenK/2joV6MZ1eBptASi7tc3+us9yMT9D1gLnlkA7mU15Ln5ekIBSFPmc57/OduB
         cMpl5U7caJxhd9t5bZ9dsI42knbDTUCCg5Wpe75LyMWa/r77CGX2BUYlJsVzdz72E2oM
         o88ZGJU+I5oerxDxygH6ZJpsyzny+4kSYLM/8WbkUBPj+hlIMvMeyykeebMlt6NxlDzi
         IKtmVLZLF+OSNP9gxifW+7s4hOMPofc8wc+qsWXhLcQK4MIPqIvT9qt63p0CWAI/yYS4
         RdGS8GDd1azY0Z1+U1NMT0mWtWSKq/VIEG0m3E7IcaWKcW8aA2sPgt6GgD+xmAqJhJVA
         Iqaw==
X-Gm-Message-State: AOAM530b/5tWsgkwa+OrdyUPXMB776B9tN0mSHGCeGkYPOFCyMF6g52T
        xY7cVme5/uQTeEHCJGjdmMct3trVHjKZ3A==
X-Google-Smtp-Source: ABdhPJxU5E7HPujTnVS3JaiI6qCKagtfA8FeTWGh+b9HXHFLfNidqlEY62VvLikAmixN06fy9HtM9A==
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr43273240wmh.109.1641318075228;
        Tue, 04 Jan 2022 09:41:15 -0800 (PST)
Received: from [10.0.0.4] ([37.165.184.46])
        by smtp.gmail.com with ESMTPSA id a144sm566847wmd.2.2022.01.04.09.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 09:41:14 -0800 (PST)
Message-ID: <0215980e-a258-5322-13e9-42fe868817b3@gmail.com>
Date:   Tue, 4 Jan 2022 09:41:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: lantiq_xrx200: add ingress SG DMA support
Content-Language: en-US
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220103194316.1116630-1-olek2@wp.pl>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220103194316.1116630-1-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/3/22 11:43, Aleksander Jan Bajkowski wrote:
> This patch adds support for scatter gather DMA. DMA in PMAC splits
> the packet into several buffers when the MTU on the CPU port is
> less than the MTU of the switch. The first buffer starts at an
> offset of NET_IP_ALIGN. In subsequent buffers, dma ignores the
> offset. Thanks to this patch, the user can still connect to the
> device in such a situation. For normal configurations, the patch
> has no effect on performance.
>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>   drivers/net/ethernet/lantiq_xrx200.c | 47 +++++++++++++++++++++++-----
>   1 file changed, 40 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 80bfaf2fec92..503fb99c5b90 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -27,6 +27,9 @@
>   #define XRX200_DMA_TX		1
>   #define XRX200_DMA_BURST_LEN	8
>   
> +#define XRX200_DMA_PACKET_COMPLETE	0
> +#define XRX200_DMA_PACKET_IN_PROGRESS	1
> +
>   /* cpu port mac */
>   #define PMAC_RX_IPG		0x0024
>   #define PMAC_RX_IPG_MASK	0xf
> @@ -62,6 +65,9 @@ struct xrx200_chan {
>   	struct ltq_dma_channel dma;
>   	struct sk_buff *skb[LTQ_DESC_NUM];
>   
> +	struct sk_buff *skb_head;
> +	struct sk_buff *skb_tail;
> +
>   	struct xrx200_priv *priv;
>   };
>   
> @@ -205,7 +211,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>   	struct xrx200_priv *priv = ch->priv;
>   	struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->dma.desc];
>   	struct sk_buff *skb = ch->skb[ch->dma.desc];
> -	int len = (desc->ctl & LTQ_DMA_SIZE_MASK);
> +	u32 ctl = desc->ctl;
> +	int len = (ctl & LTQ_DMA_SIZE_MASK);
>   	struct net_device *net_dev = priv->net_dev;
>   	int ret;
>   
> @@ -221,12 +228,36 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>   	}
>   
>   	skb_put(skb, len);
> -	skb->protocol = eth_type_trans(skb, net_dev);
> -	netif_receive_skb(skb);
> -	net_dev->stats.rx_packets++;
> -	net_dev->stats.rx_bytes += len;
>   
> -	return 0;
> +	/* add buffers to skb via skb->frag_list */
> +	if (ctl & LTQ_DMA_SOP) {
> +		ch->skb_head = skb;
> +		ch->skb_tail = skb;
> +	} else if (ch->skb_head) {
> +		if (ch->skb_head == ch->skb_tail)
> +			skb_shinfo(ch->skb_tail)->frag_list = skb;
> +		else
> +			ch->skb_tail->next = skb;
> +		ch->skb_tail = skb;
> +		skb_reserve(ch->skb_tail, -NET_IP_ALIGN);
> +		ch->skb_head->len += skb->len;
> +		ch->skb_head->data_len += skb->len;
> +		ch->skb_head->truesize += skb->truesize;
> +	}
> +
> +	if (ctl & LTQ_DMA_EOP) {
> +		ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
> +		netif_receive_skb(ch->skb_head);
> +		net_dev->stats.rx_packets++;
> +		net_dev->stats.rx_bytes += ch->skb_head->len;


Use after free alert.

Please add/test the following fix.

(It is illegal to deref skb after netif_receive_skb())


diff --git a/drivers/net/ethernet/lantiq_xrx200.c 
b/drivers/net/ethernet/lantiq_xrx200.c
index 503fb99c5b90..bf7e3c7910d1 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -247,9 +247,9 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)

         if (ctl & LTQ_DMA_EOP) {
                 ch->skb_head->protocol = eth_type_trans(ch->skb_head, 
net_dev);
-               netif_receive_skb(ch->skb_head);
                 net_dev->stats.rx_packets++;
                 net_dev->stats.rx_bytes += ch->skb_head->len;
+               netif_receive_skb(ch->skb_head);
                 ch->skb_head = NULL;
                 ch->skb_tail = NULL;
                 ret = XRX200_DMA_PACKET_COMPLETE;



> +		ch->skb_head = NULL;
> +		ch->skb_tail = NULL;
> +		ret = XRX200_DMA_PACKET_COMPLETE;
> +	} else {
> +		ret = XRX200_DMA_PACKET_IN_PROGRESS;
> +	}
> +
> +	return ret;
>   }
>   
>   static int xrx200_poll_rx(struct napi_struct *napi, int budget)
> @@ -241,7 +272,9 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>   
>   		if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) == LTQ_DMA_C) {
>   			ret = xrx200_hw_receive(ch);
> -			if (ret)
> +			if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
> +				continue;
> +			if (ret != XRX200_DMA_PACKET_COMPLETE)
>   				return ret;
>   			rx++;
>   		} else {
