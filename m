Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015C82F76CD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbhAOKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbhAOKhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 05:37:35 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4065BC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:36:56 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u17so17241375iow.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lj+KIFx9Ykt7wbRqFh7lSv9X2FM/ayPgAZMax3QTqL0=;
        b=HRvSLOxbNebgZ8XvPbC6vRm8p/V/NDg193k125uj7AuQxJrTlShTSGh31MIR76S7yT
         gtMK1NvEVojTb5qDGa9b85Az/jbNJisTvYYnVQ+7Oz7BdM5g+ITgqQ28Tp/CG5xFfKUl
         DsMBAjEAIQoGcB6J+ulWZeV9KUK8Cl+kKcFL7+OVs+clDqUvhfW8zIAMtfECV0wFLpl+
         i6b9+XjkhuQ+l4UElLsRGkZZGNVbkUYhcCQCgqlwAu/WDnmLXE6yVxFnbLIc3r5Dl6PQ
         iKu3oi4FD3oedwClG2AnouSy5lHrSJrHYN9v0WfX0RyRSSslj9S3TOULanUjJSXXf2KV
         vE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lj+KIFx9Ykt7wbRqFh7lSv9X2FM/ayPgAZMax3QTqL0=;
        b=EThU3Lr9wMbS57sQaOIbpluiicL/pGxrcQF16+BAOzqUxC7r4htZvBEWS2MIOeS5CW
         Uvr5Q3XBGK0XM85NUbRc7ewlI97JfAgPSm8Gqbj5lnqC33Lw0oQ/mUSL4UmolenUTCBM
         PDDrMxAEbyluW9A/x4oMjDGr+q8mTTtu4BBPa904CghDLohi1TwEmywYmkE2ewhf//JK
         gJ2yvUqOwaote+Z3/b4CI/9XmlbmfZ7gJg/JAFurDorUiOgnkIXoODwhni/RnQLScqsE
         3OBivA0RyADY1AYZXjAeTxjBi4W7V/jAI4tSwcrtUYyYhSdyP7vxggZgXB/Wkq87T1Mt
         ZyLw==
X-Gm-Message-State: AOAM5325hTtYmoc00gzlG6d7vcdiNMZXutx7uOwPvD0leEyF2KK2FEBS
        7pV2o4EOedCaAw9nr8+rRBKc6Q==
X-Google-Smtp-Source: ABdhPJwGwN7IYKt6crdxvroW3OOjmFrUpoXt/jC8o6ZD5OiOQ8GfeDXEJ1JlsrB2zjYXdsf8vWRxiA==
X-Received: by 2002:a02:1dca:: with SMTP id 193mr9652854jaj.39.1610707015658;
        Fri, 15 Jan 2021 02:36:55 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f2sm3902309iop.6.2021.01.15.02.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 02:36:54 -0800 (PST)
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
To:     Saeed Mahameed <saeed@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210113171532.19248-1-elder@linaro.org>
 <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <012a939e-2198-439a-6339-c69adbaaadd6@linaro.org>
Date:   Fri, 15 Jan 2021 04:36:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 5:22 PM, Saeed Mahameed wrote:
> On Wed, 2021-01-13 at 11:15 -0600, Alex Elder wrote:
>> This series implements some updates for the GSI interrupt code,
>> buliding on some bug fixes implemented last month.
>>
>> The first two are simple changes made to improve readability and
>> consistency.  The third replaces all msleep() calls with comparable
>> usleep_range() calls.
>>
>> The remainder make some more substantive changes to make the code
>> align with recommendations from Qualcomm.  The fourth implements a
>> much shorter timeout for completion GSI commands, and the fifth
>> implements a longer delay between retries of the STOP channel
>> command.  Finally, the last implements retries for stopping TX
>> channels (in addition to RX channels).
>>
>> 					-Alex
>>
> 
> A minor thing that bothers me about this series is that it looks like
> it is based on magic numbers and some redefined constant values
> according to some mysterious sources ;-) .. It would be nice to have
> some wording in the commit messages explaining reasoning and maybe
> "semi-official" sources behind the changes.

I understand this, and agree with the sentiment.

This code is ultimately derived from code published on
codeaurora.org (CAF), but it is now quite different from
what you'll find there.

While investigating some issues recently I discovered that
the details on the retry logic and timeouts, etc. no longer
matched what I saw on CAF.  I inquired and got some updated
information, and implemented in this series what I learned.

To be honest I don't know precisely where these details
are defined.  Even if I did, it wouldn't help much,
because it would be found in an internal hardware
specification of some kind, and I have no ability to
make that public.  Still, I agree, it would be nice
to have a reference.

I would absolutely have mentioned where these magic
values came from if I could (or if I knew). As you
you noticed, the commit messages were intentionally
vague on it.

Thank you very much for the review.

					-Alex

> LGMT code style wise :)
> 
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> 
>> Alex Elder (6):
>>    net: ipa: a few simple renames
>>    net: ipa: introduce some interrupt helpers
>>    net: ipa: use usleep_range()
>>    net: ipa: change GSI command timeout
>>    net: ipa: change stop channel retry delay
>>    net: ipa: retry TX channel stop commands
>>
>>   drivers/net/ipa/gsi.c          | 140 +++++++++++++++++++----------
>> ----
>>   drivers/net/ipa/ipa_endpoint.c |   4 +-
>>   2 files changed, 83 insertions(+), 61 deletions(-)
>>
> 

