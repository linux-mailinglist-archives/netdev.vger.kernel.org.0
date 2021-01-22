Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF8C30018B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbhAVL2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbhAVL0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:26:06 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB4EC06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 03:25:25 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id n15so42412qkh.8
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 03:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/2cLf+gkh6wwMG1ocK5xRA4PXQRiQsuZD7oOW9nIzG4=;
        b=bEITWoybBnsM48O356GkTtsoQsItXKyZnZgUEhtyxZpv6SJcj0SC5EUmq3dSkmmzKb
         z20OhbIyFjCSJdCBwcuE4OPJ4bkLXLEhPOZj/QridPo5TCjrUky+sG7MrkwyANMehBCG
         LQtfrd1HqhSOnac/94nL/AnO5lAmM0NL+s8YJnen+olQ60+E7htzdBklGMp8/SEI79zp
         /fvaUv9PAnYYPKZC8ofaIjTngCF+o/wkGpPFpyKnuh7xDnjYe7gCJpc382BSjN0EC/IH
         zSOt5RKjwLSK0ep52HLHYuItfCHRrwA1zRfI146xdDt5pA+rC41PMR1i+VYyIJ/9Sj7E
         dcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2cLf+gkh6wwMG1ocK5xRA4PXQRiQsuZD7oOW9nIzG4=;
        b=GlmouhPjMzjgl7fMnwjYBY0NlNZQRMIlmUaBRpTXEANmMo42T8OmPk9Wo8QGhci5Ux
         JP2zfgQV0SWU9yJ8GWWVoQJTGDLjM1gblrcG0j2E+eZ0H6GJu/J/N8QgqOmT4W9JFSP3
         RWRlj7AZGsUvBpSrzd7hbHIieaRfgZU5dN/zqK5tDaTuJEh+/STogVHCNTA+OPdAaJp6
         hEEPNIxWG9+8wTQVUoQ/r9GuR61dGhM4quXGIBivWzpzpA3AjItgcc80xIjb+FhCyWZ6
         +ve3dk/Q/klYoa2HKrR5jFC1sprHkmPYs51UPD3mQa4tXrvc9VlTpaP/FHeeiIxXtfVg
         CvJQ==
X-Gm-Message-State: AOAM5320x/I+Twl+i24iLBi2BQEY8rS3LkZpLVdPOnVXmhgTD7gWzEdJ
        4Ao8kxw77IXQMbZ1M+JvLQ4WaTZIQ86E1g==
X-Google-Smtp-Source: ABdhPJwzfwPraGJKei7it3rJu9BbkT/qaSVYL9s85PfVNt1Qq4YEFe0vpvgIZa5RiKxnn4uZ+Zm4hQ==
X-Received: by 2002:a37:8e04:: with SMTP id q4mr4234572qkd.22.1611314724903;
        Fri, 22 Jan 2021 03:25:24 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id x20sm5394815qtb.16.2021.01.22.03.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 03:25:23 -0800 (PST)
Subject: Re: tc: u32: Wrong sample hash calculation
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
 <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
 <20210120152359.GM3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
Date:   Fri, 22 Jan 2021 06:25:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120152359.GM3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

On 2021-01-20 10:23 a.m., Phil Sutter wrote:
> Hi Jamal,
> 
> On Wed, Jan 20, 2021 at 08:55:11AM -0500, Jamal Hadi Salim wrote:
>> On 2021-01-18 6:29 a.m., Phil Sutter wrote:
>>> Hi!
>>>
>>> Playing with u32 filter's hash table I noticed it is not possible to use
>>> 'sample' option with keys larger than 8bits to calculate the hash
>>> bucket.
>>
>>
>> I have mostly used something like: ht 2:: sample ip protocol 1 0xff
>> Hoping this is continuing to work.
> 
> This should read 'sample ip protocol 1 divisor 0xff', right?
> 

0xff is a mask.
The table(256 buckets) is created earlier. Something like:
filter add dev XXX parent ffff: protocol ip prio 10 handle 2:: u32 
divisor 256
This is from some scripts i have that worked. I cant see anything
that would say they will break today.


>> Reminder: you can only have 256 buckets (8 bit representation).
>> Could that be the contributing factor?
> 
> It is. Any key smaller than 256B is unaffected as no folding is done in
> either kernel or user space.
> 

Ok. I have never used it in any scenario other than 8 bits
(maybe subconsciously because of the 256 bucket limit was playing in
my head). I am not sure if Alexey at the time was thinking it is
useful for more than that.

>> Here's an example of something which is not 8 bit that i found in
>> an old script that should work (but I didnt test in current kernels).
>> ht 2:: sample u32 0x00000800 0x0000ff00 at 12
>> We are still going to extract only 8 bits for the bucket.
> 
> Yes. The resulting key is 8Bit as the low zeroes are automatically
> shifted away.
> 

ok.

>> Can you provide an example of what wouldnt work?
> 
> Sure, sorry for not including it in the original email. Let's apply
> actions to some packets based on source IP address. To efficiently
> support arbitrary numbers, we use a hash table with 256 buckets:
> 
> # tc qd add dev test0 ingress
> # tc filter add dev test0 parent ffff: prio 99 handle 1: u32 divisor 256
> # tc filter add dev test0 parent ffff: prio 1 protocol ip u32 \
> 	hashkey mask 0xffffffff at 12 link 1: match u8 0 0
> 
> So with the above in place, the kernel uses 32bits at offset 12 as a key
> to determine the bucket to jump to. This is done by just extracting the
> lowest 8bits in host byteorder, i.e. the last octet of the packet's
> source address.
> 
> Users don't know the above (and shouldn't need to), so they use sample
> to have the bucket determined automatically:
> 
> # tc filter add dev test0 parent ffff: prio 99 u32 \
> 	match ip src 10.0.0.2 \
> 	ht 1: sample ip src 10.0.0.2 divisor 256 \
> 	action drop
> 
> iproute2 calculates bucket 8 (= 10 ^ 2), while the kernel will check
> bucket 2. So the above filter will never match.
> 

Ok, makes more sense.
Is this always true though for all scenarios of key > 8b?
And is there a pattern that can be deduced?
My gut feel is user space is the right/easier spot to fix this
as long as it doesnt break the working setup of 8b.

cheers,
jamal

