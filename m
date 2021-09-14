Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AD240BC50
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhINXmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhINXmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 19:42:07 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C29C061574;
        Tue, 14 Sep 2021 16:40:49 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id m70so1788789ybm.5;
        Tue, 14 Sep 2021 16:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MTsWxNtVh/gUW07bqDpwxbltc3xjMs1mgO9/G4lqUoI=;
        b=M6tRVQwm5bciunlN5mIWsPcm2jBtUHsBujVD/sLgb2d4nNsB49bvrth4G2E0TBN6Rm
         CEAB9Y+3e8LQAoJivkEEyhOmnLWVL/ycS5tAZ+LjKWypyWSwF93S9OVBEZ3KgmlqpKxb
         ctJ7dKuv62fgavf5UgcL6A0tiaH6dP82OERmpHn0ktHmTfW8tl1QXAI/y3u1L/ApTFkP
         4zaObCjDHUDG1BzcsOfpcLhAa6GlkOms4wIdcJ7+I1S5gnXgKtqMnMQgKmhgGEFGoXZm
         BlcbeE6mV8LLuD2wxuI7iNsvENBH8jwptyCcOl0T0VSH1LXkHzrijS2eJIujKMEcYoEe
         fDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MTsWxNtVh/gUW07bqDpwxbltc3xjMs1mgO9/G4lqUoI=;
        b=hvUbqUSUw2VcfiU9msaXv4P3MgRvZlIqVPY8c9T478p7U9QwFvBEzpFmkunGjOOjyJ
         fYiS6WxKFC8pqfMvp2uP4d4jNAipnZi0dgTPPNkfdG1ncHS9+DpDCrOhsArzH8T+xp0y
         +WhM/gaUKBC541z48Gyr1O+hDvHBY6UnunaZQELKkZT+ZEQvNsZApD36gFWR0losBQR6
         WuwFKeoyjr5rrDIQ0+H2M8XIM8anFXydK9oHz1Lg3U+KmQ7mYf7KdL0RgnU59Lc7OxlO
         qmlVWl+WPd3U7H5Us1mzAiOpOBH9W0ZafBVOZ5dIPG3TvbYtjY/XpdPV9p4aLoM2foe8
         brDg==
X-Gm-Message-State: AOAM531ignYg1sALbozwPMoRwg5FochSTKHnrNncB3qfYa5f5QhucmMV
        kcSKQ+RH9trhU2dFp1Y4ZCWSLnClQ5ksyV5Oh4IBSkfm
X-Google-Smtp-Source: ABdhPJzarngUCYaTNT7QCrz8jT8AJefDfCIDqRpsx5EvzBsCDCdYCX4vXnTdDV9CWiuNXNz+HgmQbthS7KYCfl4796M=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr2449162yba.225.1631662848122;
 Tue, 14 Sep 2021 16:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210914113730.74623156@canb.auug.org.au> <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
 <20210915093802.02303754@canb.auug.org.au>
In-Reply-To: <20210915093802.02303754@canb.auug.org.au>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Sep 2021 16:40:37 -0700
Message-ID: <CAEf4BzZ7LKNZ8w8=6PGTUxfp2ea_HOBJL=dZocdsyWjKqZ2LhQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 4:38 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Andrii,
>
> On Tue, 14 Sep 2021 16:25:55 -0700 Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 6:37 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > After merging the bpf-next tree, today's linux-next build (perf) failed
> > > like this:
> > >
> > > util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
> > > util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: libbpf v0.6+: use btf__load_from_kernel_by_id instead [-Werror=deprecated-declarations]
> > >    27 |        int err = btf__get_from_id(id, &btf);
> > >       |        ^~~
> > > In file included from util/bpf-event.c:5:
> > > /home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
> > >    54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> > >       |                ^~~~~~~~~~~~~~~~
> > > cc1: all warnings being treated as errors
> > >
> > > Caused by commit
> > >
> > >   0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling API deprecations")
> >
> > Should be fixed by [0], when applied to perf tree. Thanks for reporting!
> >
> >   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210914170004.4185659-1-andrii@kernel.org/
>
> That really needs to be applied to the bpf-next tree (presumably with
> the appropriate Acks).
>

This is perf code that's not in bpf-next yet.


> --
> Cheers,
> Stephen Rothwell
