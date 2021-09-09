Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B740452F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 07:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350876AbhIIFvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 01:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhIIFvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 01:51:45 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26240C061575;
        Wed,  8 Sep 2021 22:50:36 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z18so1596063ybg.8;
        Wed, 08 Sep 2021 22:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbAwJn7fFiGfPLrVocqe11Q3q7IsLXBF5Gxx03pmlXE=;
        b=CmWrpGJWf7JI1pP0j0mp45iHU8XkQe2EqAUzjV7ZmD/9FcnGbJAjU+KHRVJytckonC
         vujUXfoq2DKOdHDooun6rux/zPb5UUNw6F0/rYYiG63z0gXl5FRo9mM4D/ZHlcjFEoT5
         TSsPsN+5dKnBSLAhkl0Su9JKaQpr90RBEm4Bp9T0uBXdLr0wrGO5QAHwK8IFJ0/Bufj4
         1xgY7VRPTUjHu9eIZWZuoV3u6fgcauS7FWhKhnxCRypxO896NpcBImOjOFxkiiobXx1x
         j7DRcXdP4TINM1IE+y5xZAS4KExdFRwogWOejAehtF6YEY4uO6oaSr2HYcGFJo7eD5l9
         eReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbAwJn7fFiGfPLrVocqe11Q3q7IsLXBF5Gxx03pmlXE=;
        b=M3+o7Uiu2ar8ZmAdlz5a0o3Y4xuynbbto8jAT3JRlBMLlkVg3gKjpuhOh573UaB8s0
         WzAGVKnr7orkAomdBC5w5SoQOPQg1Qb9DDJ2r9u8E/1wKLoLnIcKRaaggIUoehqGXW+N
         n2BOvCccpEye+zrC6LQ0b1tX5muHWfuHFnoQmsvf23mwcgNo+IO0t600MP2EUJM+cKeu
         lEFRP/Qyde0Pom5UJ+Rr9k7h9IIqlDyabwkNysxojttfzLGze25feudhrXBjqdSEQA3V
         FETbUZWPxVV2Uf08JvxuaBV9tUlRE9emWIWGcAdfUBN6HApNYlp/6aks+0G3ncYqrTRB
         dr8g==
X-Gm-Message-State: AOAM532tcAScQoeYh3tFoz9gew+uC4b6JjUv5JA5kVc/FkmxuFCwrkF4
        ECiOr/KkSegP09sE+lI+5KbrN44vqUbNiLvBrH8=
X-Google-Smtp-Source: ABdhPJxt1xA0uM8Q0oqALtqvGBUDGndJ4a+HcDFgyDfaBTs5y9qs8UNRpk1kp/Lb9NyUROynnQ45aqXim7JNzY/Zqj0=
X-Received: by 2002:a5b:702:: with SMTP id g2mr1597430ybq.307.1631166635450;
 Wed, 08 Sep 2021 22:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <1631158350-3661-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1631158350-3661-1-git-send-email-yangtiezhu@loongson.cn>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Sep 2021 22:50:24 -0700
Message-ID: <CAEf4BzZqoVZ7keWCLmC=A5oPPwj_xMNRWDkJUcjWn9yE_z1gSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Change value of MAX_TAIL_CALL_CNT from 32
 to 33
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Chaignon <paul@cilium.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 8:33 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> In the current code, the actual max tail call count is 33 which is greater
> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consistent
> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need to
> spend some time to think the reason at the first glance.

think *about* the reason

>
> We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
> bpf programs to tail-call other bpf programs") and commit f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit").
>
> In order to avoid changing existing behavior, the actual limit is 33 now,
> this is resonable.

typo: reasonable

>
> After commit 874be05f525e ("bpf, tests: Add tail call test suite"), we can
> see there exists failed testcase.
>
> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>  # echo 0 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
>
> On some archs:
>  # echo 1 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
>
> So it is necessary to change the value of MAX_TAIL_CALL_CNT from 32 to 33,
> then do some small changes of the related code.
>
> With this patch, it does not change the current limit, MAX_TAIL_CALL_CNT
> can reflect the actual max tail call count, and the above failed testcase
> can be fixed.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---

This change breaks selftests ([0]), please fix them at the same time
as you are changing the kernel behavior:

  test_tailcall_2:PASS:tailcall 128 nsec
  test_tailcall_2:PASS:tailcall 128 nsec
  test_tailcall_2:FAIL:tailcall err 0 errno 2 retval 4
  #135/2 tailcalls/tailcall_2:FAIL
  test_tailcall_3:PASS:tailcall 128 nsec
  test_tailcall_3:FAIL:tailcall count err 0 errno 2 count 34
  test_tailcall_3:PASS:tailcall 128 nsec
  #135/3 tailcalls/tailcall_3:FAIL
  #135/4 tailcalls/tailcall_4:OK
  #135/5 tailcalls/tailcall_5:OK
  #135/6 tailcalls/tailcall_bpf2bpf_1:OK
  test_tailcall_bpf2bpf_2:PASS:tailcall 128 nsec
  test_tailcall_bpf2bpf_2:FAIL:tailcall count err 0 errno 2 count 34
  test_tailcall_bpf2bpf_2:PASS:tailcall 128 nsec
  #135/7 tailcalls/tailcall_bpf2bpf_2:FAIL
  #135/8 tailcalls/tailcall_bpf2bpf_3:OK
  test_tailcall_bpf2bpf_4:PASS:tailcall 54 nsec
  test_tailcall_bpf2bpf_4:FAIL:tailcall count err 0 errno 2 count 32
  #135/9 tailcalls/tailcall_bpf2bpf_4:FAIL
  test_tailcall_bpf2bpf_4:PASS:tailcall 54 nsec
  test_tailcall_bpf2bpf_4:FAIL:tailcall count err 0 errno 2 count 32
  #135/10 tailcalls/tailcall_bpf2bpf_5:FAIL
  #135 tailcalls:FAIL


  [0] https://github.com/kernel-patches/bpf/pull/1747/checks?check_run_id=3552002906

>  arch/arm/net/bpf_jit_32.c         | 11 ++++++-----
>  arch/arm64/net/bpf_jit_comp.c     |  7 ++++---
>  arch/mips/net/ebpf_jit.c          |  4 ++--
>  arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
>  arch/powerpc/net/bpf_jit_comp64.c | 12 ++++++------
>  arch/riscv/net/bpf_jit_comp32.c   |  4 ++--
>  arch/riscv/net/bpf_jit_comp64.c   |  4 ++--
>  arch/sparc/net/bpf_jit_comp_64.c  |  8 ++++----
>  include/linux/bpf.h               |  2 +-
>  kernel/bpf/core.c                 |  4 ++--
>  10 files changed, 31 insertions(+), 29 deletions(-)
>

[...]
