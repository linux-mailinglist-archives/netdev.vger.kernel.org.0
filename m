Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2F125E22E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIDTtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgIDTtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:49:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B004EC061245;
        Fri,  4 Sep 2020 12:49:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id c17so5217266ybe.0;
        Fri, 04 Sep 2020 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iKxO9iJ5L6PJ3FfNUJvxQcSb/6FSTKaJ7GKUZ/DrJ3k=;
        b=cdslCMWs0Ce20BNa66hcBHDN4yQPS884urDnbWnXdJmjFI/rfi9tuzF8rpIb4vMERT
         SESZmPA+PxkiGHc/HVwMo2NXf4RuTsrvAdB/AwnR6WaLFHvSPC+xr8CMrBQALqXo07KP
         0xTuIelQAPen/Nf9sDYE+tNGOirtNpCN7pnc93Hgg6LunF6YiuWrIgr0D2JVuF1p5X2o
         4cOAEeBloMkcH2WOz8Xwnbz7s07Q5HjJGmNFD/vlmz6AA38GdJcI3OfMfMMM0tryu9tS
         U1MJlQqyEx5T7Mv54BGuiwnnPJ4nlMbNLwHEV36jiE7V+0NofuFZMNdgJQK5M/qL3oBJ
         Gxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iKxO9iJ5L6PJ3FfNUJvxQcSb/6FSTKaJ7GKUZ/DrJ3k=;
        b=Q3SJpom290mLfK99xjm0IP99cv03QFvQtR8yOnREo6kcBy1gmOwK/kpg/zZCAmUf+1
         zNvtaJSc9p0k6qwr9lir9kRJJUMsKfO5vbLvDuINYtzqTuiicEJHBgp5GL2PzPPFh8QO
         9EiTZ6nyLQzIlWWDu53cenQ+s1LvKd66nW2LDMkpPgCyAVsU7eNgLjAUpT8VLbdrq9dE
         joiut8tvCNlJrB9/lcBcjAdls0ZZNKZSBRQIp/51bpO111x59tHwOdkIw4UaFbVcWwYP
         x3l59xQ9Xh12r58r0sIjxNIOanJrrWkj/SLF5wRV+qM68LO65Wuj2bFyWVrlGEekdZKI
         lJ5g==
X-Gm-Message-State: AOAM5339Ql2U3Rxn6zLC9VgL6HRYgLVfP4VEckrmy/rcPNmNF93+il6Z
        C4biaaZM0a5czUmtKvNIMBVq4M9j0k8ERavnCRI=
X-Google-Smtp-Source: ABdhPJwGwS4i852REew6ZZu38pwBVO5T5/QlNjqid6jCwKsd8EWOFKX/UJNWNDrnH2YjBKk4O4WjHOiGLT2Myzhsgh0=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr12441105ybp.403.1599248955889;
 Fri, 04 Sep 2020 12:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-4-haoluo@google.com>
In-Reply-To: <20200903223332.881541-4-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 12:49:04 -0700
Message-ID: <CAEf4BzZPMwe=kz_K8P-6aeLiJo4rC69bMvju4=JEEv0CDEE9_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf/selftests: ksyms_btf to test typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
>
> Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> the other is a plain int. This tests two paths in the kernel. Struct
> ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> typed ksyms will be converted into PTR_TO_MEM.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  .../testing/selftests/bpf/prog_tests/ksyms.c  | 31 +++------
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 63 +++++++++++++++++++
>  .../selftests/bpf/progs/test_ksyms_btf.c      | 23 +++++++
>  tools/testing/selftests/bpf/trace_helpers.c   | 26 ++++++++
>  tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
>  5 files changed, 123 insertions(+), 24 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> new file mode 100644
> index 000000000000..7b6846342449
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Google */
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include "test_ksyms_btf.skel.h"
> +
> +static int duration;
> +
> +void test_ksyms_btf(void)
> +{
> +       __u64 runqueues_addr, bpf_prog_active_addr;
> +       struct test_ksyms_btf *skel;
> +       struct test_ksyms_btf__data *data;
> +       struct btf *btf;
> +       int percpu_datasec;
> +       int err;
> +
> +       err = kallsyms_find("runqueues", &runqueues_addr);
> +       if (CHECK(err == -ENOENT, "kallsyms_fopen", "failed to open: %d\n", errno))
> +               return;
> +       if (CHECK(err == -EINVAL, "ksym_find", "symbol 'runqueues' not found\n"))
> +               return;
> +
> +       err = kallsyms_find("bpf_prog_active", &bpf_prog_active_addr);
> +       if (CHECK(err == -EINVAL, "ksym_find", "symbol 'bpf_prog_active' not found\n"))
> +               return;
> +
> +       btf = libbpf_find_kernel_btf();
> +       if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
> +                 PTR_ERR(btf)))
> +               return;
> +
> +       percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
> +                                               BTF_KIND_DATASEC);
> +       if (percpu_datasec < 0) {
> +               printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
> +                      __func__);
> +               test__skip();

