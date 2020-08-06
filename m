Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2023DE80
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgHFR0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbgHFRCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:02:25 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF23C0A54D9;
        Thu,  6 Aug 2020 07:03:30 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id p4so1195485qkf.0;
        Thu, 06 Aug 2020 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JOvK3mlRWVtrCzRPPugSEdDzfzMZZqm2wdlRVxRdHEA=;
        b=qJOOeObm+/nub/UBnhSekFVsw6Jzss/ug0YWz664tPulD2NoRqV4A3NyxE/uwMScRD
         KN74mIpBB8uMFgBw9CV21yAoYdFJjRbDL61csI+1JjI3mOJpaxrsSJMOM7zoHWvOzyj5
         1zI0PUtNpHv1GLsrcMFCLY8q0RQQocOK04skuubgTmJINgFsxFrboFe9upgPCt9DN/2n
         Ml68KF5235AkRVXYfpX/XfLh91lbKl2rOb5X2PxaZvPhGLAq+fyLOeHgqjLr4v95VzO5
         I7+cWJCIuQAn+dYzdOJK7DysgeY0JYcRAAB9x1bY4WwjuyCuQOYII4AgeRhBHRF3kEIb
         vDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JOvK3mlRWVtrCzRPPugSEdDzfzMZZqm2wdlRVxRdHEA=;
        b=Bpbz9vrYVGTZUlKLWZXunqje50eaWEM1AIKqrTooO+v5qWA9F2p2bSuOa/CuLzACKl
         6NHQ6Q/x4vQj0c0JQ9ct1PRyjoEq/SWSs4bE6eUXu/3BayxcgIc2dxFzAqqVuJC8GcTF
         O5c099nApjkh2OUCce/JdJZ1XV/PjUEZ1LPuQjpp8xwgELg7BUoe2DELs7pNeYmhHNaA
         WLuZ0wmvVKTwG0RAAOJj9OhdSwC2IkC2aUTKykAa2BULHEyaHvift3WRlyBs4VvQVq0g
         Rmi4g+LNmThzF6ABQOZlfgSHLjrsZNeLSd2Or3QAUZP5Y3H6pWwlJz2myNT1ij+4fgk5
         1GAA==
X-Gm-Message-State: AOAM5307v/VIP2yzby9lw3tr3kBCtsTby+q84FUDmNaKypS/SAO9SM7U
        Ek0XmdfQTrqmngnRXYFx4kA=
X-Google-Smtp-Source: ABdhPJw4yglAOFwmGHEN2MssKpWIn/Cu9cU1Q7NsC61jUQWR3rDI6JTZ+wnSJRKug+xBLToRvHeTFQ==
X-Received: by 2002:a37:64d7:: with SMTP id y206mr8361357qkb.133.1596722605635;
        Thu, 06 Aug 2020 07:03:25 -0700 (PDT)
