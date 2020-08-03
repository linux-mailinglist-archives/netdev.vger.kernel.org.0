Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2CC23AAFE
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgHCQyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgHCQyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:54:25 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197FFC06174A;
        Mon,  3 Aug 2020 09:54:25 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a34so15432762ybj.9;
        Mon, 03 Aug 2020 09:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AX8HYptnx+t0Vh/etL5nxwW+RppxP5tYEAiauUZVtwA=;
        b=aRgJMOIk7XuXyRMzkTaBXjSVVK1rRF4+GNUKeLAfg5myyB/npPPW//jxxvHOrB0Yh4
         zvLfJ2mT+Ygn9mT9oqR0ul9TgNwWTcrL1E9O0fL8WJXX/R4svOjRAz/0v8VH0gzg9yE5
         9GIfbrY7hYL3TR+IkGDsWU3kklR7TxHcxiAdqFpimb98amdLmKnqxQfPP/c/lN/ExuDD
         MgfBFAks8Yuk7dA01DpvY+T0Spn7i3NZR4K723uDN8u6u0V7blg/QERnv6UVEw3K6Gwm
         5oPmzwAVLpOx6jNKda//755sOZjZoWBSfFqEMlHD7rlztCgc8ELhBLY3n6CG5V9lDFkI
         hF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AX8HYptnx+t0Vh/etL5nxwW+RppxP5tYEAiauUZVtwA=;
        b=Icigy7v8ZyM1DYNY2fJvEfzaBfW1ePH3cSXYoju6WfC6xfWPXW0rIEv+mZLDfYYqJ2
         l1zCH2YdStu1jQWyChu0aXQYQ9/ajGPU7PJS+oRRLZBi6DPNDWW7UdE/p6HFIplJTBcb
         HnMC/9yVO3f/LNTdkNQbuP+MqVA5Wit4yldaU5PoQn4WvtOHXOcFg+oEOkpIEZqrpugj
         sY/3Rt0o+1Lzh6ZCaLlbqh8bJQUd4Qi5Vn5s+MvFGzOD+cfiLI2KYfQ8RYKvzpR45lCo
         WaEkAqTnBPVCEcvlxDPz64ZoAg65avPTfQ89gWZpmctIuEHcs1YA1BZgRsGXbsLV0IY8
         W78w==
X-Gm-Message-State: AOAM530MLH8IKD4jXqV51NEC0qdjGWLX31VjO58hF8JOdLn3UMmS0RSZ
        LxQ9vPHVskWbJjr83tpGgBodlAonaMZM6enWf7o=
X-Google-Smtp-Source: ABdhPJxLVNzWdoIgwKnsG2XzpfNJ6Uqe6bi5oX6Ar0fhb5K2iomeXqljsUlCyBFp4tCbeizB+k1Q7okxfQiDAu2CHow=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr25060567yba.230.1596473664341;
 Mon, 03 Aug 2020 09:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200802213321.7445-1-cneirabustos@gmail.com>
In-Reply-To: <20200802213321.7445-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Aug 2020 09:54:13 -0700
Message-ID: <CAEf4BzbnygfGgxzY_h1gpnCUAoMF2Qwu76Zc-ULRoziFLFsXLw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
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

On Sun, Aug 2, 2020 at 2:36 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds a test case into test_progs.
>
> Changes from V2:
>  - Tests are now using skeleton.
>  - Test not creating a new namespace has been included in test_progs.
>  - Test creating a new pid namespace has been added as a standalone test.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |  2 +-
>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 85 -----------------
>  .../bpf/prog_tests/ns_current_pidtgid.c       | 59 ++++++++++++
>  .../bpf/progs/test_ns_current_pid_tgid.c      | 37 --------
>  .../bpf/progs/test_ns_current_pidtgid.c       | 25 +++++
>  ...new_ns.c => test_current_pidtgid_new_ns.c} |  0
>  .../bpf/test_ns_current_pidtgid_newns.c       | 91 +++++++++++++++++++
>  8 files changed, 178 insertions(+), 124 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
>  rename tools/testing/selftests/bpf/{test_current_pid_tgid_new_ns.c => test_current_pidtgid_new_ns.c} (100%)
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
> index e7a8cf83ba48..c1ba9c947196 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_cgroup_storage \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
>         test_progs-no_alu32 \
> -       test_current_pid_tgid_new_ns
> +       test_ns_current_pidtgid_newns
>
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)
> @@ -163,6 +163,7 @@ $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
>  $(OUTPUT)/test_netcnt: cgroup_helpers.c
>  $(OUTPUT)/test_sock_fields: cgroup_helpers.c
>  $(OUTPUT)/test_sysctl: cgroup_helpers.c
> +$(OUTPUT)/test_ns_current_pidtgid_newns: test_ns_current_pidtgid_newns.c

