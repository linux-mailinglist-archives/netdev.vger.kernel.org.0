Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6524055A29
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFYVpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:45:54 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36651 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:45:53 -0400
Received: by mail-oi1-f193.google.com with SMTP id w7so326904oic.3;
        Tue, 25 Jun 2019 14:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JjiTBZ0hm0NbqUS5/4bd1p2NmNnTTnu1Dvo2Kh058WY=;
        b=Fygl8X6neXLKligulReeilyoG0dSjibvXxzB5K3QiSEGWUHn53omMxJXVy6dtXuree
         kapPpf24Ab1SCrm8PcyefWC/Whia9xV1+TwqVpAQZ7sZAUkrSZNwMphtaXACYNcTJHJi
         rSbPkODKXdqJ9kDKvCdN+77fOhnStuSZ0bF2Xqy2yzt3JWH+DpJoMrRKy2Uq4anb3f6Q
         uGwTxo4t3VZXMKgs26OTPKLVpHtn2kXEeFXsnjj/byWFUM0K29RXkjfBg2MCKGWF5yM3
         NTS0mPV+wehGpSuUUPtDptFBNn49ZtpRemI0eP+XnGCfBt18sdjjIrYnBETTN3fEfdUQ
         gs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjiTBZ0hm0NbqUS5/4bd1p2NmNnTTnu1Dvo2Kh058WY=;
        b=iqWVFCd940IYIdJ/FYj4W3p7VXX5racRZQILLgG6J95qrBbPSqzABgMTzhYaD9+S2y
         cuhpe5pccyjgtJxTDBW83Emj9noJ1Lx3xSosdBc/VeM9jhzzdMgnYnAQBtG9cViqADLz
         lRUDw4L3s9VLQ7rGUw+RfaNL+CLqHsP15TSozjR83mHApAd3xBZ7CfFk8dqKdI6HR1SR
         EGczUDhqemqtXMZ+TPF4IsTszubi2l5JO5UoaOEP35fV9BFS0ymJOOsDO7GXgs8fLQNs
         mUCDcoIWSI0/Qz6sO5elLbEsjaWvjNNDaLyr/nFl/Nw+4bLGEtilTLE+AS+9BBZDfOcz
         pnaA==
X-Gm-Message-State: APjAAAWmdtK3BIUS674PmQHqIgHMBaPSjlBREByKIXj1mcL5ZfC2UQ05
        SMdquZpCoo2x2LAxM84dfhDBPgTA
X-Google-Smtp-Source: APXvYqyvvvk+AYvxBruu9uR3BNyKTd9Flkw47/n6y+yQBiIPTNOFBXO56QK9Z9AECIulsn+YmQwmlA==
X-Received: by 2002:aca:3a55:: with SMTP id h82mr2257138oia.49.1561499152775;
        Tue, 25 Jun 2019 14:45:52 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l145sm5772594oib.6.2019.06.25.14.45.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:45:52 -0700 (PDT)
Subject: Re: [PATCH 1/4] b43legacy: remove b43legacy_dma_set_mask
To:     Christoph Hellwig <hch@lst.de>, Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190625102932.32257-1-hch@lst.de>
 <20190625102932.32257-2-hch@lst.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55cf8864-3fa8-a0ed-0887-39ea21085492@lwfinger.net>
Date:   Tue, 25 Jun 2019 16:45:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625102932.32257-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 5:29 AM, Christoph Hellwig wrote:
> These days drivers are not required to fallback to smaller DMA masks,
> but can just set the largest mask they support, removing the need for
> this trial and error logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/net/wireless/broadcom/b43legacy/dma.c | 39 +------------------
>   1 file changed, 1 insertion(+), 38 deletions(-)

The patches work for PPC32 for both b43legacy and b43.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
> index 2ce1537d983c..0c2de20622e3 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/dma.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
> @@ -797,43 +797,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev)
>   	dma->tx_ring0 = NULL;
>   }
>   
> -static int b43legacy_dma_set_mask(struct b43legacy_wldev *dev, u64 mask)
> -{
> -	u64 orig_mask = mask;
> -	bool fallback = false;
> -	int err;
> -
> -	/* Try to set the DMA mask. If it fails, try falling back to a
> -	 * lower mask, as we can always also support a lower one. */
> -	while (1) {
> -		err = dma_set_mask_and_coherent(dev->dev->dma_dev, mask);
> -		if (!err)
> -			break;
> -		if (mask == DMA_BIT_MASK(64)) {
> -			mask = DMA_BIT_MASK(32);
> -			fallback = true;
> -			continue;
> -		}
> -		if (mask == DMA_BIT_MASK(32)) {
> -			mask = DMA_BIT_MASK(30);
> -			fallback = true;
> -			continue;
> -		}
> -		b43legacyerr(dev->wl, "The machine/kernel does not support "
> -		       "the required %u-bit DMA mask\n",
> -		       (unsigned int)dma_mask_to_engine_type(orig_mask));
> -		return -EOPNOTSUPP;
> -	}
> -	if (fallback) {
> -		b43legacyinfo(dev->wl, "DMA mask fallback from %u-bit to %u-"
> -			"bit\n",
> -			(unsigned int)dma_mask_to_engine_type(orig_mask),
> -			(unsigned int)dma_mask_to_engine_type(mask));
> -	}
> -
> -	return 0;
> -}
> -
>   int b43legacy_dma_init(struct b43legacy_wldev *dev)
>   {
>   	struct b43legacy_dma *dma = &dev->dma;
> @@ -844,7 +807,7 @@ int b43legacy_dma_init(struct b43legacy_wldev *dev)
>   
>   	dmamask = supported_dma_mask(dev);
>   	type = dma_mask_to_engine_type(dmamask);
> -	err = b43legacy_dma_set_mask(dev, dmamask);
> +	err = dma_set_mask_and_coherent(dev->dev->dma_dev, dmamask);
>   	if (err) {
>   #ifdef CONFIG_B43LEGACY_PIO
>   		b43legacywarn(dev->wl, "DMA for this device not supported. "
> 

