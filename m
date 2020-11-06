Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ECA2A99A1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgKFQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgKFQjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 11:39:36 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EC8C0613CF;
        Fri,  6 Nov 2020 08:39:36 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f38so1351798pgm.2;
        Fri, 06 Nov 2020 08:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E8ZXU1sB2LM2Qvs2eXs5LsyiKHVfmc6ejsqLG55A13A=;
        b=Qr1okamuqR2eM6OvhTiZaB1uMByc4kz2azxSxjYXj7w6VJkeBVZ+8D7nLbRocKH1nJ
         +tBW5Yr7EwvXgytTEqI1U5PIygNKwCcaMiSMB9hfcQZ+XURWefz7vIKgUWLwGeNamlX5
         Xn9z/b9uINKgQMnTPcXiNx8TXwxeh8ocUxiPdKDXwZMTzRTXyE4iMbgu8sOQIkBqU4Gw
         7aTbQy1GH42h07P1h9KLl2lLepqcUXzpMleFzUR3S4bUSdvsXsovE23tCEraEwiyVgNY
         JWnopqBhVroT1NFvHrUvs13n7PurmApxT2XLBWgjuE4Jx4rXvf0WhEvXp7Ktki/kyKF4
         0DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8ZXU1sB2LM2Qvs2eXs5LsyiKHVfmc6ejsqLG55A13A=;
        b=TIGGiB3Zq1US7ScQ8rRks50Rf1hT8v6++AcPB6rYUFb9zZXDVZIu71dRn0Bi9emZX8
         9equmOTR9wYM2nuDUg59lxBQd8RGR7LQtVWhcx7A/RjfgtGh5qOwdZfNhRdD+SMCZgq4
         i20Tvbl0PK8JNqcA57T71EjmQQVC5hTIbqKSwXQbKwYFVYXNgsdVkGty1FDUikiB2Y+B
         /6p8IgaDGMqzdzjbC6JMFmeT41aX9Ym2ZWEPX07Ws3ipYyLYGnATRPzCbnF3HkoRXP6D
         bRd3Co/BLb3q4DpUINzd6MOtWN5VmMFO6bFpsRfw0Ah86eWSVBTKU9tL2RE1tbM49mun
         zO6A==
X-Gm-Message-State: AOAM533aMcWSBqpH4zd3taHkZqzFSeU/DOpzQBB4eTtmQwgQEpOwV/dT
        D5/qZbQ8qUn7E9G4h8ZGpBCX/FSp7OQ=
X-Google-Smtp-Source: ABdhPJyivRJJz31AEDBGRqZm67j3SSe7W/EejIf85pjmhWKxAIEqwZcCohCO/CquCUqSDOYp3fk2iQ==
X-Received: by 2002:a63:2051:: with SMTP id r17mr2355935pgm.191.1604680775583;
        Fri, 06 Nov 2020 08:39:35 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v27sm2674776pfi.204.2020.11.06.08.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 08:39:34 -0800 (PST)
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
To:     Andrew Lunn <andrew@lunn.ch>, Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106141820.GP933237@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <24690741-cc10-eec1-33c6-7960c8b7fac6@gmail.com>
Date:   Fri, 6 Nov 2020 08:39:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201106141820.GP933237@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/2020 6:18 AM, Andrew Lunn wrote:
> On Fri, Nov 06, 2020 at 01:37:30PM +0800, Alex Shi wrote:
>> There are some macros unused, they causes much gcc warnings. Let's
>> remove them to tame gcc.
>>
>> net/dsa/tag_brcm.c:51:0: warning: macro "BRCM_EG_RC_SWITCH" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:53:0: warning: macro "BRCM_EG_RC_MIRROR" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:55:0: warning: macro "BRCM_EG_TC_MASK" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:35:0: warning: macro "BRCM_IG_TS_SHIFT" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:46:0: warning: macro "BRCM_EG_RC_MASK" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:49:0: warning: macro "BRCM_EG_RC_PROT_SNOOP" is not
>> used [-Wunused-macros]
>> net/dsa/tag_brcm.c:34:0: warning: macro "BRCM_IG_TE_MASK" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:43:0: warning: macro "BRCM_EG_CID_MASK" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:50:0: warning: macro "BRCM_EG_RC_PROT_TERM" is not
>> used [-Wunused-macros]
>> net/dsa/tag_brcm.c:54:0: warning: macro "BRCM_EG_TC_SHIFT" is not used
>> [-Wunused-macros]
>> net/dsa/tag_brcm.c:52:0: warning: macro "BRCM_EG_RC_MAC_LEARN" is not
>> used [-Wunused-macros]
>> net/dsa/tag_brcm.c:48:0: warning: macro "BRCM_EG_RC_EXCEPTION" is not
>> used [-Wunused-macros]
>>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>> Cc: Andrew Lunn <andrew@lunn.ch> 
>> Cc: Vivien Didelot <vivien.didelot@gmail.com> 
>> Cc: Florian Fainelli <f.fainelli@gmail.com> 
>> Cc: Vladimir Oltean <olteanv@gmail.com> 
>> Cc: "David S. Miller" <davem@davemloft.net> 
>> Cc: Jakub Kicinski <kuba@kernel.org> 
>> Cc: netdev@vger.kernel.org 
>> Cc: linux-kernel@vger.kernel.org 
>> ---
>>  net/dsa/tag_brcm.c | 15 ---------------
>>  1 file changed, 15 deletions(-)
>>
>> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
>> index e934dace3922..ce23b5d4c6b8 100644
>> --- a/net/dsa/tag_brcm.c
>> +++ b/net/dsa/tag_brcm.c
>> @@ -30,29 +30,14 @@
>>  /* 1st byte in the tag */
>>  #define BRCM_IG_TC_SHIFT	2
>>  #define BRCM_IG_TC_MASK		0x7
>> -/* 2nd byte in the tag */
>> -#define BRCM_IG_TE_MASK		0x3
>> -#define BRCM_IG_TS_SHIFT	7
>>  /* 3rd byte in the tag */
>>  #define BRCM_IG_DSTMAP2_MASK	1
>>  #define BRCM_IG_DSTMAP1_MASK	0xff
> 
> Hi Alex
> 
> It is good to remember that there are multiple readers of source
> files. There is the compiler which generates code from it, and there
> is the human trying to understand what is going on, what the hardware
> can do, how we could maybe extend the code in the future to make use
> of bits are currently don't, etc.
> 
> The compiler has no use of these macros, at the moment. But i as a
> human do. It is valuable documentation, given that there is no open
> datasheet for this hardware.
> 
> I would say these warnings are bogus, and the code should be left
> alone.

Agreed, these definitions are intended to document what the hardware
does. These warnings are getting too far.
-- 
Florian
