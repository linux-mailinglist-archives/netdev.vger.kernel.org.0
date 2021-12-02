Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD0F4667F4
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359501AbhLBQ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359487AbhLBQ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:28:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F5AC06174A;
        Thu,  2 Dec 2021 08:25:25 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q3so37927326wru.5;
        Thu, 02 Dec 2021 08:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0JGsvnjiYkIl6j1i8qSpFvEIFGcGRddganu7CpOyXOk=;
        b=X/0Vs8VNVs+6CMRA+kwG8jWZnxgMrYIY1EwQaL97BJweRb0ZY6vFKjx5CeZCmsapfX
         KBgZ7E9zyr3Lc+QK9JFXV8xHH0hffaS/cer6YtrdTK0cgCJ46otgp+x0AS2obh9g9BYE
         /WAg4XqUpnC3pywG+rx8VDprgBM1safugNRPF6eW1LNo23FU23WCBwei4gmdEde9uNdd
         0t8/WIGTqWj1CeHrAl8UW/P+HsWgQMM3rQhK81g5Gp3WHG3mBHDwUBpZa0MbG0LLA5uf
         xqO2+IsIaNd5i2a+rCcf2NMBRdceoyDB325XWR1M5XL2uOeV2jQjWFXnSmdSHossravG
         7BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0JGsvnjiYkIl6j1i8qSpFvEIFGcGRddganu7CpOyXOk=;
        b=7cRCnCqa0sTn4zyKMmf1M5zRoG02SVdsxDPUN86am8BZatQazpFoSL8tuE++vrSF8f
         Bpw7M4rsOPJSo/2nHEmKMNHxVxXWPs0LYT0DzC692YCuXH8z64Z6QVKruvgvXWmc9uX8
         s6QNAkNCFyLtgZnh6is1mRKGiN5Ski6r8b8gk+QcT+JXPU37GbuEMPm9tVhJl+GoSrEb
         nSdQRFApvsf4CEOXvS4gp3hxLE84g+g7oNuKOI6xU20LLKYQtooJ6zmvosHrtiU1781c
         1zMpwxIAlaJ6r+ZJmuurvlLpUVK23lpAFPU/wCQRgRmLLlVRLN9hgKA1mnIfHx3qzCgN
         wQiA==
X-Gm-Message-State: AOAM530BPupTeiWIg7mRuMSZXMl5mczpy9cYQjRl+pRafQqjvfuQiwWB
        qg6iE4+iGOHSj0d5Lwoa2x8=
X-Google-Smtp-Source: ABdhPJzUsiFaBatwrqVRFWnbt+o+h6w2j9qYRd+3ZiiiY/fxafluV9DaJ2LV6+OCq8hY+8pp9BRyXg==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr15223132wrq.354.1638462323689;
        Thu, 02 Dec 2021 08:25:23 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.137])
        by smtp.gmail.com with ESMTPSA id p12sm349112wrr.10.2021.12.02.08.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 08:25:23 -0800 (PST)
Message-ID: <9db0edcf-75c0-d014-6120-514cc37a1a9f@gmail.com>
Date:   Thu, 2 Dec 2021 16:25:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
 <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
 <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/21 00:36, Willem de Bruijn wrote:
>>>>> 1) we pass a bvec, so no page table walks.
>>>>> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
>>>>>      still doing page get/put (see 4/12) slashed 4-5%.
>>>>> 3) avoiding get_page/put_page in 5/12
>>>>> 4) completion events are posted into io_uring's CQ, so no
>>>>>      extra recvmsg for getting events
>>>>> 5) no poll(2) in the code because of io_uring
>>>>> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
>>>>>      io_uring caches the structures reducing it to nearly zero-overhead.
>>>>
>>>> Nice set of complementary optimizations.
>>>>
>>>> We have looked at adding some of those as independent additions to
>>>> msg_zerocopy before, such as long-term pinned regions. One issue with
>>>> that is that the pages must remain until the request completes,
>>>> regardless of whether the calling process is alive. So it cannot rely
>>>> on a pinned range held by a process only.
>>>>
>>>> If feasible, it would be preferable if the optimizations can be added
>>>> to msg_zerocopy directly, rather than adding a dependency on io_uring
>>>> to make use of them. But not sure how feasible that is. For some, like
>>>> 4 and 5, the answer is clearly it isn't.  6, it probably is?
>>
>> Forgot about 6), io_uring uses the fact that submissions are
>> done under an per ring mutex, and completions are under a per
>> ring spinlock, so there are two lists for them and no extra
>> locking. Lists are spliced in a batched manner, so it's
>> 1 spinlock per N (e.g. 32) cached ubuf_info's allocations.
>>
>> Any similar guarantees for sockets?
> 
> For datagrams it might matter, not sure if it would show up in a
> profile. The current notification mechanism is quite a bit more
> heavyweight than any form of fixed ubuf pool.

Just to give an idea what I'm seeing in profiles: while testing

3 | io_uring (@flush=false, nr_reqs=1)   |  96534     | 2.03

I found that removing one extra smb_mb() per request in io_uring
gave around +0.65% of t-put (quick testing). In profiles the
function where it was dropped from 0.93% to 0.09%.

 From what I see, alloc+free takes 6-10% for 64KB UDP, it may be
great to have something for MSG_ZEROCOPY, but if that adds
additional locking/atomics, honestly I'd prefer to keep it separate
from io_uring's caching.

I also hope we can optimise generic paths at some point, and the
faster it gets the more such additional locking will hurt, pretty
much how it was with the block layer.

> For TCP this matters less, as multiple sends are not needed and
> completions are coalesced, because in order.
> 

-- 
Pavel Begunkov
