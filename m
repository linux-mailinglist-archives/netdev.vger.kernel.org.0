Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0142A705
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbhJLOUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:20:07 -0400
Received: from mail.efficios.com ([167.114.26.124]:37390 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbhJLOUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:20:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4BD2E362C62;
        Tue, 12 Oct 2021 10:18:04 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 0DNMGIKTscHv; Tue, 12 Oct 2021 10:18:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AB87C362C61;
        Tue, 12 Oct 2021 10:18:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AB87C362C61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1634048283;
        bh=oDnCBhtt2kYndLvbZ2dFBdBvvOim1KjLRvBSV4K13jM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=qHFA3IhrvM/jvCrRxBuQ5z0V3oJe7BPP2XLjfE7I7j2j/hL40ExC1JOaXfJTjt3bE
         jOsOpVSc6c1y1cGAV2+8uPV+xt8RqBzzRrTmazZvCfC9rEegqXStdTlcUxaF4KYN6h
         H7XSIouCsZ6ibCi3cf8RtqT3g9WwpcdbPOpUOmFi0oZRKFpNzVFfj4oCmD3vi+CZaz
         JfFatJwx19qX+Pm26RSh9tVA1a7elmsOIawr0RDSC2HnxmxKErDs6npCf1kg5HrNT5
         5OyYh97yO869J2TvfJIvDnO/E/VBH9yJ3tfwp4OYBQElRnCtP8d1HvzXtxSVbKU2DL
         BN9K3yKFfy2oA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fAOI71LUIkg8; Tue, 12 Oct 2021 10:18:03 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 90253362CEE;
        Tue, 12 Oct 2021 10:18:03 -0400 (EDT)
Date:   Tue, 12 Oct 2021 10:18:03 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Message-ID: <364516086.11428.1634048283470.JavaMail.zimbra@efficios.com>
In-Reply-To: <4dbff8032f874a6f921ba0555c94eeaf@AcuMS.aculab.com>
References: <20211005094728.203ecef2@gandalf.local.home> <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com> <4dbff8032f874a6f921ba0555c94eeaf@AcuMS.aculab.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4156 (ZimbraWebClient - FF93 (Linux)/8.8.15_GA_4156)
Thread-Topic: Use typeof(p) instead of typeof(*p) *
Thread-Index: Ade+e4X0oj4GW2UzTF+XE9nyZN8f2yyzmkpu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 11, 2021, at 4:39 AM, David Laight David.Laight@ACULAB.COM wrote:

> From: Mathieu Desnoyers
>> Sent: 05 October 2021 16:15
>> 
>> ----- On Oct 5, 2021, at 9:47 AM, rostedt rostedt@goodmis.org wrote:
>> [...]
>> > #define rcu_dereference_raw(p) \
>> > ({ \
>> > 	/* Dependency order vs. p above. */ \
>> > 	typeof(p) ________p1 = READ_ONCE(p); \
>> > -	((typeof(*p) __force __kernel *)(________p1)); \
>> > +	((typeof(p) __force __kernel)(________p1)); \
>> > })
>> 
>> AFAIU doing so removes validation that @p is indeed a pointer, so a user might
>> mistakenly
>> try to use rcu_dereference() on an integer, and get away with it. I'm not sure
>> we want to
>> loosen this check. I wonder if there might be another way to achieve the same
>> check without
>> requiring the structure to be declared, e.g. with __builtin_types_compatible_p ?
> 
> Could you pass the pointer to something like:
> static __always_inline void foo(void *arg) {};
> 
> That would fail for integers.
> Not sure whether CFI bleats about function pointers though.
> 

That would indeed validate that a pointer is being passed to rcu_dereference()
and RCU_INITIALIZER().

However it would not solve this other issue: in Steven's patch, rcu_dereference_raw
is changed like so:

 #define rcu_dereference_raw(p) \
 ({ \
         /* Dependency order vs. p above. */ \
         typeof(p) ________p1 = READ_ONCE(p); \
-        ((typeof(*p) __force __kernel *)(________p1)); \
+        ((typeof(p) __force __kernel)(________p1)); \
 })

and AFAIU the __force __kernel attributes end up applying to the pointer rather than the
object pointed to, which changes the semantic.

So checking the pointer argument is not the only issue here.

As Linus pointed out, it might indeed be simpler to just keep declaring the structure in
public headers.

Thanks,

Mathieu

>	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT,
> UK
> Registration No: 1397386 (Wales)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
