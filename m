Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CD7423106
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhJETvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:51:52 -0400
Received: from mail.efficios.com ([167.114.26.124]:38746 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbhJETvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:51:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7E7C238FB64;
        Tue,  5 Oct 2021 15:49:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZEXrR5Ci9ztl; Tue,  5 Oct 2021 15:49:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C548438FD25;
        Tue,  5 Oct 2021 15:49:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com C548438FD25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1633463398;
        bh=dozxmLSuH4fqPxd682HodmlOfauCaaugJuGX+lZefU8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=VQLxpJX9s6Ims/iCloj2co6DZ+kAdayJlyjk0y39LTLedU12jjm3nRuS3ML03MCxy
         UY9oFtvBhPj8xL+HiCsR7Pwg4pWZisnoHzhUgxTh0R/QYj+/4YNutoi+kOcS/YdKMS
         wBGAZWIGIye7ICOyCS3Rc/lVbHQ4WNpQ0AVIsXN1r920EaxyuHuGeqkSyR8y2Fmdo0
         KJps0Xp0reKwLf3Wbgi2mxfR+PbgOIFy126o8QYAEFtBWQAFf8m4kFSiV76TqdgDf/
         8cjY4PLqtdqMqCyyloggvXTrp/dgg1EovojbCFhaBWRD8zpQnda+JqtKRVkyap5eqF
         /OSD+5ooicwig==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1mYUU1jAuvet; Tue,  5 Oct 2021 15:49:58 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id AB0C738FBD8;
        Tue,  5 Oct 2021 15:49:58 -0400 (EDT)
Date:   Tue, 5 Oct 2021 15:49:58 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
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
Message-ID: <1403497170.3059.1633463398562.JavaMail.zimbra@efficios.com>
In-Reply-To: <20211005154029.46f9c596@gandalf.local.home>
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk> <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com> <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home> <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4156 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4156)
Thread-Topic: Use typeof(p) instead of typeof(*p) *
Thread-Index: 1k/Ly56F/MzpErICaHpi/t7hzD4jKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 5, 2021, at 3:40 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 5 Oct 2021 21:06:36 +0200 (CEST)
> Jan Engelhardt <jengelh@inai.de> wrote:
>=20
>> On Tuesday 2021-10-05 20:40, Steven Rostedt wrote:
>> >>  =20
>> >> >>>> typeof(*p) *________p1 =3D (typeof(*p) *__force)READ_ONCE(p);
>> >>=20
>> >> #define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
>> >> typeof(p) p1 =3D (typeof(p) __force)static_cast(void *, READ_ONCE(p))=
;
>> >>=20
>> >> Let the name not fool you; it's absolutely _not_ the same as C++'s
>> >> static_cast, but still: it does emit a warning when you do pass an
>> >> integer, which is better than no warning at all in that case.
>> >>=20
>> >>  *flies away*
>> >
>> >Are you suggesting I should continue this exercise ;-)
>>=20
>> =E2=80=9CAfter all, why not?=E2=80=9D
>>=20
>> typeof(p) p1 =3D (typeof(p) __force)READ_ONCE(p) +
>>                BUILD_BUG_ON_EXPR(__builtin_classify_type(p) !=3D 5);
>=20
> I may try it, because exposing the structure I want to hide, is pulling o=
ut
> a lot of other crap with it :-p

I like the static_cast() approach above. It is neat way to validate that th=
e
argument is a pointer without need to dereference the pointer.

I would also be open to consider this trick for liburcu's userspace API.

About the other proposed solution based on __builtin_classify_type, I am
reluctant to use something designed specifically for varargs in a context
where they are not used.

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
