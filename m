Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7272A177F
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 13:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgJaM5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgJaM5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 08:57:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570AEC0613D5
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 05:57:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h21so10347795iob.10
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 05:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Tgo0iGYgMOSvBvP8uIFYfJAcR1ar/e958CKW4NiYNQ=;
        b=W5+LdOCQ1YdfA1lXmC679iGk9jhiKExlKYkXmUwducJnyT2NxVV+ZYUyy9DR71m2y1
         WX7ETqUFRdRzXpagOPBb6h7oAqke5SL2zHbfghKIbidfkI1Sg1gSYokIlAMHOpnokf0H
         gdjdYGRY8m/dF01kZKK8/qCxnwGuuERQKYpRfMQCo50Weuo8UJL33nX3mv5xaV+rV/h7
         +yvBNjFMg8quDR//L3hnizyhb6dldXgOPpG5hYty+zr4UTTI07KwDZ2QadWOeguGQtVV
         iVTng/As6sJy4j6Wu19Z2ohcxhIdTpPfmIS5LcinjHJA8MmaodZwAzhZTqw3U3cv6TXZ
         vPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Tgo0iGYgMOSvBvP8uIFYfJAcR1ar/e958CKW4NiYNQ=;
        b=Kly5auyf9GdoQfVb9UOVT3IENT/gN/14KlG+Qy1KDVdZB644nlSBAWlRXp/kBieRcR
         4O1rrW6mEaD1xDlZJAFtJH9g/b6RwUNnzyFCntSCsNDRAfvYY7qlH++1prjCUOltRGkC
         +LLbkCwTnYbVJXYJ4rAjRiUNgotHJwn13u7ZSPUvyd2tAJdk3bcJQBmRTliCJAUjw9yc
         ZY08teBCMzshK2DQkqXvbCuowzPdtS6xgFoqZSb6LeDlO36kYWQiv2xo8HAQ8Rj1BfQI
         wZgf2CvOZDg6BpEiAkpGxLLs/Nyt8rHzcwPjDjCsWsWdDvsO6LTNjqhIIVV9cl4Zqk7j
         Jovg==
X-Gm-Message-State: AOAM532y8dUcFEN3lxzKneXZytJYfdK3Lf+EkWeEiSPaoyNqsFoIuvKD
        033ZTsaylGB1egvxEdGV0mTk/g==
X-Google-Smtp-Source: ABdhPJzY/9C2ug9DymSL6aSXu+YTcRQ3CMUJa5x7015EyCgGyJ9KA7MZW2eYkVQKleqOiPUdPSXfXQ==
X-Received: by 2002:a02:5b09:: with SMTP id g9mr5297673jab.89.1604149057573;
        Sat, 31 Oct 2020 05:57:37 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k18sm5369915iow.4.2020.10.31.05.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 05:57:36 -0700 (PDT)
Subject: Re: [PATCH v2 net 0/5] net: ipa: minor bug fixes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201028194148.6659-1-elder@linaro.org>
 <20201029091137.1ea13ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2f62dbe1-a1b3-a5f9-8cba-82cd8061ff9b@linaro.org>
 <20201030172335.38d39b47@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <4797faea-da31-2dc2-db18-2dcccf4567f3@linaro.org>
Date:   Sat, 31 Oct 2020 07:57:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030172335.38d39b47@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 7:23 PM, Jakub Kicinski wrote:
> On Thu, 29 Oct 2020 11:50:52 -0500 Alex Elder wrote:
>> On 10/29/20 11:11 AM, Jakub Kicinski wrote:
>>> On Wed, 28 Oct 2020 14:41:43 -0500 Alex Elder wrote:  
>>>> This series fixes several bugs.  They are minor, in that the code
>>>> currently works on supported platforms even without these patches
>>>> applied, but they're bugs nevertheless and should be fixed.  
>>>
>>> By which you mean "it seems to work just fine most of the time" or "the
>>> current code does not exercise this paths/functionally these bugs don't
>>> matter for current platforms".  
>>
>> The latter, although for patch 3 I'm not 100% sure.
>>
>> Case by case:
>> Patch 1:
>>    It works.  I inquired what the consequence of passing this
>>    wrong buffer pointer was, and for the way we are using IPA
>>    it seems it's fine--the memory pointer we were assigning is
>>    not used, so it's OK.  But we're assigning the wrong pointer.
>> Patch 2:
>>    It works.  Even though the bit field is 1 bit wide (not two)
>>    we never actually write a value greater than 1, so we don't
>>    cause a problem.  But the definition is incorrect.
>> Patch 3:
>>    It works, but on the SDM845 we should be assigning the endpoints
>>    to use resource group 1 (they are 0 by default).  The way we
>>    currently use this upstream we don't have other endpoints
>>    competing for resources, so I think this is fine.  SC7180 we
>>    will assign endpoints to resource group 0, which is the default.
>> Patch 4:
>>    It works.  This is like patch 2; we define the number of these
>>    things incorrectly, but the way we currently use them we never
>>    exceed the limit in a broken way.
>> Patch 5:
>>    It works.  The maximum number of supported groups is even,
>>    and if a (smaller) odd number are used the remainder are
>>    programmed with 0, which is appropriate for undefined
>>    fields.
>>
>> If you have any concerns about back-porting these fixes I
>> think I'm comfortable posting them for net-next instead.
>> I debated that before sending them out.  Please request that
>> if it's what you think would be best.
> 
> Looks like these patches apply cleanly to net-next, so I put them there.
> 
> Thanks!

Works for me.  Thank you.	-Alex

> 

