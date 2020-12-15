Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B732DB557
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgLOUnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgLOUnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:43:10 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95604C0617A6;
        Tue, 15 Dec 2020 12:42:30 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id s6so10265793qvn.6;
        Tue, 15 Dec 2020 12:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=122b3GJHBoI9hFt00W+Aw6LC5oNOnt0kv5GB8+1gaCQ=;
        b=IXWYyCfd3sstGkmdbL3Y2jm1Q+zuGhlD64i4QzL+YjRTGYFTG52jLbtAAUnkxIWHtt
         QyKfYI64hiF43twGiRG9Pu4rNbgPUfPl3tVG4Oepm5NZjtNnj8Sp+EZI5gVkoIwFZ6zC
         I3Y3cB7EMhGFmtJBd+27RVpSPpZWwjybhQdLnTxKFQLI6Op85FW98nTeDWWeVNHDef6D
         M2LuiALAUJIPpLpOBdpAi/u/Gta5AzhF2w8VgLA/WFdSIX5FOQMgpBBVWzStOioWDeYO
         9t+TKVsaIKndTji8/5+J5bt0SVCvCt/7nIcksL5hNOOFbKzhsnkkJVW1FYCfTVvFprTU
         9mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=122b3GJHBoI9hFt00W+Aw6LC5oNOnt0kv5GB8+1gaCQ=;
        b=HVSKiNn+q6XW4vv6g7MYj8SPA73jXztBHahIBEP/9Gxwnz7dHGM87HbDj+dAhHK5iM
         k9UpwtOSaKwFQt/A+igQA928XTiR7r+oWIJYwnEX9EJviOtKzqHhayLiUJi+Mcx85N8v
         +eVLW7r6WlQUAAJMfZrOcmgUzB3/6fIGB1Xcs6Qxi9UTgGeGrQTpfSqwjBP1quKt70MY
         3ybGAvSVG7ikwj2aTrOg1VVoNdKWxhuRYWKolGA4qrwgEUkEBlk87WzU0dKmPfI0Np1C
         ugrtRWRuew+TtLW3kV6ND34AJ6WhI2r/B4IT+JQU2fUMHQqDYnleUzZRDSeZ8XgDwCs6
         Lplg==
X-Gm-Message-State: AOAM533v4BgTcsheOlcBOQKnpqFIo6InA7jgxdRm1IUoxDicjxcYljFx
        ooXHNfqnvp6virpMf0ZsQsfLkdXmLDEg4Vp5
X-Google-Smtp-Source: ABdhPJzIiLLA6/oDjaFtA2buzc/M0cP4uhcm1HJswSEg8duZ8HgS0WbChY8h9Fo64X7wbYQKNadbGQ==
X-Received: by 2002:a0c:e583:: with SMTP id t3mr39426093qvm.42.1608064949772;
        Tue, 15 Dec 2020 12:42:29 -0800 (PST)
Received: from localhost (pc-145-79-45-190.cm.vtr.net. [190.45.79.145])
        by smtp.gmail.com with ESMTPSA id 198sm1565790qkk.4.2020.12.15.12.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 12:42:29 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:42:25 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v8 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
Message-ID: <20201215204224.GA15407@localhost>
References: <20201214174953.GA14038@localhost>
 <CAEf4BzapLB+ORVJz2zOzO7MsOUcHBRcO6b-NFCiboasMx9Vq0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzapLB+ORVJz2zOzO7MsOUcHBRcO6b-NFCiboasMx9Vq0g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii,

Thank you very much for checking this out!, you were right the test was
incorrect. I'll work on your feedback and resend.
Thanks!

