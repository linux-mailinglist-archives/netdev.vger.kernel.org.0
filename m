Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C991F507EB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfFXKL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:11:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45783 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730483AbfFXKLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:11:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so13795069qtr.12;
        Mon, 24 Jun 2019 03:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=15uhjBtkGBOXqVVZTx2yLPQNj8A8hT8yrFU9WTRU2zE=;
        b=vDuNtCqW/Xou08m1ICzHq3IioWV7CRAb1gY2prIu7Uu6CixIxbqCeYTpJ3HbaDSxIA
         eptA+VRdyT/b1pkxBpZsdgNi58NyQLThioWSlUp96W5T4RRQUlml2gQ4Io3l5NaUQH4F
         JVKkiIshdooxDNznmSnmeNL0vC6qpZ3f+ZfGA9UfPvDFBXIKb6JvUEQAAP+DDMFHZ1WU
         SzFFk7k9RNEBL9lK/eIiAlG/PC4X8f09nOckM7BcO92908P120CcFwuIdWDP888348Vj
         6oZjvGfQu3BFbD0wsrxQhmf3kNVnM0F9KLrnnwd5rrH0tdEPHqKZ8M/OKQXbOJOCS2B3
         QcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=15uhjBtkGBOXqVVZTx2yLPQNj8A8hT8yrFU9WTRU2zE=;
        b=EXAeBXAc7Z+l5Hrcx/CBwHMP4BnVeg23f6Q8i89pI1Nwpt6BsnvfHh1iOkIeFGj6+b
         krJghTR4pGkrk9oTQeK9d3MZcLVFLA4hDnRborkiiT0D/R/+fhfZ+xbqF4Hq1h4wWcRx
         WxTAInYpikvRUfu73J7osydf73geNtUFZZItY6KiZJ+s0SlRPPI92B3lP1fXm5qVrpH7
         osjvoUqOtwDCGPyXU/R92VhW3vjryWor/ODrz+X2GmRvQBm7RtW9x7h2IC2doTvw/NNr
         M+kHbjSjiodb3nmNphxtB7SSxVuQe1B3l35mwyfeevCdVj4G3bSfc09QcmPLPNGo4gf0
         AIYA==
X-Gm-Message-State: APjAAAV8rpK8LHZrNHUBrYChkhqMQT9rsAqjGbXzauWPE/o4mHrbvE+C
        v+5hhbT7VsatB2IgAapP74hyEtxr9K9+KM/apJo=
X-Google-Smtp-Source: APXvYqzb8QghNWuoxknwsYEttjNUioTAxZ0Pxp9rZPkivNeZkdK8NVXuC8eLq4dhQeqqSPC6ziL2xJ5UYkSdt/rk/5Q=
X-Received: by 2002:ac8:219d:: with SMTP id 29mr24641330qty.37.1561371112625;
 Mon, 24 Jun 2019 03:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190621225938.27030-1-lukenels@cs.washington.edu>
In-Reply-To: <20190621225938.27030-1-lukenels@cs.washington.edu>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 12:11:41 +0200
Message-ID: <CAJ+HfNgHOt4gMSq_gufwxb=cKekCfLrk-uGJuGeDiOeQV1-wwQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] RV32G eBPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jun 2019 at 00:59, Luke Nelson <lukenels@cs.washington.edu> wrot=
e:
>
> From: Luke Nelson <luke.r.nels@gmail.com>
>

Yay! Thanks for working on this! Nice work!

> This is an eBPF JIT for RV32G, adapted from the JIT for RV64G.
> Any feedback would be greatly appreciated.
>
> It passes 359 out of 378 tests in test_bpf.ko. The failing tests are
> features that are not supported right now:
>   - ALU64 DIV/MOD:
>       These require loops to emulate on 32-bit hardware,
>       and are not supported on other 32-bit JITs like
>       ARM32.
>   - BPF_XADD | BPF_DW:
>       RV32G does not have atomic instructions for operating
>       on double words. This is similar to ARM32.
>   - Tail calls:
>       I'm working on adding support for these now, but couldn't
>       find any test cases that use them. What's the best way
>       of testing tail call code?

Have a look at the selftests (tools/testing/selftests/). The bpf
section has a lot a tests involving tail calls, e.g. test_progs and
test_verifier.

>   - Far branches
>       These are not supported in RV64G either.

This would be really nice to have, now that the size of BPF programs
are getting larger.

I'll try to a review/test run when I have some time over!


Bj=C3=B6rn

