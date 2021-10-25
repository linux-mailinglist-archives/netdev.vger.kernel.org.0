Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35E5439E82
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhJYSaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhJYSaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:30:08 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878DDC061745;
        Mon, 25 Oct 2021 11:27:45 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id y78so6286079wmc.0;
        Mon, 25 Oct 2021 11:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OyfSUTjxeHms5poLBJl6tylyEWbiHe67CT09WIuAMsU=;
        b=DRTJojekLcsN6KFnGL2Muvwux70aPo8ynLFl1g9pAHIDED9bCdqk3Ls2hmflxph9ro
         Zi63v7mIel1mCnNEzi82f9ld94pEDGGswxRaBqTGE1nv0lijVV90U9j4aits7iCAhdYH
         spR+nhwMene3t8+389CcOLl45h5g9wVHyYtfnKNcwZYLa6WwpkLd+fu22L3NJJEMu/Y6
         TNeTKxZlTRp67xlXGzqlyEhVn21cIREnRPX4U6+54R6PZJKXemWqmNBIQe0e4kA5PYf6
         JY4I5ao3n6Ds6FOBc09ERwXhExoqXAKEDDU/Ns09ReKGl+BgCjF0PND3xHp/2A8BK9Hw
         fLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OyfSUTjxeHms5poLBJl6tylyEWbiHe67CT09WIuAMsU=;
        b=CzEjMmwhgiZgzhWifDOJ6xlTpyMEGwkNRQJravm934wzG2lzJMpvZOIgM98lpADQH5
         vOgwHjCg9QmLRYxHCSix0YQJJYcv+9EhaOcR2IG6AeBs7eUmbCsvygp+W7QU//jeg677
         AwukBdVwyYKJz5YVwvD2uXToZ/xEpaZKJixk6hZszp1lSJis7mCbr29pzWTxeSEAFFMX
         twNh+9NLYMkcJQ3YMAYkfZ/Zawr1rnj04ytcNYwkBTSVDgOaix9VxTMwK4AsUbS8x+hf
         IWzx8lVyap890gKpVO1C65uvTVuAhhD4EJFkqTyHN7TOPuElRYtZMVCM9Sq/WvsRvbTO
         TvuA==
X-Gm-Message-State: AOAM532KtYfniXN5/pCisOuJurxVxBZJdXe+e1cO87ywq/9kGBkpUv/6
        UUb3u0FDSeEF1GqbbxzSL3MO+7qNRtL2zjDk3DhdsBw1gdE=
X-Google-Smtp-Source: ABdhPJzwTHv9KLpOQ7QaVP0ILYfQpXNWwQQ2vSvHgF424O3LFhwj3NRPR+DaIjoeCD5AWDXYd9nYdVBMWSjA1J4zZ1I=
X-Received: by 2002:a1c:740e:: with SMTP id p14mr50233220wmc.109.1635186463919;
 Mon, 25 Oct 2021 11:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211025035324.517263-1-tongtiangen@huawei.com>
In-Reply-To: <20211025035324.517263-1-tongtiangen@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 25 Oct 2021 20:27:32 +0200
Message-ID: <CAJ+HfNgSVSs5BxVdDHuGNXnC9dxTuZVtx5RiPX=O8okTJZwsPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next,v2] riscv, bpf: Add BPF exception tables
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 at 05:38, Tong Tiangen <tongtiangen@huawei.com> wrote:
>
> When a tracing BPF program attempts to read memory without using the
> bpf_probe_read() helper, the verifier marks the load instruction with
> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
> this flag it falls back to the interpreter.
>
> Add support for BPF_PROBE_MEM, by appending an exception table to the
> BPF program. If the load instruction causes a data abort, the fixup
> infrastructure finds the exception table and fixes up the fault, by
> clearing the destination register and jumping over the faulting
> instruction.
>
> A more generic solution would add a "handler" field to the table entry,
> like on x86 and s390.
>
> The same issue in ARM64 is fixed in:
> commit 800834285361 ("bpf, arm64: Add BPF exception tables")
>
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Tested-by: Pu Lehui <pulehui@huawei.com>
> ---
> v2:
> Modify according to Bj=C3=B6rn's comments, mainly removes redundant head =
files
> extable.h and some code style issues.
>

