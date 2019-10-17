Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549DCDB4AF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436896AbfJQRsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:48:37 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42821 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388605AbfJQRsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:48:36 -0400
Received: by mail-qk1-f195.google.com with SMTP id f16so2669808qkl.9;
        Thu, 17 Oct 2019 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LI50GmJZPXJoNhsatDYdTGpxhAC90h+gBys8QNPquo=;
        b=jw/rCWzf1Y4gYRjD0aQ6Ijx79toEwLkJCD0+65e+pCkpcVWzN9xLHrSO4fS1MDP4g+
         1Nh6Hn/I2pkMBR2U0Y2zUZsD+jUl/yXOhkYZ71HuJQY2gh6mv+swGgJssammMprm9C0c
         4D/RQmQgzbGMbW4AmdPKkaqqZ8jxyayiC2w8v9iDnKJhRW/p5bfdYX3CkPex71Qd5M0L
         3ZnT10sy9dIl1igLG3QTgyNGlsGGkevPJ9NNmFzFRvSBd+PxNykm1lkkH/JItVtEPfb+
         b43tFWGumvwW7tllMhrMUjv9Q/LpSR8/e4+KHvxLtRdDAwm9VUdPwj0z49V9ksftAzwU
         IWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LI50GmJZPXJoNhsatDYdTGpxhAC90h+gBys8QNPquo=;
        b=BSQSABoWpd2xwn4c/LhgRmwsxtMElQYheMTFsIkkrSsKInhL+TofQTlbs1dxMIDjX0
         puHTnF3YL5Hdx+gRBCfXEszLBd/6cfOzJg8F256FuoXJyZdIJVBqqK8vZ3h2oLOImcLq
         8iRhttfVSBZs0A90uy/1LUWBCI6OlHDYXpbzLrwD0pGK0TmyixrpeeCS6eBFVJE5b0zD
         gcTIy+CeXp5tLc11lFGpWtXRRr+7jTP262rC0r5/xJIYltBmiTuGDcVS/mYPZ36VS7Bd
         hF/zeh+bsAojqRRX5kzxo1oaq1KOWPC8ufJe69BAioJzb3A82ewHSkmRg/cxQdqVm8Ko
         lubQ==
X-Gm-Message-State: APjAAAVsWU/IdU+UQ1ytFmxpATlNX2X2cYE3pQ/hTALVTL191eF3KK3J
        E4w61jsMIK29DlZV8YXzgtpjLtkV7zcW2Tyk/jIbsF2J
X-Google-Smtp-Source: APXvYqw5Lb5mk9I/fxf23Nhk6rqCTYmj8hGv7XgWuCLQ68nNBZtNmvcoOGQUYDMm7FMKQ1MipW9lyPlGE0YyRS07kJw=
X-Received: by 2002:a37:b447:: with SMTP id d68mr4566199qkf.437.1571334514964;
 Thu, 17 Oct 2019 10:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <20191016060051.2024182-6-andriin@fb.com>
 <20191016163249.GD1897241@mini-arch> <CAEf4BzYVWc8RWNSthN8whROYJUEijR1Uh3Lyt6bkuhM2tRsq2Q@mail.gmail.com>
 <20191017160716.GA2090@mini-arch>
