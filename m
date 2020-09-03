Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0C25C777
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgICQvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:51:54 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74ECC061244;
        Thu,  3 Sep 2020 09:51:54 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q1so1754526pjd.1;
        Thu, 03 Sep 2020 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pv6HrKUqhKBVjqn9mLAbPbm6f6ubL1npNT9EY9M6gi0=;
        b=UAnjmbqtnuMEhxxyKuk8XzTdyvN6fixRglgeBDdvG+dgoG+UyqL7l20ARPeVqHW+Mf
         XdonTxMlIfFc1QUZg4j9oGUmumLvqPNVg7YUcTQ2fyi0nZbOml2rycyxstRQTJBKswwP
         5Iktr/W9hSG5WlEYvokiKGdcu4VDPeLmsWkwQz4Z5feSI0k6eOC70WXN1QJd95FVPZAT
         /aZ/ux14CZsoUGzHxGIWcQUR3s7yrxuUhncXwtVAl699ZMbWkk5BhNgEv+nHpPhHCJAz
         8C+I/xoPqM9uJ/vmhoS/Efn/W20YA9pFOhDGBVCScBFFKaJwhzsI7Z72oJAycr67blrP
         SpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pv6HrKUqhKBVjqn9mLAbPbm6f6ubL1npNT9EY9M6gi0=;
        b=nhKVL3z27L29ARvMi697atgOcht86U9CrmWcCRA+UkNF4WSK4Y0bYOdB+IjTgZ0y2b
         6Ubxrl4207e2ghYO91CWczpGG5Mb+prOU2m2jfslo3rnGS5iroamTm/g/xdhyyUreRTm
         iUPomUh7nWFAIBAFdUTeAPDng5A66ezdTKUtTj/lr0TLzup6QaJHcEocD+sl2uG9SAqv
         NVfc6ufSQxJrkSSpvnViGEqf5Cp8Iw4x8Ul6pE59sT1lqQXLbqaK24EunI2FJYnyr0Pd
         fax4Id95dnLyUd5UHoEhMoDD1A0bYtNaFts5YlHuEqYs7fTt5iy8kROAXXnuSCt8Z0jd
         tgZQ==
X-Gm-Message-State: AOAM532KZDPkgk68qLD07aGqNMMD3nJXSqG3h4JAaJWCjgqgdxo2ZXkh
        H/XhTqvxjx25kV/blXDErHsv+vhqdKg=
X-Google-Smtp-Source: ABdhPJxhyC0OriJ5n2Z9hzRaoHRVvtJwCV7wxKE/JkCqqWVvzHd2HMsDrBsdmI0dN8brbg0HsxgbZw==
X-Received: by 2002:a17:90b:374b:: with SMTP id ne11mr3837729pjb.21.1599151913799;
        Thu, 03 Sep 2020 09:51:53 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm3723098pfn.219.2020.09.03.09.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:51:53 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: dp83867: Fix various styling and space
 issues
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200903141510.20212-1-dmurphy@ti.com>
 <76046e32-a17d-b87c-26c7-6f48f4257916@gmail.com>
 <4d38ac31-8646-2c4f-616c-1a1341721819@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <52df510b-23b2-4c63-a571-26b0fa115444@gmail.com>
Date:   Thu, 3 Sep 2020 09:51:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <4d38ac31-8646-2c4f-616c-1a1341721819@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 9:41 AM, Dan Murphy wrote:
> Florian
> 
> On 9/3/20 11:34 AM, Florian Fainelli wrote:
>>
>>
>> On 9/3/2020 7:15 AM, Dan Murphy wrote:
>>> Fix spacing issues reported for misaligned switch..case and extra new
>>> lines.
>>>
>>> Also updated the file header to comply with networking commet style.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>>>   drivers/net/phy/dp83867.c | 47 ++++++++++++++++++---------------------
>>>   1 file changed, 22 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>> index cd7032628a28..f182a8d767c6 100644
>>> --- a/drivers/net/phy/dp83867.c
>>> +++ b/drivers/net/phy/dp83867.c
>>> @@ -1,6 +1,5 @@
>>>   // SPDX-License-Identifier: GPL-2.0
>>> -/*
>>> - * Driver for the Texas Instruments DP83867 PHY
>>> +/* Driver for the Texas Instruments DP83867 PHY
>>>    *
>>>    * Copyright (C) 2015 Texas Instruments Inc.
>>>    */
>>> @@ -35,7 +34,7 @@
>>>   #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
>>>   #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
>>>   #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
>>> -#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
>>> +#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    BIT(5)
>>
>> Now the definitions are inconsistent, you would want to drop this one 
>> and stick to the existing style.
> 
> OK I was a little conflicted making that change due to the reasons you 
> mentioned.  But if that is an acceptable warning I am ok with it.

IMHO, if the are no obvious incorrect styles, and using 1 << x is not, 
it just may not be the preferred style (and there is quite frankly a ton 
of those patterns in the kernel), then ignoring the checkpatch.pl 
warning is fine. After all this is a tool, not an absolute truth by any 
means, but again, others may disagree.
-- 
Florian