Thanks Tong! I haven't got around to take it for a spin yet.

However, some more minor nits, and some other comments.

>  arch/riscv/mm/extable.c         |  27 ++++-
>  arch/riscv/net/bpf_jit.h        |   1 +
>  arch/riscv/net/bpf_jit_comp64.c | 185 +++++++++++++++++++++++++-------
>  arch/riscv/net/bpf_jit_core.c   |  18 +++-
>  4 files changed, 185 insertions(+), 46 deletions(-)
>
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 2fc729422151..442695393131 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -11,14 +11,31 @@
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
>
> +#ifdef CONFIG_BPF_JIT
> +static inline bool in_bpf_jit(struct pt_regs *regs)
> +{
> +       if (!IS_ENABLED(CONFIG_BPF_JIT))
> +               return false;

The whole function is gated by the ifdef. No need for this check. Please re=
move!

> +
> +       return regs->epc >=3D BPF_JIT_REGION_START && regs->epc < BPF_JIT=
_REGION_END;
> +}
> +
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struc=
t pt_regs *regs);
> +#endif
> +
>  int fixup_exception(struct pt_regs *regs)
>  {
>         const struct exception_table_entry *fixup;
>
>         fixup =3D search_exception_tables(regs->epc);
> -       if (fixup) {
> -               regs->epc =3D fixup->fixup;
> -               return 1;
> -       }
> -       return 0;
> +       if (!fixup)
> +               return 0;
> +
> +#ifdef CONFIG_BPF_JIT
> +       if (in_bpf_jit(regs))
> +               return rv_bpf_fixup_exception(fixup, regs);
> +#endif
> +
> +       regs->epc =3D fixup->fixup;
> +       return 1;
>  }
> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
> index 75c1e9996867..8f2e5670c1aa 100644
> --- a/arch/riscv/net/bpf_jit.h
> +++ b/arch/riscv/net/bpf_jit.h
> @@ -71,6 +71,7 @@ struct rv_jit_context {
>         int ninsns;
>         int epilogue_offset;
>         int *offset;            /* BPF to RV */
> +       int nexentrys;

Nit: Spelling: entries, not entrys.

>         unsigned long flags;
>         int stack_size;
>  };
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index 3af4131c22c7..a1b9fe14ead3 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -5,6 +5,7 @@
>   *
>   */
>
> +#include <linux/bitfield.h>
>  #include <linux/bpf.h>
>  #include <linux/filter.h>
>  #include "bpf_jit.h"
> @@ -27,6 +28,21 @@ static const int regmap[] =3D {
>         [BPF_REG_AX] =3D  RV_REG_T0,
>  };
>
> +static const int pt_regmap[] =3D {
> +       [RV_REG_A5] =3D offsetof(struct pt_regs, a5),

Nit: Please place the A5 *under* A4.

> +       [RV_REG_A0] =3D offsetof(struct pt_regs, a0),
> +       [RV_REG_A1] =3D offsetof(struct pt_regs, a1),
> +       [RV_REG_A2] =3D offsetof(struct pt_regs, a2),
> +       [RV_REG_A3] =3D offsetof(struct pt_regs, a3),
> +       [RV_REG_A4] =3D offsetof(struct pt_regs, a4),
> +       [RV_REG_S1] =3D offsetof(struct pt_regs, s1),
> +       [RV_REG_S2] =3D offsetof(struct pt_regs, s2),
> +       [RV_REG_S3] =3D offsetof(struct pt_regs, s3),
> +       [RV_REG_S4] =3D offsetof(struct pt_regs, s4),
> +       [RV_REG_S5] =3D offsetof(struct pt_regs, s5),
> +       [RV_REG_T0] =3D offsetof(struct pt_regs, t0),
> +};
> +
>  enum {
>         RV_CTX_F_SEEN_TAIL_CALL =3D       0,
>         RV_CTX_F_SEEN_CALL =3D            RV_REG_RA,
> @@ -440,6 +456,69 @@ static int emit_call(bool fixed, u64 addr, struct rv=
_jit_context *ctx)
>         return 0;
>  }
>
> +#define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
> +#define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
> +
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +                               struct pt_regs *regs)
> +{
> +       off_t offset =3D FIELD_GET(BPF_FIXUP_OFFSET_MASK, ex->fixup);
> +       int regs_offset =3D FIELD_GET(BPF_FIXUP_REG_MASK, ex->fixup);
> +
> +       *(unsigned long *)((unsigned char *)regs + pt_regmap[regs_offset]=
) =3D 0;

Nit: Inconsistency. Sometimes you use (void *) cast for byte access,
sometimes (unsigned char *).  I'd change it to void * here, and keep
the (void *) below.

> +       regs->epc =3D (unsigned long)&ex->fixup - offset;
> +
> +       return 1;
> +}
> +
> +/* For accesses to BTF pointers, add an entry to the exception table */
> +static int add_exception_handler(const struct bpf_insn *insn,
> +                                struct rv_jit_context *ctx,
> +                                int dst_reg, int insn_len)
> +{
> +       struct exception_table_entry *ex;
> +       unsigned long pc;
> +       off_t offset;
> +
> +       if (!ctx->insns || !ctx->prog->aux->extable || BPF_MODE(insn->cod=
e) !=3D BPF_PROBE_MEM)
> +               return 0;
> +
> +       if (WARN_ON_ONCE(ctx->nexentrys >=3D ctx->prog->aux->num_exentrie=
s))
> +               return -EINVAL;
> +
> +       if (WARN_ON_ONCE(insn_len > ctx->ninsns))
> +               return -EINVAL;
> +
> +       if (WARN_ON_ONCE(!rvc_enabled() && insn_len =3D=3D 1))
> +               return -EINVAL;
> +
> +       ex =3D &ctx->prog->aux->extable[ctx->nexentrys];
> +       pc =3D (unsigned long)&ctx->insns[ctx->ninsns - insn_len];
> +
> +       offset =3D pc - (long)&ex->insn;
> +       if (WARN_ON_ONCE(offset >=3D 0 || offset < INT_MIN))
> +               return -ERANGE;
> +       ex->insn =3D pc;
> +
> +       /*
> +        * Since the extable follows the program, the fixup offset is alw=
ays
> +        * negative and limited to BPF_JIT_REGION_SIZE. Store a positive =
value
> +        * to keep things simple, and put the destination register in the=
 upper
> +        * bits. We don't need to worry about buildtime or runtime sort
> +        * modifying the upper bits because the table is already sorted, =
and
> +        * isn't part of the main exception table.
> +        */
> +       offset =3D (long)&ex->fixup - (pc + insn_len * sizeof(u16));
> +       if (!FIELD_FIT(BPF_FIXUP_OFFSET_MASK, offset))
> +               return -ERANGE;
> +
> +       ex->fixup =3D FIELD_PREP(BPF_FIXUP_OFFSET_MASK, offset) |
> +               FIELD_PREP(BPF_FIXUP_REG_MASK, dst_reg);
> +
> +       ctx->nexentrys++;
> +       return 0;
> +}
> +
>  int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context=
 *ctx,
