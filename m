Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9104EED28
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345883AbiDAMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241810AbiDAMbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:31:34 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D4035DEE
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 05:29:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id i132-20020a1c3b8a000000b0038ce25c870dso3430867wma.1
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 05:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=knarY0P/HR9VLQQwSOZKVbQpfKOi+mXAWn23v+UHOuU=;
        b=es3vNB+gmwleXUR7l3lIqpohW+v8Dt5oOPi/d27WUddaSeFFBuAu9BlbXS8CkgsnUz
         xX9p93HJSwkLh/pszTghxMozVeCn/KeSZLXtv0iO38kVLLNuQRFpjj56IJEKBvyUBi4p
         +MOT83oOqz6fCWpZs5JlmKXLPOfI7okx9BFbMuMLQ8GZl281jTbbDK6xEW2OdAxglyR9
         A2imFYdhQdX1+cHktz80HFIsTZmrD6FCIcegrU9FVr5NeAVEm9v7fFYR2WDz9eWhaHiP
         xTUlGgs7dQMZccji8ThdGwpLtiqmRju7+5vSt4ro7FAC4hVVq/yiDODDqlebMBJCh4kL
         4low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=knarY0P/HR9VLQQwSOZKVbQpfKOi+mXAWn23v+UHOuU=;
        b=uat1PxOh7xqTVXPA9R/x5rCPJGxkHMUtoxqYnNmvv0NlG8hsoCODqRJl5IWRXLcVd3
         PC37jWZbvZbn8wJ54kbzYvLOMSf0KyU7GUStIZGqOfnvVgNuI13TqzjYI98ukj/p0dnv
         HjbQWKDTDasPA2Xj94/MP3Yx3FOEZKkarouMzi3BcBUZI4Y+SNbYPyUXloNJZtcdyui6
         zfovZcdQhpwyQ1s0QmLNgkoYjMTIP+VsdYn+Iu9qJtNOZHmT+g2WvM3PPCmlia5GrtqF
         UuIurJ1rRIWeanuTdZ1MWJ1ewsLJx7gje2CDQ5zsga+s6jzgG+gfuYrp16rAAlukjZR4
         rzfw==
X-Gm-Message-State: AOAM532+AGO1ZDABB5WJRWXFNeuLRQKQbmVznZuNu4fpBICwGniZzpOA
        UYFjmrkGZ1W2nZTVTawRoTvtRA==
X-Google-Smtp-Source: ABdhPJzK9FbrQ+L6WETEz5Zs6aYYBGgKOhOzatOgaMiCxJy5rQAIxQS9fC5rZd0K9XJbOp53GVI/5g==
X-Received: by 2002:a05:600c:1e85:b0:38c:ef05:ba5d with SMTP id be5-20020a05600c1e8500b0038cef05ba5dmr8462294wmb.119.1648816183627;
        Fri, 01 Apr 2022 05:29:43 -0700 (PDT)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id v13-20020adfe28d000000b0020375f27a5asm2036360wri.4.2022.04.01.05.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 05:29:43 -0700 (PDT)
Message-ID: <9fd2c36d-0ac2-357e-23da-9d20397dbb67@linaro.org>
Date:   Fri, 1 Apr 2022 13:29:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND2] net: stmmac: Fix unset max_speed difference
 between DT and non-DT platforms
Content-Language: en-US
To:     Chen-Yu Tsai <wens@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220331184832.16316-1-wens@kernel.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220331184832.16316-1-wens@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/03/2022 19:48, Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
> property"), when DT platforms don't set "max-speed", max_speed is set to
> -1; for non-DT platforms, it stays the default 0.
> 
> Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
> the check for a valid max_speed setting was to check if it was greater
> than zero. This commit got it right, but subsequent patches just checked
> for non-zero, which is incorrect for DT platforms.
> 
> In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> the conversion switched completely to checking for non-zero value as a
> valid value, which caused 1000base-T to stop getting advertised by
> default.
> 
> Instead of trying to fix all the checks, simply leave max_speed alone if
> DT property parsing fails.
> 
> Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
> Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
LGTM,

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


--srini
> 
> Resend2: CC Srinivas at Linaro instead of ST. Collected Russell's ack.
> Resend: added Srinivas (author of first fixed commit) to CC list.
> 
> This was first noticed on ROC-RK3399-PC, and also observed on ROC-RK3328-CC.
> The fix was tested on ROC-RK3328-CC and Libre Computer ALL-H5-ALL-CC.
> 
>   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 5d29f336315b..11e1055e8260 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -431,8 +431,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>   	plat->phylink_node = np;
>   
>   	/* Get max speed of operation from device tree */
> -	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
> -		plat->max_speed = -1;
> +	of_property_read_u32(np, "max-speed", &plat->max_speed);
>   
>   	plat->bus_id = of_alias_get_id(np, "ethernet");
>   	if (plat->bus_id < 0)
