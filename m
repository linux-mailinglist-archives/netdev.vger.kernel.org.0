Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB47B1FEB23
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFRFvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgFRFvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:51:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99399C06174E;
        Wed, 17 Jun 2020 22:51:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so4518938qkg.3;
        Wed, 17 Jun 2020 22:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CiYvtb3pRWyG8LXP7I6EqPRPaxemikez83OyacDqRg=;
        b=rYhMFsJbX6YQa7Dub44s/2FLH2qebeAQDQnmK+9y6EsfQ4qUjrYL1x2LxktpGdikQi
         B73TIcAf7HQSMkDJ3a3ymmftH2nrb7ZeLW88RCS2e977f6yCfMLO5HHAVsudRq5TFaaW
         i96FeYunoKbQpEjvUS4ikocN19sW01RpmW57XTztUgMc0dPRpQHxrjaZPOkcneQWuMHt
         NH6ZsMvYq/Wjc/VFRrCrKAIrODdbNdE9IPu84Lg70zaOAS/YE0eLeuobnIUsGa+F+zsB
         UULzl2nSLHJYPgAX15rZi6PHhea73uMecr+u4NBvAZmtYhzUqdmIpE5fEfR0WVKAWW6c
         065A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CiYvtb3pRWyG8LXP7I6EqPRPaxemikez83OyacDqRg=;
        b=GM8lIIhhL13UWEI2dRe26IuLf5L2Vlc64SgWX5/5xY3YzDbbQeT11ucTri0Vn7G9j6
         lgPGocrv+hp+2UBf2lfpGlUAxDmA3LYjgjcb+YC27LmEFry/MM4UpjMPQEkF5tA/YWa8
         PBJZpHhRi42/AhMnlb7tiMYPffO4pNOtCTBnfZ05rPsZByV4P05TrXGzDCB2R7k2LYr1
         pxceB2diW14Z2Tn/P4QJMJpTP4q98o6SvLVDd7YzbV3hF3Wj8WIlk9aDlMVM4n1ugtp2
         vcoEzVTUAiCzbDXyHqXJ0TfNGKbZHe9FY7HUohGTD2lqM+BwJNyfpcAI2PfU02Phpu+b
         UBnA==
X-Gm-Message-State: AOAM533soz4QxkvQFQ/o1caYCJmAf4+eF05dC/aEO4GjrntEKdTeuYk3
        Xc00lamGJxKVk47WbQKaAfnqJlMQtyY0gL5t8EgpRZtP
X-Google-Smtp-Source: ABdhPJz0AAcFgMGANpN+iofmipPGFUFFCq+4TgOKiZX5XF/liyC+0QUWvgJRyJ93J2f5ZsQvpYc6y+rpMmZrCWvRt6c=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr2222280qkh.39.1592459496611;
 Wed, 17 Jun 2020 22:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200617161832.1438371-1-andriin@fb.com> <20200617161832.1438371-10-andriin@fb.com>
 <e22ae69f-c174-1cc8-d3b3-68fdda8934ae@isovalent.com>
In-Reply-To: <e22ae69f-c174-1cc8-d3b3-68fdda8934ae@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Jun 2020 22:51:25 -0700
Message-ID: <CAEf4BzZPQWFaRSvkqdcm2HxQCCi5bw8qr7zBjPQLPVwaSAdYFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 9/9] tools/bpftool: add documentation and sample
 output for process info
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 5:25 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Add statements about bpftool being able to discover process info, holding
> > reference to BPF map, prog, link, or BTF. Show example output as well.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/Documentation/bpftool-btf.rst  |  5 +++++
> >  tools/bpf/bpftool/Documentation/bpftool-link.rst | 13 ++++++++++++-
> >  tools/bpf/bpftool/Documentation/bpftool-map.rst  |  8 +++++++-
> >  tools/bpf/bpftool/Documentation/bpftool-prog.rst | 11 +++++++++++
> >  4 files changed, 35 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > index ce3a724f50c1..85f7c82ebb28 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > @@ -36,6 +36,11 @@ DESCRIPTION
> >                 otherwise list all BTF objects currently loaded on the
> >                 system.
> >
> > +               Since Linux 5.8 bpftool is able to discover information about
> > +               processes that hold open file descriptors (FDs) against BPF
> > +               links. On such kernels bpftool will automatically emit this
>
> Copy-paste error: s/BPF links/BTF objects/
>

oops, will fix

> > +               information as well.
> > +
> >       **bpftool btf dump** *BTF_SRC*
> >                 Dump BTF entries from a given *BTF_SRC*.
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
> > index 0e43d7b06c11..1da7ef65b514 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
> > @@ -37,6 +37,11 @@ DESCRIPTION
> >                 zero or more named attributes, some of which depend on type
> >                 of link.
> >
> > +               Since Linux 5.8 bpftool is able to discover information about
> > +               processes that hold open file descriptors (FDs) against BPF
> > +               links. On such kernels bpftool will automatically emit this
> > +               information as well.
> > +
> >       **bpftool link pin** *LINK* *FILE*
> >                 Pin link *LINK* as *FILE*.
> >
> > @@ -82,6 +87,7 @@ EXAMPLES
> >
> >      10: cgroup  prog 25
> >              cgroup_id 614  attach_type egress
> > +            pids test_progs(2238417)
>
> (That's a big PID. Maybe something below the default max pid (32768)
> might be less confusing for users, but also maybe that's just me
> nitpicking too much.)

heh, real system, but yeah, I can make up a smaller PID :)

>
> >
> >  **# bpftool --json --pretty link show**
> >
> > @@ -91,7 +97,12 @@ EXAMPLES
> >              "type": "cgroup",
> >              "prog_id": 25,
> >              "cgroup_id": 614,
> > -            "attach_type": "egress"
> > +            "attach_type": "egress",
> > +            "pids": [{
> > +                    "pid": 2238417,
> > +                    "comm": "test_progs"
> > +                }
> > +            ]
> >          }
> >      ]
> >