Received: from bpf-dev (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.gmail.com with ESMTPSA id y26sm4727644qto.75.2020.08.06.07.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:03:24 -0700 (PDT)
Date:   Thu, 6 Aug 2020 10:03:20 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
Message-ID: <20200806140319.GA40984@bpf-dev>
References: <20200805163503.40381-1-cneirabustos@gmail.com>
 <CAEf4BzYrek8shqzUj+zNC=TjGkDPCKUFP=YnbiNf6360f1MyTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYrek8shqzUj+zNC=TjGkDPCKUFP=YnbiNf6360f1MyTw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 01:15:05PM -0700, Andrii Nakryiko wrote:
> On Wed, Aug 5, 2020 at 1:06 PM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> > This change folds a test case into test_progs.
> >
> > Changes from V3:
> >  - STAT(2) check changed from CHECK_FAIL to CHECK.
> >  - Changed uses of _open_ to _open_and_load.
> >  - Fixed error codes were not being returned on exit.
> >  - Removed unnecessary dependency on Makefile
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> 
> bpf-next is closed, you'll have to re-submit once it opens in roughly
> two weeks. Looks good overall, few minor things below, please
> incorporate into next revision with my ack:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  tools/testing/selftests/bpf/.gitignore        |   2 +-
> >  tools/testing/selftests/bpf/Makefile          |   4 +-
> >  .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
> >  .../bpf/prog_tests/ns_current_pidtgid.c       |  54 ++++++
> >  .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
> >  .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
> >  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
> >  .../bpf/test_ns_current_pidtgid_newns.c       |  91 ++++++++++
> >  8 files changed, 173 insertions(+), 284 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> >  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> >  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> >  create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
> >
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index 1bb204cee853..022055f23592 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -30,8 +30,8 @@ test_tcpnotify_user
> >  test_libbpf
> >  test_tcp_check_syncookie_user
> >  test_sysctl
> > -test_current_pid_tgid_new_ns
> >  xdping
> > +test_ns_current_pidtgid_newns
> >  test_cpp
> >  *.skel.h
> >  /no_alu32
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index e7a8cf83ba48..92fb616cdd27 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -36,8 +36,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >         test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
> >         test_cgroup_storage \
> >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> > -       test_progs-no_alu32 \
> > -       test_current_pid_tgid_new_ns
> > +       test_progs-no_alu32\
> 
> accidentally removed space?
> 
> > +       test_ns_current_pidtgid_newns
> >
> >  # Also test bpf-gcc, if present
> >  ifneq ($(BPF_GCC),)
> 
> [...]
> 
> > +
> > +void test_ns_current_pidtgid(void)
> > +{
> > +       struct test_ns_current_pidtgid__bss  *bss;
> > +       struct test_ns_current_pidtgid *skel;
> > +       int err, duration = 0;
> > +       struct stat st;
> > +       __u64 id;
> > +
> > +       skel = test_ns_current_pidtgid__open_and_load();
> > +       CHECK(!skel, "skel_open_load", "failed to load skeleton\n");
> > +               goto cleanup;
> > +
> > +       pid_t tid = syscall(SYS_gettid);
> > +       pid_t pid = getpid();
> 
> hm... I probably missed this last time. This is not a valid C89
> standard-compliant code, all variables have to be declared up top,
> please split variable declaration and initialization.
> 
> > +
> > +       id = (__u64) tid << 32 | pid;
> > +
> > +       err = stat("/proc/self/ns/pid", &st);
> > +       if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
> > +               goto cleanup;
> > +
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> > new file mode 100644
> > index 000000000000..9818a56510d9
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> > +
> > +#include <linux/bpf.h>
> > +#include <stdint.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +__u64 user_pid_tgid = 0;
> > +__u64 dev = 0;
> > +__u64 ino = 0;
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int handler(const void *ctx)
> > +{
> > +       struct bpf_pidns_info nsdata;
> > +
> > +       if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
> > +                  sizeof(struct bpf_pidns_info)))
> > +               return 0;
> > +       user_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> 
> nit: good idea to put () around << expression when combined with other
> bitwise operators.
> 
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> 
> [...]
> 
> > +static int newns_pidtgid(void *arg)
> > +{
> > +       struct test_ns_current_pidtgid__bss  *bss;
> > +       struct test_ns_current_pidtgid *skel;
> > +       int pidns_fd = 0, err = 0;
> > +       pid_t pid, tid;
> > +       struct stat st;
> > +       __u64 id;
> > +
> > +       skel = test_ns_current_pidtgid__open_and_load();
> > +       if (!skel) {
> > +               perror("Failed to load skeleton");
> > +               goto cleanup;
> > +       }
> > +
> > +       tid = syscall(SYS_gettid);
> > +       pid = getpid();
> > +       id = (__u64) tid << 32 | pid;
> 
> see, you don't do it here :)
> 
> 
> > +
> > +       if (stat("/proc/self/ns/pid", &st)) {
> > +               printf("Failed to stat /proc/self/ns/pid: %s\n",
> > +                       strerror(errno));
> > +               goto cleanup;
> > +       }
> > +
> > +       bss = skel->bss;
> > +       bss->dev = st.st_dev;
> > +       bss->ino = st.st_ino;
> > +       bss->user_pid_tgid = 0;
> > +
> 
> [...]

Andrii,

Thank you very much, I'll incorporate these changes on the next revision.

Bests.
