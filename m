Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC77F625E2
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfGHQNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:13:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36609 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbfGHQNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:13:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so3931041pgm.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8t0LI8f5d2yC1Ell37KaoDAT1u2qrCk09hV1h5m1t5o=;
        b=14SwpmVCFEAW+QYYzXuCkYAQ31/ZEp78hlPwaiSPUKrN4JJ9b93kY0cHVk5zrKg1mS
         Y+wixUDWvAa6udSGUeqVUFtLlpYCueOfp7RVv/y8B0vBpiiuxjJytcJjbBQ5tSioI7TU
         IbMOe4xa94Fnc9zkULY0FE4Ewj9dYx3e+jrKrtuA/RgBXV6PjaVNX1h73YWdzpNY/SXI
         KBajHmyGxkW5CSYXo8xrGXxZAJ6aMA4OAzAPgwL/Cq7l7Y0mVjrI5HJKE8juhGbsQYi6
         HWTBQaN6dIckCIaMDmoilaY48HRpold/lJw7MILvMdUlKfNMt91Kc4MSZGApw6zaqMYt
         Hhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8t0LI8f5d2yC1Ell37KaoDAT1u2qrCk09hV1h5m1t5o=;
        b=H4NAPZTZ/X0FtdoUs3fc5ptiXCrjkgldMKY/l84j4NlVXCLJjPX234BFNSyvkmUgxV
         pcip0UfyGiaVfDfocJaNdzgHMYGZ/tnu1W6OEAr1p9ZaEEfFBPQd0u642fx3QnzkEsix
         Z3pzWOqRdztuhYT794ApiDpmfPFJJ5nQbtouwCpT3WcoSvBeTHk3TN72PsuU6/UZMOPg
         tJRoPeYTR+klVV/FWYahPVyY1QA2BWICJORRJKVyvHX8OF5GeQ43I41q25JbAtvO7z9y
         rDGcXCLWZCCdj1OVdHEhRSMNnUtzMokrsv6Hr3PfYCbZdSWUXbCnyeIa4+z8XqXJ7lb2
         1VqQ==
X-Gm-Message-State: APjAAAW0OkEJcHgvYQaGY14GDN74gsCwm8nI6mhwRZHT+3xUt8MwJ4iX
        jzJVEVkDqr1XUhSOKxoZKlxLkdoM1M4=
X-Google-Smtp-Source: APXvYqxTCeIzZ2W/qBHTEFfMqxCwVIiy/cRoCD7v0m1Vc7OhF130e0EtJ36LUm3tpYyvtyjhFdZYGQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr24693864pgd.241.1562602420513;
        Mon, 08 Jul 2019 09:13:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j15sm18527333pfr.146.2019.07.08.09.13.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:13:39 -0700 (PDT)
Date:   Mon, 8 Jul 2019 09:13:38 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Y Song <ys114321@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make verifier loop tests arch
 independent
Message-ID: <20190708161338.GC29524@mini-arch>
References: <20190703205100.142904-1-sdf@google.com>
 <CAH3MdRWePmAZNRfGNcBdjKAJ+D33=4Vgg1STYC3khNps8AmaHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3MdRWePmAZNRfGNcBdjKAJ+D33=4Vgg1STYC3khNps8AmaHQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03, Y Song wrote:
> On Wed, Jul 3, 2019 at 1:51 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Take the first x bytes of pt_regs for scalability tests, there is
> > no real reason we need x86 specific rax.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/progs/loop1.c | 3 ++-
> >  tools/testing/selftests/bpf/progs/loop2.c | 3 ++-
> >  tools/testing/selftests/bpf/progs/loop3.c | 3 ++-
> >  3 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> > index dea395af9ea9..d530c61d2517 100644
> > --- a/tools/testing/selftests/bpf/progs/loop1.c
> > +++ b/tools/testing/selftests/bpf/progs/loop1.c
> > @@ -14,11 +14,12 @@ SEC("raw_tracepoint/kfree_skb")
> >  int nested_loops(volatile struct pt_regs* ctx)
> >  {
> >         int i, j, sum = 0, m;
> > +       volatile int *any_reg = (volatile int *)ctx;
> >
> >         for (j = 0; j < 300; j++)
> >                 for (i = 0; i < j; i++) {
> >                         if (j & 1)
> > -                               m = ctx->rax;
> > +                               m = *any_reg;
> 
> I agree. ctx->rax here is only to generate some operations, which
> cannot be optimized away by the compiler. dereferencing a volatile
> pointee may just serve that purpose.
> 
> Comparing the byte code generated with ctx->rax and *any_reg, they are
> slightly different. Using *any_reg is slighly worse, but this should
> be still okay for the test.
> 
> >                         else
> >                                 m = j;
> >                         sum += i * m;
> > diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> > index 0637bd8e8bcf..91bb89d901e3 100644
> > --- a/tools/testing/selftests/bpf/progs/loop2.c
> > +++ b/tools/testing/selftests/bpf/progs/loop2.c
> > @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
> >  int while_true(volatile struct pt_regs* ctx)
> >  {
> >         int i = 0;
> > +       volatile int *any_reg = (volatile int *)ctx;
> >
> >         while (true) {
> > -               if (ctx->rax & 1)
> > +               if (*any_reg & 1)
> >                         i += 3;
> >                 else
> >                         i += 7;
> > diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> > index 30a0f6cba080..3a7f12d7186c 100644
> > --- a/tools/testing/selftests/bpf/progs/loop3.c
> > +++ b/tools/testing/selftests/bpf/progs/loop3.c
> > @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
> >  int while_true(volatile struct pt_regs* ctx)
> >  {
> >         __u64 i = 0, sum = 0;
> > +       volatile __u64 *any_reg = (volatile __u64 *)ctx;
> >         do {
> >                 i++;
> > -               sum += ctx->rax;
> > +               sum += *any_reg;
> >         } while (i < 0x100000000ULL);
> >         return sum;
> >  }
> > --
> > 2.22.0.410.gd8fdbe21b5-goog
> 
> Ilya Leoshkevich (iii@linux.ibm.com, cc'ed) has another patch set
> trying to solve this problem by introducing s360 arch register access
> macros. I guess for now that patch set is not needed any more?
Oh, I missed them. Do they fix the tests for other (non-s360) arches as
well? I was trying to fix the issue by not depending on any arch
specific stuff because the test really doesn't care :-)
