Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D5E2771E5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 15:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgIXNLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 09:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgIXNLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 09:11:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43A1C0613CE;
        Thu, 24 Sep 2020 06:11:52 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z4so3778339wrr.4;
        Thu, 24 Sep 2020 06:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fAIKdX6Q8v6X6iiHvQpMrhkDP+drcMiwEPPTPZj0rvw=;
        b=maJ20F6EGsDJEim/bn2SH7SAi5AhsgRO1Ou/NdSDvJ8bad8V10rA0qkN9VcPuFXOxF
         8hCDaJozazVQ/EdNOFUemlgtfLN4qDfhWNKqDzdSnL1v+D8LYePxnPpYh4LhIPdGbeCF
         8b661AurKiqj2W9Techzj6W6U0G60bB7j8YkplNkq+JbNARKQZuFXPPUVCde5V2W+Oeu
         01UjZMLeLXqW+t5NdKlw7U8MPgMrbYS2Wh/neePdBoMxbFfymPfNTvNO5wP9z/Ar4rSo
         BvZxEDQ4/6iLrJYgi7gy863iv524Ychrd52L4phMSEwNJX1eo6AgYhdwmP7H4M6gnrIE
         w2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fAIKdX6Q8v6X6iiHvQpMrhkDP+drcMiwEPPTPZj0rvw=;
        b=lSVtlxwx8lWRAPTgo0n9Jb7Lnge/jpTWOe0FHQjXxDjEIGbZzYzgLNdywV9aR6gAwM
         HFj1DUNXqMQOV1ZkEg5xcEmr6/ZXhpBVxh8Qzz3WseFcnyYWa3+irzCvqSsYyt+G+k1t
         1xSmgUPt8ldkls7IwWmzbrnuLPTL82IGAqSi1wiJ1DyiPQjWKUGDjrpeo2yov04Pus/y
         qE+E6fQX5tiukGZYqOdB4xnIvtpmpyv/2JFdDtVMjjBuaKQC57RKUA6YDA2deFalq58y
         7w9VjJ2M30H6b85uAsDCfC7/DU+uFb8zkjujMAa1yNbvZfxC4UpacXf/7+Xi6pgI1MUx
         9eAA==
X-Gm-Message-State: AOAM531ZLvXz8NOVjg8N8FcsTVo7pd9HRIjYj+Lga2kb1biPRpGsYqyq
        Xv9dM3lHy4sCeBhyQwly2izgEGtmIXIbcpfr
X-Google-Smtp-Source: ABdhPJwak7AwvSOJanVnyh+S25XeMOY/zNR+z/BdD9LIi4y4Giqh8DJfmf4ARGB0l7/ZbiqMxZIvKw==
X-Received: by 2002:a05:6000:85:: with SMTP id m5mr5014939wrx.160.1600953111296;
        Thu, 24 Sep 2020 06:11:51 -0700 (PDT)
Received: from [10.101.10.94] ([176.12.107.132])
        by smtp.gmail.com with ESMTPSA id p11sm3302323wma.11.2020.09.24.06.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 06:11:50 -0700 (PDT)
Subject: Re: [PATCH v2] net: dsa: mt7530: Add some return-value checks
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Sean Wang <Sean.Wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1600327978.11746.22.camel@mtksdccf07>
 <20200919192809.29120-1-alex.dewar90@gmail.com>
 <1600949604.11746.27.camel@mtksdccf07>
From:   Alex Dewar <alex.dewar90@gmail.com>
Message-ID: <9db38be8-9926-b74b-c860-018486b17f3a@gmail.com>
Date:   Thu, 24 Sep 2020 14:11:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600949604.11746.27.camel@mtksdccf07>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-24 13:13, Landen Chao wrote:
> Hi Alex,
>
> Thanks for your patch. By linux/scripts/checkpatch.pl
>
> On Sun, 2020-09-20 at 03:28 +0800, Alex Dewar wrote:
> [..]
>> @@ -1631,9 +1635,11 @@ mt7530_setup(struct dsa_switch *ds)
>>   		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
>>   			   PCR_MATRIX_CLR);
>>   
>> -		if (dsa_is_cpu_port(ds, i))
>> -			mt753x_cpu_port_enable(ds, i);
>> -		else
>> +		if (dsa_is_cpu_port(ds, i)) {
>> +			ret = mt753x_cpu_port_enable(ds, i);
>> +			if (ret)
>> +				return ret;
>> +		} else
>>   			mt7530_port_disable(ds, i);
> CHECK: braces {} should be used on all arms of this statement
> CHECK: Unbalanced braces around else statement
>>   
>>   		/* Enable consistent egress tag */
>> @@ -1785,9 +1791,11 @@ mt7531_setup(struct dsa_switch *ds)
>>   
>>   		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
>>   
>> -		if (dsa_is_cpu_port(ds, i))
>> -			mt753x_cpu_port_enable(ds, i);
>> -		else
>> +		if (dsa_is_cpu_port(ds, i)) {
>> +			ret = mt753x_cpu_port_enable(ds, i);
>> +			if (ret)
>> +				return ret;
>> +		} else
>>   			mt7530_port_disable(ds, i);
> CHECK: braces {} should be used on all arms of this statement
> CHECK: Unbalanced braces around else statement
>
> [..]
> regards landen
Hi Landen,

Sorry about this... I usually run checkpatch over my patches. Would you 
like me to send a separate fix or a v3?

Best,
Alex