In-Reply-To: <20191017160716.GA2090@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Oct 2019 10:48:23 -0700
Message-ID: <CAEf4BzYSUoN2Boy-iveFAFGiiAMta5S9SK8aGO1BMnd+q2FzbA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 9:07 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/16, Andrii Nakryiko wrote:
> > On Wed, Oct 16, 2019 at 9:32 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 10/15, Andrii Nakryiko wrote:
> > > > Define test runner generation meta-rule that codifies dependencies
> > > > between test runner, its tests, and its dependent BPF programs. Use that
> > > > for defining test_progs and test_maps test-runners. Also additionally define
> > > > 2 flavors of test_progs:
> > > > - alu32, which builds BPF programs with 32-bit registers codegen;
> > > > - bpf_gcc, which build BPF programs using GCC, if it supports BPF target.
> > > Question:
> > >
> > > Why not merge test_maps tests into test_progs framework and have a
> > > single binary instead of doing all this makefile-related work?
> > > We can independently address the story with alu32/gcc progs (presumably
> > > in the same manner, with make defines).
> >
> > test_maps wasn't a reason for doing this, alue2/bpf_gcc was. test_maps
> > is a simple sub-case that was just easy to convert to. I dare you to
> > try solve alu32/bpf_gcc with make defines (whatever you mean by that)
> > and in a simpler manner ;)
> I think my concern comes from the fact that I don't really understand why
> we need all that complexity (and the problem you're solving for alu/gcc;
> part of that is that you're replacing everything, so it's hard to
> understand what's the real diff).
>
> In particular, why do we need to compile test_progs 3 times for
> normal/alu32/gcc? Isn't it the same test_progs? Can we just teach test_progs
> to run the tests for 3 output dirs with different versions of BPF programs?
> (kind of like you do in your first patch with -<flavor>, but just in a loop).

So that's a good question and the answer is "no, we can't". And that's
why I consider alu32/bpf_gcc broken. Check progs/test_attach_probe.c,
it does BPF_OBJECT_EMBED, which links BPF object into test object
file. This means that if we want to compile BPF objects differently
between default/alu32/gcc flavors, we need to compile test_progs
independently. Embedding objects is going to be prevalent way to
consume them (and it is already the only way we consume them in
production at FB), so we need to accommodate it. With some more
usability improvements that's on my TODO list, it will become also
much more convenient and easy to consume such BPF objects.

>
> > > I can hardly follow the existing makefile and now with the evals it's
> > > 10x more complicated for no good reason.
> >
> > I agree that existing Makefile logic is hard to follow, especially
> > given it's broken. But I think 10x more complexity is gross
> > exaggeration and just means you haven't tried to follow rules' logic.
> Not 10x, but it does raise a complexity bar. I tried to follow the
> rules, but I admit that I didn't try too hard :-)

So see my explanation above about why we need to compile flavors
independently. Rules have to be like they are here. I'd like to make
dependencies between test objects and BPF objects a bit more granular,
but only after we land this, it's already quite a lot of changes at
once.

Beyond fixing the rules, $(eval)/$(call) is a new stuff for
selftests/bpf's Makefile, but it's semantics is well described in
documentation and you can gloss over it for now, it shouldn't break
with Makefile changes.

>
> > The rules inside DEFINE_TEST_RUNNER_RULES are exactly (minus one or
> > two ifs to prevent re-definition of target) the rules that should have
> > been written for test_progs, test_progs-alu32, test_progs-bpf_gcc.
> > They define a chain of BPF .c -> BPF .o -> tests .c -> tests .o ->
> > final binary + test.h generation. Previously we were getting away with
> > this for, e.g., test_progs-alu32, because we always also built
> > test_progs in parallel, which generated necessary stuff. Now with
> > recent changes to test_attach_probe.c which now embeds BPF .o file,
> > this doesn't work anymore. And it's going to be more and more
> > prevalent form, so we need to fix it.
> >
> > Surely $(eval) and $(call) are not common for simple Makefiles, but
> > just ignore it, we need that to only dynamically generate
> > per-test-runner rules. DEFINE_TEST_RUNNER_RULES can be almost read
> > like a normal Makefile definitions, module $$(VAR) which is turned
> > into a normal $(VAR) upon $(call) evaluation.
> >
> > But really, I'd like to be wrong and if there is simpler way to
> > achieve the same - go for it, I'll gladly review and ack.
> Again, it probably comes from the fact that I don't see the problem
> you're solving. Can we start by removing 3 test_progs variations
> (somthing like patch below)? If we can do it, then the leftover parts
> that generate alu32/gcc bpf program don't look too bad and can probably
> be tweaked without makefile codegen.

Yes, it probably is. See above, I tried to give more context.

I've fixed some other inconveniences with current Makefile set up
(e.g., on-demand bpf_helper_defs.h re-generation, etc), but those are
minor changes and it was hard to de-couple from the main change.

>
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -157,26 +157,10 @@ TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
>

[...]

>  endif
>
> > Please truncate irrelevant parts, easier to review.
> Sure, will do, but I always forget because I don't have this problem.
> In mutt I can press shift+s to jump to the next unquoted section.

no worries, but with a bit of recurring reminder it becomes easier, I
know from my own experience :)
