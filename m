Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4D244D86
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgHNR0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 13:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgHNR0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 13:26:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A7AC061384;
        Fri, 14 Aug 2020 10:26:06 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id t10so10711629ejs.8;
        Fri, 14 Aug 2020 10:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdH301wgS7cyfyANm3QdNLsmOKta1Zr4tgtkQ//vUEw=;
        b=dOpIA/4JbMCFQP35uxNzdsMPiNq0i0CAGHAMNXbyWBOwU5ZhVu79CCcnmOCTUGSgof
         poji8AKEuKDpgTKCVmDWcL5T/w5rIMpo7KaAh5LteA4VogzS1es30OuWzDjeB0iUIBzC
         QRvdlqnc/Ypu8DKuW1WgZMntkjwZPLMQJgY3vQIk8+hL9zIz1svZE4LXvfI/R1HOJKZ1
         enNh1OkDmAMPy92Bn10R3FlT4k07qxiJzDu4P09DMY5eai4t9jv/wHVDgFpof/l51OTQ
         VIx+OAHMPkfTvRFWhSIvMthr7n4ORRE5MWrztdJ1nEC4w7HsXgM1TqSvbifZWCVGyYyp
         QHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdH301wgS7cyfyANm3QdNLsmOKta1Zr4tgtkQ//vUEw=;
        b=q+np043nNBu4yHTWe9Ku59DDhCBNFaSS39rcH5nkhz7RZ1/8BDqMQ8wt27VoTXm/Dt
         an9nfhpPmomiu2nWkzdxzxEdpNKO7Csvh5/X7y48G4qDSR5a4+FlP3UKqOk4MZPMFGXe
         nLTbz/W6pgUOvjCf0TJsoA5sbXmy8Lvhsdrw7JjbWBEG1Vkb66ZCqzqPhL1T6X293v3n
         P1YqPDP/rK3kV37JDamqoPqt1NVOT3RVe2z7H+xWl2/7ODhqbWmj8Q2Ah+89GzyV699Y
         Xvy2DyNlspJS/4aCmrLPhMS3o+cvinE1dnc6FyyL2fIzA+E77FdC8LtiYFyYVHIMoL5j
         TPQQ==
X-Gm-Message-State: AOAM530KuQrd+vO38ThyRG7MedJ5W71HTOpNhP/gCIM0Kn6n2RFC7Mex
        xPAuM5yNAR1+Oh3hrARcQQPii5+BhtA=
X-Google-Smtp-Source: ABdhPJztkVGS1uzsrg8R/zQfvO6jWeUBcJbznNXsWBTi3+p08CkzyWA3Gb4Mv9/aZRPOhH2iriYJlA==
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr3512878ejc.333.1597425964745;
        Fri, 14 Aug 2020 10:26:04 -0700 (PDT)
Received: from debian64.daheim (pd9e292cf.dip0.t-ipconnect.de. [217.226.146.207])
        by smtp.gmail.com with ESMTPSA id o25sm7076217ejm.34.2020.08.14.10.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 10:26:04 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k6dSn-0006ec-WD; Fri, 14 Aug 2020 19:25:59 +0200
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as
 __maybe_unused
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
 <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com> <20200814164046.GO4354@dell>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <0a144311-2085-60b5-ea36-554c6efbf7e9@gmail.com>
Date:   Fri, 14 Aug 2020 19:25:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200814164046.GO4354@dell>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-14 18:40, Lee Jones wrote:
> On Fri, 14 Aug 2020, Christian Lamparter wrote:
> 
>> On 2020-08-14 13:39, Lee Jones wrote:
>>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>>> but not all of them.  Mark it as __maybe_unused to show that this is
>>> not only okay, it's expected.
>>>
>>> Fixes the following W=1 kernel build warning(s)
>>
>> Is this W=1 really a "must" requirement? I find it strange having
> 
> Clean W=1 warnings is the dream, yes.
But is it a requirement?

> 
> I would have thought most Maintainers would be on-board with this.
 From what I know: It's no changes For changes' sake. Because otherwise 
this would be pretty broken for maintainers. They could just write and 
revert the same code over and over to prob up their LOC and commit 
counter. Wouldn't you agree there?

> 
> The ones I've worked with thus far have certainly been thankful.  Many
> had this on their own TODO lists.
Question is, do you really want to be just the cleanup crew there? Since 
semantic patches came along and a lot of this has been automated.
I'm of course after something else. Like: "Isn't there a better way than 
manually slapping __maybe_unused there to suppress the warning and call 
it a day?" If you already went down these avenues and can confirm that 
there's no alternative than this, then "fine". But if there is a better
method of doing this, then "let's go with that!".

> 
>> __maybe_unused in header files as this "suggests" that the
>> definition is redundant.
> 
> Not true.
> 
> If it were redundant then we would remove the line entirely.
So, why adding __maybe_unused then? I find it not very helpful to
tell the compiler to "shut up" when you want it's opinion...
This was the vibe I got from gcc's attribute unused help text.

Cheers,
Christian

> 
>>>    from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>>>    In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>>>    drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]
>>>
>>> Cc: Christian Lamparter <chunkeey@googlemail.com>
>>> Cc: Kalle Valo <kvalo@codeaurora.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Johannes Berg <johannes@sipsolutions.net>
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>    drivers/net/wireless/ath/carl9170/carl9170.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
>>> index 237d0cda1bcb0..9d86253081bce 100644
>>> --- a/drivers/net/wireless/ath/carl9170/carl9170.h
>>> +++ b/drivers/net/wireless/ath/carl9170/carl9170.h
>>> @@ -68,7 +68,7 @@
>>>    #define PAYLOAD_MAX	(CARL9170_MAX_CMD_LEN / 4 - 1)
>>> -static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
>>> +static const u8 __maybe_unused ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
>>>    #define CARL9170_MAX_RX_BUFFER_SIZE		8192
>>>
>>
> 