On Tue, Dec 15, 2020 at 11:05:50AM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 14, 2020 at 10:39 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> > This change folds test cases into test_progs.
> >
> > Changes from V7:
> >  - Rebased changes.
> >  - Changed function scope.
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> please drop my ack for the next version given the changes requested, thanks!
> 
> > ---
> >  tools/testing/selftests/bpf/.gitignore        |   1 -
> >  tools/testing/selftests/bpf/Makefile          |   3 +-
> >  .../bpf/prog_tests/ns_current_pid_tgid.c      | 148 ++++++++++------
> >  .../bpf/progs/test_ns_current_pid_tgid.c      |  26 +--
> >  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
> >  5 files changed, 105 insertions(+), 233 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> >
> 
> [...]
> 
> >
> > -       obj = bpf_object__open_file(file, NULL);
> > -       if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> > -               return;
> > +       skel = test_ns_current_pid_tgid__open_and_load();
> > +       CHECK(!skel, "skel_open_load", "failed to load skeleton\n");
> > +       goto cleanup;
> 
> Are you sure your test is doing what you think it's doing? Try running
> `sudo ./test_progs -t ns_current_pid_tgid -v` and see if you get all
> the CHECK()s you expect.
> 
> It's a long way of saying that you are missing `if ()` and just
> unconditionally clean up after opening and loading the skeleton.
> 
> And if the skeleton is not open_and_load()'ed successfully, there is
> nothing to clean up, btw.
> 
> >
> > -       err = bpf_object__load(obj);
> > -       if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> > -               goto cleanup;
> > +       tid = syscall(SYS_gettid);
> > +       pid = getpid();
> > +
> > +       id = ((__u64)tid << 32) | pid;
> >
> > -       bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> > -       if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> > +       err = stat("/proc/self/ns/pid", &st);
> > +       if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
> >                 goto cleanup;
> >
> > -       prog = bpf_object__find_program_by_title(obj, probe_name);
> > -       if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
> > -                 probe_name))
> > +       bss = skel->bss;
> > +       bss->dev = st.st_dev;
> > +       bss->ino = st.st_ino;
> > +       bss->user_pid_tgid = 0;
> > +
> > +       err = test_ns_current_pid_tgid__attach(skel);
> > +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> >                 goto cleanup;
> >
> > -       memset(&bss, 0, sizeof(bss));
> > -       pid_t tid = syscall(SYS_gettid);
> > -       pid_t pid = getpid();
> > +       /* trigger tracepoint */
> > +       usleep(1);
> >
> > -       id = (__u64) tid << 32 | pid;
> > -       bss.user_pid_tgid = id;
> > +       CHECK(bss->user_pid_tgid != id, "pid/tgid", "got %llu != exp %llu\n",
> > +        bss->user_pid_tgid, id);
> > +cleanup:
> > +        test_ns_current_pid_tgid__destroy(skel);
> > +}
> >
> > -       if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> > -               perror("Failed to stat /proc/self/ns/pid");
> > +static int newns_pidtgid(void *arg)
> 
> nit: pid_tgid?
> 
> > +{
> > +       struct test_ns_current_pid_tgid__bss  *bss;
> > +       int pidns_fd = 0, err = 0, duration = 0;
> > +       struct test_ns_current_pid_tgid *skel;
> > +       pid_t pid, tid;
> > +       struct stat st;
> > +       __u64 id;
> > +
> > +       skel = test_ns_current_pid_tgid__open_and_load();
> > +       if (!skel) {
> > +               perror("Failed to load skeleton");
> 
> please use CHECK() or ASSERT_OK_PTR() instead of perror()
> 
> >                 goto cleanup;
> >         }
> >
> > -       bss.dev = st.st_dev;
> > -       bss.ino = st.st_ino;
> > +       tid = syscall(SYS_gettid);
> > +       pid = getpid();
> > +       id = ((__u64) tid << 32) | pid;
> >
> 
> [...]
> 
> > +
> > +static void test_ns_current_pid_tgid_new_ns(void)
> > +{
> > +       int wstatus, duration = 0;
> > +       pid_t cpid;
> > +
> > +       cpid = clone(newns_pidtgid,
> > +         child_stack + STACK_SIZE,
> > +         CLONE_NEWPID | SIGCHLD, NULL);
> 
> formatting here and below for wrapped arguments looks wrong. Please
> double-check whitespaces and align arguments. There is also
> `scripts/checkpatch.pl -f <path-to-file>` which will help.
> 
> > +
> > +       if (CHECK(cpid == -1, "clone", strerror(errno)))
> > +               exit(EXIT_FAILURE);
> > +
> > +       if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid",
> > +        strerror(errno))) {
> > +               exit(EXIT_FAILURE);
> > +       }
> > +
> > +       CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid",
> > +        "failed");
> > +}
> > +
> > +void test_ns_current_pid_tgid(void)
> > +{
> > +       if (test__start_subtest("ns_current_pid_tgid_global_ns"))
> > +               test_ns_current_pid_tgid_global_ns();
> > +       if (test__start_subtest("ns_current_pid_tgid_new_ns"))
> > +               test_ns_current_pid_tgid_new_ns();
> >  }
> > diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > index 1dca70a6de2f..0daa12db0d83 100644
> > --- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > +++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > @@ -5,31 +5,19 @@
> >  #include <stdint.h>
> >  #include <bpf/bpf_helpers.h>
> >
> > -static volatile struct {
> > -       __u64 dev;
> > -       __u64 ino;
> > -       __u64 pid_tgid;
> > -       __u64 user_pid_tgid;
> > -} res;
> > +__u64 user_pid_tgid = 0;
> 
> imo, no need to combine pid and tgid into a single u64, why not using
> two separate global variables and keep it simple?
> 
> > +__u64 dev = 0;
> > +__u64 ino = 0;
> >
> >  SEC("raw_tracepoint/sys_enter")
> > -int trace(void *ctx)
> > +int handler(const void *ctx)
> >  {
> > -       __u64  ns_pid_tgid, expected_pid;
> >         struct bpf_pidns_info nsdata;
> > -       __u32 key = 0;
> >
> > -       if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
> > -                  sizeof(struct bpf_pidns_info)))
> > +       if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
> > +               sizeof(struct bpf_pidns_info)))
> 
> here as well, wrapped argument looks misaligned (unless it's my email client)
> 
> >                 return 0;
> > -
> > -       ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> > -       expected_pid = res.user_pid_tgid;
> > -
> 
> [...]
