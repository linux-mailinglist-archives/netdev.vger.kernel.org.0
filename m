Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41B123F18B
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgHGQwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGQwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:52:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3741CC061756;
        Fri,  7 Aug 2020 09:52:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o1so1327627plk.1;
        Fri, 07 Aug 2020 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xsW1f+HKKG0AWp7u8NAw751nsWjHbofocHGYDxLjXgk=;
        b=Q1SYOrNC4zTSwyaxaviQBc4fwes5jTUS3LsCVqlvTlOyhdC6de9uE3yW2XqgPoDgPa
         92wX3NmzvW6z59ohlv6Zytdrc5WemjTkbRsU7o2mz3Qqg+a1Wm0O3kKScIUzCsFILN5g
         m1ara0xc2V4439ZsW/NiHG04rVTDBDw5FJBfvZAOcTOoVDQrP9I818h9UtYHOZGZxRM6
         EUSn5aMC0VyPh3QMl6mz5QmPA/IJyGDKsOGEEq7I8ZWVEC6Y52ZHjVHhu75WXUphmsw/
         0gYnl/CuDqD2NCWNajJ//PhmxbdQeRQJRHl5GK0emXKf4oEqBeUOsE8DZZnXnIsa2uni
         M5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xsW1f+HKKG0AWp7u8NAw751nsWjHbofocHGYDxLjXgk=;
        b=ZamqTZAnJEtd1OwMJZJjyGv43AI3VqILymWmqJcDbNZVwKBkPyceAjdZuW9k13ZdPw
         FH1aislySFSiSx27pxVJMCsn6ECYdZRswb2gSAkG9n1kfgYbcsbJAlsES9uxueja/ESk
         QFwb0rE99L18CpAwdKk6OL0ORxApHVpCq8TTj/CMbmpQF/n8Ba1ZD06rXZqmPxhre6M6
         dKz451+p135uuhePlQ4hZOCN4Mo6BHwT7HOf/vGr1ZmOfXYcIanDcArLsrruOjgw8U0B
         hOUsrBA6iXVzKtqYVyOG9l3K1g+f0l8fHako9NWlXJlM2VL8cHQaeEwoiUGTmC7hqfFM
         ZTeA==
X-Gm-Message-State: AOAM533KIQE0ztma+eFijm+KGj9+M24d5nR1iLKhWqm7LS4WNwYIDHRp
        uuAIJzoklc87uO0cm/IeE6FmdrwC0Os=
X-Google-Smtp-Source: ABdhPJwUh1oEwteBcYrPrFfTBzGAlocSA6XAipgXH9pn1xuNafJR9A70gE0+6psCTlRN7KE7/eKgtw==
X-Received: by 2002:a17:902:b205:: with SMTP id t5mr13628349plr.7.1596819136409;
        Fri, 07 Aug 2020 09:52:16 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id lb1sm11291217pjb.26.2020.08.07.09.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 09:52:15 -0700 (PDT)
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
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
 <20200807070316.GA6357@1wt.eu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
Date:   Fri, 7 Aug 2020 09:52:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807070316.GA6357@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-07 12:03 a.m., Willy Tarreau wrote:

> Just to give a heads up on this, here's what I'm having pending regarding
> MSWS:
>
>    struct rnd_state {
>          uint64_t x, w;
>          uint64_t seed;
>          uint64_t noise;
>    };
>
>    uint32_t msws32(struct rnd_state *state)
>    {
>          uint64_t x;
>
>          x  = state->w += state->seed;
>          x += state->x * state->x;
>          x  = state->x = (x >> 32) | (x << 32);
>          x -= state->noise++;
>          return x ^ (x >> 32);
>    }

A few comments:

This is still another non-cryptographic PRNG. An LFSR can pass PractRand 
(if you do a tweak to get around the specific linear complexity test for 
LFSRs).

On a 64-bit machine it should be fast: 4 adds, 1 multiply, 1 rotate, 1 
shift, 1 xor

This will be much slower on 32-bit machines, if that's still a concern

As long as the noise is the output of a CPRNG, this doesn't hurt the 
security of dev/dandom.

The noise is more like effective 32-bits since you're xoring the low and 
high half of the noise together (ignoring the minor details of carry 
bits). Which means that it's 2^32 effort to brute force this (which Amit 
called "no biggie for modern machines"). If the noise is the raw sample 
data with only a few bits of entropy, then it's even easier to brute force.


Given the uses of this, I think we really should look into a CPRNG for 
this and then completely reseed it periodically. The problem is finding 
one that's fast enough. Is there a hard instruction budget for this, or 
it is just "fast enough to not hurt the network benchmarks" (i.e. if 
Dave Miller screams)?


Marc

