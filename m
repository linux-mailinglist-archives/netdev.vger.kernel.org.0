Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0103DBEB8
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhG3TGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhG3TGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:06:33 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CBAC06175F;
        Fri, 30 Jul 2021 12:06:27 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id d73so17581664ybc.10;
        Fri, 30 Jul 2021 12:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DS7G5Mp3ZiNksp4LFVx/s6HRXPteROUGuVXS0Qr++e0=;
        b=N3gjS+PCkw7+HLiaQM9bONjBDWxPFtn/bLcvUMKkvToaR5zg6toBZjYU6ooIBp9qWu
         fr3bLdy1uUmIInFEruA+6Vk+ocJN50WHsemnourZXQcV/jCOWAiBjbLeZDuIpF/6bXDC
         zBxYacy7+ifzXRBdHBZMKYvE2gKcjaBbmm5jqeLUCqVQOs4k5rKWVv3PLA4Xyw5+Fc+y
         K1tpK4F2RlifaF0t+LdD/3DwyrAtjXGwIekhWhuxkd1MWWZ66goZk+nPMQaiC+zooT89
         oSuN3fLCp+4E8N59QUIzbyzrzwGvCL7jqWaT8Kh7W1LXiWkOZxTqtfyHxiSShdmTGrGT
         VgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DS7G5Mp3ZiNksp4LFVx/s6HRXPteROUGuVXS0Qr++e0=;
        b=q+s3s4A9vZZnKOd9ea4UwZI0FJnkiO2UL51jELo7+xWMQ5yMaCm2hitBhMr1KDGssh
         2P36yBfvpqfdO7mLEnaS+qA52z1sSljpNZzv+/DQQFqYYxkgJBv4zOXsK+jMMq2/aonF
         SWwTXbs86e769UV9f70p0AljMNEX3yqQeiev+f13NEX7C+VOIKWmQMUv9+BCMnYKWOFl
         BO9LNLoIh08Eqsg4dEuK82z9B8IQ9b1DlzuTAQLUkA7jTkcn9YvT2ycOp9StCRJfasZv
         0cz1msakOl5k2tHGBbG8VLhNM0D1shTmRQjhUv54rCMjyKcgvXwuWG8/vY4ABbmC9ugo
         eVfQ==
X-Gm-Message-State: AOAM5329tISGQu76kxjSsZmdwP3w5tRuP+sQ0MY1UErQZ0E7jKBR4KjL
        sdZ/SP733BwZlrkc1ZpVzAnMN6QDlf1pFGD6FCk=
X-Google-Smtp-Source: ABdhPJwx6YUyIqUyA76aHlsrSxLDW+qqB4FJkFynprjlMq8Ktz1xlVx0VtWpSuNWELHY3jPrej4HWuNbFlpzFBoUfgE=
X-Received: by 2002:a25:6148:: with SMTP id v69mr4984982ybb.510.1627671986753;
 Fri, 30 Jul 2021 12:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com>
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 12:06:15 -0700
Message-ID: <CAEf4BzbhmxAXUOoCr7wX-dqkzvQm0OMDLi+A+k6pFs=BCsDY=w@mail.gmail.com>
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

On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> To work with the different program types, map types, attach types etc.
> supported by eBPF, bpftool needs occasional updates to learn about the new
> features supported by the kernel. When such types translate into new
> keyword for the command line, updates are expected in several locations:
> typically, the help message displayed from bpftool itself, the manual page,
> and the bash completion file should be updated. The options used by the
> different commands for bpftool should also remain synchronised at those
> locations.
>
> Several omissions have occurred in the past, and a number of types are
> still missing today. This set is an attempt to improve the situation. It
> brings up-to-date the lists of types or options in bpftool, and also adds a
> Python script to the BPF selftests to automatically check that most of
> these lists remain synchronised.
>
> Quentin Monnet (7):
>   tools: bpftool: slightly ease bash completion updates
>   selftests/bpf: check consistency between bpftool source, doc,
>     completion
>   tools: bpftool: complete and synchronise attach or map types
>   tools: bpftool: update and synchronise option list in doc and help msg
>   selftests/bpf: update bpftool's consistency script for checking
>     options
>   tools: bpftool: document and add bash completion for -L, -B options
>   tools: bpftool: complete metrics list in "bpftool prog profile" doc
>
>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  48 +-
>  .../bpftool/Documentation/bpftool-cgroup.rst  |   3 +-
>  .../bpftool/Documentation/bpftool-feature.rst |   2 +-
>  .../bpf/bpftool/Documentation/bpftool-gen.rst |   9 +-
>  .../bpftool/Documentation/bpftool-iter.rst    |   2 +
>  .../bpftool/Documentation/bpftool-link.rst    |   3 +-
>  .../bpf/bpftool/Documentation/bpftool-map.rst |   3 +-
>  .../bpf/bpftool/Documentation/bpftool-net.rst |   2 +-
>  .../bpftool/Documentation/bpftool-perf.rst    |   2 +-
>  .../bpftool/Documentation/bpftool-prog.rst    |  36 +-
>  .../Documentation/bpftool-struct_ops.rst      |   2 +-
>  tools/bpf/bpftool/Documentation/bpftool.rst   |  12 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |  69 ++-
>  tools/bpf/bpftool/btf.c                       |   3 +-
>  tools/bpf/bpftool/cgroup.c                    |   3 +-
>  tools/bpf/bpftool/common.c                    |  76 +--
>  tools/bpf/bpftool/feature.c                   |   1 +
>  tools/bpf/bpftool/gen.c                       |   3 +-
>  tools/bpf/bpftool/iter.c                      |   2 +
>  tools/bpf/bpftool/link.c                      |   3 +-
>  tools/bpf/bpftool/main.c                      |   3 +-
>  tools/bpf/bpftool/main.h                      |   3 +-
>  tools/bpf/bpftool/map.c                       |   5 +-
>  tools/bpf/bpftool/net.c                       |   1 +
>  tools/bpf/bpftool/perf.c                      |   5 +-
>  tools/bpf/bpftool/prog.c                      |   8 +-
>  tools/bpf/bpftool/struct_ops.c                |   2 +-
>  tools/testing/selftests/bpf/Makefile          |   1 +
>  .../selftests/bpf/test_bpftool_synctypes.py   | 586 ++++++++++++++++++
>  29 files changed, 802 insertions(+), 96 deletions(-)
>  create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py
>
> --
> 2.30.2
>

The patch set name ends abruptly at "synchronise and "... And what? I
need to know :)

Overall, it looks good, though I can't speak Python much, so I trust
the script works and we'll fix whatever is necessary as we go. I had
one small real nit about not re-formatting tons of existing lines for
no good reason, let's keep Git blame a bit more useful.

Also, it doesn't seem like you are actually calling a new script from
selftests/bpf/Makefile, right? That's good, because otherwise any UAPI
change in kernel header would require bpftool changes in the same
patch. But once this lands, we should probably run this in
kernel-patches CI ([0]) and, maybe, not sure, libbpf CI ([1]) as well.
So please follow up with that as well afterwards, that way you won't
be the only one nagging people about missed doc updates.

  [0] https://github.com/kernel-patches/vmtest/tree/master/travis-ci/vmtest
  [1] https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest
