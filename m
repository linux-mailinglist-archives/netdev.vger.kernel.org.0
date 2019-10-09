Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF7D145F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbfJIQoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:44:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39573 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfJIQoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:44:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so4333480qtb.6;
        Wed, 09 Oct 2019 09:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W4qu3Pj1D6azeAfCWWnRp6axHDAPSV3/RKVrDHhsfb4=;
        b=S4GB4SBZcpkLbmlLhU1QF1HoX+UDln2VXuvnqQ7dNg63Q/k+zQlHxLdcli1/BxH8TE
         DUycGge2lTrJmiGQM8ncmdILD+bNK4OvAJJY7nbJz5auMq9ycx2cVvrB5T3id69AqK5S
         LkDHLRE6AoCbowEcX1eJMLmfpDgbFeCZ3U7LspENgwCVQLX2G5WFNZFmAMjTcFctSmBP
         On2EEPfMw6VZBpMaluWK5NIR1GShQUceJFr25zLs9/u99PLEnL4x586mbibUFbKphh54
         8w0TCDuAc2erua71X4G5HQIjmMEXFon1j3E4cJiJZWtmcJ2UZ4vRALaZ81FUAlL+/A6d
         5C+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W4qu3Pj1D6azeAfCWWnRp6axHDAPSV3/RKVrDHhsfb4=;
        b=Ik72iR7OZzMI37DdRKP0akKW+dOp11D4RxR1FqH6HfZN5I7JdXUoi67oYBLxxqY8AZ
         8hiECrPHEN71vRBocpZvOD/y2DFR8Qr3iqGb2nF34UODSCHD3iNNc3Exfs233cPRZGPx
         WrBgvgSxVdDfeH8tnCPVuqYQGsiBV8LloQj6oW6/D0lDgMv2D4wZl1pA/2fpAI9QCmb4
         qW2lMqqZEKAVlnbdIKG0MhJa+2NrygBWOdLejyiL0uNZNkvbTGFW61BgX0vHgjFX+Id7
         4CMW1IbpQOlU3XJexLELTwC8GRk8tbJmUi/k29Y7nji21uiDd4B+mRntqddIwu/4RcGW
         V+ZQ==
X-Gm-Message-State: APjAAAWk31JhidxV8VKhDOg6GMNndJGPH01RcqhwUZ9Rqm8wgYk+rkHo
        G5p/T4N6b0LN2lkoZD7Rifla/KBocLI=
X-Google-Smtp-Source: APXvYqy5UIXTTbZsDL2PVtr4f6O1D6xcKXUfH2FZN5O7tAxTzVYVWTUkB9LrMyF4RI26I5b9RQAhuQ==
X-Received: by 2002:ac8:2670:: with SMTP id v45mr868928qtv.233.1570639449804;
        Wed, 09 Oct 2019 09:44:09 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id 22sm1095491qkj.0.2019.10.09.09.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 09:44:09 -0700 (PDT)
Date:   Wed, 9 Oct 2019 13:44:04 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        ebiederm@xmission.com, Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v13 4/4] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Message-ID: <20191009164404.GA12351@frodo.byteswizards.com>
References: <20191009152632.14218-1-cneirabustos@gmail.com>
 <20191009152632.14218-5-cneirabustos@gmail.com>
 <CAEf4Bza+qXWurvrFqYKMb-1K2KOCKCfaDrp69FoS9p4OSsy-yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza+qXWurvrFqYKMb-1K2KOCKCfaDrp69FoS9p4OSsy-yg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 09:26:32AM -0700, Andrii Nakryiko wrote:
