Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81E1BEE0F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgD3CI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgD3CIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:08:55 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A8FC035494;
        Wed, 29 Apr 2020 19:08:55 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ep1so2288625qvb.0;
        Wed, 29 Apr 2020 19:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vu8UiaF2b4dRg9zeaHqlAMkMaJD4/cTzxpfI02uBLpY=;
        b=OR/ftyjtkMFNzeAqnvtnN1mXM6frk7fec+ZDoPVjz3zCG/8QOICl98B+8NE+sKJaAc
         U6w9Iso7GU4KkE9jQJStWS4C45JYstsyrMq2DPHW0GcbDpmru52rGVOdatUH+ve8psqR
         HKRDwmRozfmao8B1zAOP7g/rKQTu4hcpF3uf20nm8hOoz6jGA48JXjxxOLaVHYhnm4q4
         TMJF0sDZh2nlzBuylSjjJqs4fJD3ZS1owQFzx78TKls/+bbowyjD/Qga6DJVQXMfxj0y
         ReJsPh5urzz4x3Zq4TO13HuSz09PZYNcZwsKHBxzrWv3MCupSbO78gQUcM0CeudoaLrX
         r3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vu8UiaF2b4dRg9zeaHqlAMkMaJD4/cTzxpfI02uBLpY=;
        b=KAuUGE+fVowPh4MmxaFa17HMxv0UOrSzFcFw5rkJ2ZPuT2cpWBn0YEr2lAbeiuUyXB
         fL7+pb3b1ZFBh3mFc6DywGFG9o3N19q5S4RxyfekTaBhcoa2H3CiSWDAu+xeh5Vvxab+
         sc6vpwy5TXxc4TaG/qcAFrnawp1dOmveUBO3P7xcbPFDEB3n6sZljohTHyZorODRLrdZ
         q4Sh+5rQpnNUZIiJJfYNHGu66r4o4pSFJ8gt1S+p0Uhactl/rk7dkLtInAjnJ62/YeKg
         wMLELXsEnH7+J4bCxa47Drj+zjdDUF5azv1txosIZebbNnPJGoZhA2dQqiuKRhnm1cuX
         s3LQ==
X-Gm-Message-State: AGi0PuY3ntsU4W7OVQK40CpJiT1W2cC3MSUCkBKyb8vH7Dz4NjlRQCIW
        lykP93lke0YHN403/qoWb9/cVIncUMxMVleO+eIqXQ6s
X-Google-Smtp-Source: APiQypIUcTNT23Rtcj2G3NKC80N7LyIVkvjUQepIUAu6UfZbg2r9PmHgtgGsmP19kpog8YdtHiMAPLNUjFFBzNt/0XA=
X-Received: by 2002:ad4:42c9:: with SMTP id f9mr789913qvr.228.1588212534412;
 Wed, 29 Apr 2020 19:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201247.2995622-1-yhs@fb.com>
In-Reply-To: <20200427201247.2995622-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 19:08:43 -0700
Message-ID: <CAEf4BzaWkKbtDQf=0gOBj7Q6icswh61ky3FFS8bAmhkefDV0tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 11/19] bpf: add task and task/file targets
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
>
> Only the tasks belonging to "current" pid namespace
> are enumerated.
>
> For task/file target, the bpf program will have access to
>   struct task_struct *task
>   u32 fd
>   struct file *file
> where fd/file is an open file for the task.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/Makefile    |   2 +-
>  kernel/bpf/task_iter.c | 319 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 320 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/task_iter.c
>

[...]

> +static void *task_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +       struct bpf_iter_seq_task_info *info = seq->private;
> +       struct task_struct *task;
> +       u32 id = info->id;
> +
> +       if (*pos == 0)
> +               info->ns = task_active_pid_ns(current);

I wonder why pid namespace is set in start() callback each time, while
net_ns was set once when seq_file is created. I think it should be
consistent, no? Either pid_ns is another feature and is set
consistently just once using the context of the process that creates
seq_file, or net_ns could be set using the same method without
bpf_iter infra knowing about this feature? Or there are some
non-obvious aspects which make pid_ns easier to work with?

Either way, process read()'ing seq_file might be different than
process open()'ing seq_file, so they might have different namespaces.
We need to decide explicitly which context should be used and do it
consistently.

> +
> +       task = task_seq_get_next(info->ns, &id);
> +       if (!task)
> +               return NULL;
> +
> +       ++*pos;
> +       info->task = task;
> +       info->id = id;
> +
> +       return task;
> +}
> +
> +static void *task_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +       struct bpf_iter_seq_task_info *info = seq->private;
> +       struct task_struct *task;
> +
> +       ++*pos;
> +       ++info->id;

this would make iterator skip pid 0? Is that by design?

> +       task = task_seq_get_next(info->ns, &info->id);
> +       if (!task)
> +               return NULL;
> +
> +       put_task_struct(info->task);

on very first iteration info->task might be NULL, right?

> +       info->task = task;
> +       return task;
> +}
> +
> +struct bpf_iter__task {
> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> +       __bpf_md_ptr(struct task_struct *, task);
> +};
> +
> +int __init __bpf_iter__task(struct bpf_iter_meta *meta, struct task_struct *task)
> +{
> +       return 0;
> +}
> +
> +static int task_seq_show(struct seq_file *seq, void *v)
> +{
> +       struct bpf_iter_meta meta;
> +       struct bpf_iter__task ctx;
> +       struct bpf_prog *prog;
> +       int ret = 0;
> +
> +       prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_task_info),
> +                                &meta.session_id, &meta.seq_num,
> +                                v == (void *)0);
> +       if (prog) {

can it happen that prog is NULL?


> +               meta.seq = seq;
> +               ctx.meta = &meta;
> +               ctx.task = v;
> +               ret = bpf_iter_run_prog(prog, &ctx);
> +       }
> +
> +       return ret == 0 ? 0 : -EINVAL;
> +}
> +
> +static void task_seq_stop(struct seq_file *seq, void *v)
> +{
> +       struct bpf_iter_seq_task_info *info = seq->private;
> +
> +       if (!v)
> +               task_seq_show(seq, v);

hmm... show() called from stop()? what's the case where this is necessary?
> +
> +       if (info->task) {
> +               put_task_struct(info->task);
> +               info->task = NULL;
> +       }
> +}
> +

[...]
