Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68BF194380
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgCZPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:49:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42077 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbgCZPtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:49:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id 22so2964033pfa.9;
        Thu, 26 Mar 2020 08:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XdogHB70yOUiucUiIePupFL0wILSpDUbQe5TvHyToYs=;
        b=sN/Sq28CUY8JO+CJnO1f2L+XUqGi1gD1KWCd0MJKhMIZ8TTJlHd9nUMP9g4+EN+TF0
         lAsEJ5QcOXtFBnp/hN1+6wsOn+5uk+tMJmnq+VQ3rYv2i+MpUrqPl5LkJ9/ZXPG8hs0Q
         rAdXppVOEWR8sTcGsjN82W0S32xSl4Z/uI2pcriNgMTTjsGZ5DLNDRmqRnlSgUYr0VrN
         zTfp9Mb3GXAVqlVhULJ94id6rgtYorR8iujkPiizch/uZL8zQIvykqJC9O8H92o0b4EL
         szCqZAnENEWJanbfOh8ku1QXkBjIq9vLCZLjlepbwYLkG4rKuvmQJY2hWRS7RyAk6+rX
         fwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XdogHB70yOUiucUiIePupFL0wILSpDUbQe5TvHyToYs=;
        b=owmK30GnwFir78R3pxFK0UXI4MW0y85oa+Zpb/qNIrErBEVFJ17bY+aFyVmkoX0sJI
         JH9qzPhbhOPTohqWbMiYNWvh9mDYLLMz52J+g5AzgfntWd+tuVP335vmPpwxC8dVARH0
         NbUvqzfEVXqghIhbIOzI4JICZ2ZLpLhlfX+0cmyDKFklnRw0b7+AyXoMHe94tmEkOhLv
         yR3Raqq7CHfjAEbo0jeiU5kYfw+YWMUkLa0ObsJ5e4ie0GlVqtOzdJH3U74KHtyX4LtU
         r7d7Iu7IUNA4dbsgEXRgJGaimozuav3vDGLybLNTuaMLjXgsWpqjbiWbrimykSJBKf8s
         vIeQ==
X-Gm-Message-State: ANhLgQ3bNjFCtB0gaOyR9cXsCOnG8DsEwi3PzRfsaH7+L5sUcUE10dWV
        ZNmCZ7cTkPT0EnvWNX7NKo+rtTO1ZVc=
X-Google-Smtp-Source: ADFU+vuJ8UQv8VkxV2PGOhCtnzNP4rjE1R+nDI2c8Tx6RoGaZT7sSWePvHpiYxWncwcoBH5WVAuikA==
X-Received: by 2002:aa7:9838:: with SMTP id q24mr9814759pfl.135.1585237742516;
        Thu, 26 Mar 2020 08:49:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i23sm1950578pfq.157.2020.03.26.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:49:01 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:48:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e7ccee5b56f6_65132acbbe7fc5c425@john-XPS-13-9370.notmuch>
In-Reply-To: <20200326063336.do6mibb7b5xwofz2@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507159511.15666.6943798089263377114.stgit@john-Precision-5820-Tower>
 <20200326063336.do6mibb7b5xwofz2@ast-mbp>
Subject: Re: [bpf-next PATCH 07/10] bpf: test_verifier, bpf_get_stack return
 value add <0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Mar 24, 2020 at 10:39:55AM -0700, John Fastabend wrote:
> > diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> > index f24d50f..24aa6a0 100644
> > --- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> > +++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> > @@ -7,7 +7,7 @@
> >  	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> >  	BPF_LD_MAP_FD(BPF_REG_1, 0),
> >  	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> > -	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
> > +	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 29),
> >  	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
> >  	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
> >  	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> > @@ -16,6 +16,7 @@
> >  	BPF_MOV64_IMM(BPF_REG_4, 256),
> >  	BPF_EMIT_CALL(BPF_FUNC_get_stack),
> >  	BPF_MOV64_IMM(BPF_REG_1, 0),
> > +	BPF_JMP32_REG(BPF_JSLT, BPF_REG_0, BPF_REG_1, 20),
> >  	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
> >  	BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
> >  	BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
> 
> Yep. The test is wrong.
> But this is cheating ;)
> JSLT should be after shifts.
> 
> The test should have been written as:
> diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> index f24d50f09dbe..be0758c1bfbd 100644
> --- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> +++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> @@ -19,7 +19,7 @@
>         BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
>         BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
>         BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
> -       BPF_JMP_REG(BPF_JSLT, BPF_REG_1, BPF_REG_8, 16),
> +       BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
>         BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
>         BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
>         BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),
> 
> That was the intent of the test.
> But in such form it won't work with the current patch set,
> but it should.
> 
> More so the patches 1 and 5 make test_progs pass,
> but test_progs-no_alu32 fails tests 20 and 61.
> Because clang generates the following:
> 14: (85) call bpf_get_stack#67
> 15: (b7) r1 = 0
> 16: (bf) r8 = r0
> 17: (67) r8 <<= 32
> 18: (c7) r8 s>>= 32
> 19: (6d) if r1 s> r8 goto pc+16
> 
> (which is exactly what bpf_get_stack.c test tried to capture)

Ah OK well its good we have the pattern captured in verifier tests
so we don't have to rely yon clang generating it.

> 
> I guess no_alu32 may be passing for you because you have that special
> clang optimization that replaces <<32 s>>32 with more efficient insn,
> but not everyone will be using new clang, so we have to teach verifier
> recognize <<32 s>>32.

Ah dang yes I added that patch to our toolchain because it helps so
much. But I need to remember to pull from upstream branch for selftests.
I would prefer we apply that patch upstream but maybe we need to encode
the old behavior in some more verifier test cases so we avoid breaking
it like I did here.

> Thankfully with your new infra for s32 it should be easy to do.
> In scalar_min_max_lsh() we don't need to do dst_reg->smax_value = S64_MAX;
> When we have _positive_ s32_max_value
> we can set smax_value = s32_max_value << 32
> and I think that will be correct.
> scalar_min_max_arsh() shouldn't need any changes.
> And the verifier will restore valid smax_value after <<32 s>>32 sequence.
> And this test will pass (after fixing s/JSLT/JSGT/) and test_progs-no_alu32
> will do too. wdyt?

Looks correct to me for the specific case of <<32 seeing its common
enough special case for it makes sense. I'll add a patch for this
with above explanation.