This dependency is implicit and not necessary. What you see above is
*additional* .c files that tests need.

>
>  DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)

[...]

> +void test_ns_current_pidtgid(void)
> +{
> +       int err, duration = 0;
> +       struct test_ns_current_pidtgid *skel;
> +       struct test_ns_current_pidtgid__bss  *bss;
> +       struct stat st;
> +       __u64 id;
> +
> +       skel = test_ns_current_pidtgid__open();
> +       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +               return;
> +
> +       err = test_ns_current_pidtgid__load(skel);
> +       if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
> +               goto cleanup;

nit: could be combined into a single test_ns_current_pidtgid__open_and_load()

> +
> +       pid_t tid = syscall(SYS_gettid);
> +       pid_t pid = getpid();
> +
> +       id = (__u64) tid << 32 | pid;
> +
> +       if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {

please use CHECK instead of CHECK_FAIL

> +               perror("Failed to stat /proc/self/ns/pid");
> +               goto cleanup;
> +       }
> +
> +       bss = skel->bss;
> +       bss->dev = st.st_dev;
> +       bss->ino = st.st_ino;
> +       bss->user_pid_tgid = 0;
> +

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
> +       skel = test_ns_current_pidtgid__open();
> +       err = test_ns_current_pidtgid__load(skel);

if open() fails, NULL pointer dereference happens here. But also
better use open_and_load() variant.

> +       if (err) {
> +               perror("Failed to load skeleton");
> +               goto cleanup;
> +       }
> +
> +       tid = syscall(SYS_gettid);
> +       pid = getpid();
> +       id = (__u64) tid << 32 | pid;
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
> +       err = test_ns_current_pidtgid__attach(skel);
> +       if (err) {
> +               printf("Failed to attach: %s err: %d\n", strerror(errno), err);
> +               goto cleanup;
> +       }
> +       /* trigger tracepoint */
> +       usleep(1);
> +
> +       if (bss->user_pid_tgid != id) {
> +               printf("test_ns_current_pidtgid_newns:FAIL\n");
> +               err = EXIT_FAILURE;
> +       } else {
> +               printf("test_ns_current_pidtgid_newns:PASS\n");
> +               err = EXIT_SUCCESS;
> +       }
> +
> +cleanup:
> +               setns(pidns_fd, CLONE_NEWPID);
> +               test_ns_current_pidtgid__destroy(skel);
> +
> +       return 0;

you don't return err from above

> +}
> +
> +int main(int argc, char **argv)
> +{
> +       pid_t cpid;
> +       int wstatus;
> +
> +       cpid = clone(newns_pidtgid,
> +                       child_stack + STACK_SIZE,
> +                       CLONE_NEWPID | SIGCHLD, NULL);
> +       if (cpid == -1) {
> +               printf("test_ns_current_pidtgid_newns:Failed on CLONE: %s\n",
> +                        strerror(errno));
> +               exit(EXIT_FAILURE);
> +       }
> +       if (waitpid(cpid, &wstatus, 0) == -1) {
> +               printf("test_ns_current_pidtgid_newns:Failed on waitpid: %s\n",
> +                       strerror(errno));

exit(EXIT_FAILURE) here?

> +       }
> +       return (WEXITSTATUS(wstatus));

nit: unnecessary ()

> +}
> --
> 2.20.1
>
