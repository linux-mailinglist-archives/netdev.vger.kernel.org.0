Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C313D69D7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhGZWNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhGZWNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:13:41 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DF8C061757;
        Mon, 26 Jul 2021 15:54:08 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k65so12857801yba.13;
        Mon, 26 Jul 2021 15:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uzKTnoaykkm24mkJYes95tptC94OOB7GgT3faFsYOCM=;
        b=ZR3VoaV/QTk8vOoF67+intQtk93JlT9vS+p14Z+/vZXQle7JeiRF3JdQcyC+13dyFR
         g7QdlnbhfFzCukZKFNrPkIL38wGCCX+YXgU98nPN/YZ9OW/J69xCIHflfSffN3beao6W
         e43sXV0MOyfqv0k1yQJ6t8wSl/HowdhehoIf8rBeAiWA1zB89vTuzK3BqhR3p0mH0it/
         PZc+B/lL1OhsffId4VC3yhlMmnRLF3YQIsbaW2SWDkVV3c5SWp2+U5S5P2phUiFRTwG/
         HCnLL7ydw6MPkGCJCNaOW0jh+ZLvWR7X0LWHiJPYE6jWWRUJTzxmB4lWVawfr/GU9kpO
         1oXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzKTnoaykkm24mkJYes95tptC94OOB7GgT3faFsYOCM=;
        b=hp8e3nkRR8KN5mMmU8B9Qk+OUzKGXE7o9f4md3kOPk4/z8vM8KY2tPQfzZP/p3ROSs
         gGHmqufnGLuOlcHu4CoqwUd3+tysCLHP6RcBHvz2W1iDNSqydAj7VOxHaNM/drFpkTyF
         qSfg55yHBqqQ29LJbHO/ZRP0VmgFRSzsJN3n3gHgoFMivI+9SJnXvyAoZCFjgNAGom1Z
         OPotAsqzywUHwngmdt6Xt8TuwtPFltSZNQCIeQY1oLj4E1SI43H0ektVBD1D4LxYaC6U
         exYHnlIIMy/JWiZgTLUaroiXKF4r85an5dpT1Qh4zFuMe4fIUFuiyk1awSagKf9/wz5S
         KtDA==
X-Gm-Message-State: AOAM530rvtK3Q6nROOi5a639M+RRxA1HNOLn6qla82BlicifcRMUw3k3
        Bv+CRTM6QvMvJ/17FHPjyyxU1lPVxEfxQ+9oc68=
X-Google-Smtp-Source: ABdhPJxxt7ypXDDCBi/GW6AvYavtsoaaWZDYSEneE4vPBQDkkXASJ5lyJ8ohd/dr4Rsklo1F1tHp+GwwH5+Z1Gt6cKM=
X-Received: by 2002:a25:a045:: with SMTP id x63mr16392226ybh.27.1627340048187;
 Mon, 26 Jul 2021 15:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Jul 2021 15:53:57 -0700
Message-ID: <CAEf4BzYdvjz36K7=qYnfL6q=cX=ha27Ro2x6cV1X4hp22VEO=g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] bpf/tests: Extend the eBPF test suite
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 1:18 AM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> Greetings,
>
> During my work with the 32-bit MIPS JIT implementation I also added a
> number of new test cases in the test_bpf kernel module. I found it
> valuable to be able to throughly test the JIT on a low level with
> minimum dependency on user space tooling. If you think it would be useful,
> I have prepared a patch set with my additions. I have verified it on
> x86_64 and i386, with/without JIT and JIT hardening. The interpreter
> passes all tests. The JITs do too, with one exception, see NOTE below.
> The result for the x86_64 JIT is summarized below.
>
>     test_bpf: Summary: 577 PASSED, 0 FAILED, [565/565 JIT'ed]
>     test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]
>
> I have inserted the new tests in the location where related tests are run,
> rather than putting them at the end. I have also tried to use the same
> description style as the surrounding tests. Below is a summary of the
> new tests.
>
> * Operations not previously covered
>   JMP32, ALU32 ARSH, remaining ATOMIC operations including
>   XCHG and CMPXCHG.
>
> * ALU operations with edge cases
>   32-bit JITs implement ALU64 operations with two 32-bit registers per
>   operand. Even "trivial" operations like bit shifts are non-trivial to
>   implement. Test different input values that may trigger different JIT
>   code paths. JITs may also implement BPF_K operations differently
>   depending on if the immediate fits the corresponding field width of the
>   native CPU instruction or not, so test that too.
>
> * Word order in load/store
>   The word order should follow endianness. Test that DW load/store
>   operations result in the expected word order in memory.
>
> * 32-bit eBPF argument zero extension
>   On a 32-bit JIT the eBPF argument is a 32-bit pointer. If passed in
>   a CPU register only one register in the mapped pair contains valid
>   data. Verify that value is properly zero-extended.
>
> * Long conditional jumps
>   Test to trigger the relative-to-absolute branch conversion in MIPS JITs,
>   when the PC-relative offset overflows the field width of the MIPS branch
>   instruction.
>
> * Tail calls
>   A new test suite to test tail calls. Also test error paths and TCC
>   limit.
>
> NOTE: There is a minor discrepancy between the interpreter and the
> (x86) JITs. With MAX_TAIL_CALL_CNT = 32, the interpreter seems to allow
> up to 33 tail calls, whereas the JITs stop at 32. This causes the max TCC

Given the intended case was to allow 32, let's fix up the interpreter
to be in line with JITs?

> test to fail for the JITs, since I used the interpreter as reference.
> Either we change the interpreter behavior, change the JITs, or relax the
> test to allow both behaviors.
>
> Let me know what you think.
>
> Cheers,
> Johan
>
> Johan Almbladh (14):
>   bpf/tests: add BPF_JMP32 test cases
>   bpf/tests: add BPF_MOV tests for zero and sign extension
>   bpf/tests: fix typos in test case descriptions
>   bpf/tests: add more tests of ALU32 and ALU64 bitwise operations
>   bpf/tests: add more ALU32 tests for BPF_LSH/RSH/ARSH
>   bpf/tests: add more BPF_LSH/RSH/ARSH tests for ALU64
>   bpf/tests: add more ALU64 BPF_MUL tests
>   bpf/tests: add tests for ALU operations implemented with function
>     calls
>   bpf/tests: add word-order tests for load/store of double words
>   bpf/tests: add branch conversion JIT test
>   bpf/tests: add test for 32-bit context pointer argument passing
>   bpf/tests: add tests for atomic operations
>   bpf/tests: add tests for BPF_CMPXCHG
>   bpf/tests: add tail call test suite
>
>  lib/test_bpf.c | 2732 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 2475 insertions(+), 257 deletions(-)
>
> --
> 2.25.1
>
