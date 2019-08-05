Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B99782179
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfHEQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:16:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34465 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfHEQQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:16:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so36688078plt.1;
        Mon, 05 Aug 2019 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SqxSoJKpGWV14gIS52JocyeN9cK02AV2ZaIsHvNwU4k=;
        b=A6CtVSZFXsjek7YhQkIhi2zY1y08hCeaSYy6D40JpwJOHjNwPCHojwloXZQJPJ/xxE
         1n93tmzQxL7ylt2LkBB5jm3TblRMn00YaG3PwcSt3TxPeOSDU5eAy8gE5pXvVK/Pv9nd
         hYwYbZRTP4ZwfxBTQovX3yD207GuhZW3QYIDCZe3+qWu2653wAFIwPpw2lu0a1DiiSbA
         XyjfY3U0xgJ5YqBemVCoEor8rzfdGcEF/MlhrBvSf+m3i8FojcTbidrtm5MekJ8gaB9R
         gNNa5/B2KJeHZsn+BbmVzsuCLRmXDEHk6CQsaw6KEidtw3jVUbFIrCqjdkt2DO/xE3rX
         Ey2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SqxSoJKpGWV14gIS52JocyeN9cK02AV2ZaIsHvNwU4k=;
        b=RFv1I+LJ8xZjsw7Dfr7Gf0XtNU8i8AqVPdMK4eZx03KkS4FVbLaFzHY0xMK3/nRj4x
         u/Lh9et3ralttMPY+YD2zHI0Ju8fDju+7e+LFmOi08zyY+luA4o3deHVyBv2X2ncNn2i
         acm2gntk3WjtNSchmMowxGh25s0p5MUh1Vggc4O+cfiGfdpuLs5F+v0CvWTtLFRMlxPO
         BVtZaWW55aJHxleatxxdiqY5oaqLfZK4VizZZrUGtYEC9KmQAeQeOSbvH8QQE9oMf5vV
         Etg2vovH8JnRWGEEGAawOvfZYG/iBN4yKPpuIvziyTxUHigbcpgdK9Wre00hH9L3aLyB
         ZJ8w==
X-Gm-Message-State: APjAAAWojsFA3KhJt9Gfy4Xm25XzA09WbIquXnXWjnLpXgChg5dDUz8q
        4PuGrtVXl4IuShh+2SpaZu72J5sT
X-Google-Smtp-Source: APXvYqx4YGzrYlS6KlirTyBW8YVqiN7pvEKMnekXeG/Ao2ta3RPKEwfoo1atqFICCpYLlMsaWt64kg==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr144965925plm.199.1565021789174;
        Mon, 05 Aug 2019 09:16:29 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:8a30])
        by smtp.gmail.com with ESMTPSA id o95sm15825117pjb.4.2019.08.05.09.16.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 09:16:28 -0700 (PDT)
Date:   Mon, 5 Aug 2019 09:16:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add loop test 5
Message-ID: <20190805161626.dil4xkmrdlqhqhzd@ast-mbp>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-3-ast@kernel.org>
 <3f8c913c-3644-6821-70a0-cf129d2a080d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8c913c-3644-6821-70a0-cf129d2a080d@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 05:45:23AM +0000, Yonghong Song wrote:
> 
> 
> On 8/2/19 4:33 PM, Alexei Starovoitov wrote:
> > Add a test with multiple exit conditions.
> > It's not an infinite loop only when the verifier can properly track
> > all math on variable 'i' through all possible ways of executing this loop.
> 
> Agreed with motivation of this test.
> 
> > 
> > barrier()s are needed to disable llvm optimization that combines multiple
> > branches into fewer branches.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >   .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
> >   tools/testing/selftests/bpf/progs/loop5.c     | 37 +++++++++++++++++++
> >   2 files changed, 38 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/loop5.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > index 757e39540eda..29615a4a9362 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> > @@ -72,6 +72,7 @@ void test_bpf_verif_scale(void)
> >   		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >   		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> >   		{ "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT }, > +		{ "loop5.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> 
> More like a BPF_PROG_TYPE_SCHED_CLS type although probably it does not 
> matter as we did not attach it to anywhere?

right. will fix.

> >   
> >   		/* partial unroll. 19k insn in a loop.
> >   		 * Total program size 20.8k insn.
> > diff --git a/tools/testing/selftests/bpf/progs/loop5.c b/tools/testing/selftests/bpf/progs/loop5.c
> > new file mode 100644
> > index 000000000000..9d9817efe208
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/loop5.c
> > @@ -0,0 +1,37 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
> > +#include <linux/sched.h>
> > +#include <linux/ptrace.h>
> 
> The above headers probably not needed.

will fix

