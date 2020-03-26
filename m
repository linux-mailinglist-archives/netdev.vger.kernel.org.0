Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AFC1938A5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgCZGdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:33:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35818 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgCZGdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:33:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id g6so1777425plt.2;
        Wed, 25 Mar 2020 23:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mxlTXhOHwU2AiLnpR1pUDj+VY8aNMwn+PFRSWV6el4I=;
        b=oo8V/MBwam+WqT5vj1sKYIuyTECneiX/6EjuZS2QyIS+2IIQ/8qzSdP48b0euVr0Bs
         zIuQRQuyJ8ycWMqvdmHx37+4+6JBVI9Etpqjhzn8Qw55a/duAAslR110twE5X2BzUtVj
         9PmfalZarbqC1f+se4t+pCMt8qtYtVspS38uYoW+p5D1LbKEGiPR6zsiMPTMGOQw22Cc
         fImhtctI7ZA8k0tHyu+qlltSb3jJcr03kSHz9rtPrl9eB9UVY0iapas1wRmxpS6yvQ7t
         5gUsORs3+D0x6/uFjqH/ubmUEFLxfJbIl+PLEoiPSw0IXw1uP10+D8mQW4bSIrt39FZg
         XaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mxlTXhOHwU2AiLnpR1pUDj+VY8aNMwn+PFRSWV6el4I=;
        b=lmfi8L728fA1q/sJQshlWofxJzdADOwYaT1aLJXrH72Rr75pqOLSXeZf6a+/VcfSpd
         9/oIOdanHJVrDVI4kQV57OGlDK9KiIplfvQjhyDDNcXdKfVxn6nmQZ+fR7wsXqjqdetg
         EFwWeoaoQFxHJ9K5/0MnN8tHs6+HLqYJtjjxMaRolX9lvTxxS8QyN29UVcE14MLkltdq
         iGkJpXkPCaFuW5iHrlFSDMuRMg+2RH+wseG2hUXd4fRXVL80XJLDZQHmEUbTM8wNWF0l
         TqsOj9klUI9nxS9u4WQXz6DfxSClXOMq6aVrSJGy87UYFYUXjxbRTksJBhg4rd7xGChL
         ELyQ==
X-Gm-Message-State: ANhLgQ1P6C+Y2OxqG2rALcZpFHpVwNONDHWMUx9P2l4WZzi+Y3/otDiE
        TnOaG5OysN+fb9da1Eqtfsw=
X-Google-Smtp-Source: ADFU+vv3tcYji5d8o4sGrYT7YdQaf6IyZZ17LVDZvSZ70+sDd+ALrPH43x21tR3nkvAU8qrN0p0XOQ==
X-Received: by 2002:a17:90a:2dc2:: with SMTP id q2mr1445561pjm.146.1585204419530;
        Wed, 25 Mar 2020 23:33:39 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5929])
        by smtp.gmail.com with ESMTPSA id c128sm834311pfa.11.2020.03.25.23.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:33:38 -0700 (PDT)
Date:   Wed, 25 Mar 2020 23:33:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 07/10] bpf: test_verifier, bpf_get_stack return
 value add <0
Message-ID: <20200326063336.do6mibb7b5xwofz2@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507159511.15666.6943798089263377114.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158507159511.15666.6943798089263377114.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:39:55AM -0700, John Fastabend wrote:
> diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> index f24d50f..24aa6a0 100644
> --- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> +++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
> @@ -7,7 +7,7 @@
>  	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
>  	BPF_LD_MAP_FD(BPF_REG_1, 0),
>  	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> -	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
> +	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 29),
>  	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
>  	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
>  	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> @@ -16,6 +16,7 @@
>  	BPF_MOV64_IMM(BPF_REG_4, 256),
>  	BPF_EMIT_CALL(BPF_FUNC_get_stack),
>  	BPF_MOV64_IMM(BPF_REG_1, 0),
> +	BPF_JMP32_REG(BPF_JSLT, BPF_REG_0, BPF_REG_1, 20),
>  	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
>  	BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
>  	BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),

Yep. The test is wrong.
But this is cheating ;)
JSLT should be after shifts.

The test should have been written as:
diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
index f24d50f09dbe..be0758c1bfbd 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
@@ -19,7 +19,7 @@
        BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
        BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
        BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
-       BPF_JMP_REG(BPF_JSLT, BPF_REG_1, BPF_REG_8, 16),
+       BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
        BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
        BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
        BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),

That was the intent of the test.
But in such form it won't work with the current patch set,
but it should.

More so the patches 1 and 5 make test_progs pass,
but test_progs-no_alu32 fails tests 20 and 61.
Because clang generates the following:
14: (85) call bpf_get_stack#67
15: (b7) r1 = 0
16: (bf) r8 = r0
17: (67) r8 <<= 32
18: (c7) r8 s>>= 32
19: (6d) if r1 s> r8 goto pc+16

(which is exactly what bpf_get_stack.c test tried to capture)

I guess no_alu32 may be passing for you because you have that special
clang optimization that replaces <<32 s>>32 with more efficient insn,
but not everyone will be using new clang, so we have to teach verifier
recognize <<32 s>>32.
Thankfully with your new infra for s32 it should be easy to do.
In scalar_min_max_lsh() we don't need to do dst_reg->smax_value = S64_MAX;
When we have _positive_ s32_max_value
we can set smax_value = s32_max_value << 32
and I think that will be correct.
scalar_min_max_arsh() shouldn't need any changes.
And the verifier will restore valid smax_value after <<32 s>>32 sequence.
And this test will pass (after fixing s/JSLT/JSGT/) and test_progs-no_alu32
will do too. wdyt?
