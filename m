Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B84338DEEA
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhEXBhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhEXBhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 21:37:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF200C061574;
        Sun, 23 May 2021 18:36:06 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l70so18925007pga.1;
        Sun, 23 May 2021 18:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=kHbqGf+dcW6eQ7W/I/2gwdTjULIyBETu/yp5c/37iCs=;
        b=YIXBM1KU+GlzGygGoFFI1EOwEi7wI6pYzECjP9L8nRZ5CnLUNXMSwREEDSoGH/8ZQ3
         toVBz0TJLzlf2bQ9vmvW3nctaQ8PfxipOleG8xJXFOUxDfyPDtGUoAMedxDJkTGp4bmu
         HmhGikudvmEOpsy12TAOd9OcimPNKjMuigjOdOVK4hEIgM09xyMYjuv/BQN1B1+Pn+Yv
         8XStv6Af3ym9YRa+cX6o3fy56pOWgpoBZD6rraC34wA5Ux0NW39NBs23S0Gc2+ztvi+E
         cqSpPsCmyKdhcicFG28DJA2IQY8T3a8xRJncDLue+089c2rx8P9MxZ2VX+EWstbWCOyA
         kblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kHbqGf+dcW6eQ7W/I/2gwdTjULIyBETu/yp5c/37iCs=;
        b=fvcP88jaSi/UVgJ8ggvM21AT8p2NPHtAaL4vDB78tk47XPLt4zoPiguol5AhiuDCD6
         bUteY4gxFcWVI1+tRPLoxnEmT6aJRO4Xre2Kcnk9HEJ6GyXk7zfUvxbRU4WXbwoMGRYy
         hmeFHwW2sTkKYAOxgqgS7AE0L4BYjN/+KiZ1WB6U0YZFW0gJ1oedhjqkuwlPdZ88PU82
         CP5UfDUFl+p2RcUfc8ZkeDvzx4IS5tR5cPnS0JOZbEcPTxCfNQh4oiN6trVs5kV9WFgc
         chVOyE/2ElLNrWn5flNeCOLFiDnXrFbtnXzFenhE3Q8+wNauSzyn/JVtJYFoOLlONfrp
         7B9A==
X-Gm-Message-State: AOAM530AyMoPyUJk64V5UFlK7wOUabpwcdgyRxDwJoe75mI6ZIt/4F2v
        VDtsTXCp0MsJNFZu8NpdO4nfxpkAixw=
X-Google-Smtp-Source: ABdhPJw/MaRjWRT1jjmHjlPuI6gQku/kDALE4+pUGjqrS7A35zxhWi3xnuEXDjLzYU8RMDdYmpJo8w==
X-Received: by 2002:a63:3c56:: with SMTP id i22mr10887945pgn.25.1621820165953;
        Sun, 23 May 2021 18:36:05 -0700 (PDT)
Received: from [10.145.1.94] ([45.135.186.50])
        by smtp.gmail.com with ESMTPSA id w8sm10495146pgf.81.2021.05.23.18.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 18:36:05 -0700 (PDT)
Subject: Re: [PATCH] cw1200: Revert unnecessary patches that fix unreal
 use-after-free bugs
To:     Hang Zhang <zh.nvgt@gmail.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210521223238.25020-1-zh.nvgt@gmail.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <ef2d1a68-cfd2-4a0e-0e11-12b750ea25fa@gmail.com>
Date:   Mon, 24 May 2021 09:36:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20210521223238.25020-1-zh.nvgt@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for fixing my previous mistake.
The patch looks good.

On 2021/5/22 6:32, Hang Zhang wrote:
> A previous commit 4f68ef64cd7f ("cw1200: Fix concurrency
> use-after-free bugs in cw1200_hw_scan()") tried to fix a seemingly
> use-after-free bug between cw1200_bss_info_changed() and
> cw1200_hw_scan(), where the former frees a sk_buff pointed
> to by frame.skb, and the latter accesses the sk_buff
> pointed to by frame.skb. However, this issue should be a
> false alarm because:
>
> (1) "frame.skb" is not a shared variable between the above
> two functions, because "frame" is a local function variable,
> each of the two functions has its own local "frame" - they
> just happen to have the same variable name.
>
> (2) the sk_buff(s) pointed to by these two "frame.skb" are
> also two different object instances, they are individually
> allocated by different dev_alloc_skb() within the two above
> functions. To free one object instance will not invalidate
> the access of another different one.
>
> Based on these facts, the previous commit should be unnecessary.
> Moreover, it also introduced a missing unlock which was
> addressed in a subsequent commit 51c8d24101c7 ("cw1200: fix missing
> unlock on error in cw1200_hw_scan()"). Now that the
> original use-after-free is unreal, these two commits should
> be reverted. This patch performs the reversion.
>
> Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
> Fixes: 51c8d24101c7 ("cw1200: fix missing unlock on error in cw1200_hw_scan()")
> Signed-off-by: Hang Zhang <zh.nvgt@gmail.com>
> ---
>   drivers/net/wireless/st/cw1200/scan.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
> index 988581cc134b..1f856fbbc0ea 100644
> --- a/drivers/net/wireless/st/cw1200/scan.c
> +++ b/drivers/net/wireless/st/cw1200/scan.c
> @@ -75,30 +75,27 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
>   	if (req->n_ssids > WSM_SCAN_MAX_NUM_OF_SSIDS)
>   		return -EINVAL;
>   
> -	/* will be unlocked in cw1200_scan_work() */
> -	down(&priv->scan.lock);
> -	mutex_lock(&priv->conf_mutex);
> -
>   	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
>   		req->ie_len);
> -	if (!frame.skb) {
> -		mutex_unlock(&priv->conf_mutex);
> -		up(&priv->scan.lock);
> +	if (!frame.skb)
>   		return -ENOMEM;
> -	}
>   
>   	if (req->ie_len)
>   		skb_put_data(frame.skb, req->ie, req->ie_len);
>   
> +	/* will be unlocked in cw1200_scan_work() */
> +	down(&priv->scan.lock);
> +	mutex_lock(&priv->conf_mutex);
> +
>   	ret = wsm_set_template_frame(priv, &frame);
>   	if (!ret) {
>   		/* Host want to be the probe responder. */
>   		ret = wsm_set_probe_responder(priv, true);
>   	}
>   	if (ret) {
> -		dev_kfree_skb(frame.skb);
>   		mutex_unlock(&priv->conf_mutex);
>   		up(&priv->scan.lock);
> +		dev_kfree_skb(frame.skb);
>   		return ret;
>   	}
>   
> @@ -120,8 +117,8 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
>   		++priv->scan.n_ssids;
>   	}
>   
> -	dev_kfree_skb(frame.skb);
>   	mutex_unlock(&priv->conf_mutex);
> +	dev_kfree_skb(frame.skb);
>   	queue_work(priv->workqueue, &priv->scan.work);
>   	return 0;
>   }

Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>


Best wishes,
Jia-Ju Bai
