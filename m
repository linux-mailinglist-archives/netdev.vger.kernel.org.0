Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ACC276135
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWTlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWTlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:41:02 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3F8C0613CE;
        Wed, 23 Sep 2020 12:41:02 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s19so595467ybc.5;
        Wed, 23 Sep 2020 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/G1ZifA23tGD+rmBUvIw0j4DCLnW+G64Yu4Sv+ViCE=;
        b=JG6VlsmZi7MWIJLQ/feMRwUhGzWobnorf3O6s22HroNZpQC2jIkSjRjt28rAsvfRck
         TOta0Qd1a7d3qkSHigmUTYykrkzQYV+rA7rdlqHG9F1z2Z9oWRK0RF6+v2AkGgsJKCBa
         oIqRz3En3knGLACxd99NCs7xd/p9aSZ7Nczoxb2ie4Qq2UaVTrCzDGbr4JXxbJhZ0MWT
         P1lraTB2aIUJZ8ddXPhUx3PXP96UEve5FSMJnKMo8A05L0uyCC5XHwcqrvsEbeGVdupG
         TJsclB3l8K4DLCMSetT12OVqmsQUg3Ex9JteU2IbKroYI/BV5qt7Fnosd6TAnX2C2Gyw
         jzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/G1ZifA23tGD+rmBUvIw0j4DCLnW+G64Yu4Sv+ViCE=;
        b=pPG1hzyPee0a4YhiQWPbsglKgc23opfaatkvgzyLRVZsCJlJXNIbTcqj8G+66Is40E
         NylOfyccz0yuoWEmHeU47fIhbRUDs33evZD6dcy5r3ZNbd3RO96UOuUSTcjiwhNJPPzK
         8u7i1kgog4vuZlzwIMXtbRDnyW6Dj6U0wIw89IR3Ho5T/lPkVel3FOkypX2UNp+jXDJr
         ZkPsbwe7p+mrcdYUFc+51TFIcRZE4czik6ALXEa7T8C4HWDDdCJODj5syldZX1ZnRthe
         KWNrs1mPA38jY2EShRyAzeRXadfutxw5+7+sr26SBCYcdHxq4yVVoks75kiqmHCmX4Aj
         xZNg==
X-Gm-Message-State: AOAM530B/wMaxvYUZ0vsaerI+AobEzvzYrIQOOP5ZGuVSmy7/PWEskxW
        rBULdmJfWaCidEZ5f4mUI06nHYZjSfeL2s6gRPM=
X-Google-Smtp-Source: ABdhPJxB2fsMG7C4v5a2QMLn1NWLY4SblMVNKsnGaIPyuYSKqmzzBRzj0ZPaabl+p4SURkiXnQqgArB16j40XUbU2qA=
X-Received: by 2002:a25:6644:: with SMTP id z4mr2366269ybm.347.1600890061803;
 Wed, 23 Sep 2020 12:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165401.2284447-1-songliubraving@fb.com> <20200923165401.2284447-4-songliubraving@fb.com>
In-Reply-To: <20200923165401.2284447-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 12:40:51 -0700
Message-ID: <CAEf4Bzb2KdA3m6-hfH96HxwCvPeOyNQ59LRm0rW8OWs+7zyMHQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
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

On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
>
> This test runs test_run for raw_tracepoint program. The test covers ctx
> input, retval output, and proper handling of cpu_plus field.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/raw_tp_test_run.c          | 73 +++++++++++++++++++
>  .../bpf/progs/test_raw_tp_test_run.c          | 26 +++++++
>  2 files changed, 99 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
> new file mode 100644
> index 0000000000000..3c6523b61afc1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2019 Facebook */
> +#include <test_progs.h>
> +#include "bpf/libbpf_internal.h"
> +#include "test_raw_tp_test_run.skel.h"
> +
> +static int duration;
> +
> +void test_raw_tp_test_run(void)
> +{
> +       struct bpf_prog_test_run_attr test_attr = {};
> +       __u64 args[2] = {0x1234ULL, 0x5678ULL};
> +       int comm_fd = -1, err, nr_online, i;
> +       int expected_retval = 0x1234 + 0x5678;
> +       struct test_raw_tp_test_run *skel;
> +       char buf[] = "new_name";
> +       bool *online = NULL;
> +
> +       err = parse_cpu_mask_file("/sys/devices/system/cpu/online", &online,
> +                                 &nr_online);
> +       if (CHECK(err, "parse_cpu_mask_file", "err %d\n", err))
> +               return;
> +
> +       skel = test_raw_tp_test_run__open_and_load();
> +       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +               return;

leaking memory here

> +       err = test_raw_tp_test_run__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       comm_fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
> +       if (CHECK(comm_fd < 0, "open /proc/self/comm", "err %d\n", errno))
> +               goto cleanup;
> +

[...]

> +SEC("raw_tp/task_rename")
> +int BPF_PROG(rename, struct task_struct *task, char *comm)
> +{
> +
> +       count++;
> +       if ((unsigned long long) task == 0x1234 &&
> +           (unsigned long long) comm == 0x5678) {

you can use shorter __u64?

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
