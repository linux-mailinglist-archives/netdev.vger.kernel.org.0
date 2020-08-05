Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCE023D2BA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgHEUPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgHEUPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 16:15:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D60C061575;
        Wed,  5 Aug 2020 13:15:17 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id q3so4990527ybp.7;
        Wed, 05 Aug 2020 13:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=STs0JLv/8EFWVZLzJX1i5UMZbwlbxsrfliZK8y5cx/8=;
        b=rFs+NgozImTs/QS3rwuyXbDIG3be53GBkBeCiGkanSSvi/pA+faRzSy1psurvDkeGy
         NbPbutW0oelAXcxhQievWeYL3wg1szjJ54fs/qiwfEFPmEVdAlaGoThFu6CvZ6e0gxGg
         CgOwi5cqHdsSHMd+QbhUbWz6nBlHbd0yd7UIEEC4k6sUsS6FyvhEBRY7kraWRzQqs40S
         9W7jxT0wsZWSCdYPlTBQWGc6wDBcEy1BArN55wktyZBH2t6MNu7v4ecK3vAmBUISgpPj
         3238oA6Wr+oJGLtafnErd15SWHpSVOxQCSG2kvEBvDgFQH3AIHiMqv+0CwXjcRA4vKmv
         QIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=STs0JLv/8EFWVZLzJX1i5UMZbwlbxsrfliZK8y5cx/8=;
        b=ZDPvpIElcXmNx2ss+GrSeF0jpuWsPND5BW8L0w/cgULDM63Slg4d7k7s3M6ervBVVt
         R2zri3TAbeuGz5e0qBcC0Nan1cUHSywJ9SmBZr528fTtUvv/Lgym3PlMymLKprcGG3B0
         CZNwWN/QeBkleTsVeokkfbVXTQrCy5lyRU1ns5AxGPqq2RqnyQ3Zdq6lZz7RJOfk9Jya
         XttGyvmwgNCnmJUXOAU1tHIMpcuHb/+EWJnbw+hbHXcHXQqpaMo6KTpl6f5Y76WqV5FN
         c5D/oSfETN58ctODzrrPeJnn+EUUIP1iEB2EzNz8enr9IH+cB0X+YuoKXhABQ93t5+RJ
         jW/g==
X-Gm-Message-State: AOAM5304OGFVjqpACmTq10o9z3x9JsNWGEx/YUoAjZrzslFfiCJF1IK7
        dEBtyFDhztdRzcW6iUyBlmiWZ2VvIXrl3JI32IRuYQ==
X-Google-Smtp-Source: ABdhPJyJEb7l/LvXmvpttlLN+6/7Yvc1MYwgR3na5ibRPN7WIAOizDAw9EnUWZgTfasHAz3cKAZoHyqfGYfnxWIWvcU=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr7019155ybe.510.1596658516313;
 Wed, 05 Aug 2020 13:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200805163503.40381-1-cneirabustos@gmail.com>
In-Reply-To: <20200805163503.40381-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 13:15:05 -0700
Message-ID: <CAEf4BzYrek8shqzUj+zNC=TjGkDPCKUFP=YnbiNf6360f1MyTw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 1:06 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds a test case into test_progs.
>
> Changes from V3:
>  - STAT(2) check changed from CHECK_FAIL to CHECK.
>  - Changed uses of _open_ to _open_and_load.
>  - Fixed error codes were not being returned on exit.
>  - Removed unnecessary dependency on Makefile
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---

bpf-next is closed, you'll have to re-submit once it opens in roughly
two weeks. Looks good overall, few minor things below, please
incorporate into next revision with my ack:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/.gitignore        |   2 +-
>  tools/testing/selftests/bpf/Makefile          |   4 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
>  .../bpf/prog_tests/ns_current_pidtgid.c       |  54 ++++++
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
>  .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
>  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
>  .../bpf/test_ns_current_pidtgid_newns.c       |  91 ++++++++++
>  8 files changed, 173 insertions(+), 284 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>  create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 1bb204cee853..022055f23592 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -30,8 +30,8 @@ test_tcpnotify_user
>  test_libbpf
>  test_tcp_check_syncookie_user
>  test_sysctl
> -test_current_pid_tgid_new_ns
>  xdping
> +test_ns_current_pidtgid_newns
>  test_cpp
>  *.skel.h
>  /no_alu32
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e7a8cf83ba48..92fb616cdd27 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -36,8 +36,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
>         test_cgroup_storage \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> -       test_progs-no_alu32 \
> -       test_current_pid_tgid_new_ns
> +       test_progs-no_alu32\

accidentally removed space?

> +       test_ns_current_pidtgid_newns
>
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)

[...]

> +
> +void test_ns_current_pidtgid(void)
> +{
> +       struct test_ns_current_pidtgid__bss  *bss;
> +       struct test_ns_current_pidtgid *skel;
> +       int err, duration = 0;
> +       struct stat st;
> +       __u64 id;
> +
> +       skel = test_ns_current_pidtgid__open_and_load();
> +       CHECK(!skel, "skel_open_load", "failed to load skeleton\n");
> +               goto cleanup;
> +
> +       pid_t tid = syscall(SYS_gettid);
> +       pid_t pid = getpid();

hm... I probably missed this last time. This is not a valid C89
standard-compliant code, all variables have to be declared up top,
please split variable declaration and initialization.

> +
> +       id = (__u64) tid << 32 | pid;
> +
> +       err = stat("/proc/self/ns/pid", &st);
> +       if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
> +               goto cleanup;
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> new file mode 100644
> index 000000000000..9818a56510d9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> +
> +#include <linux/bpf.h>
> +#include <stdint.h>
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 user_pid_tgid = 0;
> +__u64 dev = 0;
> +__u64 ino = 0;
> +
> +SEC("raw_tracepoint/sys_enter")
> +int handler(const void *ctx)
> +{
> +       struct bpf_pidns_info nsdata;
> +
> +       if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
> +                  sizeof(struct bpf_pidns_info)))
> +               return 0;
> +       user_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;

nit: good idea to put () around << expression when combined with other
bitwise operators.

> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";

[...]

> +static int newns_pidtgid(void *arg)
> +{
> +       struct test_ns_current_pidtgid__bss  *bss;
> +       struct test_ns_current_pidtgid *skel;
> +       int pidns_fd = 0, err = 0;
> +       pid_t pid, tid;
> +       struct stat st;
> +       __u64 id;
> +
> +       skel = test_ns_current_pidtgid__open_and_load();
> +       if (!skel) {
> +               perror("Failed to load skeleton");
> +               goto cleanup;
> +       }
> +
> +       tid = syscall(SYS_gettid);
> +       pid = getpid();
> +       id = (__u64) tid << 32 | pid;

see, you don't do it here :)


> +
> +       if (stat("/proc/self/ns/pid", &st)) {
> +               printf("Failed to stat /proc/self/ns/pid: %s\n",
> +                       strerror(errno));
> +               goto cleanup;
> +       }
> +
> +       bss = skel->bss;
> +       bss->dev = st.st_dev;
> +       bss->ino = st.st_ino;
> +       bss->user_pid_tgid = 0;
> +

[...]
