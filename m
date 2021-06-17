Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E753ABB3B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFQSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFQSSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:18:21 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A6AC061574;
        Thu, 17 Jun 2021 11:16:14 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w127so7478168oig.12;
        Thu, 17 Jun 2021 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lDrvv4SjpRGkcXHTZ4eLR8O6nHpZy/vmSgaV/fvgZQc=;
        b=dDS7K0yryIVcseJxuPdmMMFGGB0HEZPSwv85uGF5IKpvHrqKoQZXn5+Z4dnhycn4dV
         5N3FucpSvxP0B7GWK0i4ztJsX3onaM2qj1pb1/AUwF2HecmpdFHwtHk22XHBFRw7nlwB
         o28/1g/B60d5U9bNdn1hpJuGWnXKHFcTg15AMUtX0HHlLYiIM06JQMAaXQbQbv0V/9jD
         SfPhb9hqWJY96njZ+xFpQYXfpI6U/QgXDc725PtljX3BOBS18wpprrVSMU/OfLHeJoVJ
         gy4t0CCiDhE7bUHyn7zlLmL88NEJlnVcIwpsZH+IsSIjrAUw8b9Rmmlp3SkV96l14vWi
         jDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lDrvv4SjpRGkcXHTZ4eLR8O6nHpZy/vmSgaV/fvgZQc=;
        b=NfrW8diJNLfl15zfoAebA6KhMLVzTWz/XS46sRILPaA70BMitUNwVe+a2lqveab9MZ
         BxDeekVIvAftvvnscScpm7fIgPR51kV34WoX38smFWSZOvoS6SOTc9o01GISOqIROQNi
         123Uf4/qmw04qJ7fLa5Xag2YB2PM2rDjM7BS+ccyPckw4qp+WyXh6XcAm1DBXKjX0GG1
         eiAULtK1iPJAwBLA/yrZsERPwjYM0bLREwE71RrDvAkQM2BnUkCh7Mlpo46gp7VxxLRy
         yeOABTdKnG9wjIg09AQpxKcXdNl4bG5Wb+PMzTSk4opjHsHXSO1GvI40m90eceZSNOqs
         8g0A==
X-Gm-Message-State: AOAM5327qtiZ7ReRd16AFVnqy1V9c/MHNyA+TVV5VF7GxKX7Wud7HJX9
        cOnlqV0l5dwc1z0CFnkfGJ8z7WUMmvk=
X-Google-Smtp-Source: ABdhPJzL4f3FCY/yfEYFwYetlXRUTOfrxQ09K6/SCwmy1h9jq+scI9PwkZczubIUdPL2JypV+NXXsQ==
X-Received: by 2002:aca:4a46:: with SMTP id x67mr11539185oia.59.1623953771779;
        Thu, 17 Jun 2021 11:16:11 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v82sm1275328oia.27.2021.06.17.11.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 11:16:10 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fully initialize curvecount_val
To:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210617171317.3410722-1-keescook@chromium.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <92f5a610-a623-b17d-40ba-963e3e84c622@lwfinger.net>
Date:   Thu, 17 Jun 2021 13:16:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210617171317.3410722-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 12:13 PM, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring array fields.
> 
> The size argument to memset() is bytes, but the array element size
> of curvecount_val is u32, so "CV_CURVE_CNT * 2" was only 1/4th of the
> contents of curvecount_val. Adjust memset() to wipe full buffer size.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index 68ec009ea157..76dd881ef9bb 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -2574,7 +2574,7 @@ static void _rtl92d_phy_lc_calibrate_sw(struct ieee80211_hw *hw, bool is2t)
>   			RTPRINT(rtlpriv, FINIT, INIT_IQK,
>   				"path-B / 2.4G LCK\n");
>   		}
> -		memset(&curvecount_val[0], 0, CV_CURVE_CNT * 2);
> +		memset(curvecount_val, 0, sizeof(curvecount_val));
>   		/* Set LC calibration off */
>   		rtl_set_rfreg(hw, (enum radio_path)index, RF_CHNLBW,
>   			      0x08000, 0x0);
> 

Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
