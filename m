Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939E62114A6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgGAVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgGAVBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:01:20 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D881C08C5C1;
        Wed,  1 Jul 2020 14:01:20 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g13so19587597qtv.8;
        Wed, 01 Jul 2020 14:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfjEswI4f5ZfjSVMaT2VMATewg6pW92LXU97L+Hb8kE=;
        b=TjuF+vQF/XkqDZ1l9gZLylVT9+Rq+0LO67iJSbfO5NonZr0chOjYH7UFT27V4Bn0By
         z3nybExvRPNcG7YCjMRbgVrpCrML4m0YaS+dFivSet5FdWaFhi2dBD/6Tw46u2wVAuUD
         Y11Z2EvRsGfcPK53ltJJSRjeEu8LS6jh8OJggqPk+oL/TM4tTCAgS11ZHr2I9TBuRv0d
         hJhuqkYcdUFZqfxJZeBKDJyy8xc0efAYHdhlU+kBhsZy5lho7KeflHaAcj0hRp4z9xsg
         Ooae6gZgt4SlB8jk+3xQ1vs3iE9yRbxlKE4zeBNeG5gHJ9Mb6y/K4JN/+IfwVna6HdY5
         Y+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfjEswI4f5ZfjSVMaT2VMATewg6pW92LXU97L+Hb8kE=;
        b=i/i/nNX/Nxt9iR5SJRA55m3QsxQtFq0HKUCQymjp8XuyKnzwf1MBPa+TThyDSR9lod
         FD15TTVdx4OwTfPLi026ePi80wGskOVOycoHQ271wiBmuLbHVl+6I2JAwmK2Q8cmyOP3
         JzMEZan8s/olexLmy+R73SqKUjyLXNDQI28ww27KNL8IlKtiDJa9hJ43xETZzNjK7a2u
         5s2gHjq/EEOKkhVqYXijVCRUA8kMPj+yAp8bkhCG+PtgoYtSBxH2i5DV6xaTrcqB+ioR
         W9onr1nOnLU6EMHVyN9vJDrnPEapE9ow4RFrbKObhVKCDmYcTCf21xUbQ6WYHSeT693u
         aX5w==
X-Gm-Message-State: AOAM533L2qfEOThhhHfGvEHfFlBwV9ORDHDD1qcVZLwb59Pjx/3n2lsl
        A7E+oa844iy1rLU3wrp9C9IKu2j8tObYKGqPBYg=
X-Google-Smtp-Source: ABdhPJxXCAp0AoVWZI9q/uHwKapEjiWQYSEyVqJb2yZTfvMXZqVNP5fq3ed7qqSwMkN1PptoITlhTSX4Cd1zxFAOseE=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr27896945qtd.59.1593637279196;
 Wed, 01 Jul 2020 14:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200701201307.855717-1-sdf@google.com> <20200701201307.855717-5-sdf@google.com>
In-Reply-To: <20200701201307.855717-5-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 14:01:08 -0700
Message-ID: <CAEf4BzYqQ_mSpadEoj2SD8QM8CSmfaiprERBjub2tGa6NxKvNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 1:14 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Simple test that enforces a single SOCK_DGRAM socker per cgroup.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/udp_limit.c      | 72 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
>  create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
>

[...]

> +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> +       if (CHECK(fd1 < 0, "fd1", "errno %d", errno))
> +               goto close_skeleton;
> +
> +       fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> +       if (CHECK(fd2 >= 0, "fd2", "errno %d", errno))

close(fd2);

> +               goto close_fd1;
> +

[...]

> +close_fd1:
> +       close(fd1);
> +close_skeleton:
> +       udp_limit__destroy(skel);
> +close_cgroup_fd:
> +       close(cgroup_fd);

nit: choosing between close_fd1 and close_skeleton (which also
alternates!) is hard to keep track of. When clean up gets one step
beyond trivial, I usually just initialize variables properly and do
clean up for all exit scenario in one block:

if (fd1 >= 0)
    close(fd1);
udp_limit__destroy(skel);
close(cgroup_fd);

It also makes later extensions simpler.


> +}
> diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> new file mode 100644
> index 000000000000..af1154bfb946
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/udp_limit.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <sys/socket.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +int invocations, in_use;

uninitialized globals can leads to libbpf refusing to load them (due
to COM section), Daniel just recently had this problem. So better to
always zero-initialize them.

[...]
