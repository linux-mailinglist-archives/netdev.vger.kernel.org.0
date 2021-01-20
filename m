Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882B42FDAC8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbhATU0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731514AbhATN4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:56:49 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7D3C061799
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:55:13 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id d14so25281718qkc.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/KyUALJJOMioBmIDBAHLuNBMHeFRbyvHUYDnGGWwIjE=;
        b=Ok5VEWD2TkZjSaFD5pbUiBXckFR/jY/PymczeKCs2SRJQ/nfkibgsFvStPFiJ46mva
         CY0G3YfuVTawlV+kAwNRVxfiY8AhxxIXpKD1Yrz3PIeClrbIYFrLdrwhsCgUv3f4jBQ7
         Bo1fpSe79aqzwMy1TK+zei2MO3Xqt+XmvPPAlDWT8t5wNBpN+LytjuvZ/kCX/MSFANDb
         NHWBDhwkwqu0Lu8I7JC8hCrJo6QVDedRotu86h8XCNICIStwXv4jwCgDr6qQtih9mpLk
         iGs/7BMVBI7C859ft39N9WiSienmxPMACQnJ4r2Fc0FMu0+X3mJHC4SJMrZQw+oOaLQ5
         r5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/KyUALJJOMioBmIDBAHLuNBMHeFRbyvHUYDnGGWwIjE=;
        b=p42VhPrgfAn6aJi6kcJlMsBNv24brsqdGEhHznJLoZ3lTQSvi/FIbCyDX7MG3xFk3d
         hvBFKjymfqKUV/92NJFb/bJkeCOpTv76DDA8imxh6HaC0qZfakVAi6hhoED9byBeU4/7
         WVMb/kwh93bmcjNdq6hSUth7gBeifFqRq9NmyNqy9QEAf+4ZXS1/oyMQ53SlqzP9tcUY
         E2xHif/34SRQ+TXvMXxSXWyd+DpMB70JSSpfmgHblA8PWdWr06nPeGdEognnEo2N/Psp
         WvUFlf1sgnJJ/AotttqaP+11oYfNvwYlcp/oDFULdHQRM/MDo7pPrq3JpmnYwaCoLh36
         bCAg==
X-Gm-Message-State: AOAM533RLbkVm+yLIKpNUnDRLgElTuFMg1JS1APIwzP5k7AefEHIb6cW
        CottjLAFCHYbov5xMhpK/euVeg==
X-Google-Smtp-Source: ABdhPJwVhNX6rHauTaOHxV8VTXo1yDfZebdJ1Zw/hJAA1zvPXfDJ5FfVaUVrvg64RPRrl96XLsxZZQ==
X-Received: by 2002:a37:4ac1:: with SMTP id x184mr9437950qka.491.1611150912936;
        Wed, 20 Jan 2021 05:55:12 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 17sm1245567qtu.23.2021.01.20.05.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 05:55:12 -0800 (PST)
Subject: Re: tc: u32: Wrong sample hash calculation
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
Date:   Wed, 20 Jan 2021 08:55:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118112919.GC3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021-01-18 6:29 a.m., Phil Sutter wrote:
> Hi!
> 
> Playing with u32 filter's hash table I noticed it is not possible to use
> 'sample' option with keys larger than 8bits to calculate the hash
> bucket. 


I have mostly used something like: ht 2:: sample ip protocol 1 0xff
Hoping this is continuing to work.

I feel i am missing something basic in the rest of your email:
Sample is a user space concept i.e it is used to instruct the
kernel what table/bucket to insert the node into. This computation
is done in user space. The kernel should just walk the nodes in
the bucket and match.
Reminder: you can only have 256 buckets (8 bit representation).
Could that be the contributing factor?
Here's an example of something which is not 8 bit that i found in
an old script that should work (but I didnt test in current kernels).
ht 2:: sample u32 0x00000800 0x0000ff00 at 12
We are still going to extract only 8 bits for the bucket.

Can you provide an example of what wouldnt work?

cheers,
jamal

> Turns out key hashing in kernel and iproute2 differ:
> 
> * net/sched/cls_u32.c (kernel) basically does:
> 
> hash = ntohl(key & mask);
> hash >>= ffs(ntohl(mask)) - 1;
> hash &= 0xff;
> hash %= divisor;
> 
> * while tc/f_u32.c (iproute2) does:
> 
> hash = key & mask;
> hash ^= hash >> 16;
> hash ^= hash >> 8;
> hash %= divisor;
> 
> In iproute2, the code changed in 2006 with commit 267480f55383c
> ("Backout the 2.4 utsname hash patch."), here's the relevant diff:
> 
>    hash = sel2.sel.keys[0].val&sel2.sel.keys[0].mask;
> - uname(&utsname);
> - if (strncmp(utsname.release, "2.4.", 4) == 0) {
> -         hash ^= hash>>16;
> -         hash ^= hash>>8;
> - }
> - else {
> -         __u32 mask = sel2.sel.keys[0].mask;
> -         while (mask && !(mask & 1)) {
> -                 mask >>= 1;
> -                 hash >>= 1;
> -         }
> -         hash &= 0xFF;
> - }
> + hash ^= hash>>16;
> + hash ^= hash>>8;
>    htid = ((hash%divisor)<<12)|(htid&0xFFF00000);
> 
> The old code would work if key and mask weren't in network byteorder. I
> guess that also changed since then.
> 
> I would simply send a patch to fix iproute2, but I don't like the
> kernel's hash "folding" as it ignores any bits beyond the first eight.
> So I would prefer to "fix" the kernel instead but would like to hear
> your opinions as that change has a much larger scope than just
> iproute2's 'sample' option.
> 
> Thanks, Phil
> 

