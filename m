Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6FD359DAB
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhDILoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhDILoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:44:17 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907BC061761
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 04:44:04 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id h3so2428215qvr.10
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xILRdjjqgvTdx0uZ4o4FMfOIz3vPmxb5Qtg/TJU4Yu8=;
        b=X1hgY0NMCegmRMytxM1g5vqshk7BQanJXzzsMHkzNqsREu6103BgHFlHMT45GxmrBP
         /htRGrqC3hcoQ9Q5jhkgGbvLjRQuiV+OeCmc0fR3PWSv6pPehDXn8iMugTkhtRxBP15j
         HuMmzamMay5CIDRwbPioUyuP6X3/0J2Jc8fdBoVbTYibnu8u3SAL9sI28comjppD+E6B
         qTo2LoLTwDgaJmkc+2xwrIxgos7HOT2RCUUKpV7oyESeF25GaQaYUK3wYJkRiovJidfX
         SCp+3j+Y0U5wqGUsf6uAGUEIUwCGmCtW+hEaAeXjblqz6WBVk+Rw4WYC3yCoBEtGsaV7
         9LNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xILRdjjqgvTdx0uZ4o4FMfOIz3vPmxb5Qtg/TJU4Yu8=;
        b=Ci8380A5UfGDKdvfKZiaAcwzzzr4sACxseRqxeK+QvkqJpSzOJ+zH3NwlnxRcE+7a7
         OTBUTfdr3y0VIcSr+CDo1GrQBiRCXlLDgTsaySyq1bcEYDbzw9oSIdmq+IRyUyKUktRL
         BI/Y+oKD6GpRQ7jGOMVMPauBQjC1ZzcBE7iSjYA4An6w6dKxYqvGz7B2HwHMXdoO02uX
         kMtmys/NDL2YPA7ZY1tqa+/cLww97Sxv8PsRneG6WUY6TaobaZt1MjelWKm3EVx6/r93
         pbQWmXnvmq7KM6z0YgVaHCieZIXXd1+biR4Qu5X4JjRmvoSSQoPooIaGnXLo4cOqKFpg
         0+Bg==
X-Gm-Message-State: AOAM533WAX9gP6ehusZ7kMjaMbIGb+G/fHAd0ykCMaQqeuxkItHFKcqR
        5IXjHZxE/Ng+kU877Cyp3ttL5w==
X-Google-Smtp-Source: ABdhPJx1MLawzUTvI++3BBM9AXazUAr9kzmP769E0PnYy4rOLqTkV3NG8pTIMs0l4HAQ7llSGxp+Ag==
X-Received: by 2002:ad4:4c83:: with SMTP id bs3mr13557008qvb.41.1617968643870;
        Fri, 09 Apr 2021 04:44:03 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id e14sm1549587qte.78.2021.04.09.04.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 04:44:03 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
 <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
 <877dlb67pk.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <6424d667-86a9-8fd1-537e-331cf4e5970c@mojatatu.com>
Date:   Fri, 9 Apr 2021 07:44:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <877dlb67pk.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-09 7:03 a.m., Petr Machata wrote:
> 
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
> 
>> I am concerned about adding new opcodes which only make sense if you
>> offload (or make sense only if you are running in s/w).
>>
>> Those opcodes are intended to be generic abstractions so the dispatcher
>> can decide what to do next. Adding things that are specific only
>> to scenarios of hardware offload removes that opaqueness.
>> I must have missed the discussion on ACT_TRAP because it is the
>> same issue there i.e shouldnt be an opcode. For details see:
>> https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf
> 
> Trap has been in since 4.13, so 2017ish. It's done and dusted at this
> point.
> 

I am afraid that is not a good arguement. With all due respect,
here's how it translates:
"We already made a mistake, therefore, its ok to build on it and
make more mistakes". Touching those opcodes is really dirty; at
least i have seen no convincing arguement _at all_ for it. And,
it is not too late not to make more mistakes.
I dont remember, I may have spoken against TRAP; what i know is had
i seen the patch i would have said something - maybe i did and should
have been louder. Mea culpa.

>> IMO:
>> It seems to me there are two actions here encapsulated in one.
>> The first is to "trap" and the second is to "drop".
>>
>> This is no different semantically than say "mirror and drop"
>> offload being enunciated by "skip_sw".
>>
>> Does the spectrum not support multiple actions?
>> e.g with a policy like:
>>   match blah action trap action drop skip_sw
> 
> Trap drops implicitly. We need a "trap, but don't drop". Expressed in
> terms of existing actions it would be "mirred egress redirect dev
> $cpu_port". But how to express $cpu_port except again by a HW-specific
> magic token I don't know.


Note: mirred was originally intended to send redirect/mirror
packets to user space (the comment is still there in the code).
Infact there is a patch lying around somewhere that does that with
packet sockets (the author hasnt been serious about pushing it
upstream). In that case the semantics are redirecting to a file
descriptor. Could we have something like that here which points
to whatever representation $cpu_port has? Sounds like semantics
for "trap and forward" are just "mirror and forward".

I think there is value in having something like trap action
which generalizes the combinations only to the fact that
it will make it easier to relay the info to the offload without
much transformation.
If i was to do it i would write one action configured by user space:
- to return DROP if you want action trap-and-drop semantics.
- to return STOLEN if you want trap
- to return PIPE if you want trap and forward. You will need a second
action composed to forward.

I said dummy because this action has no value in s/w. Someone could
use it in s/w but it would be no different than gact.
Maybe it could be extended to work also in s/w by adding the "trap to
fd" in userspace.

cheers,
jamal
