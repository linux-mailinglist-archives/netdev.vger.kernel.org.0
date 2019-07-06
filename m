Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B3061274
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 19:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGFRoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 13:44:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41699 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfGFRoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 13:44:44 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so12816709qtj.8;
        Sat, 06 Jul 2019 10:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jo5pCyAU6amA1kWLZS+XLCPZmg02HlAw8K0W9kS55aU=;
        b=MLjwoWxaAEtCJB/Pne5SZl5/XlKOzO++iyZg8sSwQBVHZrUCl3gYO5Wq7K5QENKbkP
         l7sIArwVdKOehBwaWaHBtpfdFsiD6GIBzBvuxxr+1vp5Zais+wSE9r8k3j2Pzcu8u3Ef
         XAPIrCu6VKH+NZ9mk20qMgFvhW3WJIT3I1FB/1/SNnulNAbJzLuq4SX6pzzGUl/UrNb3
         BWAAGFZH2Yglz2evmtWC5PrwP5JPnBZleztMy50d5sb3CMnQrGM94igmg5hr+XxtMdm4
         p46ISHE2KXAIE+IArS9Ca6cemQisqtXvb3yHuI4Gp85allGWU5EyIEVxy7GvpyhkIEMS
         nBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jo5pCyAU6amA1kWLZS+XLCPZmg02HlAw8K0W9kS55aU=;
        b=hmMHEOKZmK5zHTAPXrERJmUNen2WhOvwKmjAo3yWavOD2rAqyHmCVz6DqDi9SjNNzC
         z3X4xrEYIwIA5taO6irJVOAAFYZz829F/KTDm7wm6I9ccc2un9d8Dj8A0Eqb5braKIfB
         5v1Lpc034XPVYpyOapPrZFbVWuFxIVtjI7nu4B/dOd7so49q9KV6LbfIfny+0JRnAC8J
         rufVe9jxZRDx/kmBMuKRionsmyli2w+0TCWb91pisAgG8auLU7o97WmOccj+8jWP/0Hb
         NAG1LHR2caA1G1Rcv1ON25YhulMWJyhy6GcV63fjU77S8LzzBHtP3oRvRmorN2TL+1AY
         kJww==
X-Gm-Message-State: APjAAAWTrsIJVJsKanQtAmlREnjKEZy658QXYGpZqisBFmzK7kfRAu7Z
        toRyUeBffGypmqGt87zry3xrdPfIX3mod2Wv2Wk=
X-Google-Smtp-Source: APXvYqxHBA1W2gW21U6gVg+C/8UKkQt47sA5NKJQMBJwtctJ+QycZlA7KsCNolN6p9zSzIcm0oLt89wO+DibRTqVrNs=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr8132223qvc.60.1562435082922;
 Sat, 06 Jul 2019 10:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190706060220.1801632-1-andriin@fb.com> <20190706060220.1801632-4-andriin@fb.com>
 <a04cc2f1-a107-221e-4ea3-a4650826f325@fb.com>
