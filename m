Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34C20FDBA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgF3Uez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:34:55 -0400
Received: from mail.efficios.com ([167.114.26.124]:55450 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3Uez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:34:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 87A1B2C6D8C;
        Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dVsaSFwjYYPh; Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 45A442C6C2E;
        Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 45A442C6C2E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593549293;
        bh=Vph8FFamlLOEgiAqhpk9331XsQWYPCQ7ZL7ndNaBhMQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MhRbq1IiUN8q3A8o2S0VWED1BT4voByE776z9VOt72rfAj9j1TNREBLWZzN0w1jJD
         IUxwxzTPthk/yvgB+JL0iF9UOF8vhW+Okm8D5pvJE+PVsLaoWPjEJuVdgW2GCdKVk8
         wVQcvf/7V/yrDnIrMjdbJaCy5MNdEBmkN+IZTuc6qXn88My9/R6GsEmBxNYpKzuR6G
         6Gk1qypUp+B7N/AVGTnv8XQzWZs3XECuK0+a1VaEMiBWucnIbAUqKgCmG3CR2ue835
         qn2ZFB46ZIL9U+s809LsE6/UrcwkahE9XJ1Ub/4yxbGkWDaflEBxR9yhbK74LW2SgQ
         3aID6p5GOyKXA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2XoXp7J1s9mu; Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3127C2C69FB;
        Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
Date:   Tue, 30 Jun 2020 16:34:53 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
In-Reply-To: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com> <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com> <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com> <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com> <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com> <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com> <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: Wcu0dgtOM27y62oxUUFZ1+Lbhd18uw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 3:52 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Tue, Jun 30, 2020 at 12:43 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
[...]
> So I think it's still wrong (clearly others do change passwords
> outside of listening state), but considering that it apparently took
> people two years to notice, at least some of the onus on figuring out
> a better morel is on people who didn't even bother to test things in a
> timely manner.

I'm fully willing to work with Eric on finding a way forward with a
fix which addresses the original issue Eric's patch was trying to
fix while preserving ABI compatibility.

The main thing we need to agree on at this stage is what is our goal. We
can either choose to restore the original ABI behavior entirely, or only
focus on what appears to be the most important use-cases.

AFAIU, restoring full ABI compatibility would require to re-enable all
the following scenarios:

A) Transition of live socket from no key -> MD5 key.
B) Transition of live socket from MD5 key -> no key.
C) Transition of live socket from MD5 key to a different MD5 key.

Scenario (C) appears to be the most important use-case, and probably the
easiest to restore to its original behavior.

AFAIU restoring scenarios A and B would require us to validate how
much header space is needed by each SACK, TS and MD5 option enabled
on the socket, and reject enabling any option that adds header space
requirement exceeding the available space.

I welcome advice on what should be the end goal here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
