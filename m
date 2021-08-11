Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD793E900B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhHKMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhHKMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 08:06:26 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE97C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 05:06:03 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z2so2606205iln.0
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 05:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DnrUUhs9d/NQwIxtLGBh6Otm1ldtOTYeYBWlYRbI7PA=;
        b=tptwbMa9rqzpyUbqtHw71jjBwHiNvLpTl2RM4D8dM7QARsMRBNo1wEPDo37r2TvSsD
         Nt+6JUBJkRD+/90JuC9BZ/QuMQuWi0v6HflD3FJ1crdizwMHkO2dVd0kg50NIaarWsc0
         J88Vl0QMpoby/FWgGA2bk7/pZ3i25J4RImaKhT/4pSMvA93Prlrr3wi68rXGAGljOrmb
         L3n6Z9rGRPnGcIX0v3/55nnmV7Q5oZ1qfJ6/pMnnubAVHPNPu/5cx8UO7bQrqHaSaZQ5
         6dDjhAXqnN8uAvelpR4yxDCOOiv74AKukOMpjXijDd2YkgY3GuOAFCovOWkK0hv4FHJw
         GQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnrUUhs9d/NQwIxtLGBh6Otm1ldtOTYeYBWlYRbI7PA=;
        b=kzCt2R0JoYaqa7SQbKmJMLpPOfNUkkGIznLBouXqFqSEQgVHRrgmcwXiZ1T1pbClpU
         XGeTtrShpdZjOQ6FvU0uHv/xOC6bUItEK4rk1WgnUuOk+Y+bOD8/nZpMbQ4QFUUNzUaI
         HJAtZiCiKBe3m3CNBUkioG136S4FUTgBeN9tHf8eDUubRPf5yVt8eUWN0YHFah7D3fuk
         1aJadheEuxWF955MoJCfCZdwXofnT8QB0grm4HBXEBroeV3AWbag2fnORNIthqKrpTqV
         SCR/Q1k8QiuXFKB2bVB88MoIsQI3xQ9ZiV2xoGnjaTHt9kZytIMgB+/lQFQrVRhpycJa
         m71w==
X-Gm-Message-State: AOAM5300iyQtnO+cPk3kig6y3B68zg/adeBDJQw9dW82MGEVRz4kXPUB
        aoTiveaA7vk78NVDHFaCflVLhw==
X-Google-Smtp-Source: ABdhPJyLqjUEOYTMumCwcRHq2yLu/P0Hs/5xv7KeyNhWBaELdXf2yzH0tGRTzE4ErblyX06H8gn/6A==
X-Received: by 2002:a92:d987:: with SMTP id r7mr232956iln.303.1628683562526;
        Wed, 11 Aug 2021 05:06:02 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w4sm14345324ior.2.2021.08.11.05.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 05:06:02 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipa: always inline
 ipa_aggr_granularity_val()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, lkp@intel.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210810160213.2257424-1-elder@linaro.org>
 <YRO8Xtd9+RRMqw1J@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <aed281de-dd9b-c185-66b3-e597548a9649@linaro.org>
Date:   Wed, 11 Aug 2021 07:06:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRO8Xtd9+RRMqw1J@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 7:02 AM, Leon Romanovsky wrote:
> On Tue, Aug 10, 2021 at 11:02:13AM -0500, Alex Elder wrote:
>> It isn't required, but all callers of ipa_aggr_granularity_val()
>> pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
>> Two of those callers are in ipa_validate_build(), with the result
>> being passed to BUILD_BUG_ON().
>>
>> Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
>> inline ipa_aggr_granularity_val(), so the result of the function is
>> not constant at compile time, and that leads to build errors.
>>
>> Define the function with the __always_inline attribute to avoid the
>> errors.  And given that the function is inline, we can switch the
>> WARN_ON() there to be BUILD_BUG_ON().
>>
>> Fixes: 5bc5588466a1f ("net: ipa: use WARN_ON() rather than assertions")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>
>> David/Jakub, this fixes a bug in a commit in net-next/master.  -Alex
>>
>>  drivers/net/ipa/ipa_main.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
>> index 25bbb456e0078..f90b3521e266b 100644
>> --- a/drivers/net/ipa/ipa_main.c
>> +++ b/drivers/net/ipa/ipa_main.c
>> @@ -255,9 +255,9 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
>>   * less than the number of timer ticks in the requested period.  0 is not
>>   * a valid granularity value.
>>   */
>> -static u32 ipa_aggr_granularity_val(u32 usec)
>> +static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
>>  {
>> -	WARN_ON(!usec);
>> +	BUILD_BUG_ON(!usec);
> 
> So what exactly are you checking here if all callers pass same value?
> It is in-kernel API, declared as static inside one module. There is no
> need to protect from itself.

Yeah that's a good point.  It can just as well be removed.
I think the check was added before I knew it was only going
to be used with a single constant value.  That said, the
point was to check at runtime a required constraint.

I'll post version 2 that simply removes it.  Thanks.

					-Alex

> 
> Thanks
> 
>>  
>>  	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
>>  }
>> -- 
>> 2.27.0
>>

