Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4923DDEC
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgHFRTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgHFRTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:19:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78906C061574;
        Thu,  6 Aug 2020 10:18:58 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d188so19362834pfd.2;
        Thu, 06 Aug 2020 10:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nkJqCunl7w7ri3sqQzICAeLFCVweDyO02CMRxkc0Kfo=;
        b=mXW1vfmGVDajFyeMgsONYAWlgB/N34QEe5JC9bx95dh+krmYvNLj89N5wrmPU7Wjec
         DNpnHsBv18P9S/OZJ0l34dwory9XgdT5Zku9OknBA6XAmoWGu8+Vx9DmVHyGX++ypJcR
         rsQdInG1dyRfxZBVchVhyrXOM85aLUD/pV0GjNyOugyrZroQclyRtGkHYtJFcXM7yB7M
         56vYX2jKCgnf8rcYUYJ4yHPOdQabZlWKW9TEPXq7fQ8GVysbb8EzXmYVynxl5ZMt+I1i
         49UMv85X5U2ntYYLg0cSmCi1EbeZ6+wfL2x8w9N4rhfTtwtGhQrQjshk7y+dzk0E1Y22
         0XIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nkJqCunl7w7ri3sqQzICAeLFCVweDyO02CMRxkc0Kfo=;
        b=hfaZWW9TkQNIjW/oiTMAABpR6AiCle1Dbbeo+oOroCYh20V5S0EF1Bqe1g30XbFXLd
         sQnnpafJ4UDstp+YTRhuOJwi6omRyBfr4DY2ajLvik+D3hGzQ/kkKW/qE/Noas/q0qEw
         JF6YdiwKrrgkpfh7ewR6csNIK4/cUB8rXqM5L+o4jdE0k6krOLbS1CVUDnNsT0Tq0Vcn
         rhXKW/qbD/MzaZsrkJFOmBaCOrvQ4zoJ/pps6cvBp+G0JlM0W8D3HcoTuCSjSuL6d05p
         y87k7yzQehGXifITzeY1rxY7Z/VHqj8sNvdf5ebfe+QMJLynOhaAole3RjRmTKKoIPH+
         gjdw==
X-Gm-Message-State: AOAM5315v/eDoabiACQAz8HLa71X4AJff/p6n+na0qmkHB8tiUNBpKVU
        4J94D8SuCRzqzsj/Cr3UtIf2K5xTw9UBmg==
X-Google-Smtp-Source: ABdhPJyikFO4AP6ZTUkjQE29G6GqLMor6beOLmzjAyEMfFYBOG+ar04F4luHtYxjGajNCt5FKsDx+g==
X-Received: by 2002:a63:125a:: with SMTP id 26mr8398198pgs.340.1596734336590;
        Thu, 06 Aug 2020 10:18:56 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id z2sm9352289pfq.46.2020.08.06.10.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 10:18:56 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     Willy Tarreau <w@1wt.eu>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu> <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
Date:   Thu, 6 Aug 2020 10:18:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806063035.GC18515@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy,


On 2020-08-05 11:30 p.m., Willy Tarreau wrote:
> On Wed, Aug 05, 2020 at 03:21:11PM -0700, Marc Plumb wrote:
>> There is nothing wrong with perturbing net_rand_state, the sin is doing it
>> with the raw entropy that is also the seed for your CPRNG. Use the output of
>> a CPRNG to perturb the pool all you want, but don't do things that bit by
>> bit reveal the entropy that is being fed into the CPRNG.
> This is interesting because I think some of us considered it exactly the
> other way around, i.e. we're not copying exact bits but just taking a
> pseudo-random part of such bits at one point in time, to serve as an
> increment among other ones. And given that these bits were collected
> over time from not very secret sources, they appeared to be of lower
> risk than the output.

No. The output of a CPRNG can't be used to determine the internal state. 
The input can. The input entropy is the one thing that cannot be 
produced by a deterministic computer, so they are the crown jewels of 
this. It's much much safer to use the output.


> I mean, if we reimplemented something in parallel just mixing the IRQ
> return pointer and TSC, some people could possibly say "is this really
> strong enough?" but it wouldn't seem very shocking in terms of disclosure.
> But if by doing so we ended up in accident reproducing the same contents
> as the fast_pool it could be problematic.
>
> Would you think that using only the input info used to update the
> fast_pool would be cleaner ? I mean, instead of :
>
>          fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
>          fast_pool->pool[1] ^= now ^ c_high;
>          ip = regs ? instruction_pointer(regs) : _RET_IP_;
>          fast_pool->pool[2] ^= ip;
>          fast_pool->pool[3] ^= (sizeof(ip) > 4) ? ip >> 32 :
>                  get_reg(fast_pool, regs);
>
> we'd do:
>
>          x0 = cycles ^ j_high ^ irq;
>          x1 = now ^ c_high;
>          x2 = regs ? instruction_pointer(regs) : _RET_IP_;
>          x3 = (sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);
>
>          fast_pool->pool[0] ^= x0;
>          fast_pool->pool[1] ^= x1;
>          fast_pool->pool[2] ^= x2;
>          fast_pool->pool[3] ^= x3;
>
> 	this_cpu_add(net_rand_state.s1, x0^x1^x2^x3);

No. That's just as bad. There are two major problems:

It takes the entropy and sends it to the outside world without any 
strong crypto between the seed and the output. Reversing this isn't 
trivial, but it also isn't provably difficult.

It adds small amounts of entropy at a time and exposes it to the outside 
world. No crypto can make this safe (google "catastrophic reseeding"). 
If an attacker can guess the time within 1ms, then on a 4GHz CPU that's 
only 22 bits of uncertainty, so it's possible to brute force the input. 
Any details about which part of the fast_pool are used are irrelevant 
since that's determined by that input also, so it adds no security to 
this type of brute force attack. The only other part is the initial TSC 
offset, but if that were sufficient we wouldn't need the reseeding at all.


> I didn't know about SFC32, it looks like a variation of the large family
> of xorshift generators, which is thus probably quite suitable as well
> for this task. Having used xoroshiro128** myself in another project, I
> found it overkill for this task compared to MSWS but I definitely agree
> that any of them is more suited to the task than the current one.
>
It's actually a chaotic generator (not a linear one like an xorshift 
generator), which gives it weaker period guarantees which makes it more 
difficult to reverse. With a counter added to help the period length.

I'll trust Amit that SFC32 isn't strong enough and look at other options 
-- I just thought of it as better, and faster than the existing one with 
the same state size. Maybe a larger state is needed.


Thanks,

Marc

