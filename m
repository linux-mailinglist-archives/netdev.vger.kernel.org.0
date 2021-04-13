Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB635E3E7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245657AbhDMQ2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:28:23 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:45027 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237365AbhDMQ2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:28:22 -0400
Received: by mail-lj1-f176.google.com with SMTP id a25so6744056ljm.11;
        Tue, 13 Apr 2021 09:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zM1kq8q/UzhWGIdsRYnUw0k4ulKBU4s3GvRdb3Ssbxw=;
        b=CIf0ua6uBQg08NteAwSBlxByqKRxZ+bLc8J3Inq35kywD5tweq2hhuUJ2g74PZTvKO
         Xfr9a3GkpH7pLm+JosFZbgA96Gbb6S2Jhe4XBPjqb9U/FByWjXr+gR1VXKD+woBcBrP3
         oOGstU1mgaco4wwbTE+y10qiFf0+x/7jVgQXMN1HR3yR1JSl6u1ElMg1/F4uOMqbtrwk
         wMQUXxZCCAg+935pxG5UFuVrOESV7Ujc6+d2ynPKiuK9dmo1Y9sw3xLW4ezlHNDi6hFw
         89BHJlZE9sXF0yeh8StfHCEoPdKr5Z5B5w/QcCceDPUVFfCyscRJasXLCoL6l5wGvJTo
         vWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zM1kq8q/UzhWGIdsRYnUw0k4ulKBU4s3GvRdb3Ssbxw=;
        b=VEZpE74dNozbJuFKnalaw9TVGMMZwIq6lvNVm7l3ejGYJepLLcx+AgduPvDk5GhniK
         3YGCBaPWZPjXA6rAI8SZF3ZAp3Mjc03afrum95P784VEKSrND8VlVo+IFVnivJIocfAv
         7zAV9Tbvvb79Hwu1WQN1LZd1ZAS12q8B/p7g52iNr6iu4EW7YKoXokgXgQqV4mlJkPMp
         4cGgWhPTjzJM5YJq7FgFX7Qz0xeJEsIY3zxd6jjT7dsWeTpU9hUXQ0RqNcZxgF8ofv2+
         CptNEIn8taLqHNOQfPZtMoaiLCJU6WdS/Qc2m5DLoUz2ojKx6RLlANpyLskHAAhO4fKf
         cD+g==
X-Gm-Message-State: AOAM532MM28D1KXG3ZWl5zM4JpfxFX/lshRwAqE+SI30hwDNE4qbjxob
        bPb+HY0GdqbSEtx4sObefrfpG7I8MFfDJP1jC5s=
X-Google-Smtp-Source: ABdhPJyFi6sjIFp2yH25Bc6FCq8OYlTAIaS9lFUCNlNv/H7/Z5Jugm/9lpFHvU2HpDUNscrfIoXJyUsCWvVr9BRJaxA=
X-Received: by 2002:a2e:9f49:: with SMTP id v9mr4573532ljk.44.1618331220994;
 Tue, 13 Apr 2021 09:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
 <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com> <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
In-Reply-To: <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Apr 2021 09:26:49 -0700
Message-ID: <CAADnVQKjVDLBCLMzXoAQhJ5a+rZ1EKqc3dyYqpeG9M2KzGREMA@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: use !E instead of comparing with NULL
To:     "Bird, Tim" <Tim.Bird@sony.com>
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 9:19 AM <Tim.Bird@sony.com> wrote:
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >
> > On Tue, Apr 13, 2021 at 9:10 AM <Tim.Bird@sony.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > >
> > > > On Tue, Apr 13, 2021 at 2:52 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
> > > > >
> > > > > Fix the following coccicheck warnings:
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:189:7-11: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:361:7-11: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:386:14-18: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:402:14-18: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:433:7-11: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:534:14-18: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:625:7-11: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:767:7-11: WARNING
> > > > > comparing pointer to 0, suggest !E
> > > > >
> > > > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > > > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/progs/profiler.inc.h | 22 +++++++++++-----------
> > > > >  1 file changed, 11 insertions(+), 11 deletions(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > index 4896fdf8..a33066c 100644
> > > > > --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > @@ -189,7 +189,7 @@ static INLINE void populate_ancestors(struct task_struct* task,
> > > > >  #endif
> > > > >         for (num_ancestors = 0; num_ancestors < MAX_ANCESTORS; num_ancestors++) {
> > > > >                 parent = BPF_CORE_READ(parent, real_parent);
> > > > > -               if (parent == NULL)
> > > > > +               if (!parent)
> > > >
> > > > Sorry, but I'd like the progs to stay as close as possible to the way
> > > > they were written.
> > > Why?
> > >
> > > > They might not adhere to kernel coding style in some cases.
> > > > The code could be grossly inefficient and even buggy.
> > > There would have to be a really good reason to accept
> > > grossly inefficient and even buggy code into the kernel.
> > >
> > > Can you please explain what that reason is?
> >
> > It's not the kernel. It's a test of bpf program.
> That doesn't answer the question of why you don't want any changes.
>
> Why would we not use kernel coding style guidelines and quality thresholds for
> testing code?  This *is* going into the kernel source tree, where it will be
> maintained and used by other developers.

because the way the C code is written makes llvm generate a particular
code pattern that may not be seen otherwise.
Like removing 'if' because it's useless to humans, but not to the compiler
will change generated code which may or may not trigger the behavior
the prog intends to cover.
In particular this profiler.inc.h test is compiled three different ways to
maximize code generation differences.
It may not be checking error paths in some cases which can be considered
a bug, but that's the intended behavior of the C code as it was written.
So it has nothing to do with "quality of kernel code".
and it should not be used by developers. It's neither sample nor example.
