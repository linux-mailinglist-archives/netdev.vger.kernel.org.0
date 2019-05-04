Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4693D13967
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfEDLCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:02:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38172 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDLCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:02:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id f2so4594037wmj.3;
        Sat, 04 May 2019 04:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d9xqRvQ7LglnQSyEdyWwx0LaW1NdfXcmsha1uWwwA5U=;
        b=aEV5cKHE7rw5w8phwcnK4XYABmhkwlqMGBjm4KtKfMkB3HMEFI0UbjyP1MWPKSsuO4
         kV10cFluOgdaRPFW8lcQTDEA3j6cDs/KB4XFx2CjN2ohfEB9IiBX+JjKmplO9ehRUnXi
         M8IfK57Avok/aRvhLtp5YxHlQLOWE/Bf7q4La4FNtfqWZkqCHBTtTAwVTTKze3VeRFBN
         jUM10tGMTAIUns2YSTTTq+AynStJ805mdf6251QBordFuPHO+HdxdEtTAj/LpZX+tWIy
         xwyNyGDc/gxwOuofptU3PJSSPHcKfeq+DuG5LdMzWZ5DzC+Otm7ocsyICkodvIuAUyS+
         O1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d9xqRvQ7LglnQSyEdyWwx0LaW1NdfXcmsha1uWwwA5U=;
        b=WOp5zGp+rJXnUjfAak9oDZimyNV3QY9dzv5gZOI6TKWFUomqtVTdczkTy9kYbhmzOv
         NKkh8p0iXDyvlBunZ1a0EbCVjem3l4t8JviqIbU4dl0QEBOXE+OCQtLH182xBSS8o1Aw
         1bSLciZ6stovJT0zHy+JljzCyIIyKGQWX8SsM5qejhCb5pssMXgL0n2V++lHqDhBzllj
         T0opQRhUL+DLhnTX7dZQIjBF0pAL0WQEX65z6ztcztag3/oRdrKlsJLdycSzigbdGHA8
         ZxICLAoMaXaql/zgvbyHsasF8UHeB7yC7VlaGp81ov9P4TKCzEk4PjRNRLzItZMKpEPJ
         hvlw==
X-Gm-Message-State: APjAAAVTJ63JHIuQOPEqw5gmyxKUwl6JK5N5OuoFJpJA+fgYmu1joDAE
        8FeG7wVsXOvdYKs3YHmcHagvf6jB7/o=
X-Google-Smtp-Source: APXvYqy3dfTFdLwZrygw5pSCGAvurOj9VwUtSKJIX0E/y05IQOuv2UX4urpxWai1LbIz2W3WXRPigg==
X-Received: by 2002:a1c:a008:: with SMTP id j8mr9967493wme.73.1556967751884;
        Sat, 04 May 2019 04:02:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:4cd8:8005:fc98:c429? (p200300EA8BD457004CD88005FC98C429.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:4cd8:8005:fc98:c429])
        by smtp.googlemail.com with ESMTPSA id z4sm3251606wrq.75.2019.05.04.04.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:02:30 -0700 (PDT)
Subject: Re: [PATCH] net: wireless: ath9k: Return an error when
 ath9k_hw_reset() fails
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, ath9k-devel@qca.qualcomm.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190504100815.19876-1-baijiaju1990@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e47117d6-f918-1dd0-834e-d056534bfead@gmail.com>
Date:   Sat, 4 May 2019 13:02:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504100815.19876-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.05.2019 12:08, Jia-Ju Bai wrote:
> ath9k_hw_reset() in ath9k_start() can fail, and in this case, 
> ath9k_start() should return an error instead of executing the 
> subsequent code.
> 
Such mechanical patches w/o understanding the code are always
problematic. Do you have any proof that this error is fatal?
I think it is not, else we wouldn't have this line:
ah->reset_power_on = false;
Also you should consider that a mutex and a spinlock are held.
Maybe changing the error message to a warning would be more
appropriate. But this I would leave to somebody being more
familiar with this driver.

> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index f23cb2f3d296..f78e7c46764d 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -681,6 +681,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
>  			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
>  			r, curchan->center_freq);
>  		ah->reset_power_on = false;
> +		return r;
>  	}
>  
>  	/* Setup our intr mask. */
> 