leaking btf here

> +               return;
> +       }
> +
> +       skel = test_ksyms_btf__open_and_load();
> +       if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))

here

> +               return;
> +
> +       err = test_ksyms_btf__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       /* trigger tracepoint */
> +       usleep(1);
> +
> +       data = skel->data;
> +       CHECK(data->out__runqueues != runqueues_addr, "runqueues",
> +             "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
> +       CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
> +             "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);

u64 is not %llu on some arches, please cast explicitly to (unsigned long long)

> +
> +cleanup:

... and here (I suggest to just jump from all those locations here for cleanup)

> +       test_ksyms_btf__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> new file mode 100644
> index 000000000000..e04e31117f84
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Google */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 out__runqueues = -1;
> +__u64 out__bpf_prog_active = -1;

this is addresses, not values, so _addr part would make it clearer.

> +
> +extern const struct rq runqueues __ksym; /* struct type global var. */
> +extern const int bpf_prog_active __ksym; /* int type global var. */

When we add non-per-CPU kernel variables, I wonder if the fact that we
have both per-CPU and global kernel variables under the same __ksym
section would cause any problems and confusion? It's not clear to me
if we need to have a special __percpu_ksym section or not?..

> +
> +SEC("raw_tp/sys_enter")
> +int handler(const void *ctx)
> +{
> +       out__runqueues = (__u64)&runqueues;
> +       out__bpf_prog_active = (__u64)&bpf_prog_active;
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> index 4d0e913bbb22..ade555fe8294 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.c
> +++ b/tools/testing/selftests/bpf/trace_helpers.c
> @@ -90,6 +90,32 @@ long ksym_get_addr(const char *name)
>         return 0;
>  }
>
> +/* open kallsyms and read symbol addresses on the fly. Without caching all symbols,
> + * this is faster than load + find. */
> +int kallsyms_find(const char *sym, unsigned long long *addr)
> +{
> +       char type, name[500];
> +       unsigned long long value;
> +       int err = 0;
> +       FILE *f;
> +
> +       f = fopen("/proc/kallsyms", "r");
> +       if (!f)
> +               return -ENOENT;
> +
> +       while (fscanf(f, "%llx %c %499s%*[^\n]\n", &value, &type, name) > 0) {
> +               if (strcmp(name, sym) == 0) {
> +                       *addr = value;
> +                       goto out;
> +               }
> +       }
> +       err = -EINVAL;

These error codes seem backward to me. If you fail to open
/proc/kallsyms, that's an unexpected and invalid situation, so EINVAL
makes a bit more sense there. But -ENOENT is clearly for cases where
you didn't find what you were looking for, which is exactly this case.


> +
> +out:
> +       fclose(f);
> +       return err;
> +}
> +
>  void read_trace_pipe(void)
>  {
>         int trace_fd;
> diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
> index 25ef597dd03f..f62fdef9e589 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.h
> +++ b/tools/testing/selftests/bpf/trace_helpers.h
> @@ -12,6 +12,10 @@ struct ksym {
>  int load_kallsyms(void);
>  struct ksym *ksym_search(long key);
>  long ksym_get_addr(const char *name);
> +
> +/* open kallsyms and find addresses on the fly, faster than load + search. */
> +int kallsyms_find(const char *sym, unsigned long long *addr);
> +
>  void read_trace_pipe(void);
>
>  #endif
> --
> 2.28.0.526.ge36021eeef-goog
>
