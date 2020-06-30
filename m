Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC60E20FDE0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgF3Ujx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:39:53 -0400
Received: from mail.efficios.com ([167.114.26.124]:58026 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgF3Ujw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:39:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E3A5E2C6DA1;
        Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id u6VBh4kG6hgX; Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A3F032C6F0A;
        Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A3F032C6F0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593549591;
        bh=sjBFJc3lgLnEtXkMLVG8upOVvYseCMfl9eQoq9cRJWk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=aVzH4BTuRyljgJfijNTSCPjBcg1+mZu6DzcLsK2m9gh+fz8RFYKk6Xh+3RBKTrAHw
         y2h08B6OZmqZRAva7dh2vjzPt62ylUKIqx+29cL4RYoQH3yfcDC+qxw9eHLHeG1oDp
         SqgH+/+W9BDYBgir9qvHma8l2pWuT+PQdaqu23q7ySZJ0jWtOaGTuhRiDfzsv1PWvU
         Pq0L2e/7TvACjv2tpgWUPR0o+Fq+0qtw9W0/5c8604tEyNzUfnVFHkmsNPDfP8ZQ3r
         rVi/RgiukynkG5S8HBzahHD/c8VlHiIvMY0w0swyDHTWRRn3gsLOWnPx0Ah4Zj9pUB
         kBr3kVcBxRI2A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 72GketiYT7h8; Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 97CFA2C6E96;
        Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
Date:   Tue, 30 Jun 2020 16:39:51 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <1682267267.17918.1593549591608.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iKUUJsEfwp2L0pwKdCP3Rx-o=6uM+1bUhT5Cc2p0p7XqA@mail.gmail.com>
References: <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com> <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com> <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com> <20200630.132112.1161418939084868350.davem@davemloft.net> <CANn89iKUUJsEfwp2L0pwKdCP3Rx-o=6uM+1bUhT5Cc2p0p7XqA@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: tcdE3j+VTMeB5CSmGAl1c0l3cJ95bg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 4:30 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 1:21 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Tue, 30 Jun 2020 12:43:21 -0700
>>
>> > If you're not willing to do the work to fix it, I will revert that
>> > commit.
>>
>> Please let me handle this situation instead of making threats, this
>> just got reported.
>>
>> Thank you.
>>
> 
> Also keep in mind the commit fixed a security issue, since we were
> sending on the wire
> garbage bytes from the kernel.
> 
> We can not simply revert it and hope for the best.
> 
> I find quite alarming vendors still use TCP MD5 "for security
> reasons", but none of them have contributed to it in linux kernel
> since 2018
> (Time of the 'buggy patch')

I'm helping a customer increase their contributions and feedback to upstream.
As we can see, they have accumulated some backlog over time.

Clearly reverting a security fix is not acceptable here. Coming up with a
proper ABI-compatible fix should not be out of our reach though.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