In-Reply-To: <a04cc2f1-a107-221e-4ea3-a4650826f325@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 6 Jul 2019 10:44:31 -0700
Message-ID: <CAEf4BzayrqHk_PxyqQHnFT_qK=_BZiquMt6O8k4RUfuz-2zKvw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 3/5] selftests/bpf: test perf buffer API
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 10:18 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/5/19 11:02 PM, Andrii Nakryiko wrote:
> > Add test verifying perf buffer API functionality.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/perf_buffer.c    | 94 +++++++++++++++++++
> >   .../selftests/bpf/progs/test_perf_buffer.c    | 25 +++++
> >   2 files changed, 119 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> > new file mode 100644
> > index 000000000000..64556ab0d1a9
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> > @@ -0,0 +1,94 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <pthread.h>
> > +#include <sched.h>
> > +#include <sys/socket.h>
> > +#include <test_progs.h>
> > +
> > +static void on_sample(void *ctx, int cpu, void *data, __u32 size)
> > +{
> > +     int cpu_data = *(int *)data, duration = 0;
> > +     cpu_set_t *cpu_seen = ctx;
> > +
> > +     if (cpu_data != cpu)
> > +             CHECK(cpu_data != cpu, "check_cpu_data",
> > +                   "cpu_data %d != cpu %d\n", cpu_data, cpu);
> > +
> > +     CPU_SET(cpu, cpu_seen);
> > +}
> > +
> > +void test_perf_buffer(void)
> > +{
> > +     int err, prog_fd, nr_cpus, i, duration = 0;
> > +     const char *prog_name = "kprobe/sys_nanosleep";
> > +     const char *file = "./test_perf_buffer.o";
> > +     struct perf_buffer_opts pb_opts = {};
> > +     struct bpf_map *perf_buf_map;
> > +     cpu_set_t cpu_set, cpu_seen;
> > +     struct bpf_program *prog;
> > +     struct bpf_object *obj;
> > +     struct perf_buffer *pb;
> > +     struct bpf_link *link;
> > +
> > +     nr_cpus = libbpf_num_possible_cpus();
> > +     if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
> > +             return;
> > +
> > +     /* load program */
> > +     err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
> > +     if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> > +             return;
> > +
> > +     prog = bpf_object__find_program_by_title(obj, prog_name);
> > +     if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
> > +             goto out_close;
> > +
> > +     /* load map */
> > +     perf_buf_map = bpf_object__find_map_by_name(obj, "perf_buf_map");
> > +     if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
> > +             goto out_close;
> > +
> > +     /* attach kprobe */
> > +     link = bpf_program__attach_kprobe(prog, false /* retprobe */,
> > +                                           "sys_nanosleep");
>
> The attach function "sys_nanosleep" won't work. You can have something
> similar to attach_probe.c.
>
> #ifdef __x86_64__
> #define SYS_KPROBE_NAME "__x64_sys_nanosleep"
> #else
> #define SYS_KPROBE_NAME "sys_nanosleep"
> #endif
>

Yeah, this is going to be a nightmare with those arch-specific names.
I'm wondering if it's worth it to automatically do that in libbpf for
users...

But anyway, will fix in v7, thanks!

>
> > +     if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
> > +             goto out_close;
> > +
> > +     /* set up perf buffer */
> > +     pb_opts.sample_cb = on_sample;
> > +     pb_opts.ctx = &cpu_seen;
> > +     pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
> > +     if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
> > +             goto out_detach;
> > +
> > +     /* trigger kprobe on every CPU */
> > +     CPU_ZERO(&cpu_seen);
> > +     for (i = 0; i < nr_cpus; i++) {
> > +             CPU_ZERO(&cpu_set);
> > +             CPU_SET(i, &cpu_set);
> > +
> > +             err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
> > +                                          &cpu_set);
> > +             if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
> > +                              i, err))
> > +                     goto out_detach;
> > +
> > +             usleep(1);
> > +     }
> > +
> > +     /* read perf buffer */
> > +     err = perf_buffer__poll(pb, 100);
> > +     if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
> > +             goto out_free_pb;
> > +
> > +     if (CHECK(CPU_COUNT(&cpu_seen) != nr_cpus, "seen_cpu_cnt",
> > +               "expect %d, seen %d\n", nr_cpus, CPU_COUNT(&cpu_seen)))
> > +             goto out_free_pb;
> > +
> > +out_free_pb:
> > +     perf_buffer__free(pb);
> > +out_detach:
> > +     bpf_link__destroy(link);
> > +out_close:
> > +     bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> > new file mode 100644
> > index 000000000000..876c27deb65a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
> > +
> > +#include <linux/ptrace.h>
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> > +     __uint(key_size, sizeof(int));
> > +     __uint(value_size, sizeof(int));
> > +} perf_buf_map SEC(".maps");
> > +
> > +SEC("kprobe/sys_nanosleep")
> > +int handle_sys_nanosleep_entry(struct pt_regs *ctx)
> > +{
> > +     int cpu = bpf_get_smp_processor_id();
> > +
> > +     bpf_perf_event_output(ctx, &perf_buf_map, BPF_F_CURRENT_CPU,
> > +                           &cpu, sizeof(cpu));
> > +     return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> >
