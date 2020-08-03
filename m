Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1E9239D48
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHCBoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:44:06 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A762BC06174A;
        Sun,  2 Aug 2020 18:44:06 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id n141so17173282ybf.3;
        Sun, 02 Aug 2020 18:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PryV/8OZtuFccJpi6sbTqIZYt0j7YrP+Wf83lGvbckQ=;
        b=lzu5flGQMST/Rz7Bx49Obx5JWb9OYak+4q0sLHR9ig5Rwz0eoSTzXzBw4iPeEhVORH
         XmnpFq0A1iFO+zB6r/MMTVBCik5EnAD43ziFG8mJbuuz3W3W98R5vxh5JOx+KwMg/GP6
         gY2RhTkbh26RRS4lw5bUgafvkDCr/QtnItGiZPovNVAGeEHWm8arOojOlElypKelyvCS
         pX6YqeVqhqrHNA9ZH4dNPu851Np0sdR4oblNhsnlNKR8chxL5x9WhsJsBrbV4RRUkINy
         7739pTND7M5ny5Ge1IaVtCkEo0grZeWInWnMzvBwdOc3MvD7yTGsk1aaO/nc9jNnaaTZ
         +ClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PryV/8OZtuFccJpi6sbTqIZYt0j7YrP+Wf83lGvbckQ=;
        b=rd7S91jliWOmm6pxO6v1fvGLFNnp9whRk871z/T7m1Z72I6VjSnzEoMm8ebMT0WcSi
         MK1XfyqXJj/QaAZ/ky+IJd/PbHOvsmTQ2/gmrriZZFKM1pu7eUvY0vDt0bgIOtYy+pHL
         6yuNCEV2yvIKcAtVDS2vAQwU20hE7W4Sw6kDk6B9mIXRqKpkh+q2udZMl0F4kQIpcMPl
         zANK6ukJAcfoIywnN36ztHEA150D0FtIpdNbxGm5TDxINkdM2fOWvyQ5jZZ6YJ5AdGH3
         aYhqKfezHQX4yAuNmHlYOUPjLQfy/SfnMaC21MuKIfuiJzuSdXVGN9ZU2es5fBaiybIN
         /vhw==
X-Gm-Message-State: AOAM532pI9XP5aAjiuqiofWWoQ6Hgu4yYdFRP6s3+LVBX1BEWLtj12e0
        Yp7dYIZLrsvBhI9YSq66VyKKQzXEFxICp3eG61k=
X-Google-Smtp-Source: ABdhPJxYrZvW/dQWc5mvmGNXfyr53GGQbxLnH5JmoEbPqMNJOH6+Klbz1WkFR7lseCEm/97t6j4mc5YEjkpY9V7uJWQ=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr22391033ybg.459.1596419045738;
 Sun, 02 Aug 2020 18:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com> <20200801084721.1812607-4-songliubraving@fb.com>
