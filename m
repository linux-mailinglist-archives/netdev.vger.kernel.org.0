Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEDF1FFE43
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgFRWnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgFRWnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:43:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB84C06174E;
        Thu, 18 Jun 2020 15:43:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q2so7295624qkb.2;
        Thu, 18 Jun 2020 15:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwhZHcmzmSyYCBEQ7qeYwK2+N8x/nvUNoGCWawl3HGs=;
        b=gGkqpm+TlePX0fculHcIrWfQPZ3SNULh3Gh/rxu/Z9OypNAzXVSLeNf0Zoyelqj5im
         lBWxCKVqPrLcIReSLEUrWfydEM+EoaBAuIypnLp6Duh6lGc7S0LrMrpUzYZ7E1HSVTla
         /g3LDc+au7pEiSrG1mnuYwJ906APjyGO2gcKmakr+S3kV/F2GUNjJ0lafjSF3FwSq+29
         Y/9ejvzSrJYLdm6Ta/nN7pLZoHxrd2XDZjumQFlOJw2JSZppovzGtd5cy37+GY6Kgy9B
         dkjoorKOC22Cbe/+OjCGh7vh9RAFf5zEgtRZQxzHoZ8hKCBvKZPHfp1j7peBKOIFNzug
         gVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwhZHcmzmSyYCBEQ7qeYwK2+N8x/nvUNoGCWawl3HGs=;
        b=KsyXi1J1YC8szc7kqN8eHEVpkebprlE8oOk2qZrqKOkGIbF9m8LHTQI5MAf3L4AxWb
         Z5aVNKD1g4+JhOtCAs7ut0Krxn1+to0BDsSaDj05JqczIVZQzV54xqdzB2GY12PWqCqz
         1IeqU5mLk67Ag3oQ7QPmdLxopBo0ItrmuUswqJv2VFWtj7DhRpVzxPEs4oohVHfzuVfD
         EPrL2WHBJSFEb1YVOB66aFMfbr9TdJPC/O9XEIUrN9IGnB86y02O3nG4tEdJNyzsBjWy
         EmC/CQWQIFGEGf4iv+exu/X/kV3oG9qbvM+H82c3x0Y+uF+tJeKSyEvdXuskWRUosO1L
         Gmyw==
X-Gm-Message-State: AOAM530fKBNEDhiTvwZP9qlF5ADXjvs1a5AgqR1CwkckLvMVwAPJQnJl
        uIJmgj5FWjSBQ+HVUQk8kx7yynLe98OwpNbQzFI=
X-Google-Smtp-Source: ABdhPJywBFg3iNInxARijO0jUDP0B5u3dxdqpIvZYLX4uTmyP6assI50LIq321O6f/p7vPr3lsXbkU0D3MQsu30fmc4=
X-Received: by 2002:a37:a89:: with SMTP id 131mr739437qkk.92.1592520195640;
 Thu, 18 Jun 2020 15:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com> <20200611222340.24081-5-alexei.starovoitov@gmail.com>
In-Reply-To: <20200611222340.24081-5-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 15:43:04 -0700
Message-ID: <CAEf4Bzb3xfowOkrFC-KzHF5C_8_YMTwrut=s-b+hrh_sEuVHoQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 bpf-next 4/4] selftests/bpf: basic sleepable tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 3:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Modify few tests to sanity test sleepable bpf functionality.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: KP Singh <kpsingh@google.com>
> ---
>  tools/testing/selftests/bpf/bench.c             |  2 ++
>  .../selftests/bpf/benchs/bench_trigger.c        | 17 +++++++++++++++++
>  tools/testing/selftests/bpf/progs/lsm.c         | 14 ++++++++++++--
>  .../testing/selftests/bpf/progs/trigger_bench.c |  7 +++++++
>  4 files changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
> index 944ad4721c83..1a427685a8a8 100644
> --- a/tools/testing/selftests/bpf/bench.c
> +++ b/tools/testing/selftests/bpf/bench.c
> @@ -317,6 +317,7 @@ extern const struct bench bench_trig_tp;
>  extern const struct bench bench_trig_rawtp;
>  extern const struct bench bench_trig_kprobe;
>  extern const struct bench bench_trig_fentry;
> +extern const struct bench bench_trig_fentry_sleep;
>  extern const struct bench bench_trig_fmodret;
>  extern const struct bench bench_rb_libbpf;
>  extern const struct bench bench_rb_custom;
> @@ -338,6 +339,7 @@ static const struct bench *benchs[] = {
>         &bench_trig_rawtp,
>         &bench_trig_kprobe,
>         &bench_trig_fentry,
> +       &bench_trig_fentry_sleep,

Can you please add results to commit description for fentry and
fentry_sleep benchmark, just for comparison?

>         &bench_trig_fmodret,
>         &bench_rb_libbpf,
>         &bench_rb_custom,

[...]

>
> @@ -28,6 +30,9 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>         is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
>                     vma->vm_end >= vma->vm_mm->start_stack);
>
> +       bpf_copy_from_user(args, sizeof(args), (void *)vma->vm_mm->arg_start);

is there some way to ensure that user memory definitely is not paged
in (and do it from user-space selftest part), so that
bpf_copy_from_user() *definitely* sleeps? That would be the real test.
As is, even bpf_probe_read_user() might succeed as well, isn't that
right?

Seems like doing madvise(MADV_DONTNEED) should be able to accomplish
that? So instead of reading arg_start, we can pre-setup mmap()'ed
file, MADV_DONTNEED it, then trigger LSM program and let it attempt
reading that chunk of memory?


> +       /*bpf_printk("args=%s\n", args);*/

debugging leftover?

> +
>         if (is_stack && monitored_pid == pid) {
>                 mprotect_count++;
>                 ret = -EPERM;
> @@ -36,7 +41,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>         return ret;
>  }
>
> -SEC("lsm/bprm_committed_creds")
> +SEC("lsm.s/bprm_committed_creds")
>  int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
>  {
>         __u32 pid = bpf_get_current_pid_tgid() >> 32;
> @@ -46,3 +51,8 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
>
>         return 0;
>  }

nit: empty line here, don't squash those functions together :)


> +SEC("lsm/task_free") /* lsm/ is ok, lsm.s/ fails */
> +int BPF_PROG(test_task_free, struct task_struct *task)
> +{
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/testing/selftests/bpf/progs/trigger_bench.c
> index 8b36b6640e7e..9a4d09590b3d 100644
> --- a/tools/testing/selftests/bpf/progs/trigger_bench.c
> +++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
> @@ -39,6 +39,13 @@ int bench_trigger_fentry(void *ctx)
>         return 0;
>  }
>
> +SEC("fentry.s/__x64_sys_getpgid")
> +int bench_trigger_fentry_sleep(void *ctx)
> +{
> +       __sync_add_and_fetch(&hits, 1);
> +       return 0;
> +}
> +
>  SEC("fmod_ret/__x64_sys_getpgid")
>  int bench_trigger_fmodret(void *ctx)
>  {
> --
> 2.23.0
>
