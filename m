Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C032E1DA33B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgESVLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgESVLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:11:16 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE8DC08C5C0;
        Tue, 19 May 2020 14:11:16 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c24so868370qtw.7;
        Tue, 19 May 2020 14:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xaAAfS8WetBzRX6cXWvro6Ajf4D7TYt0S5EIonSLEGI=;
        b=p3GX0U+N3P8qKyoWEPRQuF40BELYdCnJEQtocpAxK3mlfXB/1r8Tzf7VcYKi36R5KB
         tRyZb6F8nG63dJ7jE9D2YoIZKrwO0gZh39LHuBWddfM4Ce71URo3ryJlYLiV6bgTyi8Y
         ix6ne/bLenLBtPsJIEnFu7h0rSE3ZqK3OvBAx96MeZiEVG7qghuzZ5Leb2hFxRcyQGZZ
         DLr9h8Nfy/8uhn9o+8YyKpdIU3pulpzNgIGbZEOp4ZUgxtdmmwG+1desTKUiLmDGX6eT
         oKRiYfc0gb5s+/EQ2lTpFFq812mPeia+V9HGxcNw6tZk94p4lGXGQSE1RcEJG1pI47+e
         Wa1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xaAAfS8WetBzRX6cXWvro6Ajf4D7TYt0S5EIonSLEGI=;
        b=CIsh/nNViJcLmE+bDYswP6NTPLTA5V0pgBMsDIf11nEcwZiD0HbHp3OeY/6tka8nSm
         sxwPy6OaEzY46ri/ydKFA5hBJSEzGbfPq1VzpunZ5rQMltduKbH3wUuxWME+IHnhhH64
         aNgCxl12ZRimy6V/lQT4jkfGwFuCTR3Nzm4I/vBVlO2WMSXm88HCnbPm5XdFUHxHxjnq
         YVvzkbq00brBlVPNGQ6UqCIAx2V35eG58OhttNIG4PePQZDuMgVavjbAgMAjkuBzlxNe
         UELr98953f+1lxPBJ0iFPDJLS/pjW9VCX/8a6VwQjgPHqJjP/9ISUwDaFbbwmvVmembL
         fcfA==
X-Gm-Message-State: AOAM533+fRJLzkOei13ubS6uZreDmbshSaITZ+uyS9d982PeI1bzTi3I
        ghUiFKVdgcj0Qsmgwms6GEjBHZSkh6N3qlUrips=
X-Google-Smtp-Source: ABdhPJz8NLEByo39Z68gr64KvvND2hdFNS7bgZ70wbn0gGOvJAXNf4vyzRJnW+b3W+YTYISJGzA+i2RHSrSJyPnc3qI=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr1958366qtm.171.1589922674983;
 Tue, 19 May 2020 14:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200519192341.134360-1-andriin@fb.com> <20200519210834.qwfrhq2ixgy6l3oy@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200519210834.qwfrhq2ixgy6l3oy@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 May 2020 14:11:04 -0700
Message-ID: <CAEf4Bzb2kLKHAVSO10yo1JO-Ye89XEz64eJh7cBkd3utXC3bkw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: convert bpf_iter_test_kern{3,4}.c
 to define own bpf_iter_meta
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 2:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 19, 2020 at 12:23:41PM -0700, Andrii Nakryiko wrote:
> > b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable against old vmlinux.h")
> > missed the fact that bpf_iter_test_kern{3,4}.c are not just including
> > bpf_iter_test_kern_common.h and need similar bpf_iter_meta re-definition
> > explicitly.
> >
> > Fixes: b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable against old vmlinux.h")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/progs/bpf_iter_test_kern3.c     | 15 +++++++++++++++
> >  .../selftests/bpf/progs/bpf_iter_test_kern4.c     | 15 +++++++++++++++
> >  2 files changed, 30 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> > index 636a00fa074d..13c2c90c835f 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
> > @@ -1,10 +1,25 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  /* Copyright (c) 2020 Facebook */
> > +#define bpf_iter_meta bpf_iter_meta___not_used
> > +#define bpf_iter__task bpf_iter__task___not_used
> >  #include "vmlinux.h"
> > +#undef bpf_iter_meta
> > +#undef bpf_iter__task
> >  #include <bpf/bpf_helpers.h>
> >
> >  char _license[] SEC("license") = "GPL";
> >
> > +struct bpf_iter_meta {
> > +     struct seq_file *seq;
> > +     __u64 session_id;
> > +     __u64 seq_num;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct bpf_iter__task {
> > +     struct bpf_iter_meta *meta;
> > +     struct task_struct *task;
> > +} __attribute__((preserve_access_index));
>
> Applied, but I was wondering whether all these structs can be placed
> in a single header file like bpf_iters.h ?
> struct bpf_iter_meta is common across all of them.
> What if next iter patch changes the name in there?
> We'd need to patch 10 tests? It's unstable api, so it's fine,
> but considering the churn it seems common header would be good.
> That .h would include struct bpf_iter__bpf_map, bpf_iter__task,
> bpf_iter__task_file, etc
> wdyt?

I initially wanted to keep each selftest independent, so that anyone
looking for example would just have everything in one file. But I
agree, we have quite a bunch of them already, so it makes sense to
centralize that in one common header. I'll post a follow-up patch a
bit later to consolidate this.
