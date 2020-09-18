Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC8E270769
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIRUtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:49:49 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C218AC0613CE;
        Fri, 18 Sep 2020 13:49:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id y5so6630162otg.5;
        Fri, 18 Sep 2020 13:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6KkfOlKQIaWtyfOevhupH1s1bYyIC6ABSgltqbmoQw4=;
        b=lluK4FaljicIdmBLv5XPthHLdZHhXfmeV/Qc234slm/ZfarEuhTN753e4x4KaadLIu
         YyhwhsI/0/EGYkCmJ6uYlQsCszjY0OU+lBdxeeMz7nPjA1bxCf8HM9nYAmN13MrZkNcU
         Ez5juY+erebiXtgIbwUqlMalo/0fsbdDfb1G/L1yT8Enh1UXYCN6joQzpDW3uGck5qg8
         ilgXOScKmJk9yu5wIMbvO7NAq3aHNKwdHfXpXIiz1KLt/pPYW70NRdn6visVo5HfB1PP
         M4UiYeSiYhstwkV3Be7i1ubE0zrHOQv/3i5qdbE/FNBUCL44E0e8Sd2nt8yzsH+Kxq5s
         fYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6KkfOlKQIaWtyfOevhupH1s1bYyIC6ABSgltqbmoQw4=;
        b=l1CJV3kr/eP3JGm605qTFQTjIOrAAEV157SYIaMu5de+UrLVYcYfW/4ROWOdmxsodh
         8bSthUtPwyf5NvqWZEY08Bgh3413qdOzTYXOQJb8cpUwBDofs5RdKxflMD2ARluf1MlY
         6Vngjqdqo6omktD6yzAMEb0JJ7hdA2WgRCDViZ49raljy1jywGRafkOuQrBPvaLTLK4U
         rwoaPjSfdZ1Pu1BtFRRhj/ovA+PEhlnM7/4MoGzpSKnB5XTHfMfiv0mWYumBWJd1vILA
         JK5XQNXkEmwFTfWdGQD5vo/bHXTc+LbUubJaoh05jLCznIA2rl7WTEHjNiLBcjolCxtI
         NLnA==
X-Gm-Message-State: AOAM532ln25lbQFDnNRnj2K/kyTTgp3+zyZXXy2+VGP5ElfEOiTcEmP6
        mU1fQ94CDe2XSu8Wb63UYIA=
X-Google-Smtp-Source: ABdhPJyrRulMsjoBfIFbzGiOD1bug6oJnhrXMm7Ik8OTUigZ259cK92WVZxrLufHpUW7QZoqOByqoQ==
X-Received: by 2002:a9d:65d1:: with SMTP id z17mr24610562oth.79.1600462188234;
        Fri, 18 Sep 2020 13:49:48 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k16sm3592839oij.56.2020.09.18.13.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:49:47 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 9/9] rtlwifi: rtl8723be: fix comparison to bool
 warning in hw.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-10-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <09ee4bfd-d010-a185-7050-702a9e9d8bd7@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:49:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-10-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c:861:6-35: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
> index 3c7ba8214daf..0748aedce2ad 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
> @@ -858,7 +858,7 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
>   	rtl_write_word(rtlpriv, REG_CR, 0x2ff);
> 
>   	if (!rtlhal->mac_func_enable) {
> -		if (_rtl8723be_llt_table_init(hw) == false)
> +		if (!_rtl8723be_llt_table_init(hw))
>   			return false;
>   	}
> 
> --
> 2.26.0.106.g9fadedd
> 

