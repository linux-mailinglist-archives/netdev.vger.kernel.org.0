Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCEF17E799
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCISxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:53:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46170 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgCISxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:53:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id c19so2940333pfo.13
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 11:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1RtRFrySCoxN/VaYYsiW5LOwKywM46sX7/G2PvRESo=;
        b=tfDMAGTUU4NA0dYskfzmzlUQrLDECL45wwlYBRYyosWSnWbpdd66ftTwvIEu/S7gzM
         6aMiabudXNWRh/WpcWSpk5ihx49cfGbfAqPBWWp1w0y1/dxfYgl4yKbPZ02MJG6et+kp
         zXgRXakow6I+Xfte3/igxgJV3SYdi5+ggsZw6oqtn0CsC064Yy43BNfndHxWV5fr5cKQ
         Cc1qfqGUBOhzaAtOFf+c2TkwavQVRO5eDOjE9Ng4gZACtpsF9IDnjaMNtKpbcNCfRunZ
         77etJD9n2zydh8Lszv1gxANSfVdxjbJBExKlzz5QC35IItWeB5j8NGLd52u8ULA7MljC
         juhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1RtRFrySCoxN/VaYYsiW5LOwKywM46sX7/G2PvRESo=;
        b=L72JawFmihjinoKRivmlp16NdV9kjJwGZdoZK8HqIaS54wKEIPeK0ZK/tv4pEWUn/W
         62W5y4Vm7GN732vdalM5XEac4MVpuDt0s77Fx99B7Rr8xd1T8byK5Uxvl+QrSKYTqv+y
         8mU1IEgxgE7K6g4BGLBwa5Ulqy0khGZJoScQQRu/ouzAdCNdA4WmG36U0OV4XrwH+CCx
         BR5slVwng2Q5hP+olfwNULTkT7f2WQmfk2L45wAESIHp8tMQqc219d6kxgLSgxHrVpYH
         e53K1NjunHN9od8t/Wgzt8Ij8FqTXCDkqEHYjAYDmwURv/FR/l6GbMqAtYiJouCnmHd9
         /KRQ==
X-Gm-Message-State: ANhLgQ3TZqLpjrn4vmPoCZBPHmLG7iKcRMhvd/MZrfD8ymKJkjL2X77w
        l4wHKZ3r6K7kinlaVxNPU3I=
X-Google-Smtp-Source: ADFU+vsLWPBuLgC90hFQCvfLaDlk0xyamuSwlPNd1n35RYyBlPQbGmyVoNRq1PJVRIzLJk/DrkvQFQ==
X-Received: by 2002:a63:2447:: with SMTP id k68mr17287048pgk.368.1583780027955;
        Mon, 09 Mar 2020 11:53:47 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id p2sm27729984pfb.41.2020.03.09.11.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 11:53:47 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: pie: change maximum integer value of
 tc_pie_xstats->prob
To:     Leslie Monis <lesliemonis@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
References: <20200305162540.4363-1-lesliemonis@gmail.com>
 <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
 <773f285c-f9f2-2253-6878-215a11ea2e67@gmail.com>
 <e1ad29bb-7766-7c9d-3191-47a5e866e07e@gmail.com>
 <CAHv+uoE_Q37jCY3=_k_hEoiOrD0Mm67qEd-ALO-E9QjQRkSxBA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <171372a7-4379-acd9-4ecd-c023f05f12da@gmail.com>
Date:   Mon, 9 Mar 2020 11:53:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHv+uoE_Q37jCY3=_k_hEoiOrD0Mm67qEd-ALO-E9QjQRkSxBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 11:42 AM, Leslie Monis wrote:
> On Mon, Mar 9, 2020 at 11:24 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> On 3/9/20 10:48 AM, Eric Dumazet wrote:
>>>
>>> This means that iproute2 is incompatible with old kernels.
>>>
>>> commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows") was wrong,
>>> it should not have changed user ABI.
>>>
>>> The rule is : iproute2 v-X should work with linux-<whatever-version>
>>>
> 
> I'm apologize. I wasn't aware of this rule.
> 
>>> Since pie MAX_PROB was implicitly in the user ABI, it can not be changed,
>>> at least from user point of view.
>>>
> 
> You're right. It shouldn't have affected user space.
> But I'm afraid the value of MAX_PROB in the kernel did change in v5.1.
> commit 3f7ae5f3dc52 ("net: sched: pie: add more cases to auto-tune
> alpha and beta")
> introduced that change. I'm not sure what to do about this. How can I fix it?
> 
>>
>> So this kernel patch might be needed :
>>
>> diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
>> index f52442d39bf57a7cf7af2595638a277e9c1ecf60..c65077f0c0f39832ee97f4e89f25639306b19281 100644
>> --- a/net/sched/sch_pie.c
>> +++ b/net/sched/sch_pie.c
>> @@ -493,7 +493,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>>  {
>>         struct pie_sched_data *q = qdisc_priv(sch);
>>         struct tc_pie_xstats st = {
>> -               .prob           = q->vars.prob,
>> +               .prob           = q->vars.prob << BITS_PER_BYTE,
>>                 .delay          = ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
>>                                    NSEC_PER_USEC,
>>                 .packets_in     = q->stats.packets_in,
> 
> Thanks. This is a much better solution.
> Should I go ahead and submit this to net-next?

Sure, please go ahead !

> I guess the applied patch (topic of this thread) has to be reverted.
> 
