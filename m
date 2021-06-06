Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1545039D116
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 21:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhFFTn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 15:43:56 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:39569 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhFFTn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 15:43:56 -0400
Received: by mail-wr1-f44.google.com with SMTP id l2so15013890wrw.6;
        Sun, 06 Jun 2021 12:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:message-id:in-reply-to:references:date:subject;
        bh=oZ1GBZrLrWXtFesbiX91BZUiYjDuBUEVaSbSR2qwXnk=;
        b=Vb7IpsFy+BRK9mzlMUFUVTpdpPwQgx02PAl7qfZN0OpzSd9XTK9vScN0k9i3S+Ur4h
         AFdi91WOX/K4e+2eMsAqEApSTWKeCHNfvZQcuadANxmO2pX+iqw81EKL6JeNmagsqWpB
         A7RAHnvFb/cQ8FdUM32kdyr8lRM9Z0WIGwCOu1Rqf7UhOTqEmUxj3tPGvyQYoK5nAOjS
         MlboEBKLlQ9zocUlka0a+QP9DeIbk7swJPuRXLDnTcpcKK1f0zGvl7O5yHbii+uH7Tmm
         umi32cSNu3n+Q2xR3Fe7h/6SJqjy0SICy8v1+9pBvuoh9KvaF0G7aBQiKv0OhFLRuIsU
         ihvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:to:from:message-id:in-reply-to:references
         :date:subject;
        bh=oZ1GBZrLrWXtFesbiX91BZUiYjDuBUEVaSbSR2qwXnk=;
        b=End6g0Ca6J0d3k7CeTrXNY+1lL72fSHcs9bqPbALsCQADC1zpjubkm+MkRPcuUI65D
         vEd8HoFlnOQEstOMLGRlElQdZFXlT5CV853YT7g5ivdcm6xJB4s9GXgb0lBRCWQsbdWK
         8ngfiXiPW/OWCUk6sGy/1BoL0QXk3LAP+M3nxJ+9UogFgxUf2htBsO76dOGn3fKIBvIt
         oMZpJvIqjJDRoQanNLedDwlvzWCg1suSLqLSDxlt22XG2em8velQFu766fTHMtiLvWJi
         TVf+Dh73kW43n3uLYgTAoTuox3+9jNH6XNqT/UgcGQSXB3iAhECHiOsyXRPbC4Ap/bmD
         TfEg==
X-Gm-Message-State: AOAM531UWn5CuymJQl/MXkiV3bxBqH3jwJt4SymQJFz91jwtXpk6ghrP
        Xb/OjFGeQWmd+CdSnlK25/A=
X-Google-Smtp-Source: ABdhPJy5jJ91aNujE1QtO1DS2ck9EWnjopyoYjaJ6DQaRnIsh7ax62b4yVNiRpDVe+DXfmwFWs3rYQ==
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr13369745wri.44.1623008448271;
        Sun, 06 Jun 2021 12:40:48 -0700 (PDT)
Received: from localhost ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id n10sm15227477wre.95.2021.06.06.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 12:40:47 -0700 (PDT)
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org
To:     syzbot+bed360704c521841c85d@syzkaller.appspotmail.com, yhs@fb.com
From:   "Kurt Manucredo" <fuzzybritches0@gmail.com>
Message-ID: <20484-14561-curtm@phaethon>
In-Reply-To: <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
Date:   Sun, 06 Jun 2021 21:15:46 +0200
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Jun 2021 10:55:25 -0700, Yonghong Song <yhs@fb.com> wrote:
> 
> 
> 
> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > kernel/bpf/core.c:1414:2.
> 
> This is not enough. We need more information on why this happens
> so we can judge whether the patch indeed fixed the issue.
> 
> > 
> > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > missing them and return with error when detected.
> > 
> > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > ---
> > 
> > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> > 
> > Changelog:
> > ----------
> > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> >       Fix commit message.
> > v3 - Make it clearer what the fix is for.
> > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >       check in check_alu_op() in verifier.c.
> > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >       check in ___bpf_prog_run().
> > 
> > thanks
> > 
> > kind regards
> > 
> > Kurt
> > 
> >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> >   1 file changed, 9 insertions(+), 21 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 94ba5163d4c5..ed0eecf20de5 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >   	u32_min_val = src_reg.u32_min_value;
> >   	u32_max_val = src_reg.u32_max_value;
> >   
> > +	if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > +			umax_val >= insn_bitness) {
> > +		/* Shifts greater than 31 or 63 are undefined.
> > +		 * This includes shifts by a negative number.
> > +		 */
> > +		verbose(env, "invalid shift %lldn", umax_val);
> > +		return -EINVAL;
> > +	}
> 
> I think your fix is good. I would like to move after
> the following code though:
> 
>          if (!src_known &&
>              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
>                  __mark_reg_unknown(env, dst_reg);
>                  return 0;
>          }
> 

It can only be right before that code not after. That's the latest. In the
case of the syzbot bug, opcode == BPF_LSH and !src_known. Therefore it
needs to be before that block of code.

> > +
> >   	if (alu32) {
> >   		src_known = tnum_subreg_is_const(src_reg.var_off);
> >   		if ((src_known &&
> > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >   		scalar_min_max_xor(dst_reg, &src_reg);
> >   		break;
> >   	case BPF_LSH:
> > -		if (umax_val >= insn_bitness) {
> > -			/* Shifts greater than 31 or 63 are undefined.
> > -			 * This includes shifts by a negative number.
> > -			 */
> > -			mark_reg_unknown(env, regs, insn->dst_reg);
> > -			break;
> > -		}
> 
> I think this is what happens. For the above case, we simply
> marks the dst reg as unknown and didn't fail verification.
> So later on at runtime, the shift optimization will have wrong
> shift value (> 31/64). Please correct me if this is not right
> analysis. As I mentioned in the early please write detailed
> analysis in commit log.
> 

Shouldn't the src reg be changed so that the shift-out-of-bounds can't
occur, if return -EINVAL is not what we want here? Changing the dst reg
might not help. If I look into kernel/bpf/core.c I can see:
	DST = DST OP SRC;

> Please also add a test at tools/testing/selftests/bpf/verifier/.
> 
I'm going to look into selftests,

kind regards
thanks,

Kurt Manucredo
