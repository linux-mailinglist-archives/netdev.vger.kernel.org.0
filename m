Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842D323F36E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHGT7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgHGT7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:59:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88468C061756;
        Fri,  7 Aug 2020 12:59:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m34so1467825pgl.11;
        Fri, 07 Aug 2020 12:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=N/pR4E/qxL/wX5EPUnI0iXLQMzb1rGW2L4MNHM92qQs=;
        b=tUUUFweRmJX05czmFHLxX721d9zsb1gXF110pU621p40LpIxFPioiAYZjoyN4p/wCO
         Liu0o+oWpFgYGL4dO8QZKRoZLFTJtkEv3Vh3kRB/wuPsyBHDCROmIs/YMAQI+4diIIId
         cTWYG3ZQ8KwkszA/t7UyezT6KO1+H4RfL2R/YHnQadj2HtcL5YliUbq9ORyLBZ7eCKoR
         /IIZSLBqahSC9yilTYMlfyxtw4XTStPcOBzca9wp8R+W8uli+KmDbqWh2xIjo3lQsQpg
         r+e+i9bAHFrmTm9uLEvz6GTWmPRWXVDUR3rJ1I254+jflk6J1NgANziDhMdz2etTSLus
         ZZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N/pR4E/qxL/wX5EPUnI0iXLQMzb1rGW2L4MNHM92qQs=;
        b=h9ikPGHsnn52ZrHtcTIQ8BvERzO+gEWBFUOJQ1RSgKC3Z3YVjHE6bfGM4Ocxqv16b5
         DkTjc2EmtfNtzGwgaIl3kZ6cCFX1bCbg6uFdZ2yWOsTCYLbGzaiQTi0032aYdP3ssKXg
         ZpxP1N1KVAM7g0PxpSC44seocVyfTjEkKjGQDpUkp9rTzKMSRKz0kQZySR/ymim8bJEG
         et9m6bmflZu2VUGuNMIya+UtWbnZ70SpZV867Gnr3Hcm+MZllKaEQZ7bdXnVjZrz9+Ah
         sQK/c9kDuuGzHJd6KPc2V/HoalDZ+uKg0LwnzA2+9/ghkoHnHRM3oBKCJ37wb4aNj1yX
         QdhA==
X-Gm-Message-State: AOAM5331DPmZ/EmA/pZC1o7xf23/aDk4XY9wbYNeuN8xnDAkAkqGmCtl
        L56UldJgn1lksiTepCy9lAnwseBB9MU=
X-Google-Smtp-Source: ABdhPJwH3ZKURa/Oxkq+1I5NslHa0VDnIJQYTAthwAXZXWxhVsHt0LoUrlc1DWVBet1ljID0Xirrkg==
X-Received: by 2002:a63:6fcd:: with SMTP id k196mr13612067pgc.251.1596830389727;
        Fri, 07 Aug 2020 12:59:49 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id w70sm13708811pfc.98.2020.08.07.12.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:59:49 -0700 (PDT)
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
 <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
 <20200807174302.GA6740@1wt.eu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <9148811b-64f9-a18c-ddeb-b1ff4b34890e@gmail.com>
Date:   Fri, 7 Aug 2020 12:59:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807174302.GA6740@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-08-07 10:43 a.m., Willy Tarreau wrote:
>
>> Which means that it's 2^32 effort to brute force this (which Amit called "no
>> biggie for modern machines"). If the noise is the raw sample data with only
>> a few bits of entropy, then it's even easier to brute force.
> Don't you forget to multiply by another 2^32 for X being folded onto itself ?
> Because you have 2^32 possible values of X which will give you a single 32-bit
> output value for a given noise value.

If I can figure the state out once, then the only new input is the 
noise, so that's the only part I have to brute force. Throwing the noise 
in makes it more difficult to get that state once, but once I have it 
then this type of reseeding doesn't help.


>> Is there a hard instruction budget for this, or it is
>> just "fast enough to not hurt the network benchmarks" (i.e. if Dave Miller
>> screams)?
> It's not just Davem. I too am concerned about wasting CPU cycles in fast
> path especially in the network code. A few half-percent gains are hardly
> won once in a while in this area and in some infrastructures they matter.
> Not much but they do.

That's why I was asking. I don't have the same experience as you for 
what acceptable is. I think it might be possible to do a decent CPRNG 
(that's at least had some cryptanalys of it) with ~20 instructions per 
word, but if that's not fast enough then I'll think about other options.

Marc
