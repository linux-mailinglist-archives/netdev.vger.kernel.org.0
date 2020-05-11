Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D591CE43D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgEKTY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 15:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729453AbgEKTY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 15:24:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A23C061A0C;
        Mon, 11 May 2020 12:24:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so20645037wmc.5;
        Mon, 11 May 2020 12:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxtARxCkPHWXnqT8lNpH00A1Ut0N5U8vfZ7iT6ckY1E=;
        b=AG7MZsX4ZOvpaULyOTIRKeZi/M6nLPWkPou4BnwRwJjZZDbwmwc2GN+LFtRg6wIESO
         vDwFcsA0F9F8GADGT963+l1vut2xgX7EXRxhHkCv6hTX5WfGbNkIvpOrqt1P8oTzAJz/
         m5qsiNAMDXCrGhAu62TssTPTyLX86ziIjlYQYM28Z3sLDG7euOQE0FHm9wmb/jvmSBPV
         KXJj34jfWOCW4evwPoBU2tc+6EDIbrbGKo00RF3+ioMJPD8pnCrwjacGigLPWEAZQdRO
         mH1+73oEcvkmFLleEXiquqHS2lIN9MqN2mLm+NJaK2yDyzE4nh5a5CG9TexWJG6o0TWy
         oyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxtARxCkPHWXnqT8lNpH00A1Ut0N5U8vfZ7iT6ckY1E=;
        b=Xg9hdysoE3KkZu0il9CNMK/6vq58uuFuFfbnAaXAWc6JBt288Qsv91C+xXts9OP/7q
         PMH6XmpApW2M8+Km+gEVJ+8sHozwRLRiiy9OJpNnjYMrptuRTC0ei9BNdB45R5XY5qhJ
         12lu9Xhcrfcb99LZI+WGAnVq0nwHH9f7Hccp/Dy1x+D3gSpa5mfjpCI2gFiF1MJ3qQRa
         uGdJssDVfAeq6Sf30FnacLVI7xUdZIBHCpQmbXQsMgrNcQ/f3HJNYji/DOjff6YefXhA
         rI1I+6layG3SicCvEAY1B/g1wuoRwaAPOrkHOevyYdskMt66SIyThVEc4ymKiL//njDT
         cVqQ==
X-Gm-Message-State: AGi0PuasNtS1aIYhDjCKo0p/fkATtl09lFy/vMjDvBUDI5fmhD5LRMJk
        8uaTTutH7tmxJRfRV20QC5Q=
X-Google-Smtp-Source: APiQypJW5vvk30z5iWdY0hSQCc1Ykgc7TXvbdxesRiVaoSvVocTszQuT5j6sF6kDtbT7WU3aCncc9w==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr33787682wmb.116.1589225065733;
        Mon, 11 May 2020 12:24:25 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p4sm8187632wrq.31.2020.05.11.12.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 12:24:25 -0700 (PDT)
Subject: Re: [PATCH v2 09/14] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200511150759.18766-1-brgl@bgdev.pl>
 <20200511150759.18766-10-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dab80587-a196-e0ab-ae97-f8e5cc4a71d4@gmail.com>
Date:   Mon, 11 May 2020 12:24:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511150759.18766-10-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 8:07 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> family. For now we only support full-duplex.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---

[snip]

> +static int mtk_mac_ring_pop_tail(struct mtk_mac_ring *ring,
> +				 struct mtk_mac_ring_desc_data *desc_data)
> +{
> +	struct mtk_mac_ring_desc *desc = &ring->descs[ring->tail];
> +	unsigned int status;
> +
> +	/* Let the device release the descriptor. */
> +	dma_rmb();
> +	status = desc->status;
> +
> +	if (!(status & MTK_MAC_DESC_BIT_COWN))
> +		return -1;
> +
> +	desc_data->len = status & MTK_MAC_DESC_MSK_LEN;
> +	desc_data->flags = status & ~MTK_MAC_DESC_MSK_LEN;
> +	desc_data->dma_addr = desc->data_ptr;
> +	desc_data->skb = ring->skbs[ring->tail];
> +
> +	desc->data_ptr = 0;
> +	desc->status = MTK_MAC_DESC_BIT_COWN;
> +	if (status & MTK_MAC_DESC_BIT_EOR)
> +		desc->status |= MTK_MAC_DESC_BIT_EOR;

Don't you need a dma_wmb() for the device to observe the new descriptor
here?

[snip]

> +static void mtk_mac_dma_unmap_tx(struct mtk_mac_priv *priv,
> +				 struct mtk_mac_ring_desc_data *desc_data)
> +{
> +	struct device *dev = mtk_mac_get_dev(priv);
> +
> +	return dma_unmap_single(dev, desc_data->dma_addr,
> +				desc_data->len, DMA_TO_DEVICE);

If you stored a pointer to the sk_buff you transmitted, then you would
need an expensive read to the descriptor to determine the address and
length, and you would also not be at the mercy of the HW putting
incorrect values there.

sp
> +static void mtk_mac_dma_init(struct mtk_mac_priv *priv)
> +{
> +	struct mtk_mac_ring_desc *desc;
> +	unsigned int val;
> +	int i;
> +
> +	priv->descs_base = (struct mtk_mac_ring_desc *)priv->ring_base;
> +
> +	for (i = 0; i < MTK_MAC_NUM_DESCS_TOTAL; i++) {
> +		desc = &priv->descs_base[i];
> +
> +		memset(desc, 0, sizeof(*desc));
> +		desc->status = MTK_MAC_DESC_BIT_COWN;
> +		if ((i == MTK_MAC_NUM_TX_DESCS - 1) ||
> +		    (i == MTK_MAC_NUM_DESCS_TOTAL - 1))
> +			desc->status |= MTK_MAC_DESC_BIT_EOR;
> +	}
> +
> +	mtk_mac_ring_init(&priv->tx_ring, priv->descs_base, 0);
> +	mtk_mac_ring_init(&priv->rx_ring,
> +			  priv->descs_base + MTK_MAC_NUM_TX_DESCS,
> +			  MTK_MAC_NUM_RX_DESCS);
> +
> +	/* Set DMA pointers. */
> +	val = (unsigned int)priv->dma_addr;

You would probably add a WARN_ON() or something that catches the upper
32-bits of the dma_addr being set, see my comment about the DMA mask
setting.

[snip]

> +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> +{
> +	struct net_device *ndev = priv_to_netdev(priv);
> +	struct mtk_mac_ring *ring = &priv->tx_ring;
> +	int ret;
> +
> +	for (;;) {
> +		mtk_mac_lock(priv);
> +
> +		if (!mtk_mac_ring_descs_available(ring)) {
> +			mtk_mac_unlock(priv);
> +			break;
> +		}
> +
> +		ret = mtk_mac_tx_complete_one(priv);
> +		if (ret) {
> +			mtk_mac_unlock(priv);
> +			break;
> +		}
> +
> +		if (netif_queue_stopped(ndev))
> +			netif_wake_queue(ndev);
> +
> +		mtk_mac_unlock(priv);
> +	}

Where do you increment the net_device statistics to indicate the bytes
and packets transmitted?

[snip]

> +	mtk_mac_set_mode_rmii(priv);
> +
> +	dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));

Your code assumes that DMA addresses are not going to be >= 4GB so you
should be checking this function's return code and abort here otherwise
your driver will fail in surprisingly difficult ways to debug.
-- 
Florian
