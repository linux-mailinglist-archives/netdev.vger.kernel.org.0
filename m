Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28555E3F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfFZCV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 22:21:56 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33599 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZCV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 22:21:56 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so430469qkc.0;
        Tue, 25 Jun 2019 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FCNQ4U+CmSb9komrrFban7LhIg2/7KYK4W5B7+E2FmI=;
        b=Toj9O+xiyCk++jXzIZZC9V5n0+2Pzo/irpTXEok2mSPTzKIVqgu0bUVTBMSIocC/P2
         LGKgt/1eQEUFAI9YILMXwYdf9GrfUMnLEkPrE3YfVmCCSOwrOtaw3XEnsR299lVsxE/w
         73E0ZNNzoz/LIguh+p6t0Lz/VnKC7H0O/BeI2bAlcJrPs7ST1erQeg864JnXxordhQNJ
         HijJP9tzwAEw9zK3te02R6CgcZBiBWK5TK4GzgXdJNt8aAcfeuNW8gN2XaM3ybDt+Xtb
         8yZwfVP1NCx+aDqVfer6tEdlZr1icWRIUkNQTc/vSQpD0z5cwQx1fkOm7xL1YGJ2nsei
         Jnjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FCNQ4U+CmSb9komrrFban7LhIg2/7KYK4W5B7+E2FmI=;
        b=QGS3xsxsuVG3Tb6rJAkzONduuEHwapMT+FYoJlooblwH/7CEL4i+5YR4XOv/ceUjoZ
         nlDA1TyMyPQcDA3h51DZv3s5FONN7HNyYhyXt+KtqJlNWXw1gOJJBximVcsGNnMpIGfA
         qVl8stvGgRgxfujwbNcS3Mf/k2zDIJXYU8LK5hTTlb1tkdTJGnJuWDXZWQLmtyMcQl/0
         f1MKILXIsP+RndslERpS1MtKrpY9hrjbskhBo/6GVcbOpCzYp0lMV7n/cE1Ej9siI0nS
         TOZ26hTDAdHfzMKfXB3VEeoMj0wgC9c7mPI+tVxucUC27PhTPdBE4uPevlaEDKBO5AEB
         YcJg==
X-Gm-Message-State: APjAAAV4v2sMmMh5UByisvGQ/Y1SBHpX/tPvIDouSDRUlhGzwx0/P3s0
        VNstLnIYoeD8xSK5wxXusRwVtv0X0ZsiOw0FCzM=
X-Google-Smtp-Source: APXvYqzUpHOp+z6lplk2Y0ZAe8dEVW/OL6SZ0WBYkSoZeS4jiZfDEYDPgF+THH5W4hJBXBXgHv1lxZQf1MGEbeoVYF8=
X-Received: by 2002:a37:4d82:: with SMTP id a124mr1660752qkb.72.1561515714500;
 Tue, 25 Jun 2019 19:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190625232601.3227055-1-andriin@fb.com> <20190625232601.3227055-3-andriin@fb.com>
In-Reply-To: <20190625232601.3227055-3-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 19:21:43 -0700
Message-ID: <CAPhsuW5vxEp=sUF45BO_XbWrXTKauJKZKxZRKonSs7Gg9AeRzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: test perf buffer API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:27 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add test verifying perf buffer API functionality.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../selftests/bpf/prog_tests/perf_buffer.c    | 86 +++++++++++++++++++
>  .../selftests/bpf/progs/test_perf_buffer.c    | 31 +++++++
>  2 files changed, 117 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> new file mode 100644
> index 000000000000..3ba3e26141ac
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <pthread.h>
> +#include <sched.h>
> +#include <sys/socket.h>
> +#include <test_progs.h>
> +
> +static void on_sample(void *ctx, void *data, __u32 size)
> +{
> +       cpu_set_t *cpu_seen = ctx;
> +       int cpu = *(int *)data;
> +
> +       CPU_SET(cpu, cpu_seen);
> +}
> +
> +void test_perf_buffer(void)
> +{
> +       int err, prog_fd, prog_pfd, nr_cpus, i, duration = 0;
> +       const char *prog_name = "kprobe/sys_nanosleep";
> +       const char *file = "./test_perf_buffer.o";
> +       struct bpf_map *perf_buf_map;
> +       cpu_set_t cpu_set, cpu_seen;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       struct perf_buffer *pb;
> +
> +       nr_cpus = libbpf_num_possible_cpus();
> +       if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
> +               return;
> +
> +       /* load program */
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
> +       if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> +               return;
> +
> +       prog = bpf_object__find_program_by_title(obj, prog_name);
> +       if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
> +               goto out_close;
> +
> +       /* load map */
> +       perf_buf_map = bpf_object__find_map_by_name(obj, "perf_buf_map");
> +       if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
> +               goto out_close;
> +
> +       /* attach kprobe */
> +       prog_pfd = bpf_program__attach_kprobe(prog, false /* retprobe */,
> +                                             "sys_nanosleep");
> +       if (CHECK(prog_pfd < 0, "attach_kprobe", "err %d\n", prog_pfd))
> +               goto out_close;
> +
> +       /* set up perf buffer */
> +       pb = perf_buffer__new(perf_buf_map, 1, on_sample, NULL, &cpu_seen);
> +       if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
> +               goto out_detach;
> +
> +       /* trigger kprobe on every CPU */
> +       CPU_ZERO(&cpu_seen);
> +       for (i = 0; i < nr_cpus; i++) {
> +               CPU_ZERO(&cpu_set);
> +               CPU_SET(i, &cpu_set);
> +
> +               err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
> +                                            &cpu_set);
> +               if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
> +                                i, err))
> +                       goto out_detach;
> +
> +               usleep(1);
> +       }
> +
> +       /* read perf buffer */
> +       err = perf_buffer__poll(pb, 100);
> +       if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
> +               goto out_free_pb;
> +
> +       if (CHECK(CPU_COUNT(&cpu_seen) != nr_cpus, "seen_cpu_cnt",
> +                 "expect %d, seen %d\n", nr_cpus, CPU_COUNT(&cpu_seen)))
> +               goto out_free_pb;
> +
> +out_free_pb:
> +       perf_buffer__free(pb);
> +out_detach:
> +       libbpf_perf_event_disable_and_close(prog_pfd);
> +out_close:
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> new file mode 100644
> index 000000000000..ba961f608fd5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +
> +#include <linux/ptrace.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +struct {
> +       int type;
> +       int key_size;
> +       int value_size;
> +       int max_entries;
> +} perf_buf_map SEC(".maps") = {
> +       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +       .key_size = sizeof(int),
> +       .value_size = sizeof(int),
> +       .max_entries = 56,
> +};
> +
> +SEC("kprobe/sys_nanosleep")
> +int handle_sys_nanosleep_entry(struct pt_regs *ctx)
> +{
> +       int cpu = bpf_get_smp_processor_id();
> +
> +       bpf_perf_event_output(ctx, &perf_buf_map, BPF_F_CURRENT_CPU,
> +                             &cpu, sizeof(cpu));
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> +__u32 _version SEC("version") = 1;
> --
> 2.17.1
>
