Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17682B8164
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgKRQB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:01:28 -0500
Received: from mail.efficios.com ([167.114.26.124]:44436 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKRQB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:01:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A801B2ECB82;
        Wed, 18 Nov 2020 11:01:25 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZwJ7XCNKGbub; Wed, 18 Nov 2020 11:01:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4FBAC2ECB05;
        Wed, 18 Nov 2020 11:01:25 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4FBAC2ECB05
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605715285;
        bh=k0a1RGHOSG7fsNrb43ytVhAyD3oE/dKDtNyXyy8B/xU=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Qbs2RxYPZHVq3437Ui3yAsk8VLrqTSOLM6tl8uIbE1D+3t4YO2Lzq3YRH8NDzfHvP
         Y7wmgNkD2kbQTYE7CrMESIGdDzNS2OYcviVTNFj9lO8FzleB+aAwXymiLaY248KdBP
         4l/jvyiHO91lZYWLaKOcS+k4MjSMBv4ddr2cLNCASbYr/oPZWG++KoEJByvG/RNNBr
         qgVNXbzRuXBxGwGamciMRHLOkRpbxBDO27twHHbEdQxM2CvTifblwcTzCnNfekT4Ov
         q2eYPl+HXVOqbn2m/5gfqWm3d0kOsctj6Jc02dcCFzmQgQawcEQFtNS5FLetkN0h9Z
         0EM+PrO/Uq9yw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jkAbwSowY55M; Wed, 18 Nov 2020 11:01:25 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 398402EC75B;
        Wed, 18 Nov 2020 11:01:25 -0500 (EST)
Date:   Wed, 18 Nov 2020 11:01:25 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Message-ID: <1762005214.49230.1605715285133.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201118090256.55656208@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <20201118090256.55656208@gandalf.local.home>
Subject: Re: violating function pointer signature
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: violating function pointer signature
Thread-Index: Obd4w6s/wcVB2Hvi8sMQ1l1Yr980kA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 18, 2020, at 9:02 AM, rostedt rostedt@goodmis.org wrote:

> On Wed, 18 Nov 2020 14:21:36 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> I think that as long as the function is completely empty (it never
>> touches any of the arguments) this should work in practise.
>> 
>> That is:
>> 
>>   void tp_nop_func(void) { }
> 
> My original version (the OP of this thread) had this:
> 
> +static void tp_stub_func(void)
> +{
> +	return;
> +}
> 
>> 
>> can be used as an argument to any function pointer that has a void
>> return. In fact, I already do that, grep for __static_call_nop().
>> 
>> I'm not sure what the LLVM-CFI crud makes of it, but that's their
>> problem.
> 
> If it is already done elsewhere in the kernel, then I will call this
> precedence, and keep the original version.

It works for me. Bonus points if you can document in a comment that this
trick depends on the cdecl calling convention.

Thanks,

Mathieu

> 
> This way Alexei can't complain about adding a check in the fast path of
> more than one callback attached.
> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
