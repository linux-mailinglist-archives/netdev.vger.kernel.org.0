Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBED4A361
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfFROFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:05:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32798 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfFROF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:05:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so14179875wru.0;
        Tue, 18 Jun 2019 07:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=18SK1qRSJEvJYwBVfAw5XTYfSEQMIGF5hpJ1dG+VLr4=;
        b=AFgiShRed81tyodvP4V1FR57IrPg4vwlECgHKtIt+Ps4vWSDwbDASQ9MuzLfmGUlpJ
         IFkplBDUqH2MngSg/aBEW3Kf25Stz2ux6Yxtq1vzPDeXvf4BfWul3gJ8bJJaYVwVrgPh
         GCfzgxO8rAcUiTtsLhKAvKlbhomeMpZYj8x9COtIF88vPuh6ArKeM11d1W8jqIeWu+ft
         rpSZO5rJL0Vu7mWYEwyqKpvgSTYd/CNM1e5hOGq/OIPafV0lXuXwnFgM+7Y6GAHbfG1v
         09aAbPTDAMbnUXqkOePVMvcxK9kd8yM6CmMdbeEWRqbQq1vWW/FHJlM5jlS1UqTXwP4o
         BeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=18SK1qRSJEvJYwBVfAw5XTYfSEQMIGF5hpJ1dG+VLr4=;
        b=D0Gjk/1hNmH7sVKOjPFKdNrYmptTWuYvyygE0yXf/pqDgJWrqBptPt2VGekzIxLU4b
         TH6LS0hhhZGL59sK+5hje2NSf78QidGtSm3JbldrLb8N663AfgjVKigbfeGSViGHGUlV
         2dVlrD193jkMTY76hWU47wcyMJm1WNyB9akHlHZ2zmu/1JqyOLtXsXMVIMX60o8CYRbi
         I2jbYzZ44vB6dOnA1URu0nuJJkX5fH/lr0IxLdaPDMtHZs//wrulRG3m2kEnKC3qzrFM
         trvaHFlWLcW5rEykdHVQ/e7qygQQRCkYCW+YQuOEOFU8ntVoI1OTAcnQ2tDbp9IqmxHt
         91Qw==
X-Gm-Message-State: APjAAAWww4amzkyB0/XU11c0a+BvaugZZ1iwAul97i32owYpQgTUpMjJ
        hxFe/7dzn7Jy247PliVZNrA=
X-Google-Smtp-Source: APXvYqzSDWkdgcDBUIG7stUjfPH55mwjUGG4z2TrOQLogEXZ2wtBzixGK9UCgPvJuJZloOsA3LrUsA==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr26097973wrj.272.1560866727378;
        Tue, 18 Jun 2019 07:05:27 -0700 (PDT)
Received: from Jitter (amontsouris-655-1-85-37.w90-44.abo.wanadoo.fr. [90.44.108.37])
        by smtp.gmail.com with ESMTPSA id r4sm32352588wra.96.2019.06.18.07.05.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:05:26 -0700 (PDT)
Date:   Tue, 18 Jun 2019 16:05:26 +0200
From:   Paul Chaignon <paul.chaignon@gmail.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Xiao Han <xiao.han@orange.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
Message-ID: <CAO5pjwRKyyuTpddzssH4=rkchQK5zeo+cEqymYGckW9eWe_90A@mail.gmail.com>
References: <20190615191225.2409862-1-ast@kernel.org>
 <CAEf4BzY_w-tTQFy_MfSvRwS4uDziNLRN+Jax4WXidP9R-s961w@mail.gmail.com>
 <70187096-9876-b004-0ccb-8293618f384f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70187096-9876-b004-0ccb-8293618f384f@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 06:57PM, Alexei Starovoitov wrote:
> On 6/17/19 9:39 AM, Andrii Nakryiko wrote:
> > On Sat, Jun 15, 2019 at 12:12 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >>
> >> v2->v3: fixed issues in backtracking pointed out by Andrii.
> >> The next step is to add a lot more tests for backtracking.
> >>
> >
> > Tests would be great, verifier complexity is at the level, where it's
> > very easy to miss issues.
> >
> > Was fuzzying approach ever discussed for BPF verifier? I.e., have a
> > fuzzer to generate both legal and illegal random small programs. Then
> > re-implement verifier as user-level program with straightforward
> > recursive exhaustive verification (so no state pruning logic, no
> > precise/coarse, etc, just register/stack state tracking) of all
> > possible branches. If kernel verifier's verdict differs from
> > user-level verifier's verdict - flag that as a test case and figure
> > out why they differ. Obviously that would work well only for small
> > programs, but that should be a good first step already.
> >
> > In addition, if this is done, that user-land verifier can be a HUGE
> > help to BPF application developers, as libbpf would (potentially) be
> > able to generate better error messages using it as well.
>
> In theory that sounds good, but doesn't work in practice.
> The kernel verifier keeps changing faster than user space can catch up.
> It's also relying on loaded maps and all sorts of callbacks that
> check context, allowed helpers, maps, combinations of them from all
> over the kernel.
> The last effort to build kernel verifier as-is into .o and link
> with kmalloc/map wrappers in user space was here:
> https://github.com/iovisor/bpf-fuzzer
> It was fuzzing the verifier and was able to find few minor bugs.
> But it quickly bit rotted.

We've been working (with Xiao Han, cc'ed) on an update of bpf-fuzzer.  It
helped us find a few issues in the verifier (mostly thanks to
warn_on("verifier bug")s).  I'll probably send a patchset to the main
repository in the next few weeks.

Updating the glue code (userspace wrappers) is okay so far, as long as
done regularly.

[...]

>
> I think syzbot is still generating bpf programs. iirc it found
> one bug in the past in the verifier core.

syzkaller's template description of BPF programs is very limited.  It
produces valid BPF instructions, but loaded programs make little sense,
are trivial or invalid, and don't go very far in the verifier.  We
probably can't rely on syzkaller to be effective for the verifier.

> I think the only way to make verifier more robust is to keep
> adding new test cases manually.
> Most interesting bugs we found by humans.

Tests and reviews are definitely the most effective ways to find bugs,
despite the above two fuzzers.  The verifier is complex enough that the
random approach of fuzzers has a hard time covering the code.

Paul
