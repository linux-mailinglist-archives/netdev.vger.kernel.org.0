Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819CB253D12
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 07:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgH0FIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 01:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgH0FIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 01:08:09 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B3FC061240;
        Wed, 26 Aug 2020 22:08:08 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id m200so2259288ybf.10;
        Wed, 26 Aug 2020 22:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnuCL2LWhGPl49aBCTEcEvse6jLuZxO0YBkIl3Y1WWs=;
        b=l3/EvTbyR3TjcR/vdzHwosjh5cLfCBm7jJ1Gpl+M2TGRcxB4wY1IWlZj13Wcp4BqUg
         1mLfUeBSJcGg+Jen4K72vX91AT6G+u1w9dU3M/ErqS4ONKO2UqrWi2JJhORQzw5lTC5F
         FMK7/syQz7If1lAEmybTHAbVisvQAVS458/lxgbjqJtJhdkMBBU77QtfINHaiwMN9sam
         pjJBvpuxxnzmo9Ln0Qp734re+MW7PF4l5KLSyzQyhckHRbweNGr/0fQQqmlOHYM3fJIt
         IeGTYXlnQkKnChdcKsLQUdBsnn9REQGBNtgeDRsNeBhZqiz/yCggaiaiSg9QYUNW/Ko9
         qv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnuCL2LWhGPl49aBCTEcEvse6jLuZxO0YBkIl3Y1WWs=;
        b=e11zbepWplLhVfsefimOUq4VbiKiVGT8Y9W+LdQCStfB5mNWs993mrIlw+vccX3vnF
         YrCsWPT3wVRW3Sq7RtT+NafZZuv/r75BqN0eLWUcwH73B0f1BXgqrs3VI0pZu5hpb60m
         3FUEbXvhlQ69HyLPKmFSgI6/PnBjCv2O49Zur3XgPhNutXnWRMzbdAXfNxd2IUuOVkEQ
         zcD899Ix/XegTamea9/vYN7agtKFcrylNmT8y5WQdAPI9TnbQZyG7WcGpEOmqGnfzmts
         MlSuQ/yq9gKXgX+m7Nxsv7y/3ESJAjX1Mxp0CGc4m82rOWv8wFLtxd92YsnH1vaMV+SJ
         syMw==
X-Gm-Message-State: AOAM533oxV9C8nOszoN+Vc4INpyXk8Nq6zQbcexp9Tip2G7UPhoVLbjM
        x1DDbS3a3X2cJGtPkZ28jSBKDKSvjbCFmvWKobo=
X-Google-Smtp-Source: ABdhPJwNY3ClugK69D/iwE3Zi8Rsed5gkD/RCOfNXoQ0PeYB5pxr/JdkymT/V4HYC1U2gDw3PWdf0s3qdH2ifMlBNts=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr24953867ybq.27.1598504887874;
 Wed, 26 Aug 2020 22:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200827000618.2711826-1-yhs@fb.com> <20200827000620.2711963-1-yhs@fb.com>
In-Reply-To: <20200827000620.2711963-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 22:07:56 -0700
Message-ID: <CAEf4BzYBQVX-YQyZiJe+xrMUmk_k+mU=Q-RNULeS4pt-YyzQUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add main_thread_only customization for
 task/task_file iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
>
> Currently, task and task_file by default iterates through
> all tasks. For task_file, by default, all files from all tasks
> will be traversed.
>
> But for a user process, the file_table is shared by all threads
> of that process. So traversing the main thread per process should
> be enough to traverse all files and this can save a lot of cpu
> time if some process has large number of threads and each thread
> has lots of open files.
>
> This patch implemented a customization for task/task_file iterator,
> permitting to traverse only the kernel task where its pid equal
> to tgid in the kernel. This includes some kernel threads, and
> main threads of user processes. This will solve the above potential
> performance issue for task_file. This customization may be useful
> for task iterator too if only traversing main threads is enough.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  3 ++-
>  include/uapi/linux/bpf.h       |  5 ++++
>  kernel/bpf/task_iter.c         | 46 +++++++++++++++++++++++-----------
>  tools/include/uapi/linux/bpf.h |  5 ++++
>  4 files changed, 43 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a6131d95e31e..058eb9b0ba78 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1220,7 +1220,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>         int __init bpf_iter_ ## target(args) { return 0; }
>
>  struct bpf_iter_aux_info {
> -       struct bpf_map *map;
> +       struct bpf_map *map;    /* for iterator traversing map elements */
> +       bool main_thread_only;  /* for task/task_file iterator */

As a user of task_file iterator I'd hate to make this decision,
honestly, especially if I can't prove that all processes share the
same file table (I think clone() syscall allows to do weird
combinations like that, right?). It does make sense for a task/
iterator, though, if I need to iterate a user-space process (group of
tasks). So can we do this:

1a. Either add a new bpf_iter type process/ (or in kernel lingo
task_group/) to iterate only main threads (group_leader in kernel
lingo);
1b. Or make this main_thread_only an option for only a task/ iterator
(and maybe call it "group_leader_only" or something to reflect kernel
terminology?)

2. For task/file iterator, still iterate all tasks, but if the task's
files struct is the same as group_leader's files struct, then go to
the next one. This should eliminate tons of duplication of iterating
the same files over and over. It would still iterate a bunch of tasks,
but compared to the number of files that's generally a much smaller
number, so should still give sizable savings. I don't think we need an
extra option for this, tbh, this behavior was my intuitive
expectation, so I don't think you'll be breaking any sane user of this
iterator.

Disclaimer: I haven't got a chance to look through kernel code much,
so I'm sorry if what I'm proposing is something that is impossible to
implement or extremely hard/unreliable. But thought I'll put this idea
out there before we decide on this.

WDYT?

[...]
