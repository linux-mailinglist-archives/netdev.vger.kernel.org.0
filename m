Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9018D35E280
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345807AbhDMPR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhDMPR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:17:57 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4FAC061574;
        Tue, 13 Apr 2021 08:17:37 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u20so19744965lja.13;
        Tue, 13 Apr 2021 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppycM44YZ5/x+F+FpvuSz3e42AYu8dnomgM7Aqbca+E=;
        b=hV1cZt86ol9OrFFJMnsOxExc4VN7PmveVwEcLa466q1WCtozm5QiWOrb197eE23XQK
         2sUzjmdIWPmI/LTl23676LpJpXYHXXgbAR1Vk+XIsZux00hHeRWuDofGjTjxEaJSKi6x
         LW3obTPgpF3SWNHhg5vyCh46TC6fSZFfkfd91eTEXBQatTLJTa09Iiha0YKYRVuupIpx
         PrZ6nInhLZcdrQvDqv8M5rH9nIoGjVWv9Hhr+yC5yaZQhaamie142rbNiOtOQ0ItEB0i
         gJsYW4R57MeY6yjWx8EeGV4Vcuw9O3dfOQMCW065uwMla0ELZI33EgVb12m1bK3Lf0nq
         qxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppycM44YZ5/x+F+FpvuSz3e42AYu8dnomgM7Aqbca+E=;
        b=aRj+4Sm5mMOgg4750RG1Nbh04aQiYL0WfWgD9xVknQjgUbQYgloNj93kw6Fr1ZsRzb
         XzJ98brAmeNQFMVhI1XmZIviSLfTp8YdCMecKMHMUwS28z16NayrC/voVNZBlHoQfSdw
         03NUU4o/2hxcM+cM1bCRb4DeLtgvntzMp06Np28NFNEOoT0UoLceqU7Lx4FuxBbOXCmv
         jWl97V90Y7EelHwWC3mdD+WjKH36jPQeVefSTpm7CBxtz3yglw/q7el4nK4ckKlcc4Eh
         sZviBCwEJPR1nMrLsaUifOVvRqapSU0F9eqMmAP2yRS/gZDUtjd6QZV/d/TmCxJw6T9C
         gkbw==
X-Gm-Message-State: AOAM531U4bMBy0pSHofBaT1eqbIjaUC3BVrHlKMKxGiAo2PjVHwpmRvN
        q4QabFNlFoHTsno288iLcgD97hc/JoAYKMPMX98=
X-Google-Smtp-Source: ABdhPJyQgJyvDlcUvaXlleED63s+k9x+S1iLokB1S12f3JreA8voCDlIiOMnYUa8RmjcNZqKnmnfr5WUNYhmseH+zDA=
X-Received: by 2002:a2e:894d:: with SMTP id b13mr13096620ljk.486.1618327040638;
 Tue, 13 Apr 2021 08:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Apr 2021 08:17:09 -0700
Message-ID: <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: use !E instead of comparing with NULL
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Tue, Apr 13, 2021 at 2:52 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:189:7-11: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:361:7-11: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:386:14-18: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:402:14-18: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:433:7-11: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:534:14-18: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:625:7-11: WARNING
> comparing pointer to 0, suggest !E
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:767:7-11: WARNING
> comparing pointer to 0, suggest !E
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  tools/testing/selftests/bpf/progs/profiler.inc.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> index 4896fdf8..a33066c 100644
> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -189,7 +189,7 @@ static INLINE void populate_ancestors(struct task_struct* task,
>  #endif
>         for (num_ancestors = 0; num_ancestors < MAX_ANCESTORS; num_ancestors++) {
>                 parent = BPF_CORE_READ(parent, real_parent);
> -               if (parent == NULL)
> +               if (!parent)

Sorry, but I'd like the progs to stay as close as possible to the way
they were written.
They might not adhere to kernel coding style in some cases.
The code could be grossly inefficient and even buggy.
Please don't run spell checks, coccicheck, checkpatch.pl on them.
