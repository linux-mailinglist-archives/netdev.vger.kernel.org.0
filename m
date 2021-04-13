Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB335E398
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbhDMQO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:14:58 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:44839 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbhDMQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:14:57 -0400
Received: by mail-lf1-f54.google.com with SMTP id e14so15482403lfn.11;
        Tue, 13 Apr 2021 09:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZa6xX98+lkUJw38jz4IW+RW3vhcytEYCGbyuVjeplQ=;
        b=k8t/UGWhPiHZJ45SazvSK/dkLlXNJ5vqj7mHLukq3zLiERcxc/6G9btqsJBVr8Y+sL
         JLsA6lL5O0zB0Vs37DDDFoNZFwER+7OOoJ/9zjGPPON73d9+m+bYIcUeZtP1h/p4qxzo
         ykulc3XEMWfj3dvHmdKfS1J8TVbpFIzSm81pCW8ps8TQ13zlddfINi08AV+d9yTZaX8n
         ekhADWpivzyZj9rbR0q0kdRY12dAyB9K74PTHwCipEmiCjViFCGX+r12NzhrS34RsQWR
         WfyAKQlIAw0EKE67zHn6HV+TlH6T45Y7wvuhedvwc7hqiT5SXot3OOjuFBixWGhypA3A
         3S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZa6xX98+lkUJw38jz4IW+RW3vhcytEYCGbyuVjeplQ=;
        b=L3kagSCQo8DdUBssMUxD0FkJ8Ayck5nVrR6yVL1nwj2l18tOL3o/d5gAUNEfdFCtgb
         ZV6WJs2CwdrFAdbtT34gMRUl6SepowgPxvG9lND1aQZc/+ZODQXpbWJPcSh7o79+V8Lw
         ba9auejzP33yk+7qyKwRtNBEJBg7rqV27dd7l6uOWCtvacoys1g7j8NwqlQa02X0Ig7B
         3KSUhdlrnxSAS31b7y1xfr9Hi3uNK/2gM6v2NB8CECEtXa+1Tfxvw9JPt9piYAgebMnH
         TohXKZ+LVN0MOxXieBeVCkttd80zD9v68cpFdeLNuPdgN+gP61DWYhSkUklNHlgyfrR/
         t6KQ==
X-Gm-Message-State: AOAM533JMsVBVoz2jjUoBupwoy1pwz3xn34TLEHhq097LDqnrwH5L//K
        sp1OK1xRQFbF6vHH9dfaoZm5yJPeCWasoGjZU/c=
X-Google-Smtp-Source: ABdhPJxXIFxMSHEbOtOERgUPBpgR2jRiJOTnPDQcTDuqmf/m00cg9RrJk2mUUP+J5hhqoHclMRNNzXNzb17gX/PL5UA=
X-Received: by 2002:ac2:4d4d:: with SMTP id 13mr16413881lfp.540.1618330415836;
 Tue, 13 Apr 2021 09:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com> <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
In-Reply-To: <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Apr 2021 09:13:24 -0700
Message-ID: <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
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

On Tue, Apr 13, 2021 at 9:10 AM <Tim.Bird@sony.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >
> > On Tue, Apr 13, 2021 at 2:52 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
> > >
> > > Fix the following coccicheck warnings:
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:189:7-11: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:361:7-11: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:386:14-18: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:402:14-18: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:433:7-11: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:534:14-18: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:625:7-11: WARNING
> > > comparing pointer to 0, suggest !E
> > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:767:7-11: WARNING
> > > comparing pointer to 0, suggest !E
> > >
> > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > > ---
> > >  tools/testing/selftests/bpf/progs/profiler.inc.h | 22 +++++++++++-----------
> > >  1 file changed, 11 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > index 4896fdf8..a33066c 100644
> > > --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > @@ -189,7 +189,7 @@ static INLINE void populate_ancestors(struct task_struct* task,
> > >  #endif
> > >         for (num_ancestors = 0; num_ancestors < MAX_ANCESTORS; num_ancestors++) {
> > >                 parent = BPF_CORE_READ(parent, real_parent);
> > > -               if (parent == NULL)
> > > +               if (!parent)
> >
> > Sorry, but I'd like the progs to stay as close as possible to the way
> > they were written.
> Why?
>
> > They might not adhere to kernel coding style in some cases.
> > The code could be grossly inefficient and even buggy.
> There would have to be a really good reason to accept
> grossly inefficient and even buggy code into the kernel.
>
> Can you please explain what that reason is?

It's not the kernel. It's a test of bpf program.
