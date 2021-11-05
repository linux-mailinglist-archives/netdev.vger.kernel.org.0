Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D10C446885
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhKESkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhKESkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 14:40:19 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B95AC061714;
        Fri,  5 Nov 2021 11:37:39 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v64so25028744ybi.5;
        Fri, 05 Nov 2021 11:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kofmRQNt7PhJuF/iVk+TbzKStrnSIY6+7N/dSa7isc4=;
        b=nRpRbDKixbWmvgWncm06J66lr1DAaRON7RnLpL64zY6S8O1UWXkArFFCih94qTYUEH
         4tvq2p5TdOorVy958oahE4sQeHheY1ZNBAlNPwkA0Opx+CgBnEspNFElHl/K0HIcO4/n
         mRzLZ5Zi1+SQPnl/XpS3W50eIFU4HJrYE4/CTpUuWsGScff1taxQ9lyz+SYZjSKs4Ede
         1tM/UaU/KXMJe5s6jLNFUg8X0dyjHZcCM+txTPbjx3Gn1ZrlVv3shMG8HyYvqkDMHnuh
         8TU+sifzuc+wghK3gayAjYFvt99Ciov8xgptxX579F0o/FPklINzouTYl1axfYeJMj6Z
         xXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kofmRQNt7PhJuF/iVk+TbzKStrnSIY6+7N/dSa7isc4=;
        b=FPb7m2lj+VSSrKmYYQNiJHdo9KPQZlSK1CZlK2itZMnbAsWQbcQx8fKrdMN44lWBum
         h2HpHE6omZUHmAjlvHySHZw5lsO8PS1WdAXvb/HudHyumbMFpDGhgYKM4JnCLRWjdggg
         Q2YXFa2iWZLT12btdWgnqbo7oc4BoQ87nvk142CloojgHKdBEowdgYInnHrxWl3yA7ke
         SI59zHqQ5wj3HCu7zgIVpJfOVZBuUovBx8zLjKhXA2Vmaco1KTI6OddWDVw9J0QlkbwX
         zY7HfQGY4Msgc+bdc/kGWULaSG2WG4Jxyy2VvUoSgTozV4t75PP20zY29tQ8xyf6XPGO
         bYqA==
X-Gm-Message-State: AOAM532Tk789FsH1BRZdyGkW58Us19kcls+859wV00r72qYFBrjz3e0H
        vCuYcF+0Uz79xHsAbHDXi4ub6hfUQeN8Kvr/Db0=
X-Google-Smtp-Source: ABdhPJzS4xP+faSXzRqHhRa0K/A8BY2ZNgKS4LqQw9kI4Up2HGa860h754FXxvSPjnLbyrFTJ4IxefhW3DetuiV/3do=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr64193971ybf.114.1636137458241;
 Fri, 05 Nov 2021 11:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211104213138.2779620-1-songliubraving@fb.com> <20211104213138.2779620-3-songliubraving@fb.com>
