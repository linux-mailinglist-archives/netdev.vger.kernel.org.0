Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2047EDCA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 10:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352259AbhLXJam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 04:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352252AbhLXJaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 04:30:39 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941A4C061401;
        Fri, 24 Dec 2021 01:30:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q16so16496789wrg.7;
        Fri, 24 Dec 2021 01:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=EJQtFTzz9lwvfgf1qw1K/0Ljk8OXzOsLX8IG2GBDVhk=;
        b=SLOebor4t29N3kvyTeRO9KKbsNldrRZ1/WIKSilbdlggR1xPz+64+QcVEh/QWpvfJm
         wmz8OfwLUIlRtmvKBYdcCYnvZ/lVb5LFIt7/lVBIbbYr9AvTNxGyhLvOjQ3oE5+Ainp/
         Eqjba0RLE56yetCzhECjH4EuJxOIqno4gmyn3WMLIwU5cBOf/1WwNprHJtYupcZYACkj
         dsoPsZNejZJMVfB7qEy2TbGpn1ZfD5gvw6eXz85NKTpeBzC86IUQ11m91FuLav7V99aM
         bqwXA04fTE0/8/4TEyWmoZT8Vh+2mgzPfmbHyDJq1Og/TtfBz2xp5ggKpTIvPg9jsrKP
         Ua/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=EJQtFTzz9lwvfgf1qw1K/0Ljk8OXzOsLX8IG2GBDVhk=;
        b=vczsmbL23w4awuxi/Mhr80CDRenzr+Z4QLd2c6WTKXuRzaJAQv4Vt3aqGfKMd2/fuN
         nQtRecksm0ZD1WpqmhsK6oN/dIMkwr8L55wK17kPfOODH2vU16aYSJzjBvvyJ9Fg3H5I
         T1zpWS4+Xv95SUnIbJysUock//QaA+WWIPG0vFMhN6jY+g7eJVPx3XDNB4l2WA/aImlI
         Hy5RL/fiTzG7YmVYHOPwY8y6j0jhfVgJKiyHuQU3hd/1ar9/uX4dbPk/4NDtF0hAEs34
         fbFvuD86Ieq3sS8aAA2EgUewCfbbXfa8iTZOd0TEZFaG659qTXT5RkRV9qaUU70fuy+R
         zMLA==
X-Gm-Message-State: AOAM530NhvWXBeq5Cmu0lEB3nyJb6mH3T+RwU+Pyv1a3tA5NT23ZBNKi
        DvOM0mH12Cng9b7Z3fMVkZFH8pqbdTM=
X-Google-Smtp-Source: ABdhPJwyhGykyU41jwFR7DtKGJCl4l+j+5Heq+Q4I/odmPNJmBAg6G/C57xgLMGmbrCbaJ9hvxXbLQ==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr4238550wrv.126.1640338238191;
        Fri, 24 Dec 2021 01:30:38 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:8bf:4fa4:e765:100f? (p200300ea8f24fd0008bf4fa4e765100f.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:8bf:4fa4:e765:100f])
        by smtp.googlemail.com with ESMTPSA id v1sm8101709wru.45.2021.12.24.01.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Dec 2021 01:30:37 -0800 (PST)
Message-ID: <30be5b7d-3049-6bb9-9dc2-61b80fed10e0@gmail.com>
Date:   Fri, 24 Dec 2021 10:30:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net
Cc:     kuba@kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20211224091208.32274-1-yang.lee@linux.alibaba.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH -next] net: phy: micrel: use min() macro instead of doing
 it manually
In-Reply-To: <20211224091208.32274-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.12.2021 10:12, Yang Li wrote:
> Fix following coccicheck warning:
> ./drivers/net/phy/micrel.c:1482:12-13: WARNING opportunity for min()
> 
Please always check whether a coccicheck warning makes sense,
and don't create "fixes" mechanically w/o thinking.
Here using min() doesn't make sense because it's not about a
numerical operation. ret < 0 is equivalent to is_err(ret).


> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/phy/micrel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index c6a97fcca0e6..dda426596445 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1479,7 +1479,7 @@ static int ksz886x_cable_test_wait_for_completion(struct phy_device *phydev)
>  				    !(val & KSZ8081_LMD_ENABLE_TEST),
>  				    30000, 100000, true);
>  
> -	return ret < 0 ? ret : 0;
> +	return min(ret, 0);
>  }
>  
>  static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)