>                       bool extra_pass)
>  {
> @@ -893,52 +972,86 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, =
struct rv_jit_context *ctx,
>
>         /* LDX: dst =3D *(size *)(src + off) */
>         case BPF_LDX | BPF_MEM | BPF_B:
> -               if (is_12b_int(off)) {
> -                       emit(rv_lbu(rd, off, rs), ctx);
> +       case BPF_LDX | BPF_MEM | BPF_H:
> +       case BPF_LDX | BPF_MEM | BPF_W:
> +       case BPF_LDX | BPF_MEM | BPF_DW:
> +       case BPF_LDX | BPF_PROBE_MEM | BPF_B:
> +       case BPF_LDX | BPF_PROBE_MEM | BPF_H:
> +       case BPF_LDX | BPF_PROBE_MEM | BPF_W:
> +       case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
> +       {
> +               int insn_len, insns_start;
> +
> +               switch (BPF_SIZE(code)) {
> +               case BPF_B:
> +                       if (is_12b_int(off)) {
> +                               insns_start =3D ctx->ninsns;
> +                               emit(rv_lbu(rd, off, rs), ctx);
> +                               insn_len =3D ctx->ninsns - insns_start;
> +                               break;
> +                       }
> +
> +                       emit_imm(RV_REG_T1, off, ctx);
> +                       emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> +                       insns_start =3D ctx->ninsns;
> +                       emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
> +                       insn_len =3D ctx->ninsns - insns_start;
> +                       if (insn_is_zext(&insn[1]))
> +                               return 1;
>                         break;
> -               }
> +               case BPF_H:
> +                       if (is_12b_int(off)) {
> +                               insns_start =3D ctx->ninsns;
> +                               emit(rv_lhu(rd, off, rs), ctx);
> +                               insn_len =3D ctx->ninsns - insns_start;
> +                               break;
> +                       }
>
> -               emit_imm(RV_REG_T1, off, ctx);
> -               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> -               emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
> -               if (insn_is_zext(&insn[1]))
> -                       return 1;
> -               break;
> -       case BPF_LDX | BPF_MEM | BPF_H:
> -               if (is_12b_int(off)) {
> -                       emit(rv_lhu(rd, off, rs), ctx);
> +                       emit_imm(RV_REG_T1, off, ctx);
> +                       emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> +                       insns_start =3D ctx->ninsns;
> +                       emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
> +                       insn_len =3D ctx->ninsns - insns_start;
> +                       if (insn_is_zext(&insn[1]))
> +                               return 1;
>                         break;
> -               }
> +               case BPF_W:
> +                       if (is_12b_int(off)) {
> +                               insns_start =3D ctx->ninsns;
> +                               emit(rv_lwu(rd, off, rs), ctx);
> +                               insn_len =3D ctx->ninsns - insns_start;
> +                               break;
> +                       }
>
> -               emit_imm(RV_REG_T1, off, ctx);
> -               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> -               emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
> -               if (insn_is_zext(&insn[1]))
> -                       return 1;
> -               break;
> -       case BPF_LDX | BPF_MEM | BPF_W:
> -               if (is_12b_int(off)) {
> -                       emit(rv_lwu(rd, off, rs), ctx);
> +                       emit_imm(RV_REG_T1, off, ctx);
> +                       emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> +                       insns_start =3D ctx->ninsns;
> +                       emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
> +                       insn_len =3D ctx->ninsns - insns_start;
> +                       if (insn_is_zext(&insn[1]))
> +                               return 1;
>                         break;
> -               }
> +               case BPF_DW:
> +                       if (is_12b_int(off)) {
> +                               insns_start =3D ctx->ninsns;
> +                               emit_ld(rd, off, rs, ctx);
> +                               insn_len =3D ctx->ninsns - insns_start;
> +                               break;
> +                       }
>
> -               emit_imm(RV_REG_T1, off, ctx);
> -               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> -               emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
> -               if (insn_is_zext(&insn[1]))
> -                       return 1;
> -               break;
> -       case BPF_LDX | BPF_MEM | BPF_DW:
> -               if (is_12b_int(off)) {
> -                       emit_ld(rd, off, rs, ctx);
> +                       emit_imm(RV_REG_T1, off, ctx);
> +                       emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> +                       insns_start =3D ctx->ninsns;
> +                       emit_ld(rd, 0, RV_REG_T1, ctx);
> +                       insn_len =3D ctx->ninsns - insns_start;
>                         break;
>                 }
>
> -               emit_imm(RV_REG_T1, off, ctx);
> -               emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
> -               emit_ld(rd, 0, RV_REG_T1, ctx);
> +               ret =3D add_exception_handler(insn, ctx, rd, insn_len);
> +               if (ret)
> +                       return ret;
>                 break;
> -
> +       }
>         /* speculation barrier */
>         case BPF_ST | BPF_NOSPEC:
>                 break;
> diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.=
c
> index fed86f42dfbe..5f2a842ec6f3 100644
> --- a/arch/riscv/net/bpf_jit_core.c
> +++ b/arch/riscv/net/bpf_jit_core.c
> @@ -41,12 +41,12 @@ bool bpf_jit_needs_zext(void)
>
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
> +       unsigned int image_size, prog_size, extable_size;
>         bool tmp_blinded =3D false, extra_pass =3D false;
>         struct bpf_prog *tmp, *orig_prog =3D prog;
>         int pass =3D 0, prev_ninsns =3D 0, i;
>         struct rv_jit_data *jit_data;
>         struct rv_jit_context *ctx;
> -       unsigned int image_size =3D 0;

Hmm, image_size is now the *program size* plus the extable. So,
prog_size is what image_size was. If my memory is not failing I
*think* that the image_size has to be initialized to zero , if so this
new prog_size has to be initialized to zero. I might be wrong. I just
want to make sure that we're not introducing uninitialized data
access.

Same question for the extable_size. I see it's being used outside the
for-loop below.

To me it looks like both prog_size and extable_size needs to be
initialized to zero.

>
>         if (!prog->jit_requested)
>                 return orig_prog;
> @@ -73,7 +73,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *p=
rog)
>
>         if (ctx->offset) {
>                 extra_pass =3D true;
> -               image_size =3D sizeof(*ctx->insns) * ctx->ninsns;
> +               prog_size =3D sizeof(*ctx->insns) * ctx->ninsns;
>                 goto skip_init_ctx;
>         }
>
> @@ -102,8 +102,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
>                 if (ctx->ninsns =3D=3D prev_ninsns) {
>                         if (jit_data->header)
>                                 break;
> +                       /* obtain the actual image size */
> +                       extable_size =3D prog->aux->num_exentries *
> +                               sizeof(struct exception_table_entry);
> +                       prog_size =3D sizeof(*ctx->insns) * ctx->ninsns;
> +                       image_size =3D prog_size + extable_size;

image_size is only used in the call to bpf_jit_binary_alloc(). I'd
remove it and only use prog_size + extable_size in the call. Or move
it into the if-statement.

>
> -                       image_size =3D sizeof(*ctx->insns) * ctx->ninsns;
>                         jit_data->header =3D
>                                 bpf_jit_binary_alloc(image_size,
>                                                      &jit_data->image,
> @@ -130,9 +134,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
>                 goto out_offset;
>         }
>
> +       if (extable_size)
> +               prog->aux->extable =3D (void *)ctx->insns + prog_size;

(This was the void*-cast I was talking about)


> skip_init_ctx:
>         pass++;
>         ctx->ninsns =3D 0;
> +       ctx->nexentrys =3D 0;
>
>         bpf_jit_build_prologue(ctx);
>         if (build_body(ctx, extra_pass, NULL)) {
> @@ -143,11 +151,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
>         bpf_jit_build_epilogue(ctx);
>
>         if (bpf_jit_enable > 1)
> -               bpf_jit_dump(prog->len, image_size, pass, ctx->insns);
> +               bpf_jit_dump(prog->len, prog_size, pass, ctx->insns);
>
>         prog->bpf_func =3D (void *)ctx->insns;
>         prog->jited =3D 1;
> -       prog->jited_len =3D image_size;
> +       prog->jited_len =3D prog_size;
>
>         bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
>
> --
> 2.25.1



Again, thank you for hacking on this!


Cheers,
Bj=C3=B6rn
