Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E8F422FA0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhJESI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:08:26 -0400
Received: from mail.efficios.com ([167.114.26.124]:58954 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhJESIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:08:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B0E2438EEEF;
        Tue,  5 Oct 2021 14:06:33 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iZsE1lZA6tlX; Tue,  5 Oct 2021 14:06:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2ABCC38EEEE;
        Tue,  5 Oct 2021 14:06:33 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2ABCC38EEEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1633457193;
        bh=tfKh6mHkN2x9qWMzx/jgb3e4/+PZ5d3ilSaKBX4BnfE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=J1O8CHuaXrbI7ETe8Lggn0Ls3THmmH6Z255M+LFzCsvbwZvBjLaWEfdtRLINCrWKF
         h+hFmLwjsWKIFlLaxcszT1refvDhhwvXpKU0PgW+dj2kjV4E98m+bevWK2dxNpkV5M
         Qe/iIuKd4hwBKoQRGEVNQVmBIRi2/KxaS0E3saN0ArKs82vUSXgdzIGctghBcm5mlI
         bdQx2RQCRwI7UTH7y3Au+l6horu4X28A/qMAUyWPTaJxqElbOhvK9Ujp8p1e9xeR5h
         MvWQjVHa4IekTRKcmedzI4kcmRCof5bK/Jz+8LUOgiYWVnRydMteIRMgQQTnz/+47W
         2i7Fugh/Da13Q==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PKk_2bA41C_h; Tue,  5 Oct 2021 14:06:33 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 0EC1B38F196;
        Tue,  5 Oct 2021 14:06:33 -0400 (EDT)
Date:   Tue, 5 Oct 2021 14:06:32 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
Message-ID: <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
In-Reply-To: <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4156 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4156)
Thread-Topic: Use typeof(p) instead of typeof(*p) *
Thread-Index: RjCoJoA6Ynqqjw2vHnEn40XORyRWhA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 5, 2021, at 2:01 PM, Rasmus Villemoes linux@rasmusvillemoes.dk wrote:

> On 05/10/2021 15.47, Steven Rostedt wrote:
> 
>> That is, instead of declaring: typeof(*p) *_p; just do:
>>  typeof(p) _p;
>> 
>> Also had to update a lot of the function pointer initialization in the
>> networking code, as a function address must be passed as an argument in
>> RCU_INIT_POINTER()
> 
> I would think that one could avoid that churn by saying
> 
>  typeof((p) + 0)
> 
> instead of just "typeof(p)", to force the decay to a pointer.

If the type of @p is an integer, (p) + 0 is still valid, so it will not
prevent users from passing an integer type as argument, which is what
the current implementation prevents.

Also, AFAIU, the compiler wants to know the sizeof(p) in order to evaluate
(p + 0). Steven's goal is to hide the structure declaration, so that would
not work either.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