In-Reply-To: <20211104213138.2779620-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Nov 2021 11:37:27 -0700
Message-ID: <CAEf4BzZpU5F2r55wecR4OCTsYwiT-BcbypEMOboWhvQOvxLwnA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>, KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 2:31 PM Song Liu <songliubraving@fb.com> wrote:
>
> Add tests for bpf_find_vma in perf_event program and kprobe program. The
> perf_event program is triggered from NMI context, so the second call of
> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
> on the other hand, does not have this constraint.
>
> Also add tests for illegal writes to task or vma from the callback
> function. The verifier should reject both cases.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../selftests/bpf/prog_tests/find_vma.c       | 115 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/find_vma.c  |  69 +++++++++++
>  .../selftests/bpf/progs/find_vma_fail1.c      |  29 +++++
>  .../selftests/bpf/progs/find_vma_fail2.c      |  29 +++++
>  4 files changed, 242 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
>  create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
>  create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/find_vma.c b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> new file mode 100644
> index 0000000000000..d081edbc9cae3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <test_progs.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include "find_vma.skel.h"
> +#include "find_vma_fail1.skel.h"
> +#include "find_vma_fail2.skel.h"
> +
> +static void test_and_reset_skel(struct find_vma *skel, int expected_find_zero_ret)
> +{
> +       ASSERT_EQ(skel->bss->found_vm_exec, 1, "found_vm_exec");
> +       ASSERT_EQ(skel->data->find_addr_ret, 0, "find_addr_ret");
> +       ASSERT_EQ(skel->data->find_zero_ret, expected_find_zero_ret, "find_zero_ret");
> +       ASSERT_OK_PTR(strstr(skel->bss->d_iname, "test_progs"), "find_test_progs");
> +
> +       skel->bss->found_vm_exec = 0;
> +       skel->data->find_addr_ret = -1;
> +       skel->data->find_zero_ret = -1;
> +       skel->bss->d_iname[0] = 0;
> +}
> +
> +static int open_pe(void)
> +{
> +       struct perf_event_attr attr = {0};
> +       int pfd;
> +
> +       /* create perf event */
> +       attr.size = sizeof(attr);
> +       attr.type = PERF_TYPE_HARDWARE;
> +       attr.config = PERF_COUNT_HW_CPU_CYCLES;
> +       attr.freq = 1;
> +       attr.sample_freq = 4000;
> +       pfd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
> +
> +       return pfd >= 0 ? pfd : -errno;
> +}
> +
> +static void test_find_vma_pe(struct find_vma *skel)
> +{
> +       struct bpf_link *link = NULL;
> +       volatile int j = 0;
> +       int pfd = -1, i;

nit: no need to initialize pfd

> +
> +       pfd = open_pe();
> +       if (pfd < 0) {
> +               if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
> +                       printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
> +                       test__skip();
> +                       goto cleanup;
> +               }
> +               if (!ASSERT_GE(pfd, 0, "perf_event_open"))
> +                       goto cleanup;
> +       }
> +
> +       link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
> +       if (!ASSERT_OK_PTR(link, "attach_perf_event"))
> +               goto cleanup;
> +
> +       for (i = 0; i < 1000000; ++i)
> +               ++j;
> +
> +       test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
> +cleanup:
> +       bpf_link__destroy(link);
> +       close(pfd);
> +}
> +
> +static void test_find_vma_kprobe(struct find_vma *skel)
> +{
> +       int err;
> +
> +       err = find_vma__attach(skel);
> +       if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
> +               return;
> +
> +       getpgid(skel->bss->target_pid);
> +       test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
> +}
> +
> +static void test_illegal_write_vma(void)
> +{
> +       struct find_vma_fail1 *skel;
> +
> +       skel = find_vma_fail1__open_and_load();
> +       ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load");

destroy a skeleton in case of unexpected success?

> +}
> +
> +static void test_illegal_write_task(void)
> +{
> +       struct find_vma_fail2 *skel;
> +
> +       skel = find_vma_fail2__open_and_load();
> +       ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load");

same

> +}
> +
> +void serial_test_find_vma(void)
> +{
> +       struct find_vma *skel;
> +
> +       skel = find_vma__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
> +               return;
> +
> +       skel->bss->target_pid = getpid();
> +       skel->bss->addr = (__u64)test_find_vma_pe;

I suspect this might generate warning on some architectures. Can you
cast to uintptr_t first?

> +
> +       test_find_vma_pe(skel);
> +       usleep(100000); /* allow the irq_work to finish */
> +       test_find_vma_kprobe(skel);
> +
> +       find_vma__destroy(skel);
> +       test_illegal_write_vma();
> +       test_illegal_write_task();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing/selftests/bpf/progs/find_vma.c
> new file mode 100644
> index 0000000000000..9451f0a047442
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +       int dummy;
> +};
> +
> +#define VM_EXEC                0x00000004
> +#define DNAME_INLINE_LEN 32
> +
> +pid_t target_pid = 0;
> +char d_iname[DNAME_INLINE_LEN] = {0};
> +__u32 found_vm_exec = 0;
> +__u64 addr = 0;
> +int find_zero_ret = -1;
> +int find_addr_ret = -1;
> +
> +static long check_vma(struct task_struct *task, struct vm_area_struct *vma,
> +                     struct callback_ctx *data)
> +{
> +       if (vma->vm_file)
> +               bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
> +                                         vma->vm_file->f_path.dentry->d_iname);
> +
> +       /* check for VM_EXEC */
> +       if (vma->vm_flags & VM_EXEC)
> +               found_vm_exec = 1;
> +
> +       return 0;
> +}
> +
> +SEC("raw_tp/sys_enter")
> +int handle_getpid(void)
> +{
> +       struct task_struct *task = bpf_get_current_task_btf();
> +       struct callback_ctx data = {0};
> +
> +       if (task->pid != target_pid)
> +               return 0;
> +
> +       find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +       /* this should return -ENOENT */
> +       find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +       return 0;
> +}
> +
> +SEC("perf_event")
> +int handle_pe(void)
> +{
> +       struct task_struct *task = bpf_get_current_task_btf();
> +       struct callback_ctx data = {0};

nit: misleading syntax, just do = {}


> +
> +       if (task->pid != target_pid)
> +               return 0;
> +
> +       find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +       /* In NMI, this should return -EBUSY, as the previous call is using
> +        * the irq_work.
> +        */
> +       find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> new file mode 100644
> index 0000000000000..6ecd1515f1221
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +       int dummy;
> +};
> +
> +static long write_vma(struct task_struct *task, struct vm_area_struct *vma,
> +                     struct callback_ctx *data)
> +{
> +       /* writing to vma, which is illegal */
> +       vma->vm_flags |= 0x55;
> +
> +       return 0;
> +}
> +
> +SEC("raw_tp/sys_enter")
> +int handle_getpid(void)
> +{
> +       struct task_struct *task = bpf_get_current_task_btf();
> +       struct callback_ctx data = {0};

same as the above

> +
> +       bpf_find_vma(task, 0, write_vma, &data, 0);
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail2.c b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> new file mode 100644
> index 0000000000000..5ea93a67f6c8b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +       int dummy;
> +};
> +
> +static long write_task(struct task_struct *task, struct vm_area_struct *vma,
> +                      struct callback_ctx *data)
> +{
> +       /* writing to task, which is illegal */
> +       task->mm = NULL;
> +
> +       return 0;
> +}
> +
> +SEC("raw_tp/sys_enter")
> +int handle_getpid(void)
> +{
> +       struct task_struct *task = bpf_get_current_task_btf();
> +       struct callback_ctx data = {0};

and here

> +
> +       bpf_find_vma(task, 0, write_task, &data, 0);
> +       return 0;
> +}
> --
> 2.30.2
>
