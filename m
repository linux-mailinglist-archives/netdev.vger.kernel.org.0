Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAE83DC0A1
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhG3V6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhG3V6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:58:45 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672AFC0617BC;
        Fri, 30 Jul 2021 14:58:31 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id x192so18396223ybe.0;
        Fri, 30 Jul 2021 14:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xZnyejMAotCOAQeJWyyQ7gWMmz8cw13hMQvhBFO3GkE=;
        b=BziFnDS5wsguCDWqgwJKxqrvVny20d2BPLuqLBMsi1eRr3CJ17MayxyMyY0ioTux+J
         N3S8tKX+ns39EjCOoQkAojjH5hUqglOUp36HVo5toAtIVS8Yo5fFtwsMhkh0IDIVXi8r
         YBz2LSqOo28aGPWOFZKl7yd/Zjc3Q1C65tmipAXcVcpqNi2IBQURR0Q9+MDsiaohEUAu
         7OJsIKbX2UX0aTCm+gZtBvi1zdmp152AdQoY1ga2CW7a+yUD82gm9iMP+i2GqsDyNxoI
         /aVbqeW+JVSU6hJCQZV749XKcyXRCkrYPzws6dl1jkd7y6zoXydSAwKbWX4z6RyzACeY
         o20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xZnyejMAotCOAQeJWyyQ7gWMmz8cw13hMQvhBFO3GkE=;
        b=C30r16z2x8FK63UzleC5dLyYWOwkkzRp1bkeaNbiV7sVoqYCMQVHlNQRCHZH1+qQu4
         O+p+/ULNAoWU1zH1WFQtc5HOs7JjC5Hm3tbSD57xAYpM1r1LHffOdjvXO8V6NjQuaneY
         Ak4E554qAwnZFEgQuOIKZxwjHHfQoF54fY41FKrMgBBbGkZzysFmIbMv/CcjMTbCMCJq
         VlgS68W/KGHyiVnCoFGsyOBJpwuEJFAnIN1kgnRU5vMm6s7jOKz2mONKHDyGSjcuAsAb
         1mgqIXtfE6h35CbAdFfGuRIxwg73qzcpJYtYZKlK7HIfxRAQAe15B7KZIyyitZ7gtqNd
         +7AA==
X-Gm-Message-State: AOAM532hqW2UuzW1fCyR6OHabKJ4/DiCDo3Ac27fkO6BtJxNGxrzJ4hT
        pyBsmO7Ja1sp6n77bUWQTF2J2e0NYxQFlRju8jg=
X-Google-Smtp-Source: ABdhPJxsm/OEKh4rIj0YUOKhiBg8bGHa5DEznua6bhefkX4ljtNDV9zpfW2OaF1wFhKe2AwFkRf6ICfcEQqcEm8uV8c=
X-Received: by 2002:a25:b741:: with SMTP id e1mr6124166ybm.347.1627682310717;
 Fri, 30 Jul 2021 14:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <CAEf4BzbhmxAXUOoCr7wX-dqkzvQm0OMDLi+A+k6pFs=BCsDY=w@mail.gmail.com>
 <c61560c7-47eb-bd86-45cb-131b15cd89c1@isovalent.com>
