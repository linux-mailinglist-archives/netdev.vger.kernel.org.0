Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C725D1299BC
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLWSDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:03:34 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37365 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfLWSDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:03:33 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so7469557plz.4
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=SX6xGdHWcUslbOaZq1936ovi75UbfYkq2eUPLIzVJRg=;
        b=kwWoa9JLAwA2Fb4ueybvidyLBDjAom2y7rtrkUmXqoNCNQ4PePSEKVHfvXHbWf3YEU
         RqPerjfpOplXJEkVt+HR7D7yRn9uk4GlH7TaC0gXdunW20mhtvB70x1gwS+0J3ueyDWH
         WAaHYK8PbPy89DNEN+XXBumey+UTPTSEc+i1Xk+3yKhsNItj6MmAxVSX2Aof7KcAhFUb
         Dmb8cXYP4fiYzpicRhaO8sNbf6oGC0igBXAAWDv851+6DP7z3GSHJqAORB7Tc57P/VH4
         hVgE1y1tyJ+oRFQX1ejtsj3ry3KRShHSpfNMNI3fYttUU2gA9YAuLlUT9SqNGjRLoxdX
         Pi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=SX6xGdHWcUslbOaZq1936ovi75UbfYkq2eUPLIzVJRg=;
        b=mPRov9hZflTrZaNs/+Ba5TDi01SRPeG4qBiVhtTTSZUbOkKCkwbfzn4oK0RljxbHNE
         PXQ3oRkunLldTG9sbg2ead//RSwJe8K1A+9wuzuyYtGyBq8xx7n1nyBclNj8K/NDXDKy
         fkjuTgymOdUtaEjb+yjLxPW/Ig/10SkiNqGWoIqNBHFY07VD+nujRRfHsXb+dZIf9Tro
         IBZU0FCL+omOCTyzOT3AAhe/X46SiiUdeEClC26/hy6Tz3QceYql/GiXNTfKw8qhXtL6
         DIjQf9MG9ZPaRYyzKxpVMEDWGsN1xT+h0hZHZ112CSCcUm7f346aVrc9Az8KpZe5rb8K
         eBBw==
X-Gm-Message-State: APjAAAWkQegiPbLFb7UQK6GeR+inppo3c3EZjn055e2SXA8cOBRoIlrt
        Soj735fknWURZctrbEXKI64pgng2vzc=
X-Google-Smtp-Source: APXvYqzgXBk/wo2vTnIy3t9wEaW/hHRyc4vt8FDumRtGKTRJ6zmBfemhU4yg1fwRxDlKKCexPmcNrQ==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr23865135plv.322.1577124212093;
        Mon, 23 Dec 2019 10:03:32 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id h12sm10439980pfo.12.2019.12.23.10.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 10:03:31 -0800 (PST)
Date:   Mon, 23 Dec 2019 10:03:31 -0800 (PST)
X-Google-Original-Date: Mon, 23 Dec 2019 10:03:28 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH bpf-next v2 2/9] riscv, bpf: add support for far branching
CC:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        Bjorn Topel <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, lukenels@cs.washington.edu,
        bpf@vger.kernel.org, xi.wang@gmail.com
To:     Bjorn Topel <bjorn.topel@gmail.com>
In-Reply-To: <20191216091343.23260-3-bjorn.topel@gmail.com>
References: <20191216091343.23260-3-bjorn.topel@gmail.com>
  <20191216091343.23260-1-bjorn.topel@gmail.com>
Message-ID: <mhng-6be38b2a-78df-4016-aaea-f35aa0acd7e0@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 01:13:36 PST (-0800), Bjorn Topel wrote:
> This commit adds branch relaxation to the BPF JIT, and with that
> support for far (offset greater than 12b) branching.

Interesting.  We don't actually relax these in the binutils linker, but instead
just do it staticly at assembly time...

> The branch relaxation requires more than two passes to converge. For
> most programs it is three passes, but for larger programs it can be
> more.

... and that's why :).  In binutils we just worst-case the link-time
relaxations when doing assembler relaxation, which proves to be good enough.  C
code doesn't branch outside a function, so most branches end up fairly short
anyway.

> Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 352 ++++++++++++++++++----------------
>  1 file changed, 188 insertions(+), 164 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index 1606ebd49666..e599458a9bcd 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -461,6 +461,11 @@ static u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
>  	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
>  }
>
> +static u32 rv_auipc(u8 rd, u32 imm31_12)
> +{
> +	return rv_u_insn(imm31_12, rd, 0x17);
> +}
> +
>  static bool is_12b_int(s64 val)
>  {
>  	return -(1 << 11) <= val && val < (1 << 11);
> @@ -484,7 +489,7 @@ static bool is_32b_int(s64 val)
>  static int is_12b_check(int off, int insn)
>  {
>  	if (!is_12b_int(off)) {
> -		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
> +		pr_err("bpf-jit: insn=%d 12b < offset=%d not supported yet!\n",
>  		       insn, (int)off);
>  		return -1;
>  	}
> @@ -494,7 +499,7 @@ static int is_12b_check(int off, int insn)
>  static int is_13b_check(int off, int insn)
>  {
>  	if (!is_13b_int(off)) {
> -		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
> +		pr_err("bpf-jit: insn=%d 13b < offset=%d not supported yet!\n",
>  		       insn, (int)off);
>  		return -1;
>  	}
> @@ -504,7 +509,7 @@ static int is_13b_check(int off, int insn)
>  static int is_21b_check(int off, int insn)
>  {
>  	if (!is_21b_int(off)) {
> -		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
> +		pr_err("bpf-jit: insn=%d 21b < offset=%d not supported yet!\n",
>  		       insn, (int)off);
>  		return -1;
>  	}
> @@ -550,10 +555,13 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
>  		emit(rv_addi(rd, rd, lower), ctx);
>  }
>
> -static int rv_offset(int bpf_to, int bpf_from, struct rv_jit_context *ctx)
> +static int rv_offset(int insn, int off, struct rv_jit_context *ctx)
>  {
> -	int from = ctx->offset[bpf_from] - 1, to = ctx->offset[bpf_to];
> +	int from, to;
>
> +	off++; /* BPF branch is from PC+1, RV is from PC */
> +	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
> +	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
>  	return (to - from) << 2;
>  }
>
> @@ -606,6 +614,109 @@ static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
>  	emit(rv_jalr(RV_REG_ZERO, reg, 0), ctx);
>  }
>
> +/* return -1 or inverted cond */
> +static int invert_bpf_cond(u8 cond)
> +{
> +	switch (cond) {
> +	case BPF_JEQ:
> +		return BPF_JNE;
> +	case BPF_JGT:
> +		return BPF_JLE;
> +	case BPF_JLT:
> +		return BPF_JGE;
> +	case BPF_JGE:
> +		return BPF_JLT;
> +	case BPF_JLE:
> +		return BPF_JGT;
> +	case BPF_JNE:
> +		return BPF_JEQ;
> +	case BPF_JSGT:
> +		return BPF_JSLE;
> +	case BPF_JSLT:
> +		return BPF_JSGE;
> +	case BPF_JSGE:
> +		return BPF_JSLT;
> +	case BPF_JSLE:
> +		return BPF_JSGT;
> +	}
> +	return -1;
> +}
> +
> +static void emit_bcc(u8 cond, u8 rd, u8 rs, int rvoff,
> +		     struct rv_jit_context *ctx)
> +{
> +	switch (cond) {
> +	case BPF_JEQ:
> +		emit(rv_beq(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JGT:
> +		emit(rv_bltu(rs, rd, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JLT:
> +		emit(rv_bltu(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JGE:
> +		emit(rv_bgeu(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JLE:
> +		emit(rv_bgeu(rs, rd, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JNE:
> +		emit(rv_bne(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JSGT:
> +		emit(rv_blt(rs, rd, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JSLT:
> +		emit(rv_blt(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JSGE:
> +		emit(rv_bge(rd, rs, rvoff >> 1), ctx);
> +		return;
> +	case BPF_JSLE:
> +		emit(rv_bge(rs, rd, rvoff >> 1), ctx);
> +	}
> +}
> +
> +static void emit_branch(u8 cond, u8 rd, u8 rs, int rvoff,
> +			struct rv_jit_context *ctx)
> +{
> +	s64 upper, lower;
> +
> +	if (is_13b_int(rvoff)) {
> +		emit_bcc(cond, rd, rs, rvoff, ctx);
> +		return;
> +	}
> +
> +	/* Adjust for jal */
> +	rvoff -= 4;
> +
> +	/* Transform, e.g.:
> +	 *   bne rd,rs,foo
> +	 * to
> +	 *   beq rd,rs,<.L1>
> +	 *   (auipc foo)
> +	 *   jal(r) foo
> +	 * .L1
> +	 */
> +	cond = invert_bpf_cond(cond);
> +	if (is_21b_int(rvoff)) {
> +		emit_bcc(cond, rd, rs, 8, ctx);
> +		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
> +		return;
> +	}
> +
> +	/* 32b No need for an additional rvoff adjustment, since we
> +	 * get that from the auipc at PC', where PC = PC' + 4.
> +	 */
> +	upper = (rvoff + (1 << 11)) >> 12;
> +	lower = rvoff & 0xfff;
> +
> +	emit_bcc(cond, rd, rs, 12, ctx);
> +	emit(rv_auipc(RV_REG_T1, upper), ctx);
> +	emit(rv_jalr(RV_REG_ZERO, RV_REG_T1, lower), ctx);
> +}
> +
>  static void emit_zext_32(u8 reg, struct rv_jit_context *ctx)
>  {
>  	emit(rv_slli(reg, reg, 32), ctx);
> @@ -693,13 +804,6 @@ static void init_regs(u8 *rd, u8 *rs, const struct bpf_insn *insn,
>  		*rs = bpf_to_rv_reg(insn->src_reg, ctx);
>  }
>
> -static int rv_offset_check(int *rvoff, s16 off, int insn,
> -			   struct rv_jit_context *ctx)
> -{
> -	*rvoff = rv_offset(insn + off, insn, ctx);
> -	return is_13b_check(*rvoff, insn);
> -}
> -
>  static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ctx)
>  {
>  	emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
> @@ -732,13 +836,19 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
>  	*rd = RV_REG_T2;
>  }
>
> +static bool is_signed_bpf_cond(u8 cond)
> +{
> +	return cond == BPF_JSGT || cond == BPF_JSLT ||
> +		cond == BPF_JSGE || cond == BPF_JSLE;
> +}
> +
>  static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  		     bool extra_pass)
>  {
>  	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
>  		    BPF_CLASS(insn->code) == BPF_JMP;
> +	int s, e, rvoff, i = insn - ctx->prog->insnsi;
>  	struct bpf_prog_aux *aux = ctx->prog->aux;
> -	int rvoff, i = insn - ctx->prog->insnsi;
>  	u8 rd = -1, rs = -1, code = insn->code;
>  	s16 off = insn->off;
>  	s32 imm = insn->imm;
> @@ -1006,7 +1116,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>
>  	/* JUMP off */
>  	case BPF_JMP | BPF_JA:
> -		rvoff = rv_offset(i + off, i, ctx);
> +		rvoff = rv_offset(i, off, ctx);
>  		if (!is_21b_int(rvoff)) {
>  			pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
>  			       i, rvoff);
> @@ -1019,194 +1129,96 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  	/* IF (dst COND src) JUMP off */
>  	case BPF_JMP | BPF_JEQ | BPF_X:
>  	case BPF_JMP32 | BPF_JEQ | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_beq(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JGT | BPF_X:
>  	case BPF_JMP32 | BPF_JGT | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bltu(rs, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JLT | BPF_X:
>  	case BPF_JMP32 | BPF_JLT | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bltu(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JGE | BPF_X:
>  	case BPF_JMP32 | BPF_JGE | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bgeu(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JLE | BPF_X:
>  	case BPF_JMP32 | BPF_JLE | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bgeu(rs, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JNE | BPF_X:
>  	case BPF_JMP32 | BPF_JNE | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bne(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSGT | BPF_X:
>  	case BPF_JMP32 | BPF_JSGT | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_sext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_blt(rs, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSLT | BPF_X:
>  	case BPF_JMP32 | BPF_JSLT | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_sext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_blt(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSGE | BPF_X:
>  	case BPF_JMP32 | BPF_JSGE | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_sext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bge(rd, rs, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSLE | BPF_X:
>  	case BPF_JMP32 | BPF_JSLE | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_sext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_bge(rs, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSET | BPF_X:
>  	case BPF_JMP32 | BPF_JSET | BPF_X:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		if (!is64)
> -			emit_zext_32_rd_rs(&rd, &rs, ctx);
> -		emit(rv_and(RV_REG_T1, rd, rs), ctx);
> -		emit(rv_bne(RV_REG_T1, RV_REG_ZERO, rvoff >> 1), ctx);
> +		rvoff = rv_offset(i, off, ctx);
> +		if (!is64) {
> +			s = ctx->ninsns;
> +			if (is_signed_bpf_cond(BPF_OP(code)))
> +				emit_sext_32_rd_rs(&rd, &rs, ctx);
> +			else
> +				emit_zext_32_rd_rs(&rd, &rs, ctx);
> +			e = ctx->ninsns;
> +
> +			/* Adjust for extra insns */
> +			rvoff -= (e - s) << 2;
> +		}
> +
> +		if (BPF_OP(code) == BPF_JSET) {
> +			/* Adjust for and */
> +			rvoff -= 4;
> +			emit(rv_and(RV_REG_T1, rd, rs), ctx);
> +			emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff,
> +				    ctx);
> +		} else {
> +			emit_branch(BPF_OP(code), rd, rs, rvoff, ctx);
> +		}
>  		break;
>
>  	/* IF (dst COND imm) JUMP off */
>  	case BPF_JMP | BPF_JEQ | BPF_K:
>  	case BPF_JMP32 | BPF_JEQ | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_beq(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JGT | BPF_K:
>  	case BPF_JMP32 | BPF_JGT | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_bltu(RV_REG_T1, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JLT | BPF_K:
>  	case BPF_JMP32 | BPF_JLT | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_bltu(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JGE | BPF_K:
>  	case BPF_JMP32 | BPF_JGE | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_bgeu(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JLE | BPF_K:
>  	case BPF_JMP32 | BPF_JLE | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_bgeu(RV_REG_T1, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JNE | BPF_K:
>  	case BPF_JMP32 | BPF_JNE | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_bne(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSGT | BPF_K:
>  	case BPF_JMP32 | BPF_JSGT | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_sext_32_rd(&rd, ctx);
> -		emit(rv_blt(RV_REG_T1, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSLT | BPF_K:
>  	case BPF_JMP32 | BPF_JSLT | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_sext_32_rd(&rd, ctx);
> -		emit(rv_blt(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSGE | BPF_K:
>  	case BPF_JMP32 | BPF_JSGE | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_sext_32_rd(&rd, ctx);
> -		emit(rv_bge(rd, RV_REG_T1, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSLE | BPF_K:
>  	case BPF_JMP32 | BPF_JSLE | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> -		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_sext_32_rd(&rd, ctx);
> -		emit(rv_bge(RV_REG_T1, rd, rvoff >> 1), ctx);
> -		break;
>  	case BPF_JMP | BPF_JSET | BPF_K:
>  	case BPF_JMP32 | BPF_JSET | BPF_K:
> -		if (rv_offset_check(&rvoff, off, i, ctx))
> -			return -1;
> +		rvoff = rv_offset(i, off, ctx);
> +		s = ctx->ninsns;
>  		emit_imm(RV_REG_T1, imm, ctx);
> -		if (!is64)
> -			emit_zext_32_rd_t1(&rd, ctx);
> -		emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
> -		emit(rv_bne(RV_REG_T1, RV_REG_ZERO, rvoff >> 1), ctx);
> +		if (!is64) {
> +			if (is_signed_bpf_cond(BPF_OP(code)))
> +				emit_sext_32_rd(&rd, ctx);
> +			else
> +				emit_zext_32_rd_t1(&rd, ctx);
> +		}
> +		e = ctx->ninsns;
> +
> +		/* Adjust for extra insns */
> +		rvoff -= (e - s) << 2;
> +
> +		if (BPF_OP(code) == BPF_JSET) {
> +			/* Adjust for and */
> +			rvoff -= 4;
> +			emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
> +			emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff,
> +				    ctx);
> +		} else {
> +			emit_branch(BPF_OP(code), rd, RV_REG_T1, rvoff, ctx);
> +		}
>  		break;
>
>  	/* function call */
> @@ -1557,6 +1569,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  {
>  	bool tmp_blinded = false, extra_pass = false;
>  	struct bpf_prog *tmp, *orig_prog = prog;
> +	int pass = 0, prev_ninsns = 0, i;
>  	struct rv_jit_data *jit_data;
>  	struct rv_jit_context *ctx;
>  	unsigned int image_size;
> @@ -1596,15 +1609,25 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  		prog = orig_prog;
>  		goto out_offset;
>  	}
> +	for (i = 0; i < prog->len; i++) {
> +		prev_ninsns += 32;
> +		ctx->offset[i] = prev_ninsns;
> +	}

It feels like the first-order implementation is the same as binutils here: the
first round is worst cased, after which things can be more exact.  We're only
doing one pass in binutils because most of the relaxation happens in the
linker, but this approach seems reasonable to me.  I'd be interested in seeing
some benchmarks, as it may be worth relaxing these in the binutils linker as
well -- I can certainly come up with contrived test cases that aren't relaxed,
but I'm not sure how common this is.

My only worry is that that invariant should be more explicit.  Specifically,
I'm thinking that every time offset is updated there should be some sort of
assertion that the offset is shrinking.  This is enforced structurally in the
binutils code because we only generate code once and then move it around, but
since you're generating code every time it'd be easy for a bug to sneak in as
the JIT gets more complicated.

Since most of the branches should be forward, you'll probably end up with way
fewer iterations if you do the optimization passes backwards.

> -	/* First pass generates the ctx->offset, but does not emit an image. */
> -	if (build_body(ctx, extra_pass)) {
> -		prog = orig_prog;
> -		goto out_offset;
> +	for (i = 0; i < 16; i++) {
> +		pass++;
> +		ctx->ninsns = 0;
> +		if (build_body(ctx, extra_pass)) {
> +			prog = orig_prog;
> +			goto out_offset;

Isn't this returning a broken program if build_body() errors out the first time
through?

> +		}
> +		build_prologue(ctx);
> +		ctx->epilogue_offset = ctx->ninsns;
> +		build_epilogue(ctx);
> +		if (ctx->ninsns == prev_ninsns)
> +			break;
> +		prev_ninsns = ctx->ninsns;

IDK how important the performance of the JIT is, but you could probably get
away with skipping an iteration by keeping track of some simple metric that
determines if it would be possible to 

>  	}
> -	build_prologue(ctx);
> -	ctx->epilogue_offset = ctx->ninsns;
> -	build_epilogue(ctx);
>
>  	/* Allocate image, now that we know the size. */
>  	image_size = sizeof(u32) * ctx->ninsns;
> @@ -1619,6 +1642,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	/* Second, real pass, that acutally emits the image. */
>  	ctx->insns = (u32 *)jit_data->image;
>  skip_init_ctx:
> +	pass++;
>  	ctx->ninsns = 0;
>
>  	build_prologue(ctx);
> @@ -1630,7 +1654,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	build_epilogue(ctx);
>
>  	if (bpf_jit_enable > 1)
> -		bpf_jit_dump(prog->len, image_size, 2, ctx->insns);
> +		bpf_jit_dump(prog->len, image_size, pass, ctx->insns);
>
>  	prog->bpf_func = (void *)ctx->insns;
>  	prog->jited = 1;
