Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D92779F2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgIXUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIXUJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:09:32 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5542C0613CE;
        Thu, 24 Sep 2020 13:09:32 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h9so351757ybm.4;
        Thu, 24 Sep 2020 13:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7J41NLfAQ7GGWFlQfsQEAm0BJem7+QZ5TkgJ5oKJ9Yw=;
        b=jA7OFjlVQbEWru2KFbx3QXi3b2CE69ugcLLmLv6kXBTmABuJ7uuEJgyvLJw26wQbG1
         kdA1PygW1rjOZYUW/02nl1qN5gmXQhsqotYiPhH7eqNpvwQ2CtekAS9n27Jhf2KFMmAI
         e5Dp+WnkJKcrFYOnj0x4XsySenoPmkSvZ/G2MbNUH0yQAH4KVUmJoyY8RVwdKIcU9D+t
         +3/FkmsARrmOzPhRT7CqbOohktEIygrA6ONYyOICDEbIwsIqg8jN4GU+yPkQ2lAcy2He
         fxuHDoid7uSaav1PiR0kto8M2nVzlCUDuNyoTPJXXCcKTY3iVf2Z8vxMlPrtrD0YQqSS
         caVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7J41NLfAQ7GGWFlQfsQEAm0BJem7+QZ5TkgJ5oKJ9Yw=;
        b=HWnrQx1zdxhExx958mZC7PAaOehuYRZCl6llnygheVc/gqe/3jlCxct8LBSvS12fV8
         Zk0IKt7cIdlG1qfDD4hUyLEGDj+ZEV6H2QY336NedxeMzFYhGP5dcWcPe9QwyW5nteru
         A+zAlQ+aIv9JzdM+Ww4hQZpKgWXiEP+AB+ONLJ9sLCAIcDxE8elCLmcKXQGZbOB4FpAT
         qPACKUjjgJVXF8jeR2ZqyADp+GeOJ/e8vFegrPKSdrSU6kheLme/6AgcccKGCLEc/g1x
         njJe6DqGQAl/xwGQRec05P3kuK3qcN0PaaChHjSpWksdkrhK9y8Hm8A4giBnJGsh8zaE
         eiAA==
X-Gm-Message-State: AOAM5311x2mLC3CSt3c269AH8G2mMXhNp1j26fgwFqMBCexmKQTm7BLx
        hkY+oqrkJhEbFmtJjchuifl6E2898Px68htPB1Y=
X-Google-Smtp-Source: ABdhPJxI8ZqRkLvOx3Uj6iRUIfuQcmxaHU/pH3vAV/2faSzxRfsopM1BBpjUPpzbir4pHbABcsG68EjE0Y9ZeSnI/tE=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr647390ybz.27.1600978171951;
 Thu, 24 Sep 2020 13:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200924011951.408313-1-songliubraving@fb.com> <20200924011951.408313-4-songliubraving@fb.com>
In-Reply-To: <20200924011951.408313-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:09:21 -0700
Message-ID: <CAEf4BzYtq3X3kma2Hd-OfkK=D9DeaxhD77dq2V73gj9aOWOrMQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 6:55 PM Song Liu <songliubraving@fb.com> wrote:
>
> This test runs test_run for raw_tracepoint program. The test covers ctx
> input, retval output, and running on correct cpu.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/raw_tp_test_run.c          | 79 +++++++++++++++++++
>  .../bpf/progs/test_raw_tp_test_run.c          | 25 ++++++
>  2 files changed, 104 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
>

[...]

> +       test_attr.ctx_size_in = sizeof(args);
> +       err = bpf_prog_test_run_xattr(&test_attr);
> +       CHECK(err < 0, "test_run", "err %d\n", errno);
> +       CHECK(test_attr.retval != expected_retval, "check_retval",
> +             "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
> +
> +       for (i = 0; i < nr_online; i++)

nit: this for loop is so multi-line that it deserves {}

> +               if (online[i]) {
> +                       DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> +                               .ctx_in = args,
> +                               .ctx_size_in = sizeof(args),
> +                               .flags = BPF_F_TEST_RUN_ON_CPU,
> +                               .retval = 0,
> +                               .cpu = i,
> +                       );
> +
> +                       err = bpf_prog_test_run_opts(
> +                               bpf_program__fd(skel->progs.rename), &opts);
> +                       CHECK(err < 0, "test_run_opts", "err %d\n", errno);
> +                       CHECK(skel->data->on_cpu != i, "check_on_cpu",
> +                             "expect %d got %d\n", i, skel->data->on_cpu);
> +                       CHECK(opts.retval != expected_retval,
> +                             "check_retval", "expect 0x%x, got 0x%x\n",
> +                             expected_retval, opts.retval);
> +               }

as I mentioned in the first patch, let's have a test specifying
ridiculous CPU and see if it properly fails and doesn't cause any
kernel warning

> +cleanup:
> +       close(comm_fd);
> +       test_raw_tp_test_run__destroy(skel);
> +       free(online);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
> new file mode 100644
> index 0000000000000..6b356e003d16c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>

nit: you don't need bpf_endian.h here, do you?

> +#include <bpf/bpf_tracing.h>
> +
> +__u32 count = 0;
> +__u32 on_cpu = 0xffffffff;
> +
> +SEC("raw_tp/task_rename")
> +int BPF_PROG(rename, struct task_struct *task, char *comm)
> +{
> +
> +       count++;
> +       if ((__u64) task == 0x1234ULL && (__u64) comm == 0x5678ULL) {
> +               on_cpu = bpf_get_smp_processor_id();
> +               return (int)task + (int)comm;
> +       }
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.24.1
>
