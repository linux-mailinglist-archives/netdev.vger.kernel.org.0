Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD482174
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHEQPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:15:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44174 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfHEQPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:15:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so36638117plr.11;
        Mon, 05 Aug 2019 09:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v6WgJ0lzBNgL6kZdwswGg76XfBJnMJw2yV33npEYWYM=;
        b=fyF7OG5i5sjU1Ygl24fsM+DhUis/2WZTrKuSfuDiXKHhDI2jBBZc+AY/ob+D/RIAob
         DpC1ukRAtAMDJH01apAF350iFFXSJpsKgyr3neyHqGFu6/+Co4jHwq5mCjEQoEnnPR/m
         5xdtJ/ITlQSUCOEuuJ1XLSJMjjcisP0qThFSrWImHsaxZ5xzNj087UAMmJ2EX4IKS9vk
         GG5MdoxfB5qYNZNl6ykXdqtHE3H+9dJjtlf/3NQQZLprvrwinORBJI5wbeS6reqVKnNG
         NMVH+C6nDdFgDzWaMcU5nLV5ovkvtnRotbENYGnWjcXCY1gsVd5kFbV/J/zDesaQqoiQ
         OPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v6WgJ0lzBNgL6kZdwswGg76XfBJnMJw2yV33npEYWYM=;
        b=G7LdMy3pOPy0neeMjy27Dbh1VzYRdgewL/dxSxXslmEuLi3h+aSFaMQURDgxZSWbT2
         p6k43i4SpHgh3KnjUFuuhx85QZmWAcFpqFVMsS+gaKLnYYR11xFI6l4ez23DsWvfGsxj
         xSuwf5eekFn4LhfgArvf2Lc57eOFwPwwb9/CVzDdZ8dIUd8feCutQkuLr4VyCkXt1EpE
         d/MmqtdHLe8lslr94Ogjk/ccITVk8a4TAJilyOrNVWcyz+Nrn1T3qBsI5xgd4k9YYRV6
         /ZckrttnA8P8ym2yD/e+K6mPOky9bollfHf1NZ0ZdA/7yIkPre7vtJk2uCX7HPaOwxdy
         450A==
X-Gm-Message-State: APjAAAVvMt6Xoc72pQzrqJli1z6kIffoeOt9l3L27x9O0QpFuY3Svw+K
        XOcQmJ4wPlXkRn2a+I8MPAtKjJOc
X-Google-Smtp-Source: APXvYqxOuUY6MUvEkSLZcanihOqFOOB9ZQIT90oPEtCsL8yXAdUfRYmLuL2/tgtBXz3Vid+EkooREQ==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr144436930plo.124.1565021735244;
        Mon, 05 Aug 2019 09:15:35 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:8a30])
        by smtp.gmail.com with ESMTPSA id x25sm114962131pfa.90.2019.08.05.09.15.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 09:15:34 -0700 (PDT)
Date:   Mon, 5 Aug 2019 09:15:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Message-ID: <20190805161531.lr5pby7mlwxhh3uq@ast-mbp>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-2-ast@kernel.org>
 <63f123d2-b35f-a775-e414-004c90b4f4b7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f123d2-b35f-a775-e414-004c90b4f4b7@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 05:29:42AM +0000, Yonghong Song wrote:
> 
> 
> On 8/2/19 4:33 PM, Alexei Starovoitov wrote:
> > Add a test that returns a 'random' number between [0, 2^20)
> > If state pruning is not working correctly for loop body the number of
> > processed insns will be 2^20 * num_of_insns_in_loop_body and the program
> > will be rejected.
> 
> The maximum processed insns will be 2^20 or 2^20 * 
> num_of_insns_in_loop_body? 

the later.

> I thought the verifier will
> stop processing once processed insns reach 1M?

right.

> Could you elaborate which potential issues in verifier
> you try to cover with this test case? Extra tests are
> always welcome. We already have scale/loop tests and some
> (e.g., strobemeta tests) are more complex than this one.
> Maybe you have something in mind for this particular
> test? Putting in the commit message may help people understand
> the concerns.

it's not testing any new functionality.
It's more targeted test that pruning happens in loop body due to precision tracking.
When precision tracking is off the pruning won't be happening and 1m will be hit.
Since it's a small test comparing to others it's easier to analyze.

2^20 is to make sure 1m will be hit even if loop body is 1 insn.
For the given llmv the loop body is 16 insn, but it may vary.

> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >   .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
> >   tools/testing/selftests/bpf/progs/loop4.c     | 23 +++++++++++++++++++
> >   2 files changed, 24 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/loop4.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > index b4be96162ff4..757e39540eda 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > @@ -71,6 +71,7 @@ void test_bpf_verif_scale(void)
> >   
> >   		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >   		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> > +		{ "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> 
> The program is more like a BPF_PROG_TYPE_SCHED_CLS type than
> a BPF_PROG_TYPE_RAW_TRACEPOINT?

right. that's more accurate.

> >   
> >   		/* partial unroll. 19k insn in a loop.
> >   		 * Total program size 20.8k insn.
> > diff --git a/tools/testing/selftests/bpf/progs/loop4.c b/tools/testing/selftests/bpf/progs/loop4.c
> > new file mode 100644
> > index 000000000000..3e7ee14fddbd
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/loop4.c
> > @@ -0,0 +1,23 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
> > +#include <linux/sched.h>
> > +#include <linux/ptrace.h>
> 
> Since the program is a networking type,
> the above two headers are probably unneeded.

yeah. just a copy paste. will remove

> > +#include <stdint.h>
> > +#include <stddef.h>
> > +#include <stdbool.h>
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +SEC("socket")
> > +int combinations(volatile struct __sk_buff* skb)
> > +{
> > +	int ret = 0, i;
> > +
> > +#pragma nounroll
> > +	for (i = 0; i < 20; i++)
> > +		if (skb->len)
> > +			ret |= 1 << i;
> > +	return ret;
> > +}
> > 
