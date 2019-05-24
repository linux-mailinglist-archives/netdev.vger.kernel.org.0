Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471D229C1E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390314AbfEXQZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:25:52 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33399 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389588AbfEXQZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:25:52 -0400
Received: by mail-qk1-f196.google.com with SMTP id p18so8415380qkk.0;
        Fri, 24 May 2019 09:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ttYej1qJcIMh2aErjoDEWFewc3N0q3PgxxXI/yC/lTU=;
        b=qrYESdVDuSLtCNwlBbog+NOjCXMnxkakrZNXfPuIWFMzQ5JHCGnSm1vjcy+yP5reue
         b1S0zLfNIUFgy4PndFHyshZR2vMZa1+nv/iYBHziqqQyd3fsA7FhivN8J87fbbsYDGmH
         jjpyLOJYdQoG9PHoRhpCUs2SVYx9ruCZRzboVqqaZOq9RyqKYfz20YVXAc2c7pCujSAq
         FWCIRCes1By3FiJ0yNhnxDWvIiK8WuiS9hFFblrFRyUM+h8HvdVET7wWiD5R9PVRt/DW
         lSlTgAcPj8/vU7PuIRNoQZZoQMSPwJ+XT8OxlRA6Z4le0q2KXClrvpMPIZuyhnnpYdQZ
         VIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ttYej1qJcIMh2aErjoDEWFewc3N0q3PgxxXI/yC/lTU=;
        b=VfIo30EPodbVnE5Yo8X+GR+L0Ga797lHcsHbfoqqfUEmo5hEKi8BBMyo83iivSz3ii
         LZRwp7wE9OWWc5ElL5QzrrhMkvXHPdaUm3/Dm8L7E5u8QO3G/fLAWJ4r7p7urjLpY1xn
         odfnOY+qBHyWE9mgIrGmVeeHNebZxFCwhb/Ou+MHpRBwL5aV5whsndnoeqlt86BnlZqP
         gQ2AqJfVUuDOuo86PVyKhqFzmPGtS7DIvLfWDv9L+ch4BdUEeYRDi34KlTIsq+CBpyi8
         +ySUhTsmFxl/s0UudvZXVpddjJqQ3sW1qG/3PnRHab2TQxlmDTS+uiMWdy8kOW2n/SXB
         TC2Q==
X-Gm-Message-State: APjAAAXpXVvbYFVKMrLJrcoxSfZ6H+0ud2NTY2SgHV0GDDlf9aM1W51T
        j2Vw7ZQLDEIqLsoaUmLm0/vJ2Nove6hobEPHll/A+MMGtkY=
X-Google-Smtp-Source: APXvYqylTsvZbr2RcG7oq3YntnDGPeHGkK7tIlac/kZaHqMIs6QGE6Af/qtbhOMYvfp/Y4HIeRjyKmp0JrEpHT9EhI4=
X-Received: by 2002:aed:21b8:: with SMTP id l53mr86955472qtc.36.1558715150976;
 Fri, 24 May 2019 09:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com> <1558697726-4058-16-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1558697726-4058-16-git-send-email-jiong.wang@netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 24 May 2019 18:25:39 +0200
