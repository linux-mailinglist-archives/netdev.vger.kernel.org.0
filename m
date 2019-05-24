Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8469029B84
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389948AbfEXPvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:51:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39741 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389496AbfEXPvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:51:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id w22so5276444pgi.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 08:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0kwzGKqYhyU21EREFW1b/eYq/9XAO88Z6a4x2Pv5o4Y=;
        b=nga1CjOZWPF2fHBlNwJG9LVG8wRVEeUzH1VPL4t36HAfbSsiqDQbDSXhjXwEzfsFbc
         wZ63An0NIatKwM3Ta7eQXvx32vWbuMJbw3v+ENz9OhSi6iKGhABHWUrp06svz+vs510Q
         +t+IopLXwNrnFm02/jYK6Hfts43/PAAdzJ8xMRkawH3K0ssqwyYF7hxT/2ulJi9FcVZm
         g+GiA5rUz8zQ5+iH4LSBQ7TBXxnBkXDmpQ8n66n59qfKmf9gHS6h5TMiSrsJmV8SNfn/
         WexLxQbn1srT0gxZYWt6rNJBKvED7NjXMyZ1QaKv9HNpZt8Rrd4nIJk+IRMhOY9NWDke
         iDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0kwzGKqYhyU21EREFW1b/eYq/9XAO88Z6a4x2Pv5o4Y=;
        b=aE0Mo4yZbOMLEx83YuJZqH6aglmodZk9abrtQ89oG8WwIikIs+B8NOo2Szh4OzhS9u
         d7B8pVV7H6aGIfUpLK/iBIbg3vdhQPfE+w8NC0WKdestgCtnQ/sohz1tOh+k7Y8rq5VX
         bDiHe2IaivtqL3owmw26kT2Zk/z1ngfMbZEORuYD7JW4ZtGtVW+HgA57xgPQJ9w/Z6ZN
         7aI0RjzrvYawk/X4ihnn6daWWnDNQYAA6QoqvIxPRRWhv38d0QFcpRv92Jor969Y+fKx
         bwqByeLmG+SI8ezZAZ51vtgR1jFm3gBRbWC8Hcy3iwEp0se6a1GbWYaYACif66zQxkEy
         W9bA==
X-Gm-Message-State: APjAAAXD3UfQUrGnHMbXELgGC/uazLoozSPEIxfhkQ3ZMslE2P6SVF/U
        OtW9kCU++6A/DkyrZWnXRUI=
X-Google-Smtp-Source: APXvYqx3AQy7bl6qbCss8/DsKCHCdE4Pli4iISLo913MkA/j5HYAlBm2uKi0TURq1UUgAIyidMyOXw==
X-Received: by 2002:a63:f710:: with SMTP id x16mr92354430pgh.216.1558713104014;
        Fri, 24 May 2019 08:51:44 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p64sm3711246pfp.72.2019.05.24.08.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 08:51:43 -0700 (PDT)
Date:   Fri, 24 May 2019 08:51:34 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Message-ID: <5ce81306aacbe_39402ae86c50a5bc2f@john-XPS-13-9360.notmuch>
In-Reply-To: <87r28oz398.fsf@cloudflare.com>
References: <20190211090949.18560-1-jakub@cloudflare.com>
 <5439765e-1288-c379-0ead-75597092a404@iogearbox.net>
 <871s423i6d.fsf@cloudflare.com>
 <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch>
 <87v9y2zqpz.fsf@cloudflare.com>
 <5ce6c32418618_64ba2ad730e1a5b44@john-XPS-13-9360.notmuch>
 <87r28oz398.fsf@cloudflare.com>
Subject: Re: [PATCH net] sk_msg: Keep reference on socket file while psock
 lives
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, May 23, 2019 at 05:58 PM CEST, John Fastabend wrote:
> > [...]
> >
> >>
> >> Thanks for taking a look at it. Setting MSG_DONTWAIT works great for
> >> me. No more crashes in sk_stream_wait_memory. I've tested it on top of
> >> current bpf-next (f49aa1de9836). Here's my:
> >>
> >>   Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
> >>
> >> The actual I've tested is below, for completeness.
> >>
> >> BTW. I've ran into another crash which I haven't seen before while
> >> testing sockmap-echo, but it looks unrelated:
> >>
> >>   https://lore.kernel.org/netdev/20190522100142.28925-1-jakub@cloudflare.com/
> >>
> >> -Jakub
> >>
> >> --- 8< ---
> >>
> >> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >> index e89be6282693..4a7c656b195b 100644
> >> --- a/net/core/skbuff.c
> >> +++ b/net/core/skbuff.c
> >> @@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
> >>                 kv.iov_base = skb->data + offset;
> >>                 kv.iov_len = slen;
> >>                 memset(&msg, 0, sizeof(msg));
> >> +               msg.msg_flags = MSG_DONTWAIT;
> >>
> >>                 ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
> >>                 if (ret <= 0)
> >
> > I went ahead and submitted this feel free to add your signed-off-by.
> 
> Thanks! The fix was all your idea :-)

If I can push the correct patch to Daniel it should be in bpf tree
soon.

> 
> Now that those pesky crashes are gone, we plan to look into drops when
> doing echo with sockmap. Marek tried running echo-sockmap [1] with
> latest bpf-next (plus mentioned crash fixes) and reports that not all
> data bounces back:
> 
> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
> 971832
> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
> 867352
> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
> 952648
> 
> I'm tring to turn echo-sockmap into a selftest but as you can probably
> guess over loopback all works fine.
> 

Right, sockmap when used from recvmsg with redirect is lossy. This
was a design choice I made that apparently caught a few people
by surprise. The original rationale for this was when doing a
multiplex operation, e.g. single ingress socket to many egress
sockets blocking would cause head of line blocking on all
sockets. To resolve this I simply dropped the packet and then allow
the flow to continue. This pushes the logic up to the application
to do retries, etc. when this happens. FWIW userspace proxies I
tested also had similar points where they fell over and dropped
packets. In hind sight though it probably would have made more
sense to make this behavior opt-in vs the default. But, the
use case I was solving at the time I wrote this could handle
drops and was actually a NxM sockets with N ingress sockets and M
egress sockets so head of line blocking was a real problem.

Adding a flag to turn this into a blocking op has been on my
todo list for awhile. Especially when sockmap is being used as
a single ingress to single egress socket then blocking vs dropping
makes much more sense.

The place to look is in sk_psock_verdict_apply() in __SK_REDIRECT
case there is a few checks and notice we can fallthrough to a
kfree_skb(skb). This is most likely the drops you are hitting.
Maybe annotate it with a dbg statement to check.

To fix this we could have a flag to _not_ drop but enqueue the
packet regardless of the test or hold it until space is
available. I even think sk_psock_strp_read could push back
on the stream parser which would eventually push back via TCP
and get the behavior you want.

Also, I have a couple items on my TODO list that I'll eventually
get to. First we run without stream parsers in some Cilium
use cases. I'll push some patches to allow this in the next
months or so. This avoids the annoying stream parser prog that
simply returns skb->len. This is mostly an optimizations. A
larger change I want to make at some point is to remove the
backlog workqueue altogether. Originally it was added for
simplicity but actually causes some latency spikes when
looking at 99+ percentiles. It really doesn't need to be
there it was a hold over from some original architecture that
got pushed upstream. If you have time and want to let me know
if you would like to tackle removing it.

Thanks,
John
