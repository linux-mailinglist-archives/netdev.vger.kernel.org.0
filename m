Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29E20FFF2
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgF3WPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgF3WPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:15:44 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0D9C061755;
        Tue, 30 Jun 2020 15:15:44 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h23so16984864qtr.0;
        Tue, 30 Jun 2020 15:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pK1FGAJn5zXXtwc5XJEyCxMCJEKVZhRmn3aSzwOgSc8=;
        b=rTzIn9nI3q3mntJa4eKa7/IglYOgLBqE34iv5qD+BlQX6KrNNgtqgdbt34NNDAzaT8
         QyENiK9JKlJGSYlOB2lgtzWjZomirQKwZHlB69+Kx6EHXffFjQDdf9j/gEc58HKCvb6u
         s9taafRayKa16Vx6OKCVJpUBn+ZZtD7+nsYgVMwIKp7jHhTujxz1nIo3HnonngWs874o
         3SA9+eiacJ1DG9dsFbGIqh+93uSrZjBbE3TmuHJOROQo77zc3mAvrpeletRgtVspASgA
         p40T4B4GOZPEJv71D9dAmr+w1g4lYEWVaaX/lH7xQlXu56wSQeq+gB3ZFA0yhSAjxmSF
         tvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pK1FGAJn5zXXtwc5XJEyCxMCJEKVZhRmn3aSzwOgSc8=;
        b=dKbMLn2EpWdBxvbpqxU6Fafm5osHLgv2t2TvZG2+tBy3W15SVcSXxWURAoWfdgHMTA
         nAKTlBfVpsWPVYcZHSL2NmI5b404qeAY35OpVJtPGZ9CZZVSPhlJY8tHwORV93KPETPf
         xt5KSnScYxh/eb7idkZmLH/8nOPj8ulSWj5hWsHPnyRgCAtuANw1qP+3h4Pg1UitSBN0
         JEAhWglAI29KIapXr+Evhv/uduGfeyvubbQhVuACvIcmiydSiKQYJs2wx8vrJ6XtUCyd
         0fzFVdNQJIWqjf6jSr9uPaandG394DKfBX1iLjH18AqdOtVNb8f84Vxp5smAsFwfaBoJ
         jGfw==
X-Gm-Message-State: AOAM531Yw00YlIxNGfFCr7sLfsNGA9JixN2nNMCqkOxlWNu9gOW1YN3D
        dg7a48hvQWkSw1cjiv7bTe59j/WWhBz8Xw==
X-Google-Smtp-Source: ABdhPJwD1rR5cxE9+96FcFqSH/7ju4vsisCd4k5f5Yj1Z+v6pUc7/N91twhA8paSCw7jEQexvWs3tA==
X-Received: by 2002:ac8:1c09:: with SMTP id a9mr23318368qtk.64.1593555343325;
        Tue, 30 Jun 2020 15:15:43 -0700 (PDT)
Received: from bpf-dev (pc-4-149-45-190.cm.vtr.net. [190.45.149.4])
        by smtp.gmail.com with ESMTPSA id k2sm4228738qkf.127.2020.06.30.15.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 15:15:42 -0700 (PDT)
Date:   Tue, 30 Jun 2020 18:15:38 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next] fold test_current_pid_tgid_new_ns into into
 test_progs
Message-ID: <20200630221537.GA9818@bpf-dev>
References: <20200623124726.5039-1-cneirabustos@gmail.com>
 <CAEf4BzYSKXE2aYkbE2XKa9z1Wc8Zv9-bkTmh=8unOM+Za-6uMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYSKXE2aYkbE2XKa9z1Wc8Zv9-bkTmh=8unOM+Za-6uMw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:10:51AM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 5:48 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > folds tests from test_current_pid_tgid_new_ns into test_progs.
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |   3 +-
> >  .../bpf/prog_tests/ns_current_pid_tgid.c      | 112 +++++++++++-
> >  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
> >  3 files changed, 112 insertions(+), 162 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 22aaec74ea0a..7b2ea7adccb0 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -36,8 +36,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >         test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
> >         test_cgroup_storage \
> >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> > -       test_progs-no_alu32 \
> > -       test_current_pid_tgid_new_ns
> > +       test_progs-no_alu32
> 
> Please update .gitignore as well.
> 
> >
> >  # Also test bpf-gcc, if present
> >  ifneq ($(BPF_GCC),)
> 
> [...]
> 
> > +
> > +       snprintf(nspath, sizeof(nspath) - 1, "/proc/%d/ns/pid", ppid);
> > +       pidns_fd = open(nspath, O_RDONLY);
> > +
> > +       if (CHECK(unshare(CLONE_NEWPID),
> > +               "unshare CLONE_NEWPID",
> > +               "error: %s\n", strerror(errno)))
> > +               return;
> > +
> > +       pid = vfork();
> 
> is vfork necessary()? Maybe just stick to fork(), as in original implementation?
> 
> > +       if (CHECK(pid < 0, "ns_current_pid_tgid_new_ns", "vfork error: %s\n",
> > +           strerror(errno))) {
> > +               return;
> > +       }
> > +       if (pid > 0) {
> > +       printf("waiting pid is %u\n", pid);
> 
> indentation off?
> 
> > +               usleep(5);
> > +               wait(NULL);
> 
> waitpid() for specific child would be more reliable, no?
> 
> > +               return;
> > +       } else {
> 
> what if fork failed?
> 
> > +               const char *probe_name = "raw_tracepoint/sys_enter";
> > +               const char *file = "test_ns_current_pid_tgid.o";
> > +               int err, key = 0, duration = 0;
> > +               struct bpf_link *link = NULL;
> > +               struct bpf_program *prog;
> > +               struct bpf_map *bss_map;
> > +               struct bpf_object *obj;
> > +               struct bss bss;
> > +               struct stat st;
> > +               __u64 id;
> > +
> 
> [...]
> 
> > +               err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> > +               if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> > +                       goto cleanup;
> > +
> > +               if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs bpf pid/tgid",
> > +                       "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> > +                       goto cleanup;
> 
> 
> Good half of all this code could be removed if you used BPF skeleton,
> see other tests utilizing *.skel.h for inspiration.
> 
> > +cleanup:
> > +               setns(pidns_fd, CLONE_NEWPID);
> > +               bpf_link__destroy(link);
> > +               bpf_object__close(obj);
> > +       }
> > +}
> > +
> > +void test_ns_current_pid_tgid(void)
> > +{
> > +       if (test__start_subtest("ns_current_pid_tgid_global_ns"))
> > +               test_ns_current_pid_tgid_global_ns();
> > +       if (test__start_subtest("ns_current_pid_tgid_new_ns"))
> > +               test_ns_current_pid_tgid_new_ns();
> > +}
> 
> [...]
Thanks!.
I'll include your feedback on the next version, thanks for reviewing this.

Bests
