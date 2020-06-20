Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C893B201F68
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 03:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbgFTBJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 21:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbgFTBJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 21:09:20 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CF2C0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:09:18 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x18so11027078ilp.1
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhpiekcL/osjMfUbk2t4fa9K4n9IVTXK5qtITfS7wb0=;
        b=GfqBm5RdsHI42oHaK/oBjBSImguZ28HHD8MDzpPr8hBFhP58BbmwDERtuo2xgQ2tJQ
         d25O+ywySM7cRgg7R7R+0zvBs20a7atV9qkWE41Y5b0SXqG5XbPsTYOx5Mg2Bb1uh6qW
         ClGSpE06XoQsHl5THJRbScZIH5IMgDYix51oriyBO0NQzdC8gq6prQwRSzlWLlDUWUj9
         Nj4BE3yC/T0tethFc7a7ATI3Jb4RVV5iROLYk/Bw1RXrZ23fKShgGDhDAHvXyw96Fiiw
         uJNmMewzvOilrNnaR5vgZ4sRNSPNihjXtqM99vzKmk2Tb6kLGQ0/D1dgjdn+azEjRJbN
         5KyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhpiekcL/osjMfUbk2t4fa9K4n9IVTXK5qtITfS7wb0=;
        b=Wf6k266Fg8vMSeKYzRu80muN/oqNQ6tiuSYEWWDOpvq9SzbTtiwFvo+ANJQbjceEYl
         ljJn5Ohjyduy1esrX+DIGvuHgEXeULoida6/uISIXVIWYtxKRvLiAkjah/wdELEEmsHv
         HQ/7wRjpgf1zaK51q7ACIT0PL+l19lZptzLdOAR2COR0G+79SNtLYT8yCAtzwHW8dPMP
         074DZNiB5Wu/pAxz9yYvNnf0mOzbRfQku9duKIRReZ1R3MsFzE3ZBerddNYN+zk/+Ery
         77DHzxmDJdQ6mHbWCjE7Z4nCtvXvrm2s0tDDzx3QHJx1/sYaTJU3dl22R+iDxbwvRL0t
         g7IA==
X-Gm-Message-State: AOAM533jzCncALbBZ6tbGzChgWY1at5p4CwpFGT3MeMEm4UBOazyvWkz
        fAEe0qm5C7k/J2ZirC4kW60eMi22+WMb3zI0lA1u1w==
X-Google-Smtp-Source: ABdhPJxIoLpD5Q1uOBA4YmvfB8qMILvfC1Mq0gFbBu0+slUj482v69aao7f9YrQHgHctYLzJpsJ0dqoonX3Gfbahrr4=
X-Received: by 2002:a92:1f15:: with SMTP id i21mr5744544ile.61.1592615358238;
 Fri, 19 Jun 2020 18:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200619231703.738941-1-andriin@fb.com> <20200619231703.738941-4-andriin@fb.com>
In-Reply-To: <20200619231703.738941-4-andriin@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 19 Jun 2020 18:09:06 -0700
Message-ID: <CA+khW7gMZrKcwkzCkc4f3nfQ4PStiN6PJDjYb0F4uD+M4QPWug@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/9] selftests/bpf: add __ksym extern selftest
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Hao Luo <haoluo@google.com>


On Fri, Jun 19, 2020 at 4:19 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Validate libbpf is able to handle weak and strong kernel symbol externs in BPF
> code correctly.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../testing/selftests/bpf/prog_tests/ksyms.c  | 71 +++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_ksyms.c  | 32 +++++++++
>  2 files changed, 103 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms.c b/tools/testing/selftests/bpf/prog_tests/ksyms.c
> new file mode 100644
> index 000000000000..e3d6777226a8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms.c
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook */
> +
> +#include <test_progs.h>
> +#include "test_ksyms.skel.h"
> +#include <sys/stat.h>
> +
> +static int duration;
> +
> +static __u64 kallsyms_find(const char *sym)
> +{
> +       char type, name[500];
> +       __u64 addr, res = 0;
> +       FILE *f;
> +
> +       f = fopen("/proc/kallsyms", "r");
> +       if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
> +               return 0;
> +
> +       while (fscanf(f, "%llx %c %499s%*[^\n]\n", &addr, &type, name) > 0) {
> +               if (strcmp(name, sym) == 0) {
> +                       res = addr;
> +                       goto out;
> +               }
> +       }
> +
> +       CHECK(false, "not_found", "symbol %s not found\n", sym);
> +out:
> +       fclose(f);
> +       return res;
> +}
> +
> +void test_ksyms(void)
> +{
> +       __u64 link_fops_addr = kallsyms_find("bpf_link_fops");
> +       const char *btf_path = "/sys/kernel/btf/vmlinux";
> +       struct test_ksyms *skel;
> +       struct test_ksyms__data *data;
> +       struct stat st;
> +       __u64 btf_size;
> +       int err;
> +
> +       if (CHECK(stat(btf_path, &st), "stat_btf", "err %d\n", errno))
> +               return;
> +       btf_size = st.st_size;
> +
> +       skel = test_ksyms__open_and_load();
> +       if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
> +               return;
> +
> +       err = test_ksyms__attach(skel);
> +       if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +               goto cleanup;
> +
> +       /* trigger tracepoint */
> +       usleep(1);
> +
> +       data = skel->data;
> +       CHECK(data->out__bpf_link_fops != link_fops_addr, "bpf_link_fops",
> +             "got 0x%llx, exp 0x%llx\n",
> +             data->out__bpf_link_fops, link_fops_addr);
> +       CHECK(data->out__bpf_link_fops1 != 0, "bpf_link_fops1",
> +             "got %llu, exp %llu\n", data->out__bpf_link_fops1, (__u64)0);
> +       CHECK(data->out__btf_size != btf_size, "btf_size",
> +             "got %llu, exp %llu\n", data->out__btf_size, btf_size);
> +       CHECK(data->out__per_cpu_start != 0, "__per_cpu_start",
> +             "got %llu, exp %llu\n", data->out__per_cpu_start, (__u64)0);
> +
> +cleanup:
> +       test_ksyms__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms.c b/tools/testing/selftests/bpf/progs/test_ksyms.c
> new file mode 100644
> index 000000000000..6c9cbb5a3bdf
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms.c
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook */
> +
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 out__bpf_link_fops = -1;
> +__u64 out__bpf_link_fops1 = -1;
> +__u64 out__btf_size = -1;
> +__u64 out__per_cpu_start = -1;
> +
> +extern const void bpf_link_fops __ksym;
> +extern const void __start_BTF __ksym;
> +extern const void __stop_BTF __ksym;
> +extern const void __per_cpu_start __ksym;
> +/* non-existing symbol, weak, default to zero */
> +extern const void bpf_link_fops1 __ksym __weak;
> +
> +SEC("raw_tp/sys_enter")
> +int handler(const void *ctx)
> +{
> +       out__bpf_link_fops = (__u64)&bpf_link_fops;
> +       out__btf_size = (__u64)(&__stop_BTF - &__start_BTF);
> +       out__per_cpu_start = (__u64)&__per_cpu_start;
> +
> +       out__bpf_link_fops1 = (__u64)&bpf_link_fops1;
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.24.1
>