In-Reply-To: <20200801084721.1812607-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:43:55 -0700
Message-ID: <CAEf4BzazkFMw3LAs3M2hxSLWWZJ7ywykwte=0WDhC1zgMYw-3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: add selftest for BPF_PROG_TYPE_USER
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>
> This test checks the correctness of BPF_PROG_TYPE_USER program, including:
> running on the right cpu, passing in correct args, returning retval, and
> being able to call bpf_get_stack|stackid.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../selftests/bpf/prog_tests/user_prog.c      | 52 +++++++++++++++++
>  tools/testing/selftests/bpf/progs/user_prog.c | 56 +++++++++++++++++++
>  2 files changed, 108 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/user_prog.c
>  create mode 100644 tools/testing/selftests/bpf/progs/user_prog.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/user_prog.c b/tools/testing/selftests/bpf/prog_tests/user_prog.c
> new file mode 100644
> index 0000000000000..416707b3bff01
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/user_prog.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include <test_progs.h>
> +#include "user_prog.skel.h"
> +
> +static int duration;
> +
> +void test_user_prog(void)
> +{
> +       struct bpf_user_prog_args args = {{0, 1, 2, 3, 4}};
> +       struct bpf_prog_test_run_attr attr = {};
> +       struct user_prog *skel;
> +       int i, numcpu, ret;
> +
> +       skel = user_prog__open_and_load();
> +
> +       if (CHECK(!skel, "user_prog__open_and_load",
> +                 "skeleton open_and_laod failed\n"))
> +               return;
> +
> +       numcpu = libbpf_num_possible_cpus();

nit: possible doesn't mean online right now, so it will fail on
offline or non-present CPUs

> +
> +       attr.prog_fd = bpf_program__fd(skel->progs.user_func);
> +       attr.data_size_in = sizeof(args);
> +       attr.data_in = &args;
> +
> +       /* start from -1, so we test cpu_plus == 0 */
> +       for (i = -1; i < numcpu; i++) {
> +               args.args[0] = i + 1;
> +               attr.cpu_plus = i + 1;
> +               ret = bpf_prog_test_run_xattr(&attr);
> +               CHECK(ret, "bpf_prog_test_run_xattr", "returns error\n");
> +
> +               /* skip two tests for i == -1 */
> +               if (i == -1)
> +                       continue;
> +               CHECK(attr.retval != i + 2, "bpf_prog_test_run_xattr",
> +                     "doesn't get expected retval\n");
> +               CHECK(skel->data->sum != 11 + i, "user_prog_args_test",
> +                     "sum of args doesn't match\n");
> +       }
> +
> +       CHECK(skel->data->cpu_match == 0, "cpu_match_test", "failed\n");
> +       CHECK(skel->bss->get_stack_success != numcpu + 1, "test_bpf_get_stack",
> +             "failed on %d cores\n", numcpu - skel->bss->get_stack_success);
> +       CHECK(skel->bss->get_stackid_success != numcpu + 1,
> +             "test_bpf_get_stackid",
> +             "failed on %d cores\n",
> +             numcpu + 1 - skel->bss->get_stackid_success);
> +
> +       user_prog__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/user_prog.c b/tools/testing/selftests/bpf/progs/user_prog.c
> new file mode 100644
> index 0000000000000..cf320e97f107a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/user_prog.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#ifndef PERF_MAX_STACK_DEPTH
> +#define PERF_MAX_STACK_DEPTH         127
> +#endif
> +
> +typedef __u64 stack_trace_t[PERF_MAX_STACK_DEPTH];
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_STACK_TRACE);
> +       __uint(max_entries, 16384);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(stack_trace_t));
> +} stackmap SEC(".maps");
> +
> +volatile int cpu_match = 1;
> +volatile __u64 sum = 1;
> +volatile int get_stack_success = 0;
> +volatile int get_stackid_success = 0;
> +volatile __u64 stacktrace[PERF_MAX_STACK_DEPTH];

nit: no need for volatile for non-static variables

> +
> +SEC("user")
> +int user_func(struct bpf_user_prog_ctx *ctx)

If you put args in bpf_user_prog_ctx as a first field, you should be
able to re-use the BPF_PROG macro to access those arguments in a more
user-friendly way.

> +{
> +       int cpu = bpf_get_smp_processor_id();
> +       __u32 key = cpu;
> +       long stackid, err;
> +
> +       /* check the program runs on the right cpu */
> +       if (ctx->args[0] && ctx->args[0] != cpu + 1)
> +               cpu_match = 0;
> +
> +       /* check the sum of arguments are correct */
> +       sum = ctx->args[0] + ctx->args[1] + ctx->args[2] +
> +               ctx->args[3] + ctx->args[4];
> +
> +       /* check bpf_get_stackid works */
> +       stackid = bpf_get_stackid(ctx, &stackmap, 0);
> +       if (stackid >= 0)
> +               get_stackid_success++;
> +
> +       /* check bpf_get_stack works */
> +       err = bpf_get_stack(ctx, (void *)stacktrace,
> +                           PERF_MAX_STACK_DEPTH * sizeof(__u64),
> +                           BPF_F_USER_STACK);
> +       if (err >= 0)
> +               get_stack_success++;
> +
> +       return cpu + 2;
> +}
> --
> 2.24.1
>
