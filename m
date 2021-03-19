Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A27A341D0F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhCSMkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhCSMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:40:23 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BB4C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:40:23 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z136so5909807iof.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KQM+TnnK73mIR8dvkMWkIKwG/G6WwhfgXEfohLbUjJI=;
        b=ifk76JjCf1aax6E7GBeDbL+c93oGjTB60QK5ee14RCT5+APXZhPJKUXYgFou/CV7+e
         ItZVjc2cbgTDr8qFVBp4AJDeMheQJnZ6BO3PN297hH96BTowylsx5KatfLI775EmigrK
         8vulGRAobwKCQjkN1SYFOQGmz+bINmo1jJV0naR7O42Lt4z345kZAZWJUXu1iEqP96F+
         ltvePRzZFfIFvqvzsfV5YUDEn76aWqbacJ0olJm9NYBxtkYjdHHNY0kL1YZ5pEYR3P86
         roJLy+CIfZIzTxPGoukdK01y7JxS8XzTilo9PXr4bgIq4lqURg9vMCHjCeVxxBhbOfOY
         vqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KQM+TnnK73mIR8dvkMWkIKwG/G6WwhfgXEfohLbUjJI=;
        b=SSfttO/HNf/hg4iWy4mPCLEOQfkIpQmnbxZN9Etwig9uOjC8Sfic9Vgdca9/M3u5Kx
         Am1pCYo1X3hwspHiLlT6wshcKClmxo7HLNN7UW0OFKICIzlACo1mykhq21Ke9kkvIWi2
         E4e98MhmSnYcBwcTbym1fiiAtEAXzQlQH3r+wPcmrBDxtnMOs0H7lYkR20IjwLqZNo8L
         pO4kCWrHSCRt3MVNx65WXCDY6FTLQ3Pty3/r01CXcn8oXXeOKYhUsST8WYLOAVv6Ca9W
         ZCRTDsNHgHRjOZU86Q/2zvIieReuAxUZcuWqBi72+u8B8hGoX0CQQhrCuoZcQZPUBJ57
         IY3Q==
X-Gm-Message-State: AOAM532L8lK4zAYi0vVFBhG2RG7h+j2VHSl6Dxlo5hUdfDBCqUUJGnXW
        QAyYiwHySVnsyJyMcy0VhjLLPQ==
X-Google-Smtp-Source: ABdhPJxUaPsJMhQF3ZM9WmIYgUIzJEiLmwI9x1gBSK0PmZoRWH5sp5ky8unYoOay+2JTMX7fH1KXhQ==
X-Received: by 2002:a02:77d0:: with SMTP id g199mr1135829jac.118.1616157622494;
        Fri, 19 Mar 2021 05:40:22 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id x6sm2479363ioh.19.2021.03.19.05.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 05:40:22 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org> <YFQwAYL15nEkfNf7@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <7520639c-f08b-cb25-1a62-7e3d69981f95@linaro.org>
Date:   Fri, 19 Mar 2021 07:40:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFQwAYL15nEkfNf7@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 12:00 AM, Leon Romanovsky wrote:
> On Thu, Mar 18, 2021 at 11:29:23PM -0500, Alex Elder wrote:
>> Convert some commented assertion statements into real calls to
>> ipa_assert().  If the IPA device pointer is available, provide it,
>> otherwise pass NULL for that.
>>
>> There are lots more places to convert, but this serves as an initial
>> verification of the new mechanism.  The assertions here implement
>> both runtime and build-time assertions, both with and without the
>> device pointer.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/ipa_reg.h   | 7 ++++---
>>   drivers/net/ipa/ipa_table.c | 5 ++++-
>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
>> index 732e691e9aa62..d0de85de9f08d 100644
>> --- a/drivers/net/ipa/ipa_reg.h
>> +++ b/drivers/net/ipa/ipa_reg.h
>> @@ -9,6 +9,7 @@
>>   #include <linux/bitfield.h>
>>   
>>   #include "ipa_version.h"
>> +#include "ipa_assert.h"
>>   
>>   struct ipa;
>>   
>> @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
>>   			BCR_HOLB_DROP_L2_IRQ_FMASK |
>>   			BCR_DUAL_TX_FMASK;
>>   
>> -	/* assert(version != IPA_VERSION_4_5); */
>> +	ipa_assert(NULL, version != IPA_VERSION_4_5);
> 
> This assert will fire for IPA_VERSION_4_2, I doubt that this is
> something you want.

No, it will only fail if version == IPA_VERSION_4_5.
The logic of an assertion is the opposite of BUG_ON().
It fails only if the asserted condition yields false.

					-Alex

> 
> Thanks
> 

