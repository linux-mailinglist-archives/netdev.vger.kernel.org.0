Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98723D3E2
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 00:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHEWVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 18:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgHEWVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 18:21:13 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45544C061575;
        Wed,  5 Aug 2020 15:21:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u10so16913273plr.7;
        Wed, 05 Aug 2020 15:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uMaj9W0Kk2d7hsZ76QX48BObbjxdnKyoua1hgbfb4Kw=;
        b=cYcMnpkWjmRtQfmQ8WqgJah29oibxkWximX0mFA7lAXpcTwKi7wqp/3661bGIm0Htl
         tec8bI1N9HWvvnYvvdQaPpX3khVeAtfFK0lERv5jCKJEsRZvjHgoHv0aqq9W1IV3fNpQ
         G+J7OEi6VEqB0cVX9105ly4VBQgb2482543cUihssCyiimaHiwR2nyHjnT1/YhyvQcGr
         zBaLf9mo2HWYsTcav493UcddFYlLyCkT5ITbP9wvLwaRyaiRXZbZ/rcqCKcfVJioG7DX
         UGKWhSIg+IOGUBkr1resbmp1MO3YdMi4O+rY5svmrbAwKCfD52TSv6mggfZn7hnViZb9
         pzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uMaj9W0Kk2d7hsZ76QX48BObbjxdnKyoua1hgbfb4Kw=;
        b=EJp5VbKBXjUBfsWWVwrH94xcV3PCBhK12t46jB97WG9anYUX+YSGX3f4HgUgyS3ccV
         /OQ9eNVzRg+fLWiSjzlY+UNFj2MM+NAdhexkcyMlFekJEPj7/H+QVonw9w14P3qdjY8e
         K3k6cIlHp4YDKb37nPCvr96kPkBRP/AElrjEmt+LxEn3ZBJwcmaY4YDJaBZtf43yG9xQ
         gPXTaPZPsrlTeQnDpQBEcrSNA5viUN3nEyt8PQqlXFAB/rUPmn/wIGaEULbbHP+I1ZyX
         qUTn5pN/4vXUlSJ4YAXrg7tmIhwwq/fiPl2vNqOLf6gX/X4pv69Xr0ZqEfI92Hl1jwJP
         sTOQ==
X-Gm-Message-State: AOAM533hmfT4qc32pPb+IQWW2laZHz8xPOcH2i7FULZm/XqlXiunn6vA
        BYBfAwC4qxdEdtAClUvEfAbO2j/SLKnxxw==
X-Google-Smtp-Source: ABdhPJyCNYsNtqpqP+bMtx36a7+mhLqWcUnZ5XhwKHl9VaLLr9q0u66scRhuhh5Gg5ku7jxvD6czRg==
X-Received: by 2002:a17:902:4b:: with SMTP id 69mr5246954pla.18.1596666072336;
        Wed, 05 Aug 2020 15:21:12 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id q2sm5330618pfc.40.2020.08.05.15.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 15:21:11 -0700 (PDT)
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
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
Date:   Wed, 5 Aug 2020 15:21:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805193824.GA17981@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy,

On 2020-08-05 12:38 p.m., Willy Tarreau wrote:

> It's not *that* major an issue (in my personal opinion) but the current
> net_rand_state is easy enough to guess so that an observer may reduce
> the difficulty to build certain attacks (using known source ports for
> example). The goal of this change (and the one in update_process_times())
> is to disturb the net_rand_state a little bit so that external observations
> turn from "this must be that" to "this may be this or maybe that", which
> is sufficient to limit the ability to reliably guess a state and reduce
> the cost of an attack.
There is nothing wrong with perturbing net_rand_state, the sin is doing 
it with the raw entropy that is also the seed for your CPRNG. Use the 
output of a CPRNG to perturb the pool all you want, but don't do things 
that bit by bit reveal the entropy that is being fed into the CPRNG.


> Another approach involving the replacement of the algorithm was considered
> but we were working with -stable in mind, trying to limit the backporting
> difficulty (and it revealed a circular dependency nightmare that had been
> sleeping there for years), and making the changes easier to check (which
> is precisely what you're doing).

Really? You can replace the LFSR and only change lib/random32.c. That 
might fix the problem without the need to use the raw fast_pool data for 
seed material. As Linus said, speed is a concern but SFC32 is faster 
than existing Tausworthe generator, and it's a drop-in replacement with 
the same state size if that makes your life easier. If you're willing to 
expand the state there are even better options (like SFC64 or some of 
chaotic generators like Jenkins' Frog).


> We're not trying to invent any stream cipher or whatever, just making
> use of a few bits that are never exposed alone as-is to internal nor
> external states, to slightly disturb another state that otherwise only
> changes once a minute so that there's no more a 100% chance of guessing
> a 16-bit port after seeing a few packets. I mean, I'm pretty sure that
> even stealing three or four bits only from there would be quite enough
> to defeat the attack given that Amit only recovers a few bits per packet.

If Amit's attack can recover that much per packet (in practice not just 
in theory) and there is even one packet per interrupt, then it's a major 
problem. There are at most 2 bits of entropy added per call to 
add_interrupt_randomness, so it you're leaking "a few bits per packet" 
then that's everything. Over 64 interrupts you've lost the 128 bits of 
entropy that the fast_pool has spilled into the input_pool.

Marc