Message-ID: <CAJ+HfNjJ6hoDvcjbU7yELDrzWhxXmyG44TcvBRL4OO1035U5fw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 15/16] riscv: bpf: eliminate zero extension code-gen
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, David Miller <davem@davemloft.net>,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 at 13:36, Jiong Wang <jiong.wang@netronome.com> wrote:
>
> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 43 ++++++++++++++++++++++++++++++-------=
------
>  1 file changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.=
c
> index 80b12aa..c4c836e 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -731,6 +731,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>  {
>         bool is64 =3D BPF_CLASS(insn->code) =3D=3D BPF_ALU64 ||
>                     BPF_CLASS(insn->code) =3D=3D BPF_JMP;
> +       struct bpf_prog_aux *aux =3D ctx->prog->aux;
>         int rvoff, i =3D insn - ctx->prog->insnsi;
>         u8 rd =3D -1, rs =3D -1, code =3D insn->code;
>         s16 off =3D insn->off;
> @@ -742,8 +743,13 @@ static int emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>         /* dst =3D src */
>         case BPF_ALU | BPF_MOV | BPF_X:
>         case BPF_ALU64 | BPF_MOV | BPF_X:
> +               if (imm =3D=3D 1) {
> +                       /* Special mov32 for zext */
> +                       emit_zext_32(rd, ctx);
> +                       break;
> +               }

Hmm, missing is64 check here (fall-through for 64-bit movs)?

Bj=C3=B6rn

>                 emit(is64 ? rv_addi(rd, rs, 0) : rv_addiw(rd, rs, 0), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>
> @@ -771,19 +777,19 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>         case BPF_ALU | BPF_MUL | BPF_X:
>         case BPF_ALU64 | BPF_MUL | BPF_X:
>                 emit(is64 ? rv_mul(rd, rd, rs) : rv_mulw(rd, rd, rs), ctx=
);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_DIV | BPF_X:
>         case BPF_ALU64 | BPF_DIV | BPF_X:
>                 emit(is64 ? rv_divu(rd, rd, rs) : rv_divuw(rd, rd, rs), c=
tx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_MOD | BPF_X:
>         case BPF_ALU64 | BPF_MOD | BPF_X:
>                 emit(is64 ? rv_remu(rd, rd, rs) : rv_remuw(rd, rd, rs), c=
tx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_LSH | BPF_X:
> @@ -867,7 +873,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>         case BPF_ALU | BPF_MOV | BPF_K:
>         case BPF_ALU64 | BPF_MOV | BPF_K:
>                 emit_imm(rd, imm, ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>
> @@ -882,7 +888,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                         emit(is64 ? rv_add(rd, rd, RV_REG_T1) :
>                              rv_addw(rd, rd, RV_REG_T1), ctx);
>                 }
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_SUB | BPF_K:
> @@ -895,7 +901,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                         emit(is64 ? rv_sub(rd, rd, RV_REG_T1) :
>                              rv_subw(rd, rd, RV_REG_T1), ctx);
>                 }
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_AND | BPF_K:
> @@ -906,7 +912,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                         emit_imm(RV_REG_T1, imm, ctx);
>                         emit(rv_and(rd, rd, RV_REG_T1), ctx);
>                 }
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_OR | BPF_K:
> @@ -917,7 +923,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                         emit_imm(RV_REG_T1, imm, ctx);
>                         emit(rv_or(rd, rd, RV_REG_T1), ctx);
>                 }
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_XOR | BPF_K:
> @@ -928,7 +934,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                         emit_imm(RV_REG_T1, imm, ctx);
>                         emit(rv_xor(rd, rd, RV_REG_T1), ctx);
>                 }
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_MUL | BPF_K:
> @@ -936,7 +942,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, imm, ctx);
>                 emit(is64 ? rv_mul(rd, rd, RV_REG_T1) :
>                      rv_mulw(rd, rd, RV_REG_T1), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_DIV | BPF_K:
> @@ -944,7 +950,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, imm, ctx);
>                 emit(is64 ? rv_divu(rd, rd, RV_REG_T1) :
>                      rv_divuw(rd, rd, RV_REG_T1), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_MOD | BPF_K:
> @@ -952,7 +958,7 @@ static int emit_insn(const struct bpf_insn *insn, str=
uct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, imm, ctx);
>                 emit(is64 ? rv_remu(rd, rd, RV_REG_T1) :
>                      rv_remuw(rd, rd, RV_REG_T1), ctx);
> -               if (!is64)
> +               if (!is64 && !aux->verifier_zext)
>                         emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_LSH | BPF_K:
> @@ -1239,6 +1245,8 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, off, ctx);
>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>                 emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
> +               if (insn_is_zext(&insn[1]))
> +                       return 1;
>                 break;
>         case BPF_LDX | BPF_MEM | BPF_H:
>                 if (is_12b_int(off)) {
> @@ -1249,6 +1257,8 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, off, ctx);
>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>                 emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
> +               if (insn_is_zext(&insn[1]))
> +                       return 1;
>                 break;
>         case BPF_LDX | BPF_MEM | BPF_W:
>                 if (is_12b_int(off)) {
> @@ -1259,6 +1269,8 @@ static int emit_insn(const struct bpf_insn *insn, s=
truct rv_jit_context *ctx,
>                 emit_imm(RV_REG_T1, off, ctx);
>                 emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
>                 emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
> +               if (insn_is_zext(&insn[1]))
> +                       return 1;
>                 break;
>         case BPF_LDX | BPF_MEM | BPF_DW:
>                 if (is_12b_int(off)) {
> @@ -1503,6 +1515,11 @@ static void bpf_flush_icache(void *start, void *en=
d)
>         flush_icache_range((unsigned long)start, (unsigned long)end);
>  }
>
> +bool bpf_jit_needs_zext(void)
> +{
> +       return true;
> +}
> +
>  struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
>         bool tmp_blinded =3D false, extra_pass =3D false;
> --
> 2.7.4
>
