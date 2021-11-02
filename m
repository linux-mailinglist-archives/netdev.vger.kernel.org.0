Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52011443450
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhKBRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbhKBRJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:09:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71E2C061203;
        Tue,  2 Nov 2021 10:07:05 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b2-20020a1c8002000000b0032fb900951eso2518336wmd.4;
        Tue, 02 Nov 2021 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8oHRsraxLr95dyqIZ4i9gXSUOIKBzXvt3sHaqmNleG0=;
        b=OqjNpfDy0PUdCVV1P26ri7l8lKLTQsh2UcZ6l2GN0uogRjm1BD3KoebfP6om75E6rs
         QLeJTes1JktuwmDiStKQEPhewLZ50hveU63bhUCIP7CW8LyCvQ1JWsvqifB43LEscbLd
         TifylW4u5W2qb5V3HzJ79D6HSx0sZq1A1qU6syLF4QbknNMtz7mkUVYpGJ3FD2GWQiuL
         uXuw8kxrS6Lb0PFGPj8eoSOH5nAVtPbeyCdPqLwORz9skH8LU8+MC1LtbflcqbuP/dPd
         sPsj0IuFmm1ZBb7WZacOkoJ4zS7jnfpK8tY5+W3inGCj28azStpZKbetgSRJkSF3E5Vl
         eVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8oHRsraxLr95dyqIZ4i9gXSUOIKBzXvt3sHaqmNleG0=;
        b=3zG44NETv7ttTRT5NkZMbEV1Ynm2kzRCLpbQmi5+SSUDwACzuHfFoEi5LuPAHbqtcB
         Y5a5b/9tV2q2CFaVBC5F3jnG9Gt+cAjtCU6E9tkfNeP+cs0aDxjwVY17FrzWAPewJoYX
         9etM39b2cB/XELZh7g/DDpbDECAShRt3AMAZJMGme0n8CcLBX5V0O91XMZSWDzsOcDdy
         FLlZilHzzGQJahWVr5zExrN4yAQfZxC8XcWHTsnwjcckPAPOKRUdbfqwjBCET6AxZiBW
         mP8q68fgpFkucWM2UBfkkRrL87s0P2XVU5TdBkdwIRat/RdCli0vUf0exbxrA84BvDQY
         DjtA==
X-Gm-Message-State: AOAM530UVj7cuRLqcIwgDEFoWUctXVo+DOhwgngVQmdGh7CV0gLPkoVt
        CrKTKOBJ6oiLhrJ7/39nf1oEBkpIKmVKsecPys8=
X-Google-Smtp-Source: ABdhPJzloyupizZ7CVP+cylrlRwT3lgpREZU9rA+BH8jQPtuqSLx4DwsJrvizBVECMnuYLbESVnlvmxl8hBhMSibCsc=
X-Received: by 2002:a05:600c:1ca7:: with SMTP id k39mr8761216wms.74.1635872824205;
 Tue, 02 Nov 2021 10:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <1635843092-12907-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1635843092-12907-1-git-send-email-yangtiezhu@loongson.cn>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 2 Nov 2021 18:06:52 +0100
Message-ID: <CAJ+HfNhtZFnxNjzDo8gSJdyDhEEicgUo5hDdCeBYJ=rutBZ93w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: Change value of MAX_TAIL_CALL_CNT from
 32 to 33
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, naveen.n.rao@linux.ibm.com,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, iii@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, udknight@gmail.com,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 at 09:51, Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> In the current code, the actual max tail call count is 33 which is greate=
r
> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consisten=
t
> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need t=
o
> spend some time to think about the reason at the first glance.
>
> We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
> bpf programs to tail-call other bpf programs") and commit f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit").
>
> In order to avoid changing existing behavior, the actual limit is 33 now,
> this is reasonable.
>
> After commit 874be05f525e ("bpf, tests: Add tail call test suite"), we ca=
n
> see there exists failed testcase.
>
> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>  # echo 0 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:0 ret 34 !=3D 33 FAIL
>
> On some archs:
>  # echo 1 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:1 ret 34 !=3D 33 FAIL
>
> Although the above failed testcase has been fixed in commit 18935a72eb25
> ("bpf/tests: Fix error in tail call limit tests"), it is still necessary
> to change the value of MAX_TAIL_CALL_CNT from 32 to 33 to make the code
> more readable, then do some small changes of the related code.
>
> With this patch, it does not change the current limit 33, MAX_TAIL_CALL_C=
NT
> can reflect the actual max tail call count, the related tailcall testcase=
s
> in test_bpf and selftests can work well for the interpreter and the JIT.
>

[...]

> diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_com=
p32.c
> index e649742..ead9733 100644
> --- a/arch/riscv/net/bpf_jit_comp32.c
> +++ b/arch/riscv/net/bpf_jit_comp32.c
> @@ -799,13 +799,12 @@ static int emit_bpf_tail_call(int insn, struct rv_j=
it_context *ctx)
>         emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
>
>         /*
> -        * temp_tcc =3D tcc - 1;
> -        * if (tcc < 0)
> +        * if (--tcc < 0)
>          *   goto out;
>          */
>         emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
>         off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
> -       emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
> +       emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
>
>         /*
>          * prog =3D array->ptrs[index];
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index 2ca345c..9822f58 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -327,12 +327,12 @@ static int emit_bpf_tail_call(int insn, struct rv_j=
it_context *ctx)
>         off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
>         emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
>
> -       /* if (TCC-- < 0)
> +       /* if (--tcc < 0)
>          *     goto out;
>          */
>         emit_addi(RV_REG_T1, tcc, -1, ctx);
>         off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
> -       emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
> +       emit_branch(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
>
>         /* prog =3D array->ptrs[index];
>          * if (!prog)

The RISC-V code can be simplified, to save one move:

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp3=
2.c
index e6497424cbf6..529a83b85c1c 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -799,11 +799,10 @@ static int emit_bpf_tail_call(int insn, struct
rv_jit_context *ctx)
        emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);

        /*
-        * temp_tcc =3D tcc - 1;
-        * if (tcc < 0)
+        * if (--tcc < 0)
         *   goto out;
         */
-       emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
+       emit(rv_addi(RV_REG_TCC, RV_REG_TCC, -1), ctx);
        off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
        emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);

@@ -829,7 +828,6 @@ static int emit_bpf_tail_call(int insn, struct
rv_jit_context *ctx)
        if (is_12b_check(off, insn))
                return -1;
        emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
-       emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
        /* Epilogue jumps to *(t0 + 4). */
        __build_epilogue(true, ctx);
        return 0;
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp6=
4.c
index 2ca345c7b0bf..f4466b7997b5 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -327,12 +327,12 @@ static int emit_bpf_tail_call(int insn, struct
rv_jit_context *ctx)
        off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
        emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);

-       /* if (TCC-- < 0)
+       /* if (--TCC < 0)
         *     goto out;
         */
-       emit_addi(RV_REG_T1, tcc, -1, ctx);
+       emit_addi(RV_REG_TCC, tcc, -1, ctx);
        off =3D ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
-       emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
+       emit_branch(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);

        /* prog =3D array->ptrs[index];
         * if (!prog)
@@ -352,7 +352,6 @@ static int emit_bpf_tail_call(int insn, struct
rv_jit_context *ctx)
        if (is_12b_check(off, insn))
                return -1;
        emit_ld(RV_REG_T3, off, RV_REG_T2, ctx);
-       emit_mv(RV_REG_TCC, RV_REG_T1, ctx);
        __build_epilogue(true, ctx);
        return 0;
 }

With that change applied, for RISC-V:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>


Bj=C3=B6rn
