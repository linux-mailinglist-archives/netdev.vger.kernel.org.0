Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079CE270766
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIRUt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:49:27 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6A3C0613CE;
        Fri, 18 Sep 2020 13:49:27 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w16so8605091oia.2;
        Fri, 18 Sep 2020 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KnYbvRtxo0h0fpybH55VXe8NUzazXfD/y41Wf1JnDlE=;
        b=JcRy0hN2PjkSLdOSRq6P93Hb1FHJNiYdVmFoGHczPCJQkncXi+IeKPsJDA92+UrolX
         7jx/kI7VeGiikiK2F8MsW9HSgSa0pzrd85sQ0xdbqbiUzrROvnGEyVHGOUM+Z5lKTjDO
         VyO0hIkVN1rTWwqGhyUDAJk/yZkmqrNily+VncF0RDOT6FPlY0PEfwod+ZIrFY8TEIqu
         asJvHChIZZFPqaAkgM/iP5U1TBrSjcm9PR0q+JmtHLY774uvJmZXbpCvBgDuvKa/JSD2
         QuTgzyBKcIXCAgeEe1zhYxX6t133WrWxhFockczYVIYekw3gNEsOtH+Vy3Y78BDGJHbe
         N/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KnYbvRtxo0h0fpybH55VXe8NUzazXfD/y41Wf1JnDlE=;
        b=iDjlX6Knxhv5rohyFW03a+jKcR29DMhfoqNeviUh0SeMljLO5Y83kmkoLNR+FPAZk0
         CM39pebQdB6QLE7dAvQ6lyf/9+fyCgFClEMoOmQhJm1vI6gjjnELOKDh7+Ph7uwwOBZI
         jgPJnLO65uVJmmgu332QJxkLSlxUOYklySNg+uhws4rlUoPSHNUC/qaR2DF61AvC07ko
         0YY/SmptfXdqoMnWBmC1R5SPCWSHiGdlkG+YhlkeS6Q6fYCKONWzllGaWRQF0XJD6lkh
         sXz2tAKyZ+iJPTPQ8HDNhSSYFC2MQTsx+2HkUJQl7goiPeipEkYAMXWQSL8hUeYNMWSd
         F2fw==
X-Gm-Message-State: AOAM532Bn7JC/dgLOsYQSfdlfPybWI8onB2MUrvyEsFFU4XDwo0fXFKf
        R47XRTyjz5HwG8mjCBF9lRg=
X-Google-Smtp-Source: ABdhPJzvw5kPnDD/8Ya/GQ6drXLFN3YPqKAoTQIt63Je1zkveyrKmL7T+ziVl/jbEQkLLVwG6m/ugQ==
X-Received: by 2002:aca:aa85:: with SMTP id t127mr10006203oie.46.1600462166944;
        Fri, 18 Sep 2020 13:49:26 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d63sm3715849oig.53.2020.09.18.13.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:49:26 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 8/9] rtlwifi: rtl8192de: fix comparison to bool
 warning in hw.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-9-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <72b79a89-193b-b087-c6fd-6a529c98be06@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:49:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-9-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:566:14-20: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:572:13-19: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:581:14-20: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:587:13-19: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> index 2deadc7339ce..f849291cc587 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> @@ -563,13 +563,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
>   	/* 18.  LLT_table_init(Adapter);  */
>   	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
>   		status = _rtl92de_llt_write(hw, i, i + 1);
> -		if (true != status)
> +		if (!status)
>   			return status;
>   	}
> 
>   	/* end of list */
>   	status = _rtl92de_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
> -	if (true != status)
> +	if (!status)
>   		return status;
> 
>   	/* Make the other pages as ring buffer */
> @@ -578,13 +578,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
>   	/* Otherwise used as local loopback buffer.  */
>   	for (i = txpktbuf_bndy; i < maxpage; i++) {
>   		status = _rtl92de_llt_write(hw, i, (i + 1));
> -		if (true != status)
> +		if (!status)
>   			return status;
>   	}
> 
>   	/* Let last entry point to the start entry of ring buffer */
>   	status = _rtl92de_llt_write(hw, maxpage, txpktbuf_bndy);
> -	if (true != status)
> +	if (!status)
>   		return status;
> 
>   	return true;
> --
> 2.26.0.106.g9fadedd
> 