>
> There are two main changes required for this to work compared to the
> RV64 JIT.
>
> First, eBPF registers are 64-bit, while RV32G registers are 32-bit.
> I take an approach similar to ARM32: most BPF registers map directly to
> 2 RISC-V registers, while some reside in stack scratch space and must
> be saved / restored when used.
>
> Second, many 64-bit ALU operations do not trivially map to 32-bit
> operations. Operations that move bits between high and low words, such
> as ADD, LSH, MUL, and others must emulate the 64-bit behavior in terms
> of 32-bit instructions.
>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> Cc: Xi Wang <xi.wang@gmail.com>
> ---
>  arch/riscv/Kconfig              |    2 +-
>  arch/riscv/net/Makefile         |    7 +-
>  arch/riscv/net/bpf_jit_comp32.c | 1460 +++++++++++++++++++++++++++++++
>  3 files changed, 1467 insertions(+), 2 deletions(-)
>  create mode 100644 arch/riscv/net/bpf_jit_comp32.c
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 0c4b12205632..153ff9ee6e6c 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -49,7 +49,7 @@ config RISCV
>         select GENERIC_IRQ_MULTI_HANDLER
>         select ARCH_HAS_PTE_SPECIAL
>         select ARCH_HAS_MMIOWB
> -       select HAVE_EBPF_JIT if 64BIT
> +       select HAVE_EBPF_JIT
>
>  config MMU
>         def_bool y
> diff --git a/arch/riscv/net/Makefile b/arch/riscv/net/Makefile
> index ec5b14763316..5511fb1dd40e 100644
> --- a/arch/riscv/net/Makefile
> +++ b/arch/riscv/net/Makefile
> @@ -1,2 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_BPF_JIT) +=3D bpf_jit_comp.o
> +
> +ifeq ($(CONFIG_ARCH_RV64I),y)
> +       obj-$(CONFIG_BPF_JIT) +=3D bpf_jit_comp.o
> +else
> +       obj-$(CONFIG_BPF_JIT) +=3D bpf_jit_comp32.o
> +endif
> diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_com=
p32.c
> new file mode 100644
> index 000000000000..8790fd931aed
> --- /dev/null
> +++ b/arch/riscv/net/bpf_jit_comp32.c
> @@ -0,0 +1,1460 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* BPF JIT compiler for RV32G
> + *
> + * Copyright(c) 2019 Luke Nelson <luke.r.nels@gmail.com>
> + * This code is based on the code and ideas from
> + * Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>,
> + * who wrote the rv64g BPF JIT, and
> + * Shubham Bansal <illusionist.neo@gmail.com> and
> + * Mircea Gherzan <mgherzan@gmail.com>,
> + * who wrote the 32-bit ARM BPF JIT.
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +#include <asm/cacheflush.h>
> +
> +enum {
> +       RV_REG_ZERO =3D   0,      /* The constant value 0 */
> +       RV_REG_RA =3D     1,      /* Return address */
> +       RV_REG_SP =3D     2,      /* Stack pointer */
> +       RV_REG_GP =3D     3,      /* Global pointer */
> +       RV_REG_TP =3D     4,      /* Thread pointer */
> +       RV_REG_T0 =3D     5,      /* Temporaries */
> +       RV_REG_T1 =3D     6,
> +       RV_REG_T2 =3D     7,
> +       RV_REG_FP =3D     8,
> +       RV_REG_S1 =3D     9,      /* Saved registers */
> +       RV_REG_A0 =3D     10,     /* Function argument/return values */
> +       RV_REG_A1 =3D     11,     /* Function arguments */
> +       RV_REG_A2 =3D     12,
> +       RV_REG_A3 =3D     13,
> +       RV_REG_A4 =3D     14,
> +       RV_REG_A5 =3D     15,
> +       RV_REG_A6 =3D     16,
> +       RV_REG_A7 =3D     17,
> +       RV_REG_S2 =3D     18,     /* Saved registers */
> +       RV_REG_S3 =3D     19,
> +       RV_REG_S4 =3D     20,
> +       RV_REG_S5 =3D     21,
> +       RV_REG_S6 =3D     22,
> +       RV_REG_S7 =3D     23,
> +       RV_REG_S8 =3D     24,
> +       RV_REG_S9 =3D     25,
> +       RV_REG_S10 =3D    26,
> +       RV_REG_S11 =3D    27,
> +       RV_REG_T3 =3D     28,     /* Temporaries */
> +       RV_REG_T4 =3D     29,
> +       RV_REG_T5 =3D     30,
> +       RV_REG_T6 =3D     31,
> +};
> +
> +enum {
> +       /* Stack layout - these are offsets from (top of stack - 4) */
> +       BPF_R6_HI,
> +       BPF_R6_LO,
> +       BPF_R7_HI,
> +       BPF_R7_LO,
> +       BPF_R8_HI,
> +       BPF_R8_LO,
> +       BPF_R9_HI,
> +       BPF_R9_LO,
> +       BPF_TC_HI,
> +       BPF_TC_LO,
> +       BPF_AX_HI,
> +       BPF_AX_LO,
> +       /* Stack space for BPF_REG_6, BPF_REG_7, BPF_REG_8, BPF_REG_9,
> +        * BPF_REG_AX and tail call counts.
> +        */
> +       BPF_JIT_SCRATCH_REGS,
> +};
> +
> +#define STACK_OFFSET(k) (-4 - ((k) * 4))
> +
> +#define TMP_REG_1      (MAX_BPF_JIT_REG + 0)   /* TEMP Register 1 */
> +#define TMP_REG_2      (MAX_BPF_JIT_REG + 1)   /* TEMP Register 2 */
> +#define TCALL_CNT      (MAX_BPF_JIT_REG + 2)   /* Tail Call Count */
> +
> +static const s8 bpf2rv32[][2] =3D {
> +       /* Return value from in-kernel function, and exit value from eBPF=
 */
> +       [BPF_REG_0] =3D {RV_REG_S2, RV_REG_S1},
> +       /* Arguments from eBPF program to in-kernel function */
> +       [BPF_REG_1] =3D {RV_REG_A1, RV_REG_A0},
> +       [BPF_REG_2] =3D {RV_REG_A3, RV_REG_A2},
> +       [BPF_REG_3] =3D {RV_REG_A5, RV_REG_A4},
> +       [BPF_REG_4] =3D {RV_REG_A7, RV_REG_A6},
> +       [BPF_REG_5] =3D {RV_REG_S4, RV_REG_S3},
> +       /* Callee saved registers that in-kernel function will preserve *=
/
> +       /* Stored on stack scratch space */
> +       [BPF_REG_6] =3D {STACK_OFFSET(BPF_R6_HI), STACK_OFFSET(BPF_R6_LO)=
},
> +       [BPF_REG_7] =3D {STACK_OFFSET(BPF_R7_HI), STACK_OFFSET(BPF_R7_LO)=
},
> +       [BPF_REG_8] =3D {STACK_OFFSET(BPF_R8_HI), STACK_OFFSET(BPF_R8_LO)=
},
> +       [BPF_REG_9] =3D {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)=
},
> +       /* Read only Frame Pointer to access Stack */
> +       [BPF_REG_FP] =3D {RV_REG_S6, RV_REG_S5},
> +       /* Temporary Register for internal BPF JIT, can be used
> +        * for constant blindings and others. Save T0 and T1
> +        * for use internal to one instruction.
> +        */
> +       [TMP_REG_1] =3D {RV_REG_T3, RV_REG_T2},
> +       [TMP_REG_2] =3D {RV_REG_T5, RV_REG_T4},
> +       /* Tail call count. Stored on stack scratch space. */
> +       [TCALL_CNT] =3D {STACK_OFFSET(BPF_TC_HI), STACK_OFFSET(BPF_TC_LO)=
},
> +       /* Temporary register for blinding constants.
> +        * Stored on stack scratch space.
> +        */
> +       [BPF_REG_AX] =3D {STACK_OFFSET(BPF_AX_HI), STACK_OFFSET(BPF_AX_LO=
)},
> +};
> +
> +struct rv_jit_context {
> +       struct bpf_prog *prog;
> +       u32 *insns; /* RV insns */
> +       int ninsns;
> +       int epilogue_offset;
> +       int *offset; /* BPF to RV */
> +       unsigned long flags;
> +       int stack_size;
> +};
> +
> +struct rv_jit_data {
> +       struct bpf_binary_header *header;
> +       u8 *image;
> +       struct rv_jit_context ctx;
> +};
> +
> +static void emit(const u32 insn, struct rv_jit_context *ctx)
> +{
> +       if (ctx->insns)
> +               ctx->insns[ctx->ninsns] =3D insn;
> +
> +       ctx->ninsns++;
> +}
> +
> +static u32 rv_r_insn(u8 funct7, u8 rs2, u8 rs1, u8 funct3, u8 rd, u8 opc=
ode)
> +{
> +       return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12=
) |
> +               (rd << 7) | opcode;
> +}
> +
> +static u32 rv_i_insn(u16 imm11_0, u8 rs1, u8 funct3, u8 rd, u8 opcode)
> +{
> +       return (imm11_0 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7)=
 |
> +               opcode;
> +}
> +
> +static u32 rv_s_insn(u16 imm11_0, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
> +{
> +       u8 imm11_5 =3D imm11_0 >> 5, imm4_0 =3D imm11_0 & 0x1f;
> +
> +       return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 1=
2) |
> +               (imm4_0 << 7) | opcode;
> +}
> +
> +static u32 rv_sb_insn(u16 imm12_1, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
> +{
> +       u8 imm12 =3D ((imm12_1 & 0x800) >> 5) | ((imm12_1 & 0x3f0) >> 4);
> +       u8 imm4_1 =3D ((imm12_1 & 0xf) << 1) | ((imm12_1 & 0x400) >> 10);
> +
> +       return (imm12 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12)=
 |
> +               (imm4_1 << 7) | opcode;
> +}
> +
> +static u32 rv_u_insn(u32 imm31_12, u8 rd, u8 opcode)
> +{
> +       return (imm31_12 << 12) | (rd << 7) | opcode;
> +}
> +
> +static u32 rv_uj_insn(u32 imm20_1, u8 rd, u8 opcode)
> +{
> +       u32 imm;
> +
> +       imm =3D (imm20_1 & 0x80000) |  ((imm20_1 & 0x3ff) << 9) |
> +                 ((imm20_1 & 0x400) >> 2) | ((imm20_1 & 0x7f800) >> 11);
> +
> +       return (imm << 12) | (rd << 7) | opcode;
> +}
> +
> +static u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
> +                          u8 funct3, u8 rd, u8 opcode)
> +{
> +       u8 funct7 =3D (funct5 << 2) | (aq << 1) | rl;
> +
> +       return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
> +}
> +
> +static u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
> +}
> +
> +static u32 rv_add(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 0, rd, 0x33);
> +}
> +
> +static u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
> +}
> +
> +static u32 rv_and(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
> +}
> +
> +static u32 rv_or(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 6, rd, 0x33);
> +}
> +
> +static u32 rv_xor(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 4, rd, 0x33);
> +}
> +
> +static u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
> +}
> +
> +static u32 rv_mulhu(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(1, rs2, rs1, 3, rd, 0x33);
> +}
> +
> +static u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
> +}
> +
> +static u32 rv_remu(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(1, rs2, rs1, 7, rd, 0x33);
> +}
> +
> +static u32 rv_sll(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 1, rd, 0x33);
> +}
> +
> +static u32 rv_srl(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 5, rd, 0x33);
> +}
> +
> +static u32 rv_sra(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x33);
> +}
> +
> +static u32 rv_sltu(u8 rd, u8 rs1, u8 rs2)
> +{
> +       return rv_r_insn(0, rs2, rs1, 3, rd, 0x33);
> +}
> +
> +static u32 rv_lui(u8 rd, u32 imm31_12)
> +{
> +       return rv_u_insn(imm31_12, rd, 0x37);
> +}
> +
> +static u32 rv_slli(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(imm11_0, rs1, 1, rd, 0x13);
> +}
> +
> +static u32 rv_srli(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(imm11_0, rs1, 5, rd, 0x13);
> +}
> +
> +static u32 rv_srai(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x13);
> +}
> +
> +static u32 rv_andi(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(imm11_0, rs1, 7, rd, 0x13);
> +}
> +
> +static u32 rv_jal(u8 rd, u32 imm20_1)
> +{
> +       return rv_uj_insn(imm20_1, rd, 0x6f);
> +}
> +
> +static u32 rv_jalr(u8 rd, u8 rs1, u16 imm11_0)
> +{
> +       return rv_i_insn(imm11_0, rs1, 0, rd, 0x67);
> +}
> +
> +static u32 rv_beq(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 0, 0x63);
> +}
> +
> +static u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 6, 0x63);
> +}
> +
> +static u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 7, 0x63);
> +}
> +
> +static u32 rv_bne(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 1, 0x63);
> +}
> +
> +static u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 4, 0x63);
> +}
> +
> +static u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
> +{
> +       return rv_sb_insn(imm12_1, rs2, rs1, 5, 0x63);
> +}
> +
> +static u32 rv_sb(u8 rs1, u16 imm11_0, u8 rs2)
> +{
> +       return rv_s_insn(imm11_0, rs2, rs1, 0, 0x23);
> +}
> +
> +static u32 rv_sh(u8 rs1, u16 imm11_0, u8 rs2)
> +{
> +       return rv_s_insn(imm11_0, rs2, rs1, 1, 0x23);
> +}
> +
> +static u32 rv_sw(u8 rs1, u16 imm11_0, u8 rs2)
> +{
> +       return rv_s_insn(imm11_0, rs2, rs1, 2, 0x23);
> +}
> +
> +static u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
> +{
> +       return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
> +}
> +
> +static u32 rv_lhu(u8 rd, u16 imm11_0, u8 rs1)
> +{
> +       return rv_i_insn(imm11_0, rs1, 5, rd, 0x03);
> +}
> +
> +static u32 rv_lw(u8 rd, u16 imm11_0, u8 rs1)
> +{
> +       return rv_i_insn(imm11_0, rs1, 2, rd, 0x03);
> +}
> +
> +static u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
> +{
> +       return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
> +}
> +
> +static bool is_13b_int(s32 val)
> +{
> +       return -(1 << 12) <=3D val && val < (1 << 12);
> +}
> +
> +static bool is_21b_int(s32 val)
> +{
> +       return -(1L << 20) <=3D val && val < (1L << 20);
> +}
> +
> +static int is_13b_check(int off, int insn)
> +{
> +       if (!is_13b_int(off)) {
> +               pr_err("bpf-jit: insn=3D%d offset=3D%d not supported yet!=
\n",
> +                      insn, off);
> +               return -1;
> +       }
> +       return 0;
> +}
> +
> +static int is_21b_check(int off, int insn)
> +{
> +       if (!is_21b_int(off)) {
> +               pr_err("bpf-jit: insn=3D%d offset=3D%d not supported yet!=
\n",
> +                      insn, off);
> +               return -1;
> +       }
> +       return 0;
> +}
> +
> +static void emit_imm(const s8 rd, s32 imm, struct rv_jit_context *ctx)
> +{
> +       u32 upper =3D (imm + (1 << 11)) >> 12;
> +       u32 lower =3D imm & 0xfff;
> +
> +       if (upper) {
> +               emit(rv_lui(rd, upper), ctx);
> +               emit(rv_addi(rd, rd, lower), ctx);
> +       } else {
> +               emit(rv_addi(rd, RV_REG_ZERO, lower), ctx);
> +       }
> +}
> +
> +static void emit_imm32(const s8 *rd, s32 imm, struct rv_jit_context *ctx=
)
> +{
> +       /* Emit immediate into lower bits */
> +       emit_imm(rd[1], imm, ctx);
> +
> +       /* Sign-extend into upper bits */
> +       emit(rv_addi(rd[0], rd[1], 0), ctx);
> +       emit(rv_srai(rd[0], rd[0], 31), ctx);
> +}
> +
> +static void emit_imm64(const s8 *rd, s32 imm_hi, s32 imm_lo,
> +                      struct rv_jit_context *ctx)
> +{
> +       emit_imm(rd[1], imm_lo, ctx);
> +       emit_imm(rd[0], imm_hi, ctx);
> +}
> +
> +static int rv_offset(int bpf_to, int bpf_from, struct rv_jit_context *ct=
x)
> +{
> +       int from =3D ctx->offset[bpf_from] - 1, to =3D ctx->offset[bpf_to=
];
> +
> +       return (to - from) << 2;
> +}
> +
> +static int epilogue_offset(struct rv_jit_context *ctx)
> +{
> +       int to =3D ctx->epilogue_offset, from =3D ctx->ninsns;
> +
> +       return (to - from) << 2;
> +}
> +
> +static void build_epilogue(struct rv_jit_context *ctx)
> +{
> +       int stack_adjust =3D ctx->stack_size, store_offset =3D stack_adju=
st - 8;
> +       const s8 *r0 =3D bpf2rv32[BPF_REG_0];
> +
> +       store_offset -=3D 4 * BPF_JIT_SCRATCH_REGS;
> +
> +       /* Set return value. */
> +       emit(rv_addi(RV_REG_A0, r0[1], 0), ctx);
> +       emit(rv_addi(RV_REG_A1, r0[0], 0), ctx);
> +
> +       /* Restore callee-saved registers. */
> +       emit(rv_lw(RV_REG_RA, store_offset - 0, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_FP, store_offset - 4, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S1, store_offset - 8, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S2, store_offset - 12, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S3, store_offset - 16, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S4, store_offset - 20, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S5, store_offset - 24, RV_REG_SP), ctx);
> +       emit(rv_lw(RV_REG_S6, store_offset - 28, RV_REG_SP), ctx);
> +
> +       emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
> +       emit(rv_jalr(RV_REG_ZERO, RV_REG_RA, 0), ctx);
> +}
> +
> +static int rv_offset_check(int *rvoff, s16 off, int insn,
> +                          struct rv_jit_context *ctx)
> +{
> +       *rvoff =3D rv_offset(insn + off, insn, ctx);
> +       return is_13b_check(*rvoff, insn);
> +}
> +
> +static bool is_stacked(s8 reg)
> +{
> +       return reg < 0;
> +}
> +
> +static const s8 *rv32_bpf_get_reg64(const s8 *reg, const s8 *tmp,
> +                                   struct rv_jit_context *ctx)
> +{
> +       if (is_stacked(reg[0])) {
> +               emit(rv_lw(tmp[0], reg[0], RV_REG_FP), ctx);
> +               emit(rv_lw(tmp[1], reg[1], RV_REG_FP), ctx);
> +               reg =3D tmp;
> +       }
> +       return reg;
> +}
> +
> +static void rv32_bpf_put_reg64(const s8 *reg, const s8 *src,
> +                              struct rv_jit_context *ctx)
> +{
> +       if (is_stacked(reg[0])) {
> +               emit(rv_sw(RV_REG_FP, reg[0], src[0]), ctx);
> +               emit(rv_sw(RV_REG_FP, reg[1], src[1]), ctx);
> +       }
> +}
> +
> +static const s8 *rv32_bpf_get_reg32(const s8 *reg, const s8 *tmp,
> +                                   struct rv_jit_context *ctx)
> +{
> +       if (is_stacked(reg[1])) {
> +               emit(rv_lw(tmp[1], reg[1], RV_REG_FP), ctx);
> +               reg =3D tmp;
> +       }
> +       return reg;
> +}
> +
> +static void rv32_bpf_put_reg32(const s8 *reg, const s8 *src,
> +                              struct rv_jit_context *ctx)
> +{
> +       if (is_stacked(reg[1])) {
> +               emit(rv_sw(RV_REG_FP, reg[1], src[1]), ctx);
> +               emit(rv_sw(RV_REG_FP, reg[0], RV_REG_ZERO), ctx);
> +       } else {
> +               emit(rv_addi(reg[0], RV_REG_ZERO, 0), ctx);
> +       }
> +}
> +
> +static void emit_rv32_alu_i64(const s8 dst[], s32 imm,
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +       switch (op) {
> +       case BPF_MOV:
> +               emit_imm32(rd, imm, ctx);
> +               break;
> +       }
> +
> +       rv32_bpf_put_reg64(dst, rd, ctx);
> +}
> +
> +static void emit_rv32_alu_i32(const s8 dst[], s32 imm,
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *rd =3D rv32_bpf_get_reg32(dst, tmp1, ctx);
> +
> +       switch (op) {
> +       case BPF_MOV:
> +               emit_imm32(rd, imm, ctx);
> +               break;
> +       }
> +
> +       rv32_bpf_put_reg32(dst, rd, ctx);
> +}
> +
> +static void emit_rv32_alu_r64(const s8 dst[], const s8 src[],
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +       const s8 *rs =3D rv32_bpf_get_reg64(src, tmp2, ctx);
> +
> +       switch (op) {
> +       case BPF_MOV:
> +               emit(rv_addi(rd[0], rs[0], 0), ctx);
> +               emit(rv_addi(rd[1], rs[1], 0), ctx);
> +               break;
> +       case BPF_ADD:
> +               emit(rv_addi(RV_REG_T0, rd[1], 0), ctx);
> +               emit(rv_add(rd[1], rd[1], rs[1]), ctx);
> +               emit(rv_sltu(RV_REG_T0, rd[1], RV_REG_T0), ctx);
> +               emit(rv_add(rd[0], rd[0], rs[0]), ctx);
> +               emit(rv_add(rd[0], rd[0], RV_REG_T0), ctx);
> +               break;
> +       case BPF_SUB:
> +               emit(rv_addi(RV_REG_T0, rd[1], 0), ctx);
> +               emit(rv_sub(rd[1], rd[1], rs[1]), ctx);
> +               emit(rv_sltu(RV_REG_T0, RV_REG_T0, rd[1]), ctx);
> +               emit(rv_sub(rd[0], rd[0], rs[0]), ctx);
> +               emit(rv_sub(rd[0], rd[0], RV_REG_T0), ctx);
> +               break;
> +       case BPF_AND:
> +               emit(rv_and(rd[0], rd[0], rs[0]), ctx);
> +               emit(rv_and(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_OR:
> +               emit(rv_or(rd[0], rd[0], rs[0]), ctx);
> +               emit(rv_or(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_XOR:
> +               emit(rv_xor(rd[0], rd[0], rs[0]), ctx);
> +               emit(rv_xor(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_MUL:
> +               emit(rv_mul(RV_REG_T0, rs[0], rd[1]), ctx);
> +               emit(rv_mul(rd[0], rd[0], rs[1]), ctx);
> +               emit(rv_mulhu(RV_REG_T1, rd[1], rs[1]), ctx);
> +               emit(rv_add(rd[0], rd[0], RV_REG_T0), ctx);
> +               emit(rv_mul(rd[1], rd[1], rs[1]), ctx);
> +               emit(rv_add(rd[0], rd[0], RV_REG_T1), ctx);
> +               break;
> +       case BPF_LSH:
> +               emit(rv_addi(RV_REG_T0, rs[1], -32), ctx);
> +               emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 16 >> 1), ctx);
> +
> +               emit(rv_sll(rd[0], rd[1], RV_REG_T0), ctx);
> +               emit(rv_addi(rd[1], RV_REG_ZERO, 0), ctx);
> +               emit(rv_jal(RV_REG_ZERO, 32 >> 1), ctx);
> +
> +               emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
> +               emit(rv_srli(RV_REG_T0, rd[1], 1), ctx);
> +               emit(rv_sub(RV_REG_T1, RV_REG_T1, rs[1]), ctx);
> +               emit(rv_srl(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
> +               emit(rv_sll(rd[0], rd[0], rs[1]), ctx);
> +               emit(rv_or(rd[0], RV_REG_T0, rd[0]), ctx);
> +               emit(rv_sll(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_RSH:
> +               emit(rv_addi(RV_REG_T0, rs[1], -32), ctx);
> +               emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 16 >> 1), ctx);
> +
> +               emit(rv_srl(rd[1], rd[0], RV_REG_T0), ctx);
> +               emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +               emit(rv_jal(RV_REG_ZERO, 32 >> 1), ctx);
> +
> +               emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
> +               emit(rv_slli(RV_REG_T0, rd[0], 1), ctx);
> +               emit(rv_sub(RV_REG_T1, RV_REG_T1, rs[1]), ctx);
> +               emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
> +               emit(rv_srl(rd[1], rd[1], rs[1]), ctx);
> +               emit(rv_or(rd[1], RV_REG_T0, rd[1]), ctx);
> +               emit(rv_srl(rd[0], rd[0], rs[1]), ctx);
> +               break;
> +       case BPF_ARSH:
> +               emit(rv_addi(RV_REG_T0, rs[1], -32), ctx);
> +               emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 16 >> 1), ctx);
> +
> +               emit(rv_sra(rd[1], rd[0], RV_REG_T0), ctx);
> +               emit(rv_srai(rd[0], rd[0], 0x1f), ctx);
> +               emit(rv_jal(RV_REG_ZERO, 32 >> 1), ctx);
> +
> +               emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
> +               emit(rv_slli(RV_REG_T0, rd[0], 1), ctx);
> +               emit(rv_sub(RV_REG_T1, RV_REG_T1, rs[1]), ctx);
> +               emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
> +               emit(rv_srl(rd[1], rd[1], rs[1]), ctx);
> +               emit(rv_or(rd[1], RV_REG_T0, rd[1]), ctx);
> +               emit(rv_sra(rd[0], rd[0], rs[1]), ctx);
> +               break;
> +       case BPF_NEG:
> +               emit(rv_sub(rd[1], RV_REG_ZERO, rd[1]), ctx);
> +               emit(rv_sltu(RV_REG_T0, RV_REG_ZERO, rd[1]), ctx);
> +               emit(rv_sub(rd[0], RV_REG_ZERO, rd[0]), ctx);
> +               emit(rv_sub(rd[0], rd[0], RV_REG_T0), ctx);
> +               break;
> +       }
> +
> +       rv32_bpf_put_reg64(dst, rd, ctx);
> +}
> +
> +static void emit_rv32_alu_r32(const s8 dst[], const s8 src[],
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rd =3D rv32_bpf_get_reg32(dst, tmp1, ctx);
> +       const s8 *rs =3D rv32_bpf_get_reg32(src, tmp2, ctx);
> +
> +       switch (op) {
> +       case BPF_MOV:
> +               emit(rv_addi(rd[1], rs[1], 0), ctx);
> +               break;
> +       case BPF_ADD:
> +               emit(rv_add(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_SUB:
> +               emit(rv_sub(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_AND:
> +               emit(rv_and(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_OR:
> +               emit(rv_or(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_XOR:
> +               emit(rv_xor(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_MUL:
> +               emit(rv_mul(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_DIV:
> +               emit(rv_divu(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_MOD:
> +               emit(rv_remu(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_LSH:
> +               emit(rv_sll(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_RSH:
> +               emit(rv_srl(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_ARSH:
> +               emit(rv_sra(rd[1], rd[1], rs[1]), ctx);
> +               break;
> +       case BPF_NEG:
> +               emit(rv_sub(rd[1], RV_REG_ZERO, rd[1]), ctx);
> +               break;
> +       }
> +
> +       rv32_bpf_put_reg32(dst, rd, ctx);
> +}
> +
> +static int emit_rv32_jump_r64(const s8 src1[], const s8 src2[],
> +                             s16 off, int insn,
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       int rvoff;
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rs1 =3D rv32_bpf_get_reg64(src1, tmp1, ctx);
> +       const s8 *rs2 =3D rv32_bpf_get_reg64(src2, tmp2, ctx);
> +
> +       if (rv_offset_check(&rvoff, off, insn, ctx))
> +               return -1;
> +
> +       switch (op) {
> +       case BPF_JEQ:
> +               emit(rv_bne(rs1[0], rs2[0], 8 >> 1), ctx);
> +               emit(rv_beq(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JNE:
> +               emit(rv_bne(rs1[0], rs2[0], (rvoff + 4) >> 1), ctx);
> +               emit(rv_bne(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JLE:
> +               emit(rv_bltu(rs1[0], rs2[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bltu(rs2[0], rs1[0], 8 >> 1), ctx);
> +               emit(rv_bgeu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JLT:
> +               emit(rv_bltu(rs1[0], rs2[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bltu(rs2[0], rs1[0], 8 >> 1), ctx);
> +               emit(rv_bltu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JGE:
> +               emit(rv_bltu(rs2[0], rs1[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bltu(rs1[0], rs2[0], 8 >> 1), ctx);
> +               emit(rv_bgeu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JGT:
> +               emit(rv_bltu(rs2[0], rs1[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bltu(rs1[0], rs2[0], 8 >> 1), ctx);
> +               emit(rv_bltu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSLE:
> +               emit(rv_blt(rs1[0], rs2[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bne(rs2[0], rs1[0], 8 >> 1), ctx);
> +               emit(rv_bgeu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSLT:
> +               emit(rv_blt(rs1[0], rs2[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bne(rs2[0], rs1[0], 8 >> 1), ctx);
> +               emit(rv_bltu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSGE:
> +               emit(rv_blt(rs2[0], rs1[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bne(rs1[0], rs2[0], 8 >> 1), ctx);
> +               emit(rv_bgeu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSGT:
> +               emit(rv_blt(rs2[0], rs1[0], (rvoff + 8) >> 1), ctx);
> +               emit(rv_bne(rs1[0], rs2[0], 8 >> 1), ctx);
> +               emit(rv_bltu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSET:
> +               emit(rv_and(RV_REG_T0, rs1[0], rs2[0]), ctx);
> +               emit(rv_bne(RV_REG_T0, RV_REG_ZERO, (rvoff + 8) >> 1), ct=
x);
> +               emit(rv_and(RV_REG_T0, rs1[1], rs2[1]), ctx);
> +               emit(rv_bne(RV_REG_T0, RV_REG_ZERO, rvoff >> 1), ctx);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int emit_rv32_jump_r32(const s8 src1[], const s8 src2[],
> +                             s16 off, int insn,
> +                             struct rv_jit_context *ctx,
> +                             const u8 op)
> +{
> +       int rvoff;
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rs1 =3D rv32_bpf_get_reg32(src1, tmp1, ctx);
> +       const s8 *rs2 =3D rv32_bpf_get_reg32(src2, tmp2, ctx);
> +
> +       if (rv_offset_check(&rvoff, off, insn, ctx))
> +               return -1;
> +
> +       switch (op) {
> +       case BPF_JEQ:
> +               emit(rv_beq(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JNE:
> +               emit(rv_bne(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JLE:
> +               emit(rv_bgeu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JLT:
> +               emit(rv_bltu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JGE:
> +               emit(rv_bgeu(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JGT:
> +               emit(rv_bltu(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSLE:
> +               emit(rv_bge(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSLT:
> +               emit(rv_blt(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSGE:
> +               emit(rv_bge(rs1[1], rs2[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSGT:
> +               emit(rv_blt(rs2[1], rs1[1], rvoff >> 1), ctx);
> +               break;
> +       case BPF_JSET:
> +               emit(rv_and(RV_REG_T0, rs1[1], rs2[1]), ctx);
> +               emit(rv_bne(RV_REG_T0, RV_REG_ZERO, rvoff >> 1), ctx);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int emit_rv32_load_r64(const s8 dst[], const s8 src[],
> +                             s16 off,
> +                             struct rv_jit_context *ctx,
> +                             const u8 size)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +       const s8 *rs =3D rv32_bpf_get_reg64(src, tmp2, ctx);
> +
> +       emit_imm(RV_REG_T0, off, ctx);
> +       emit(rv_add(RV_REG_T0, RV_REG_T0, rs[1]), ctx);
> +
> +       switch (size) {
> +       case BPF_B:
> +               emit(rv_lbu(rd[1], 0, RV_REG_T0), ctx);
> +               emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +               break;
> +       case BPF_H:
> +               emit(rv_lhu(rd[1], 0, RV_REG_T0), ctx);
> +               emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +               break;
> +       case BPF_W:
> +               emit(rv_lw(rd[1], 0, RV_REG_T0), ctx);
> +               emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +               break;
> +       case BPF_DW:
> +               emit(rv_lw(rd[1], 0, RV_REG_T0), ctx);
> +               emit(rv_lw(rd[0], 4, RV_REG_T0), ctx);
> +               break;
> +       }
> +
> +       rv32_bpf_put_reg64(dst, rd, ctx);
> +       return 0;
> +}
> +
> +static int emit_rv32_store_r64(const s8 dst[], const s8 src[],
> +                              s16 off,
> +                              struct rv_jit_context *ctx,
> +                              const u8 size, const u8 mode)
> +{
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +       const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +       const s8 *rs =3D rv32_bpf_get_reg64(src, tmp2, ctx);
> +
> +       if (mode =3D=3D BPF_XADD && size !=3D BPF_W)
> +               return -1;
> +
> +       emit_imm(RV_REG_T0, off, ctx);
> +       emit(rv_add(RV_REG_T0, RV_REG_T0, rd[1]), ctx);
> +
> +       switch (size) {
> +       case BPF_B:
> +               emit(rv_sb(RV_REG_T0, 0, rs[1]), ctx);
> +               break;
> +       case BPF_H:
> +               emit(rv_sh(RV_REG_T0, 0, rs[1]), ctx);
> +               break;
> +       case BPF_W:
> +               switch (mode) {
> +               case BPF_MEM:
> +                       emit(rv_sw(RV_REG_T0, 0, rs[1]), ctx);
> +                       break;
> +               case BPF_XADD:
> +                       emit(rv_amoadd_w(RV_REG_ZERO, rs[1], RV_REG_T0, 0=
, 0), ctx);
> +                       break;
> +               }
> +               break;
> +       case BPF_DW:
> +               emit(rv_sw(RV_REG_T0, 0, rs[1]), ctx);
> +               emit(rv_sw(RV_REG_T0, 4, rs[0]), ctx);
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static void emit_rv32_rev16(const s8 rd, struct rv_jit_context *ctx)
> +{
> +       emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 0), ctx);
> +
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +       emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
> +       emit(rv_srli(rd, rd, 8), ctx);
> +
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +
> +       emit(rv_addi(rd, RV_REG_T1, 0), ctx);
> +}
> +
> +static void emit_rv32_rev32(const s8 rd, struct rv_jit_context *ctx)
> +{
> +       emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 0), ctx);
> +
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +       emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
> +       emit(rv_srli(rd, rd, 8), ctx);
> +
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +       emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
> +       emit(rv_srli(rd, rd, 8), ctx);
> +
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +       emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
> +       emit(rv_srli(rd, rd, 8), ctx);
> +       emit(rv_andi(RV_REG_T0, rd, 0xff), ctx);
> +       emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
> +
> +       emit(rv_addi(rd, RV_REG_T1, 0), ctx);
> +}
> +
> +static int emit_insn(const struct bpf_insn *insn,
> +                    struct rv_jit_context *ctx,
> +                    bool extra_pass)
> +{
> +       int rvoff, i =3D insn - ctx->prog->insnsi;
> +       u8 code =3D insn->code;
> +       s16 off =3D insn->off;
> +       s32 imm =3D insn->imm;
> +
> +       const s8 *dst =3D bpf2rv32[insn->dst_reg];
> +       const s8 *src =3D bpf2rv32[insn->src_reg];
> +       const s8 *tmp1 =3D bpf2rv32[TMP_REG_1];
> +       const s8 *tmp2 =3D bpf2rv32[TMP_REG_2];
> +
> +       switch (code) {
> +       case BPF_ALU64 | BPF_MOV | BPF_X:
> +
> +       case BPF_ALU64 | BPF_ADD | BPF_X:
> +       case BPF_ALU64 | BPF_ADD | BPF_K:
> +
> +       case BPF_ALU64 | BPF_SUB | BPF_X:
> +       case BPF_ALU64 | BPF_SUB | BPF_K:
> +
> +       case BPF_ALU64 | BPF_AND | BPF_X:
> +       case BPF_ALU64 | BPF_AND | BPF_K:
> +
> +       case BPF_ALU64 | BPF_OR | BPF_X:
> +       case BPF_ALU64 | BPF_OR | BPF_K:
> +
> +       case BPF_ALU64 | BPF_XOR | BPF_X:
> +       case BPF_ALU64 | BPF_XOR | BPF_K:
> +
> +       case BPF_ALU64 | BPF_MUL | BPF_X:
> +       case BPF_ALU64 | BPF_MUL | BPF_K:
> +
> +       case BPF_ALU64 | BPF_LSH | BPF_X:
> +       case BPF_ALU64 | BPF_LSH | BPF_K:
> +
> +       case BPF_ALU64 | BPF_RSH | BPF_X:
> +       case BPF_ALU64 | BPF_RSH | BPF_K:
> +
> +       case BPF_ALU64 | BPF_ARSH | BPF_X:
> +       case BPF_ALU64 | BPF_ARSH | BPF_K:
> +               if (BPF_SRC(code) =3D=3D BPF_K) {
> +                       emit_imm32(tmp2, imm, ctx);
> +                       src =3D tmp2;
> +               }
> +               emit_rv32_alu_r64(dst, src, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU64 | BPF_NEG:
> +               emit_rv32_alu_r64(dst, tmp2, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU64 | BPF_DIV | BPF_X:
> +       case BPF_ALU64 | BPF_DIV | BPF_K:
> +       case BPF_ALU64 | BPF_MOD | BPF_X:
> +       case BPF_ALU64 | BPF_MOD | BPF_K:
> +               goto notsupported;
> +
> +       case BPF_ALU64 | BPF_MOV | BPF_K:
> +               emit_rv32_alu_i64(dst, imm, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU | BPF_MOV | BPF_X:
> +
> +       case BPF_ALU | BPF_ADD | BPF_X:
> +       case BPF_ALU | BPF_ADD | BPF_K:
> +
> +       case BPF_ALU | BPF_SUB | BPF_X:
> +       case BPF_ALU | BPF_SUB | BPF_K:
> +
> +       case BPF_ALU | BPF_AND | BPF_X:
> +       case BPF_ALU | BPF_AND | BPF_K:
> +
> +       case BPF_ALU | BPF_OR | BPF_X:
> +       case BPF_ALU | BPF_OR | BPF_K:
> +
> +       case BPF_ALU | BPF_XOR | BPF_X:
> +       case BPF_ALU | BPF_XOR | BPF_K:
> +
> +       case BPF_ALU | BPF_MUL | BPF_X:
> +       case BPF_ALU | BPF_MUL | BPF_K:
> +
> +       case BPF_ALU | BPF_DIV | BPF_X:
> +       case BPF_ALU | BPF_DIV | BPF_K:
> +
> +       case BPF_ALU | BPF_MOD | BPF_X:
> +       case BPF_ALU | BPF_MOD | BPF_K:
> +
> +       case BPF_ALU | BPF_LSH | BPF_X:
> +       case BPF_ALU | BPF_LSH | BPF_K:
> +
> +       case BPF_ALU | BPF_RSH | BPF_X:
> +       case BPF_ALU | BPF_RSH | BPF_K:
> +
> +       case BPF_ALU | BPF_ARSH | BPF_X:
> +       case BPF_ALU | BPF_ARSH | BPF_K:
> +               if (BPF_SRC(code) =3D=3D BPF_K) {
> +                       emit_imm32(tmp2, imm, ctx);
> +                       src =3D tmp2;
> +               }
> +               emit_rv32_alu_r32(dst, src, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU | BPF_MOV | BPF_K:
> +               emit_rv32_alu_i32(dst, imm, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU | BPF_NEG:
> +               /* src is ignored---choose a register known not to be sta=
cked */
> +               emit_rv32_alu_r32(dst, tmp2, ctx, BPF_OP(code));
> +               break;
> +
> +       case BPF_ALU | BPF_END | BPF_FROM_LE:
> +       {
> +               const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +               switch (imm) {
> +               case 16:
> +                       emit(rv_slli(rd[1], rd[1], 16), ctx);
> +                       emit(rv_srli(rd[1], rd[1], 16), ctx);
> +                       /* Fallthrough to clear high bits. */
> +               case 32:
> +                       emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +                       break;
> +               case 64:
> +                       /* Do nothing. */
> +                       break;
> +               default:
> +                       pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
> +                       return -1;
> +               }
> +
> +               rv32_bpf_put_reg64(dst, rd, ctx);
> +               break;
> +       }
> +
> +       case BPF_ALU | BPF_END | BPF_FROM_BE:
> +       {
> +               const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +               switch (imm) {
> +               case 16:
> +                       emit_rv32_rev16(rd[1], ctx);
> +                       emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +                       break;
> +               case 32:
> +                       emit_rv32_rev32(rd[1], ctx);
> +                       emit(rv_addi(rd[0], RV_REG_ZERO, 0), ctx);
> +                       break;
> +               case 64:
> +                       /* Swap upper and lower halves. */
> +                       emit(rv_addi(RV_REG_T0, rd[1], 0), ctx);
> +                       emit(rv_addi(rd[1], rd[0], 0), ctx);
> +                       emit(rv_addi(rd[0], RV_REG_T0, 0), ctx);
> +
> +                       /* Swap each half. */
> +                       emit_rv32_rev32(rd[1], ctx);
> +                       emit_rv32_rev32(rd[0], ctx);
> +                       break;
> +               default:
> +                       pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
> +                       return -1;
> +               }
> +
> +               rv32_bpf_put_reg64(dst, rd, ctx);
> +               break;
> +       }
> +
> +       case BPF_JMP | BPF_JA:
> +               rvoff =3D rv_offset(i + off, i, ctx);
> +               if (!is_21b_int(rvoff)) {
> +                       pr_err("bpf-jit: insn=3D%d offset=3D%d not suppor=
ted yet!\n",
> +                              i, rvoff);
> +                       return -1;
> +               }
> +               emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
> +               break;
> +
> +       case BPF_JMP | BPF_CALL:
> +       {
> +               bool fixed;
> +               int ret;
> +               u64 addr;
> +               const s8 *r0 =3D bpf2rv32[BPF_REG_0];
> +               const s8 *r5 =3D bpf2rv32[BPF_REG_5];
> +
> +               ret =3D bpf_jit_get_func_addr(ctx->prog, insn, extra_pass=
, &addr,
> +                                           &fixed);
> +               if (ret < 0)
> +                       return ret;
> +               if (fixed) {
> +                       emit_imm(RV_REG_T0, (u32) addr, ctx);
> +               } else {
> +                       pr_err("bpf-jit: pseudocall call not supported ye=
t!\n");
> +                       return -1;
> +               }
> +
> +               /* R1-R4 already in correct reigsters---need to push R5 t=
o stack */
> +               emit(rv_addi(RV_REG_SP, RV_REG_SP, -8), ctx);
> +               emit(rv_sw(RV_REG_SP, 0, r5[1]), ctx);
> +               emit(rv_sw(RV_REG_SP, 4, r5[0]), ctx);
> +
> +               emit(rv_jalr(RV_REG_RA, RV_REG_T0, 0), ctx);
> +
> +               /* Set return value */
> +               emit(rv_addi(r0[1], RV_REG_A0, 0), ctx);
> +               emit(rv_addi(r0[0], RV_REG_A1, 0), ctx);
> +               emit(rv_addi(RV_REG_SP, RV_REG_SP, 8), ctx);
> +               break;
> +       }
> +
> +       case BPF_JMP | BPF_JEQ | BPF_X:
> +       case BPF_JMP | BPF_JEQ | BPF_K:
> +       case BPF_JMP32 | BPF_JEQ | BPF_X:
> +       case BPF_JMP32 | BPF_JEQ | BPF_K:
> +
> +       case BPF_JMP | BPF_JNE | BPF_X:
> +       case BPF_JMP | BPF_JNE | BPF_K:
> +       case BPF_JMP32 | BPF_JNE | BPF_X:
> +       case BPF_JMP32 | BPF_JNE | BPF_K:
> +
> +       case BPF_JMP | BPF_JLE | BPF_X:
> +       case BPF_JMP | BPF_JLE | BPF_K:
> +       case BPF_JMP32 | BPF_JLE | BPF_X:
> +       case BPF_JMP32 | BPF_JLE | BPF_K:
> +
> +       case BPF_JMP | BPF_JLT | BPF_X:
> +       case BPF_JMP | BPF_JLT | BPF_K:
> +       case BPF_JMP32 | BPF_JLT | BPF_X:
> +       case BPF_JMP32 | BPF_JLT | BPF_K:
> +
> +       case BPF_JMP | BPF_JGE | BPF_X:
> +       case BPF_JMP | BPF_JGE | BPF_K:
> +       case BPF_JMP32 | BPF_JGE | BPF_X:
> +       case BPF_JMP32 | BPF_JGE | BPF_K:
> +
> +       case BPF_JMP | BPF_JGT | BPF_X:
> +       case BPF_JMP | BPF_JGT | BPF_K:
> +       case BPF_JMP32 | BPF_JGT | BPF_X:
> +       case BPF_JMP32 | BPF_JGT | BPF_K:
> +
> +       case BPF_JMP | BPF_JSLE | BPF_X:
> +       case BPF_JMP | BPF_JSLE | BPF_K:
> +       case BPF_JMP32 | BPF_JSLE | BPF_X:
> +       case BPF_JMP32 | BPF_JSLE | BPF_K:
> +
> +       case BPF_JMP | BPF_JSLT | BPF_X:
> +       case BPF_JMP | BPF_JSLT | BPF_K:
> +       case BPF_JMP32 | BPF_JSLT | BPF_X:
> +       case BPF_JMP32 | BPF_JSLT | BPF_K:
> +
> +       case BPF_JMP | BPF_JSGE | BPF_X:
> +       case BPF_JMP | BPF_JSGE | BPF_K:
> +       case BPF_JMP32 | BPF_JSGE | BPF_X:
> +       case BPF_JMP32 | BPF_JSGE | BPF_K:
> +
> +       case BPF_JMP | BPF_JSGT | BPF_X:
> +       case BPF_JMP | BPF_JSGT | BPF_K:
> +       case BPF_JMP32 | BPF_JSGT | BPF_X:
> +       case BPF_JMP32 | BPF_JSGT | BPF_K:
> +
> +       case BPF_JMP | BPF_JSET | BPF_X:
> +       case BPF_JMP | BPF_JSET | BPF_K:
> +       case BPF_JMP32 | BPF_JSET | BPF_X:
> +       case BPF_JMP32 | BPF_JSET | BPF_K:
> +               if (BPF_SRC(code) =3D=3D BPF_K) {
> +                       emit_imm32(tmp2, imm, ctx);
> +                       src =3D tmp2;
> +               }
> +               switch (BPF_CLASS(code)) {
> +               case BPF_JMP:
> +                       if (emit_rv32_jump_r64(dst, src, off, i, ctx, BPF=
_OP(code)))
> +                               return -1;
> +                       break;
> +               case BPF_JMP32:
> +                       if (emit_rv32_jump_r32(dst, src, off, i, ctx, BPF=
_OP(code)))
> +                               return -1;
> +                       break;
> +               }
> +               break;
> +
> +       case BPF_JMP | BPF_EXIT:
> +               if (i =3D=3D ctx->prog->len - 1)
> +                       break;
> +
> +               rvoff =3D epilogue_offset(ctx);
> +               if (is_21b_check(rvoff, i))
> +                       return -1;
> +               emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
> +               break;
> +
> +       case BPF_LD | BPF_IMM | BPF_DW:
> +       {
> +               struct bpf_insn insn1 =3D insn[1];
> +               s32 imm_lo =3D imm;
> +               s32 imm_hi =3D insn1.imm;
> +               const s8 *rd =3D rv32_bpf_get_reg64(dst, tmp1, ctx);
> +
> +               emit_imm64(rd, imm_hi, imm_lo, ctx);
> +               rv32_bpf_put_reg64(dst, rd, ctx);
> +               return 1;
> +       }
> +
> +       case BPF_LDX | BPF_MEM | BPF_B:
> +       case BPF_LDX | BPF_MEM | BPF_H:
> +       case BPF_LDX | BPF_MEM | BPF_W:
> +       case BPF_LDX | BPF_MEM | BPF_DW:
> +               if (emit_rv32_load_r64(dst, src, off, ctx, BPF_SIZE(code)=
))
> +                       return -1;
> +               break;
> +
> +
> +       case BPF_ST | BPF_MEM | BPF_B:
> +       case BPF_STX | BPF_MEM | BPF_B:
> +       case BPF_ST | BPF_MEM | BPF_H:
> +       case BPF_STX | BPF_MEM | BPF_H:
> +       case BPF_ST | BPF_MEM | BPF_W:
> +       case BPF_STX | BPF_MEM | BPF_W:
> +       case BPF_ST | BPF_MEM | BPF_DW:
> +       case BPF_STX | BPF_MEM | BPF_DW:
> +
> +       case BPF_STX | BPF_XADD | BPF_W:
> +               if (BPF_CLASS(code) =3D=3D BPF_ST) {
> +                       emit_imm32(tmp2, imm, ctx);
> +                       src =3D tmp2;
> +               }
> +
> +               if (emit_rv32_store_r64(dst, src, off, ctx, BPF_SIZE(code=
), BPF_MODE(code)))
> +                       return -1;
> +               break;
> +
> +       case BPF_STX | BPF_XADD | BPF_DW:
> +               goto notsupported;
> +
> +notsupported:
> +               pr_info_once("*** NOT SUPPORTED: opcode %02x ***\n", code=
);
> +               return -EFAULT;
> +
> +       default:
> +               pr_err("bpf-jit: unknown opcode %02x\n", code);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static void build_prologue(struct rv_jit_context *ctx)
> +{
> +       int stack_adjust =3D 32, store_offset, bpf_stack_adjust;
> +
> +       stack_adjust =3D round_up(stack_adjust, 16);
> +       bpf_stack_adjust =3D round_up(ctx->prog->aux->stack_depth, 16);
> +       stack_adjust +=3D bpf_stack_adjust;
> +
> +       store_offset =3D stack_adjust - 8;
> +
> +       stack_adjust +=3D 4 * BPF_JIT_SCRATCH_REGS;
> +
> +       emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
> +
> +       /* Save callee-save registers */
> +       emit(rv_sw(RV_REG_SP, store_offset - 0, RV_REG_RA), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 4, RV_REG_FP), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 8, RV_REG_S1), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 12, RV_REG_S2), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 16, RV_REG_S3), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 20, RV_REG_S4), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 24, RV_REG_S5), ctx);
> +       emit(rv_sw(RV_REG_SP, store_offset - 28, RV_REG_S6), ctx);
> +
> +       emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
> +
> +       /* Set up BPF stack pointer */
> +       emit(rv_addi(bpf2rv32[BPF_REG_FP][1], RV_REG_SP, bpf_stack_adjust=
), ctx);
> +       emit(rv_addi(bpf2rv32[BPF_REG_FP][0], RV_REG_ZERO, 0), ctx);
> +
> +       /* Set up context pointer */
> +       emit(rv_addi(bpf2rv32[BPF_REG_1][1], RV_REG_A0, 0), ctx);
> +       emit(rv_addi(bpf2rv32[BPF_REG_1][0], RV_REG_ZERO, 0), ctx);
> +
> +       ctx->stack_size =3D stack_adjust;
> +}
> +
> +static int build_body(struct rv_jit_context *ctx, bool extra_pass)
> +{
> +       const struct bpf_prog *prog =3D ctx->prog;
> +       int i;
> +
> +       for (i =3D 0; i < prog->len; i++) {
> +               const struct bpf_insn *insn =3D &prog->insnsi[i];
> +               int ret;
> +
> +               ret =3D emit_insn(insn, ctx, extra_pass);
> +               if (ret > 0) {
> +                       i++;
> +                       if (ctx->insns =3D=3D NULL)
> +                               ctx->offset[i] =3D ctx->ninsns;
> +                       continue;
> +               }
> +               if (ctx->insns =3D=3D NULL)
> +                       ctx->offset[i] =3D ctx->ninsns;
> +               if (ret)
> +                       return ret;
> +       }
> +       return 0;
> +}
> +
> +static void bpf_fill_ill_insns(void *area, unsigned int size)
> +{
> +       memset(area, 0, size);
> +}
> +
> +static void bpf_flush_icache(void *start, void *end)
> +{
> +       flush_icache_range((unsigned long)start, (unsigned long)end);
> +}
> +
> +struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> +{
> +       bool tmp_blinded =3D false, extra_pass =3D false;
> +       struct bpf_prog *tmp, *orig_prog =3D prog;
> +       struct rv_jit_data *jit_data;
> +       struct rv_jit_context *ctx;
> +       unsigned int image_size;
> +
> +       if (!prog->jit_requested)
> +               return orig_prog;
> +
> +       tmp =3D bpf_jit_blind_constants(prog);
> +       if (IS_ERR(tmp))
> +               return orig_prog;
> +       if (tmp !=3D prog) {
> +               tmp_blinded =3D true;
> +               prog =3D tmp;
> +       }
> +
> +       jit_data =3D prog->aux->jit_data;
> +       if (!jit_data) {
> +               jit_data =3D kzalloc(sizeof(*jit_data), GFP_KERNEL);
> +               if (!jit_data) {
> +                       prog =3D orig_prog;
> +                       goto out;
> +               }
> +               prog->aux->jit_data =3D jit_data;
> +       }
> +
> +       ctx =3D &jit_data->ctx;
> +
> +       if (ctx->offset) {
> +               extra_pass =3D true;
> +               image_size =3D sizeof(u32) * ctx->ninsns;
> +               goto skip_init_ctx;
> +       }
> +
> +       ctx->prog =3D prog;
> +       ctx->offset =3D kcalloc(prog->len, sizeof(int), GFP_KERNEL);
> +       if (!ctx->offset) {
> +               prog =3D orig_prog;
> +               goto out_offset;
> +       }
> +
> +       /* First pass generates the ctx->offset, but does not emit an ima=
ge. */
> +       if (build_body(ctx, extra_pass)) {
> +               prog =3D orig_prog;
> +               goto out_offset;
> +       }
> +       build_prologue(ctx);
> +       ctx->epilogue_offset =3D ctx->ninsns;
> +       build_epilogue(ctx);
> +
> +       /* Allocate image, now that we know the size. */
> +       image_size =3D sizeof(u32) * ctx->ninsns;
> +       jit_data->header =3D bpf_jit_binary_alloc(image_size, &jit_data->=
image,
> +                                               sizeof(u32),
> +                                               bpf_fill_ill_insns);
> +       if (!jit_data->header) {
> +               prog =3D orig_prog;
> +               goto out_offset;
> +       }
> +
> +       /* Second, real pass, that acutally emits the image. */
> +       ctx->insns =3D (u32 *)jit_data->image;
> +skip_init_ctx:
> +       ctx->ninsns =3D 0;
> +
> +       build_prologue(ctx);
> +       if (build_body(ctx, extra_pass)) {
> +               bpf_jit_binary_free(jit_data->header);
> +               prog =3D orig_prog;
> +               goto out_offset;
> +       }
> +       build_epilogue(ctx);
> +
> +       if (bpf_jit_enable > 1)
> +               bpf_jit_dump(prog->len, image_size, 2, ctx->insns);
> +
> +       prog->bpf_func =3D (void *)ctx->insns;
> +       prog->jited =3D 1;
> +       prog->jited_len =3D image_size;
> +
> +       bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
> +
> +       if (!prog->is_func || extra_pass) {
> +out_offset:
> +               kfree(ctx->offset);
> +               kfree(jit_data);
> +               prog->aux->jit_data =3D NULL;
> +       }
> +out:
> +       if (tmp_blinded)
> +               bpf_jit_prog_release_other(prog, prog =3D=3D orig_prog ?
> +                                          tmp : orig_prog);
> +       return prog;
> +}
> --
> 2.20.1
>
