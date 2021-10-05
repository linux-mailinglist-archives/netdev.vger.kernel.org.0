Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299DC422DA0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbhJEQQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:16:57 -0400
Received: from mail.efficios.com ([167.114.26.124]:48222 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbhJEQQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:16:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1606838E466;
        Tue,  5 Oct 2021 12:15:05 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id m0Qvt7WXiQiC; Tue,  5 Oct 2021 12:15:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 748AD38E780;
        Tue,  5 Oct 2021 12:15:04 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 748AD38E780
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1633450504;
        bh=wdXI//wKXjJYzeAAdexY7E9PnkR6DLjHJxcq7rpw10M=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=M4xcmPCu9QQijyxoeSD7mQnm/miHc6NnbsFQ4tWPe0I66PpgBDxrH9mbSnGBOpJMi
         +bj1V51Nqw29OTYPj5Ry0lmmj4S6bT69I6PQsawkruFuEnW3OKhFTf/xXx/APCaoHA
         jVhORbMm9RPSv2bAjZT0i3xBhXqlJ7S6s2ssnCkX1+zTUQXPRgfJEPX95W8kagv1Rq
         o+G3kyphfZis+HmS6DOU4P3bC979jwKMF+mk3yZd+eqbqUAFDTaBWfBRuy1EazPVcq
         de6GgD0LKY0hKYEK8qOL/rYH5wW6MJ0tiDqZdUjeBwfg8MRIqymzjKl2N3bmAVPAGu
         PYXYKFD659Aog==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZC9KUwjnWQxC; Tue,  5 Oct 2021 12:15:04 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 5DACE38E2F5;
        Tue,  5 Oct 2021 12:15:04 -0400 (EDT)
Date:   Tue, 5 Oct 2021 12:15:04 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
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
Message-ID: <155148572.2789.1633450504238.JavaMail.zimbra@efficios.com>
In-Reply-To: <20211005115817.2e1b57bd@gandalf.local.home>
References: <20211005094728.203ecef2@gandalf.local.home> <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com> <20211005115817.2e1b57bd@gandalf.local.home>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4156 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4156)
Thread-Topic: Use typeof(p) instead of typeof(*p) *
Thread-Index: DIGMOxZGUFfMiJjhKijLQjQDGvVFOA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 5, 2021, at 11:58 AM, rostedt rostedt@goodmis.org wrote:

> On Tue, 5 Oct 2021 11:15:12 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
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
> Is that really an issue? Because you would be assigning it to an integer.
> 
> 
>	x = rcu_dereference_raw(y);
> 
> And that just makes 'x' a copy of 'y' and not really a reference to it, thus
> if you don't have a pointer, it's just a fancy READ_ONCE(y).

See Documentation/RCU/arrayRCU.rst:

"It might be tempting to consider use
of RCU to instead protect the index into an array, however, this use
case is **not** supported.  The problem with RCU-protected indexes into
arrays is that compilers can play way too many optimization games with
integers, which means that the rules governing handling of these indexes
are far more trouble than they are worth.  If RCU-protected indexes into
arrays prove to be particularly valuable (which they have not thus far),
explicit cooperation from the compiler will be required to permit them
to be safely used."

So AFAIU validation that rcu_dereference receives a pointer as parameter
is done on purpose.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
