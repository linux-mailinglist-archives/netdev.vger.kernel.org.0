Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B934A387
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCZI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCZI6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 04:58:20 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E2FC0613AA;
        Fri, 26 Mar 2021 01:58:20 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id w2so3976579ilj.12;
        Fri, 26 Mar 2021 01:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=l9gbWzCZ8sOW1i9QHPhtjOrMNdak/ShYPTyDf3NGDKA=;
        b=c+ynMnCmKrVQ1yuNyPCQ2R34kJotwByI5mKeVlXe5fmJYu7rf3JgxA6FVNJrODpZHq
         vb3c8++5tjvoVdWH71RAPsZW7w6TQF3zPCAv8Tqtw4321M3RUNuLHyFoFM3eNjdR9SiM
         EuYnZLigXKC8l2tq+eqXSbXAjqDD+LlYW33dYM6nY94YxP/QFy86YVtT1EjXBtswlYyk
         j87Aik23OGx+4/G0OyvMWpnvSchBX7D6+3OuzWOzyfe627A7xqTq8Fj2+PRdGsKGy3iD
         USFNFyJAwFcnF3tvzZFFcQXLIu2xOQE6Q+IftkGsEoAWDKb9/kmbCERbPYMWPjmN2QzV
         wGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=l9gbWzCZ8sOW1i9QHPhtjOrMNdak/ShYPTyDf3NGDKA=;
        b=mpFqo6b+siV2Iss22qyaT3ouH/i85GGvNo9cE1OJMbs7F4TeUyz/awd8yIttUJEAcb
         WTU8fyKCLk06DY0BrdfW95ntj2WrU24/nhHnofeSCEfiEV4UQSoq0y5/ilnP4wjMoMRB
         QQ0HyCo15iuPx5hDaGoI2a00JhACrjKxopS3aIG1X6Fnob6D3CKBvxhUm5uCdavUMZHw
         iKzuGLGTGhR8Chg8h2cAvKlCHOFT/99/rpqKPw+zMlny7KqZPZuYwGItW/9rXzO+gkSu
         8eOFsxSJ0r/Eg6DRPynuYEvEqInr1C3/uTAAbXeucvYrC7q0bMVW0gp4QIUGPj2WKrdp
         98wQ==
X-Gm-Message-State: AOAM531Fjuzkf9agcHZ79MrVjx/gb6IAjHTNFKhSt0sDzQpSmvzE9WSq
        3Z3i8/cmeaQ33RnMh/b76PFXQ4qVj6cIrcaZYIw=
X-Google-Smtp-Source: ABdhPJxRSRmZPkaFJ9lIZ2i2BYVsNFqjiz0yKj1NZKgvoYdQ57SsLPTRUlA6PL29NXfGRbHLKzFKHiVybIsTnfw89uA=
X-Received: by 2002:a92:d78f:: with SMTP id d15mr8934897iln.112.1616749099521;
 Fri, 26 Mar 2021 01:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210322143714.494603ed@canb.auug.org.au> <20210322090036.GB10031@zn.tnic>
In-Reply-To: <20210322090036.GB10031@zn.tnic>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 26 Mar 2021 09:57:43 +0100
Message-ID: <CA+icZUVkE73_31m0UCo-2mHOHY5i1E54_zMb7yp18UQmgN5x+A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
To:     Borislav Petkov <bp@suse.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 10:02 AM Borislav Petkov <bp@suse.de> wrote:
>
> On Mon, Mar 22, 2021 at 02:37:14PM +1100, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> >
> > arch/x86/net/bpf_jit_comp.c: In function 'arch_prepare_bpf_trampoline':
> > arch/x86/net/bpf_jit_comp.c:2015:16: error: 'ideal_nops' undeclared (first use in this function)
> >  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> >       |                ^~~~~~~~~~
> > arch/x86/net/bpf_jit_comp.c:2015:16: note: each undeclared identifier is reported only once for each function it appears in
> > arch/x86/net/bpf_jit_comp.c:2015:27: error: 'NOP_ATOMIC5' undeclared (first use in this function); did you mean 'GFP_ATOMIC'?
> >  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> >       |                           ^~~~~~~~~~~
> >       |                           GFP_ATOMIC
> >
> > Caused by commit
> >
> >   a89dfde3dc3c ("x86: Remove dynamic NOP selection")
> >
> > interacting with commit
> >
> >   b90829704780 ("bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG")
> >
> > from the net tree.
> >
> > I have applied the following merge fix patch.
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 22 Mar 2021 14:30:37 +1100
> > Subject: [PATCH] x86: fix up for "bpf: Use NOP_ATOMIC5 instead of
> >  emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG"
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index db50ab14df67..e2b5da5d441d 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -2012,7 +2012,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >               /* remember return value in a stack for bpf prog to access */
> >               emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> >               im->ip_after_call = prog;
> > -             memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> > +             memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
> >               prog += X86_PATCH_SIZE;
> >       }
> >
> > --
>
> I guess we can do the same as with the hyperv tree - the folks who send the
> respective branches to Linus in the next merge window should point to this patch
> of yours which Linus can apply after merging the second branch in order.
>
> Thx.
>

The commit b90829704780 "bpf: Use NOP_ATOMIC5 instead of
emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG" is now in Linus Git
(see [1]).

Where will Stephen's fixup-patch be carried?
Linux-next?
net-next?
<tip.git#x86/cpu>?

Thanks.

- Sedat -

[1] https://git.kernel.org/linus/b9082970478009b778aa9b22d5561eef35b53b63