> On Wed, Oct 9, 2019 at 8:29 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > Self tests added for new helper
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/bpf_helpers.h     |  4 +
> >  .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 85 +++++++++++++++++++
> >  .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++++
> >  3 files changed, 142 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index 54a50699bbfd..16261b23e011 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -233,6 +233,10 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
> >  static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
> >                                           int ip_len, void *tcp, int tcp_len) =
> >         (void *) BPF_FUNC_tcp_gen_syncookie;
> > +static unsigned long long (*bpf_get_ns_current_pid_tgid)(struct bpf_pidns_info *nsinfo,
> > +               unsigned int buf_size) =
> > +       (void *) BPF_FUNC_get_ns_current_pid_tgid;
> > +
> 
> This is obsolete as of two days ago :) We now generate this
> automatically from the bpf.h's documentation (which is currently
> broken for your helper, I replied on respective patch). So please pull
> latest bpf-next and rebase.
> 
> >
> >  /* llvm builtin functions that eBPF C program may use to
> >   * emit BPF_LD_ABS and BPF_LD_IND instructions
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> > new file mode 100644
> > index 000000000000..a7bff0ef6677
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> > @@ -0,0 +1,85 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> > +#include <test_progs.h>
> > +#include <sys/stat.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > +#include <sys/syscall.h>
> > +
> > +void test_get_ns_current_pid_tgid(void)
> > +{
> > +       const char *probe_name = "syscalls/sys_enter_nanosleep";
> > +       const char *file = "get_ns_current_pid_tgid_kern.o";
> > +       int ns_data_map_fd, duration = 0;
> > +       struct perf_event_attr attr = {};
> > +       int err, efd, prog_fd, pmu_fd;
> > +       __u64 ino, dev, id, nspid;
> > +       struct bpf_object *obj;
> > +       struct stat st;
> > +       __u32 key = 0;
> > +       char buf[256];
> > +
> > +       err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
> > +       if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
> > +               return;
> > +
> > +       ns_data_map_fd = bpf_find_map(__func__, obj, "ns_data_map");
> > +       if (CHECK_FAIL(ns_data_map_fd < 0))
> > +               goto close_prog;
> > +
> > +       pid_t tid = syscall(SYS_gettid);
> > +       pid_t pid = getpid();
> > +
> > +       id = (__u64) tid << 32 | pid;
> > +       bpf_map_update_elem(ns_data_map_fd, &key, &id, 0);
> > +
> > +       if (stat("/proc/self/ns/pid", &st))
> 
> CHECK() or CHECK_FAIL() ?
> 
> > +               goto close_prog;
> > +
> > +       dev = st.st_dev;
> > +       ino = st.st_ino;
> > +       key = 1;
> > +       bpf_map_update_elem(ns_data_map_fd, &key, &dev, 0);
> > +       key = 2;
> > +       bpf_map_update_elem(ns_data_map_fd, &key, &ino, 0);
> > +
> > +       snprintf(buf, sizeof(buf),
> > +                "/sys/kernel/debug/tracing/events/%s/id", probe_name);
> > +       efd = open(buf, O_RDONLY, 0);
> > +       read(efd, buf, sizeof(buf));
> > +       close(efd);
> > +       attr.config = strtol(buf, NULL, 0);
> > +       attr.type = PERF_TYPE_TRACEPOINT;
> > +       attr.sample_type = PERF_SAMPLE_RAW;
> > +       attr.sample_period = 1;
> > +       attr.wakeup_events = 1;
> > +
> > +       pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
> > +       if (CHECK_FAIL(pmu_fd < 0))
> > +               goto cleanup;
> > +
> > +       err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> > +       if (CHECK_FAIL(err))
> > +               goto cleanup;
> > +
> > +       err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> > +       if (CHECK_FAIL(err))
> > +               goto cleanup;
> 
> 
> All this attaching boilerplate is now obsolete as well, stick to
> bpf_program__attach_tracepoint(). But even better, use RAW_TRACEPOINT.
> 
> > +
> > +       /* trigger some syscalls */
> > +       sleep(1);
> > +       key = 3;
> > +       err = bpf_map_lookup_elem(ns_data_map_fd, &key, &nspid);
> > +       if (CHECK_FAIL(err))
> > +               goto cleanup;
> > +
> > +       if (CHECK(id != nspid, "Compare user pid/tgid vs. bpf pid/tgid",
> > +                 "Userspace pid/tgid %llu EBPF pid/tgid %llu\n", id, nspid))
> > +               goto cleanup;
> > +
> > +cleanup:
> > +       close(pmu_fd);
> > +close_prog:
> > +       bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> > new file mode 100644
> > index 000000000000..3659aaa7c71f
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> > @@ -0,0 +1,53 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> > +
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(max_entries, 4);
> > +       __type(key, __u32);
> > +       __type(value, __u64);
> > +} ns_data_map SEC(".maps");
> > +
> > +
> > +SEC("tracepoint/syscalls/sys_enter_nanosleep")
> > +int trace(void *ctx)
> > +{
> > +       __u64 *val, *inum, *dev, nspidtgid, *expected_pid;
> > +       struct bpf_pidns_info nsdata;
> > +       __u32 key = 1;
> > +
> > +       dev = bpf_map_lookup_elem(&ns_data_map, &key);
> > +       if (!dev)
> > +               return 0;
> > +       key = 2;
> > +       inum = bpf_map_lookup_elem(&ns_data_map, &key);
> > +       if (!inum)
> > +               return 0;
> > +
> > +       nsdata.dev = *dev;
> > +       nsdata.inum = *inum;
> > +
> > +       if (bpf_get_ns_current_pid_tgid(&nsdata, sizeof(struct bpf_pidns_info)))
> > +               return 0;
> > +
> > +       nspidtgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> > +       key = 0;
> > +       expected_pid = bpf_map_lookup_elem(&ns_data_map, &key);
> > +
> > +       if (!expected_pid || *expected_pid != nspidtgid)
> > +               return 0;
> > +
> > +       key = 3;
> > +       val = bpf_map_lookup_elem(&ns_data_map, &key);
> 
> Please, use global data for this, will make this BPF program much
> shorter, cleaner, and up to the point. See recent patch by Daniel T.
> Lee, or some of the tests I added (e.g.,
> progs/test_core_reloc_kernel.c)
> 
> > +
> > +       if (val)
> > +               *val = nspidtgid;
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> 
> You can drop version now (recent stuff), it's not required by libbpf anymore.
> 
> > --
> > 2.20.1
> >
Thanks for checking this out!, I'll rebase to current bpf-next and
checkout progs/test_core_reloc_kernel.c.

Bests 
