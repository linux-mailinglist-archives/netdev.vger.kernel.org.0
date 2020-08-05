Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B600F23D272
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgHEUMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgHEQZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:25:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE6FC001FC6;
        Wed,  5 Aug 2020 08:44:06 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g19so12887057plq.0;
        Wed, 05 Aug 2020 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=38oGDFVZxYlm4jCt82Y6Pi2UrtgWkhfSP7CwpkOvuwo=;
        b=q/Puz6CNiEQUtbimeIQUcWx+fyOQe4YZBRrvoO3QnjbPNCN0bjyJbSQ4NTn6C8mQNa
         tBHi76QLKQ1rOi4mmEhslKbkk30WJmN+AG5RInHchGHO1L9NHZfSxc75PPVKvAjDAqRt
         sSqSB+jevUhLUjtNcI93ZEekTRIsqz0LEfzaH5QKAvy3f8UUE0JDbnPQxtYgQ08xeG9b
         8AE8lR1JvbEuoTBQKtn8X5/sNdrDUwswQntqQXDBAsMet7/zJcjdWNS0SVs3X7vMu1fO
         SZlWUFx/c6mTLIvZsKkDZ+DwusfrnjOIkcfv7jqv7UMX6p6/d/9kimLG8aU4BoC3d9fg
         i6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=38oGDFVZxYlm4jCt82Y6Pi2UrtgWkhfSP7CwpkOvuwo=;
        b=Ho97s6rh6j3il0wHJ0mQo5xKooAaoT7Todbw6smaAeu5mByDS7ADLxXe/G6pJsJFaM
         AYHjidnEj+iueeKGi2OwjpMbeBjaRn5Phj/pAkVzgofMkJ9w/PwewE3OhBud/6QwUtXV
         6f2KCtsigCZvADgB7RFbmnvyGx7fmiYy/PbDrWePkTJc9c+YDrutBtFMkyJp07m580gL
         71sJ8PgGah1JwAEA41+D41dQimZPowNUmaASKKmJjs25c7Vv47JiP9wuhUAX27r76FDv
         4r2qUFgQ1f1XrH685AOfS9G8ypa4gU62MscDlKlLKSCSO0QiIqVawpmvhCJePWRRAdFr
         a1HQ==
X-Gm-Message-State: AOAM533Dc60X8NMzDNOVReCfIVyx6+sN4wdpeu+iOCuvu6++Zpy8Ilcq
        Ajk44RrhI+hRoHIXoYSaGyFOn/ruMEbvyA==
X-Google-Smtp-Source: ABdhPJxU2jwD16AOtHWirmkbYGfOdJGfCpi76zPG8pvgitZMToYDQ7zuX7HkifSxNEoCf3zxpAhdfA==
X-Received: by 2002:a17:90b:1413:: with SMTP id jo19mr3824714pjb.37.1596642245650;
        Wed, 05 Aug 2020 08:44:05 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id 207sm3809364pfz.203.2020.08.05.08.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 08:44:05 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     Willy Tarreau <w@1wt.eu>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <66f06ea1-3221-5661-e0de-6eef45ac3664@gmail.com>
Date:   Wed, 5 Aug 2020 08:44:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805024941.GA17301@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

On 2020-08-04 7:49 p.m., Willy Tarreau wrote:
> Hi Marc,
>
> On Tue, Aug 04, 2020 at 05:52:36PM -0700, Marc Plumb wrote:
>> Seeding two PRNGs with the same entropy causes two problems. The minor one
>> is that you're double counting entropy. The major one is that anyone who can
>> determine the state of one PRNG can determine the state of the other.
>>
>> The net_rand_state PRNG is effectively a 113 bit LFSR, so anyone who can see
>> any 113 bits of output can determine the complete internal state.
>>
>> The output of the net_rand_state PRNG is used to determine how data is sent
>> to the network, so the output is effectively broadcast to anyone watching
>> network traffic. Therefore anyone watching the network traffic can determine
>> the seed data being fed to the net_rand_state PRNG.
> The problem this patch is trying to work around is that the reporter
> (Amit) was able to determine the entire net_rand_state after observing
> a certain number of packets due to this trivial LFSR and the fact that
> its internal state between two reseedings only depends on the number
> of calls to read it.

I thought net_rand_state was assumed to be insecure and that anyone 
could determine the internal state. Isn't this Working as Designed? It's 
a PRNG not a CPRNG. If some aspects of security depends on the sate 
remaining secret then this is fundamentally the wrong tool.

> (please note that regarding this point I'll
> propose a patch to replace that PRNG to stop directly exposing the
> internal state to the network).

I'm glad to hear that. A good option would be SFC32.

> If you look closer at the patch, you'll see that in one interrupt
> the patch only uses any 32 out of the 128 bits of fast_pool to
> update only 32 bits of the net_rand_state. As such, the sequence
> observed on the network also depends on the remaining bits of
> net_rand_state, while the 96 other bits of the fast_pool are not
> exposed there.

The fast pool contains 128 bits of state, not 128 bits of entropy. The 
purpose of the large pool size is to make sure that the entropy is not 
lost due to collisions. The non-linear mixing function (a simplified 
version of a single round of the ChaCha mixing function so the entropy 
diffusion is low) means that the 32 bits leaked are not independent from 
the other 96 bits, and in fact you can reconstruct the entire pool from 
a single reading of 32 bits (as long as there aren't more than 32 bits 
of entropy added during this time -- which isn't the case, see below). 
Please think harder about this part. I think you are misunderstanding 
how this code works.

>> Since this is the same
>> seed data being fed to get_random_bytes, it allows an attacker to determine
>> the state and there output of /dev/random. I sincerely hope that this was
>> not the intended goal. :)
> Not only was this obviously not the goal, but I'd be particularly
> interested in seeing this reality demonstrated, considering that
> the whole 128 bits of fast_pool together count as a single bit of
> entropy, and that as such, even if you were able to figure the
> value of the 32 bits leaked to net_rand_state, you'd still have to
> guess the 96 other bits for each single entropy bit :-/

The code assumes that there is at least 1/64 bit of entropy per sample, 
and at most 2 bits of entropy per sample (which is why it dumps 128 bits 
every 64 samples). If you're extracting 32 bits every sample, which 
means it's leaking 2048 bits in 64 samples (to net_random, how fast it 
leaks to the outside world is a different issue). So the question is if 
an attacker can reconstruct 128 bits of entropy from 2048 bits of 
internal state -- this does not seem obviously impossible, since there 
are no cryptographically vetted operations in this.

The other thing that this misses is that reseeding in dribs and drabs 
makes it much easier to recover the new state. This is is explained well 
in the documentation about catastrophic reseeding in the Fortuna CPRNG. 
This entire approach is flawed. Throwing in single bits of entropy at a 
time doesn't really help since an attacker can brute force a single bit 
at a time. (There is a challenge in deriving the initial fast_pool 
states which this makes more difficult, but there is no real 
crytptographic guarantee about how difficult it is.)

Thanks,

Marc

