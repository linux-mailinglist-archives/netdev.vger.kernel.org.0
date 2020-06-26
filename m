Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470AB20BC26
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFZWGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:06:46 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17596C03E979;
        Fri, 26 Jun 2020 15:06:46 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v19so8619161qtq.10;
        Fri, 26 Jun 2020 15:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kuXTIVaH42U+4fQbLLcv4WIz+SpSeRqhEbTQeefPB38=;
        b=pIwS9gLBPErYWp/oAbKSxUs7NTfimbDt1CTa1O4hJ/ZP1te7fZ8tOSV/9uIPo7vZIM
         ESVMlGBOe2wyDwM0rCUsYeQTJVnVmFPv2yZMrl93rKo1aCTAVbmRYlOrJLGfiQBNa+eN
         +wKBOjbaUA8JHGtCRRAvPJ8DGHqSZTZ0OHVSkaHxllFCzDPVVHhD0wfcEO1bObUJFHr+
         FQlk98GPCd6XB0AD1QX3XMAvVpD33l5+cnw4m11pOWCuxyE9PVEvxCtn0jXZOXSir7mN
         IFl8bSEuUrJr88jeN8uKKShkqNZCv1K+Uzvdg3PbgDwPBPJwRqJIjN40D3Wd0Bi5Kg05
         g1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kuXTIVaH42U+4fQbLLcv4WIz+SpSeRqhEbTQeefPB38=;
        b=Qws9FRDWsX/c2GOiB9l/Ek8Fkloujl2EwuiI+cYoUFLgnlEYTI99SwMIEvIwDG282C
         MvWjY9wmzcL51Z+ZSAZhC3yTL9Oo7wK5ShIQvKfPfyCopXewXRfhFHlzgUpoD2J0VDAJ
         CMzdnOpfbbjb43/cPrb1nL6XIe4G3lLhc2+OYiQWQMkIej2vkywH5yteih5qNH8RNSdm
         9fU9JnkXnZBWQlzi6B2N6QLYXb3gE0xU0Nt6Mwzkq79KH2K4Sd58PPUROjxcYhylN1VV
         x+JsFyIvHjro/3lHHk/e/bvteLFcPRnVyQ8S7F82C3cZ3t9KV1bbbyKfTr3UVk/zLHZ1
         9I3Q==
X-Gm-Message-State: AOAM530t14dhmVmA6Fgh65eNQzHe3zAwCOp2hZGpYALDpKlWadxxTBQ5
        sllf6aOLTBrGoNIvz8KMtCBWoJmdQzK39kg2HodmgA==
X-Google-Smtp-Source: ABdhPJxZIzbjuL48QOAfxbpm1gQzAq40ziMKxEGJUhOqxlyYd4bkvEERhQJ6LkcXdqxVtlVLK9o+r1dBYehYJkC3+Ms=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr4863202qtj.93.1593209205179;
 Fri, 26 Jun 2020 15:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com> <20200626000929.217930-4-sdf@google.com>
In-Reply-To: <20200626000929.217930-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:06:34 -0700
Message-ID: <CAEf4BzaeEKvw0S5oMe7N+mUOyeEzaU3bPbaMPtMXrQ1CnVHXBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
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

On Thu, Jun 25, 2020 at 5:13 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Simple test that enforces a single SOCK_DGRAM socker per cgroup.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/udp_limit.c      | 71 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
>  create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> new file mode 100644
> index 000000000000..fe359a927d92
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "udp_limit.skel.h"
> +
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +
> +void test_udp_limit(void)
> +{
> +       struct udp_limit *skel;
> +       int cgroup_fd;
> +       int fd1, fd2;
> +       int err;
> +
> +       cgroup_fd = test__join_cgroup("/udp_limit");
> +       if (CHECK_FAIL(cgroup_fd < 0))
> +               return;
> +
> +       skel = udp_limit__open_and_load();
> +       if (CHECK_FAIL(!skel))
> +               goto close_cgroup_fd;
> +
> +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock),
> +                             cgroup_fd, BPF_CGROUP_INET_SOCK_CREATE, 0);
> +       if (CHECK_FAIL(err))
> +               goto close_skeleton;
> +
> +       err = bpf_prog_attach(bpf_program__fd(skel->progs.sock_release),
> +                             cgroup_fd, BPF_CGROUP_INET_SOCK_RELEASE, 0);
> +       if (CHECK_FAIL(err))
> +               goto close_skeleton;

Have you tried:

skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock);

and similarly for sock_release?

> +
> +       /* BPF program enforces a single UDP socket per cgroup,
> +        * verify that.
> +        */
> +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> +       if (CHECK_FAIL(fd1 < 0))
> +               goto close_skeleton;
> +
> +       fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> +       if (CHECK_FAIL(fd2 != -1))
> +               goto close_fd1;
> +
> +       /* We can reopen again after close. */
> +       close(fd1);
> +
> +       fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> +       if (CHECK_FAIL(fd1 < 0))
> +               goto close_skeleton;
> +
> +       /* Make sure the program was invoked the expected
> +        * number of times:
> +        * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
> +        * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
> +        * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
> +        * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
> +        */
> +       if (CHECK_FAIL(skel->bss->invocations != 4))
> +               goto close_fd1;
> +
> +       /* We should still have a single socket in use */
> +       if (CHECK_FAIL(skel->bss->in_use != 1))
> +               goto close_fd1;

Please use a non-silent CHECK() macro for everything that's a proper
and not a high-frequency check. That generates "a log trail" when
running the test in verbose mode, so it's easier to pinpoint where the
failure happened.

> +
> +close_fd1:
> +       close(fd1);
> +close_skeleton:
> +       udp_limit__destroy(skel);
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> new file mode 100644
> index 000000000000..98fe294d9c21
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
> +
> +SEC("cgroup/sock")
> +int sock(struct bpf_sock *ctx)
> +{
> +       __u32 key;
> +
> +       if (ctx->type != SOCK_DGRAM)
> +               return 1;
> +
> +       __sync_fetch_and_add(&invocations, 1);
> +
> +       if (&in_use > 0) {


&in_use is supposed to return an address of a variable... this looks
weird and probably not what you wanted?

> +               /* BPF_CGROUP_INET_SOCK_RELEASE is _not_ called
> +                * when we return an error from the BPF
> +                * program!
> +                */
> +               return 0;
> +       }
> +
> +       __sync_fetch_and_add(&in_use, 1);
> +       return 1;
> +}
> +
> +SEC("cgroup/sock_release")
> +int sock_release(struct bpf_sock *ctx)
> +{
> +       __u32 key;
> +
> +       if (ctx->type != SOCK_DGRAM)
> +               return 1;
> +
> +       __sync_fetch_and_add(&invocations, 1);
> +       __sync_fetch_and_add(&in_use, -1);
> +       return 1;
> +}
> --
> 2.27.0.111.gc72c7da667-goog
>
