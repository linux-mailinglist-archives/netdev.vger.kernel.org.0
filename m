Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA58466892
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359656AbhLBQtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbhLBQtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:49:06 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF6C06174A;
        Thu,  2 Dec 2021 08:45:44 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d9so66365wrw.4;
        Thu, 02 Dec 2021 08:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AKQ2pAOmEBJeGaC+Fg+TZ5OgSJZapELwBH5HT52ld0E=;
        b=DWyCnwkiT9jP17kIiITLctgKV5J8BjqINPgNPrM3tZ6Rg2b5hCB7yvJlJ5w7i8rFui
         /STV1QMz9I/mghF4FGTpGqd3feDNxMZUbC/aw/Mw3/hh1ZuWQ0xh+mzog0LgfHBDyuv3
         6rpY7d28lzihf35gndWOnFBZuc+VBrzlqkUi2CeHl7rz3SVmVSplaI1swxtwy+bE8pq7
         INjTe8sPMC9FyYLq6EOsquMDypF1Q7ajA3vdQZ/HZRcxh7lI5INusAv+XYcP/B0ZITj1
         Kqp7IUPZAiCq0ymQXsbwlPY+30qaYjnHmKceBNgvAvPGXMwpO05jmBp0zbTjRBnZFrMX
         Szaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AKQ2pAOmEBJeGaC+Fg+TZ5OgSJZapELwBH5HT52ld0E=;
        b=s3y2HDqeH6iU5IYuU2IiBkZXT+Z9HTLS42KjGxhMMmvvJ36jkrgrRXFm4nfE+FmTt6
         rP+hC3XbWNYS59/N0zy2LToDdX4zF5KfQaLeZjKJpqbSg+6u4A+tJUxNXFR+DzgFFA2v
         lFna8oOJgSuJKm2ZkFhv7zN8AgecihBw9Sk9XpAn1hzbplE+ztm+kuee2yL4rSogJFg4
         +ERknfD4dpt8ivfr712tAwk+x6bI35AJldd89/2f+zjUYauIaf0oZ5Y6AkZ7N9I/IZHK
         dC/HSNv799iiZYTVIPBUmJFj79sJWxxpOO9uoz3CBawOwHX446TYMcWrVyVNBMScZH2H
         D8NQ==
X-Gm-Message-State: AOAM531R0DAfr3HuAmp6oF4juaoiFfU7Ad/LCmiLA39HmKT9/BhYhQKA
        NjapsDVg93cTPeC8tH9F8zo=
X-Google-Smtp-Source: ABdhPJzYALyvcqQRhcSVq0MDZZC1OBiAF0C2u/IvC46Hz2V7qJ8Q8UyzJFyXmFMsz7YAtJ1uOBtTTQ==
X-Received: by 2002:adf:d22a:: with SMTP id k10mr16152878wrh.80.1638463542576;
        Thu, 02 Dec 2021 08:45:42 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.137])
        by smtp.gmail.com with ESMTPSA id h204sm169540wmh.33.2021.12.02.08.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 08:45:42 -0800 (PST)
Message-ID: <6e07fb0c-075b-4072-273b-f9d55ba1e1dd@gmail.com>
Date:   Thu, 2 Dec 2021 16:45:36 +0000
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
 <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/21 00:32, Willem de Bruijn wrote:
>>>> # discussion / questions
>>>>
>>>> I haven't got a grasp on many aspects of the net stack yet, so would
>>>> appreciate feedback in general and there are a couple of questions
>>>> thoughts.
>>>>
>>>> 1) What are initialisation rules for adding a new field into
>>>> struct mshdr? E.g. many users (mainly LLD) hand code initialisation not
>>>> filling all the fields.
>>>>
>>>> 2) I don't like too much ubuf_info propagation from udp_sendmsg() into
>>>> __ip_append_data() (see 3/12). Ideas how to do it better?
>>>
>>> Agreed that both of these are less than ideal.
>>>
>>> I can't comment too much on the io_uring aspect of the patch series.
>>> But msg_zerocopy is probably used in a small fraction of traffic (even
>>> if a high fraction for users who care about its benefits). We have to
>>> try to minimize the cost incurred on the general hot path.
>>
>> One thing, I can hide the initial ubuf check in the beginning of
>> __ip_append_data() under a common
>>
>> if (sock_flag(sk, SOCK_ZEROCOPY)) {}
>>
>> But as SOCK_ZEROCOPY is more of a design problem workaround,
>> tbh not sure I like from the API perspective. Thoughts?
> 
> Agreed. io_uring does not have the legacy concerns that msg_zerocopy
> had to resolve.
> 
> It is always possible to hide runtime overhead behind a static_branch,
> if nothing else.
> 
> Or perhaps do pass the flag and use that:
> 
>    - if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
>    + if (flags & MSG_ZEROCOPY && length) {
>    +         if (uarg) {
> 
>    etc.

Good idea. Unfortunately, not going to work (SOCK_ZEROCOPY would neither)
because we pass ubuf as a parameter into the function, and e.g. we need
to NULL it if not used, but at least good for tcp_sendmsg_locked

>> I hope
>> I can also shuffle some of the stuff in 5/12 out of the
>> hot path, need to dig a bit deeper.
>>
>>> I was going to suggest using the standard msg_zerocopy ubuf_info
>>> alloc/free mechanism. But you explicitly mention seeing omalloc/ofree
>>> in the cycle profile.
>>>
>>> It might still be possible to somehow signal to msg_zerocopy_alloc
>>> that this is being called from within an io_uring request, and
>>> therefore should use a pre-existing uarg with different
>>> uarg->callback. If nothing else, some info can be passed as a cmsg.
>>> But perhaps there is a more direct pointer path to follow from struct
>>> sk, say? Here my limited knowledge of io_uring forces me to hand wave.
>>
>> One thing I consider important though is to be able to specify a
>> ubuf per request, but not somehow registering it in a socket. It's
>> more flexible from the userspace API perspective. It would also need
>> constant register/unregister, and there are concerns with
>> referencing/cancellations, that's where it came from in the first
>> place.
> 
> What if the ubuf pool can be found from the sk, and the index in that
> pool is passed as a cmsg?

It looks to me that ubufs are by nature is something that is not
tightly bound to a socket (at least for io_uring API in the patchset),
it'll be pretty ugly:

1) io_uring'd need to care to register the pool in the socket. Having
multiple rings using the same socket would be horrible. It may be that
it doesn't make much sense to send in parallel from multiple rings, but
a per thread io_uring is a popular solution, and then someone would
want to pass a socket from one thread to another and we'd need to support
it.

2) And io_uring would also need to unregister it, so the pool would
store a list of sockets where it's used, and so referencing sockets
and then we need to bind it somehow to io_uring fixed files or
register all that for tracking referencing circular dependencies.

3) IIRC, we can't add a cmsg entry from the kernel, right? May be wrong,
but if so I don't like exposing basically io_uring's referencing through
cmsg. And it sounds io_uring would need to parse cmsg then.


A lot of nuances :) I'd really prefer to pass it on per-request basis,
it's much cleaner, but still haven't got what's up with msghdr
initialisation...

Maybe, it's better to add a flags field, which would include
"msg_control_is_user : 1" and whether msghdr includes msg_iocb, msg_ubuf,
and everything else that may be optional. Does it sound sane?

-- 
Pavel Begunkov
