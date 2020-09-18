Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB43F27075C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIRUsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIRUsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:48:20 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F26C0613CE;
        Fri, 18 Sep 2020 13:48:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 60so6635235otw.3;
        Fri, 18 Sep 2020 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SEWE4bLz78qutGMkH+cJ3lHq5IPoER+Ic3teUKQs/6U=;
        b=fPS4AFT5p2sa0yXrilyfZ+9/jV+2ClR5qmd2NBY+Es4W9QPbPIdQ35PbQDo7GjRRqH
         TddzivINfQGcMgyhml/XgxrhrI2dXZvDDUbTMCWoLn3Te7iSybMvKQjgmNBsV3AX8WeJ
         r7C9On58MGvWwqRO+9S7UAYJA/9cM2RdSKx2/d7eudEZcf0vqmvXh8pBN6FE6i3i52SW
         pN325fp0uRKKiJJRY1H/eRR0l2/EcGsuWbHX6pXnmF1W3ehg7kzSUsyzQzx6y+Jfhbna
         MzoQBPWshNtE+ylbiSEPMDkj3YBpEDbUlokiwsgeANVE4f2eS7HYpwE15y2ydO2EgjaK
         4QkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SEWE4bLz78qutGMkH+cJ3lHq5IPoER+Ic3teUKQs/6U=;
        b=iy/CeYuXi1DETtW8BhroKWQqWwx9gjSUe3BdE07i/FNmk9dQu6HhkcMfwVmoi4Htdz
         0ZSwrhT6XuTRCu/RYeAetg5PMfQAJ1Y75mF19N9m2lAbFPu8nrQpKA/5v/ZEACOyRaqF
         tiq8DG1kt6jnqmwuqTpNzIW0bQnopy+pqixRS+MSf/YP7BldfZBsSnmKQa8jqhvVoVTF
         /zhGT+57vMVipCF4t07JvCDTP+Zcfdjy6imgOdiqhmJnhO5EJ0IbDU/VXxamVrt3bFwt
         B+l6KyVw9ZT6nz/t2/5OXRC3z4J+jPoyBZS6bUtsLlP7ZlgmjnRyWTbBVR7uoIcYRZpL
         7QPA==
X-Gm-Message-State: AOAM533IsElD11ahq9H3mEEukq5jljPKyrNIqfA56rm+zL6eWfde/TcA
        Vnhfps2zmht9IbjFJyNBO+g=
X-Google-Smtp-Source: ABdhPJxCSy39awk0tpFf1Ed5BzA1B/UtcyPA3f7x8jb7Cs2ClIg/oZmz9VTNYvIChNjvOyO6e8tmEg==
X-Received: by 2002:a9d:7448:: with SMTP id p8mr11223612otk.306.1600462099615;
        Fri, 18 Sep 2020 13:48:19 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id i6sm3644075oig.54.2020.09.18.13.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:48:18 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 5/9] rtlwifi: rtl8821ae: fix comparison to bool
 warning in phy.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-6-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <762b547f-1c5e-15cb-ce1f-b94caaebbbe5@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:48:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-6-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1816:5-13: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1825:5-13: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1839:5-13: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> index 7832fae3d00f..38669b4d6190 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> @@ -1813,7 +1813,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
> 
>   	rtstatus = _rtl8821ae_phy_config_bb_with_headerfile(hw,
>   						       BASEBAND_CONFIG_PHY_REG);
> -	if (rtstatus != true) {
> +	if (!rtstatus) {
>   		pr_err("Write BB Reg Fail!!\n");
>   		return false;
>   	}
> @@ -1822,7 +1822,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
>   		rtstatus = _rtl8821ae_phy_config_bb_with_pgheaderfile(hw,
>   						    BASEBAND_CONFIG_PHY_REG);
>   	}
> -	if (rtstatus != true) {
> +	if (!rtstatus) {
>   		pr_err("BB_PG Reg Fail!!\n");
>   		return false;
>   	}
> @@ -1836,7 +1836,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
>   	rtstatus = _rtl8821ae_phy_config_bb_with_headerfile(hw,
>   						BASEBAND_CONFIG_AGC_TAB);
> 
> -	if (rtstatus != true) {
> +	if (!rtstatus) {
>   		pr_err("AGC Table Fail\n");
>   		return false;
>   	}
> --
> 2.26.0.106.g9fadedd
> 

