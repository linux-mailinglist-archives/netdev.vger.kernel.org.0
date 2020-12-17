Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419A92DC9D3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgLQAJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgLQAJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:09:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14929C06179C;
        Wed, 16 Dec 2020 16:08:59 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id t13so24069591ybq.7;
        Wed, 16 Dec 2020 16:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hzyl8Vanq8UyFw4xpnzrxijKBEvJAOy66S3vapenpIg=;
        b=j3hinockrKt+52K9QHyd2DrtUBVDY0KVLpsBDFXR2r0FfwRxC05mCilhVcZ6WBvxru
         ams0rGIKGQ2uwqbgkW6365gJZBqnMlRm2UgqNOX+TAZSOcWqjk7ndf97kllpJkhFP2Xg
         lKBulALn4BzApe6h4hS9/ee6Mpi7BQNvgxkeXPVvj8sfh3d5hsaJh7C26jsCxmiYp6r1
         FGakqQbHAugBdALv6FBw9/y2PhYmdfdx6TmlQlFweBGA8X7LnkRQXqhW2E2lxjCsL7kG
         7Ca5r63eP0K8I043aliRiYIRYQo/QF22S286wGsJLvZ2CxOCEqHk2gaZA5hYFbjJrWRf
         LrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hzyl8Vanq8UyFw4xpnzrxijKBEvJAOy66S3vapenpIg=;
        b=V8b0oztp68wNqoA8thAPDkkaajkIu9kqcW+qlW25aB/nLcgQGQdvkEdg2DoUcfKUoK
         sW6fbpjfuGzgWobhlKLMlRMYWfvuESQbXSaprldaQpNVp3HOgnEyT6h1JZT5eq+EFL/u
         9x6mr+T9IgmPNXclMolPnyNem6hhaxEhCGK8lj38yxKn/v2N8LzalAdWY239JaX/tP7F
         kA8OHqTHp3+v9cxL8Ai4er+XN4QBFtwB6c02BV3oJ4VjDS++LBp9vlnhBl7YEtsd3sJ/
         DTurA8eYMt4cwVA3gcNCnvRsL/ReF7QbnwataHGBtAYLdUYXKQEimNruRHggv0KL3fBH
         TElg==
X-Gm-Message-State: AOAM533YvOVg76M4KpnRTJ8lNXkoPAZoefhEBREYFT1soZl14TGhcqiG
        GgW0aays07GQh356sj3ogy33W+7WvMAoimet9Lg=
X-Google-Smtp-Source: ABdhPJwnVERiiFWNoqxv1We2ohuhrUbG4eraM6rSw+kLRCzupSK81hgmWsQQVS2T6iznjq4fyetGj//plfaRpp6Siu8=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr54523853ybj.347.1608163738352;
 Wed, 16 Dec 2020 16:08:58 -0800 (PST)
MIME-Version: 1.0
References: <20201216141806.GA21694@localhost>
In-Reply-To: <20201216141806.GA21694@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 16:08:47 -0800
Message-ID: <CAEf4BzZ_Tk+zk8Sa3A+MhLq-8=8i5yRsUpDG8i8B22N30VgVFQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 6:18 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds test cases into test_progs.
>
> Changes from v8:
>
>  - Fixed code style
>  - Fixed CHECK macro usage
>  - Removed root namespace sub-test
>  - Split pid_tgid variable
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   1 -
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 115 ++++++-------
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  27 +--
>  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
>  5 files changed, 68 insertions(+), 238 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>

[...]

>
> -       err = bpf_object__load(obj);
> -       if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> +       skel = test_ns_current_pid_tgid__open_and_load();
> +       if (CHECK(!skel, "skel_open_load", "failed to load skeleton\n"))
>                 goto cleanup;
>
> -       bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> -       if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> -               goto cleanup;
> +       tid = syscall(SYS_gettid);
> +       pid = getpid();

So pid here corresponds to tgid from the BPF program
tid is thread ID, which is the same as pid in Linux kernel
terminology. So checks below are wrong and just by coincidence pass.
Which also might mean that test doesn't test enough?

Would it be possible to also check non-namespaced pid/tgid and see if
they are at least different? As is, this test doesn't give me enough
confidence it would catch issues.

>
> -       prog = bpf_object__find_program_by_title(obj, probe_name);
> -       if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
> -                 probe_name))
> +       err = stat("/proc/self/ns/pid", &st);
> +       if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
>                 goto cleanup;
>
> -       memset(&bss, 0, sizeof(bss));
> -       pid_t tid = syscall(SYS_gettid);
> -       pid_t pid = getpid();
> -
> -       id = (__u64) tid << 32 | pid;
> -       bss.user_pid_tgid = id;
> +       bss = skel->bss;
> +       bss->dev = st.st_dev;
> +       bss->ino = st.st_ino;
> +       bss->user_pid = 0;
> +       bss->user_tgid = 0;
>
> -       if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> -               perror("Failed to stat /proc/self/ns/pid");
> +       err = test_ns_current_pid_tgid__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
>                 goto cleanup;
> -       }
>
> -       bss.dev = st.st_dev;
> -       bss.ino = st.st_ino;
> +       /* trigger tracepoint */
> +       usleep(1);
>
> -       err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
> -       if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
> +       if (CHECK((pid_t)bss->user_pid != pid, "pid", "got %d != exp %d\n",
> +        (pid_t)bss->user_pid, pid))
>                 goto cleanup;
>
> -       link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> -       if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> -                 PTR_ERR(link))) {
> -               link = NULL;
> +       if (CHECK((pid_t)bss->user_tgid != tid, "tgid", "got %d != exp %d\n",
> +        (pid_t)bss->user_tgid, tid))

wrapped arguments need to be aligned with the first argument on the
first line, please pay attention to that, you have a similar problem
above.

But better yet in this case, just use ASSERT_EQ, which is more succinct:

ASSERT_EQ(bss->user_pid, pid, "pid");
ASSERT_EQ(bss->user_tgid, tid, "pid");

>                 goto cleanup;
> -       }
>
> -       /* trigger some syscalls */
> -       usleep(1);
> +cleanup:
> +       if (skel)

no need to check for null, skeleton's destroy() handles that already

> +               test_ns_current_pid_tgid__destroy(skel);
>
> -       err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> -       if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> -               goto cleanup;
> +       return err;
> +}
>
> -       if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
> -                 "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> -               goto cleanup;
> -cleanup:
> -       bpf_link__destroy(link);
> -       bpf_object__close(obj);
> +void test_ns_current_pid_tgid(void)
> +{
> +       int wstatus, duration = 0;
> +       pid_t cpid;
> +
> +       cpid = clone(newns_pid_tgid,
> +         child_stack + STACK_SIZE,
> +         CLONE_NEWPID | SIGCHLD, NULL);

I know nothing about namespaces, but seems like you are not doing
unshare(CLONE_NEWPID | CLONE_NEWNS) anymore, which previously was done
in the tests. What's up with that? You also used fork() before, now
you use clone(). It would be nice to explain the changes in the commit
message, so that reviewers don't have to dig through `man clone` that
much.

> +
> +       if (CHECK(cpid == -1, "clone", strerror(errno)))
> +               exit(EXIT_FAILURE);
> +
> +       if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid",
> +        strerror(errno)))
> +               exit(EXIT_FAILURE);
> +
> +
> +       if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid",
> +        "failed"))
> +               exit(EXIT_FAILURE);
>  }

[...]