In-Reply-To: <c61560c7-47eb-bd86-45cb-131b15cd89c1@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 14:58:19 -0700
Message-ID: <CAEf4BzZZHBmCvbpza0VavP0L7uGk2bR1fF5zqjzLNdc_-bRmtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/7] tools: bpftool: update, synchronise and
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 2:48 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-30 12:06 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> To work with the different program types, map types, attach types etc.
> >> supported by eBPF, bpftool needs occasional updates to learn about the new
> >> features supported by the kernel. When such types translate into new
> >> keyword for the command line, updates are expected in several locations:
> >> typically, the help message displayed from bpftool itself, the manual page,
> >> and the bash completion file should be updated. The options used by the
> >> different commands for bpftool should also remain synchronised at those
> >> locations.
> >>
> >> Several omissions have occurred in the past, and a number of types are
> >> still missing today. This set is an attempt to improve the situation. It
> >> brings up-to-date the lists of types or options in bpftool, and also adds a
> >> Python script to the BPF selftests to automatically check that most of
> >> these lists remain synchronised.
> >>
> >> Quentin Monnet (7):
> >>   tools: bpftool: slightly ease bash completion updates
> >>   selftests/bpf: check consistency between bpftool source, doc,
> >>     completion
> >>   tools: bpftool: complete and synchronise attach or map types
> >>   tools: bpftool: update and synchronise option list in doc and help msg
> >>   selftests/bpf: update bpftool's consistency script for checking
> >>     options
> >>   tools: bpftool: document and add bash completion for -L, -B options
> >>   tools: bpftool: complete metrics list in "bpftool prog profile" doc
> >>
> >>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  48 +-
> >>  .../bpftool/Documentation/bpftool-cgroup.rst  |   3 +-
> >>  .../bpftool/Documentation/bpftool-feature.rst |   2 +-
> >>  .../bpf/bpftool/Documentation/bpftool-gen.rst |   9 +-
> >>  .../bpftool/Documentation/bpftool-iter.rst    |   2 +
> >>  .../bpftool/Documentation/bpftool-link.rst    |   3 +-
> >>  .../bpf/bpftool/Documentation/bpftool-map.rst |   3 +-
> >>  .../bpf/bpftool/Documentation/bpftool-net.rst |   2 +-
> >>  .../bpftool/Documentation/bpftool-perf.rst    |   2 +-
> >>  .../bpftool/Documentation/bpftool-prog.rst    |  36 +-
> >>  .../Documentation/bpftool-struct_ops.rst      |   2 +-
> >>  tools/bpf/bpftool/Documentation/bpftool.rst   |  12 +-
> >>  tools/bpf/bpftool/bash-completion/bpftool     |  69 ++-
> >>  tools/bpf/bpftool/btf.c                       |   3 +-
> >>  tools/bpf/bpftool/cgroup.c                    |   3 +-
> >>  tools/bpf/bpftool/common.c                    |  76 +--
> >>  tools/bpf/bpftool/feature.c                   |   1 +
> >>  tools/bpf/bpftool/gen.c                       |   3 +-
> >>  tools/bpf/bpftool/iter.c                      |   2 +
> >>  tools/bpf/bpftool/link.c                      |   3 +-
> >>  tools/bpf/bpftool/main.c                      |   3 +-
> >>  tools/bpf/bpftool/main.h                      |   3 +-
> >>  tools/bpf/bpftool/map.c                       |   5 +-
> >>  tools/bpf/bpftool/net.c                       |   1 +
> >>  tools/bpf/bpftool/perf.c                      |   5 +-
> >>  tools/bpf/bpftool/prog.c                      |   8 +-
> >>  tools/bpf/bpftool/struct_ops.c                |   2 +-
> >>  tools/testing/selftests/bpf/Makefile          |   1 +
> >>  .../selftests/bpf/test_bpftool_synctypes.py   | 586 ++++++++++++++++++
> >>  29 files changed, 802 insertions(+), 96 deletions(-)
> >>  create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py
> >>
> >> --
> >> 2.30.2
> >>
> >
> > The patch set name ends abruptly at "synchronise and "... And what? I
> > need to know :)
>
> "... and validate types and options" is the missing part. I noticed
> after sending -_-. My editor wrapped the Subject: line, resulting in a
> truncation. I'll fix for v2 to relieve readers from the suspense :).
>
> >
> > Overall, it looks good, though I can't speak Python much, so I trust
> > the script works and we'll fix whatever is necessary as we go. I had
> > one small real nit about not re-formatting tons of existing lines for
> > no good reason, let's keep Git blame a bit more useful.
> >
> > Also, it doesn't seem like you are actually calling a new script from
> > selftests/bpf/Makefile, right? That's good, because otherwise any UAPI
> > change in kernel header would require bpftool changes in the same
> > patch.
>
> Hmm. Ha. Certainly I wouldn't do such a thing. Please don't look again
> at patch 2, and let's focus on v2. 0:)

You got it.

>
> > But once this lands, we should probably run this in
> > kernel-patches CI ([0]) and, maybe, not sure, libbpf CI ([1]) as well.
> > So please follow up with that as well afterwards, that way you won't
> > be the only one nagging people about missed doc updates.
> >
> >   [0] https://github.com/kernel-patches/vmtest/tree/master/travis-ci/vmtest
> >   [1] https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest
> >
>
> What's the process to add them to the CI (did I miss some doc)? Should I
> just go for a GitHub PR once the script is merged in bpf-next, or do you
> have a tool to mirror the relevant scripts? Do we need to have the
> Python script in the kernel repo if we don't run it as part of the
> selftest suite, by the way?

Just normal, nicely prepared and described PRs against respective repos.
