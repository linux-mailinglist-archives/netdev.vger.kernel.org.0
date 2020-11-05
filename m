Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25D2A86E4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgKETQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgKETQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:16:31 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A577C0613CF;
        Thu,  5 Nov 2020 11:16:31 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id s8so128100yba.13;
        Thu, 05 Nov 2020 11:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQDWwq8QvMqdJVjzKGOETKiS1dHDi+D7vZxRLNj3byE=;
        b=azygivsUO3WQ3joNx+4dX4Nbmg2PNAghBNk/vpB/zvr95CQWczH5VKrdKtgSmtZ76Q
         mEXaKtXwJ2FUDibZdfn/c4DWWfu+lw3bdhv7lZK0gWtgtEMgNR+AEyu3fM67BtvWDpAU
         uwHVmEIQL7VfJ93hX0RpFkirXlB0yyqWL6JmDM2uYlMbDP2BUiss5aJyxyWFSaIl6ts/
         byqnNf25QOP53SxZ1IzachOloGnOGiq6TCRTpeZrihj1lkipfIkMN3zODz6EPugNN2Kq
         f7NIgu9a1N44TFllgqC/IMQbQyy2zwgvtyuct2hRzo1F+P2DuWHCHgw5GN6qYWyPk4lo
         FLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQDWwq8QvMqdJVjzKGOETKiS1dHDi+D7vZxRLNj3byE=;
        b=fJSCMFUZdlYIKtzuuqij/i69+Cnor86h4PVDX5o4cRy+wLvp+cmUjkYyP90CTw6KqI
         m1Mez89XLr+cffc48hvfWmSw31ERxeCwwUAo10zagF5p6uf5Jb3O9zOojNyiNW/tRuYZ
         DJ6NtG1kjcuQazHocOdOBbB/bA9jLU9xnoVDDwbBZAxTvNb1hJX2DgQ9swIW6Wsr94JT
         s56ehMI8oOGawBKcFVgppJqCbXvgN5rojn2gMadsSpWI5Z5rGh9ZEdAw4aHqhgivwXec
         FS+XqtGgc3qKQq7Tj2ox/ogH2qyIHtD22ceCe+qwNtC+8UstY9bNlMxtdthTZMsRiOsR
         juoQ==
X-Gm-Message-State: AOAM531G35oG81OyTbFIW14PcUumVm6RbsEfQurYknIZydnbgSNJHetn
        xlgf/3Y9ikDX05cfpttPoMbMyfRzJW4Jp+hyccA=
X-Google-Smtp-Source: ABdhPJyCyz06QqQEAxYz9uaHbc6oT73ifk10hhdeAkNDkDovRgGK1ZtVOdvbeHkjfe1kT0ho0uvoZ4IuZ+ucRo50c1U=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr5738478ybe.403.1604603790660;
 Thu, 05 Nov 2020 11:16:30 -0800 (PST)
MIME-Version: 1.0
References: <20201105043402.2530976-1-andrii@kernel.org> <20201105105254.27c84b78@carbon>
In-Reply-To: <20201105105254.27c84b78@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 11:16:19 -0800
Message-ID: <CAEf4BzYOcQt1dv2f5UmVqCGWJVqM95DoUAumH+sRuXW3rzejMg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] libbpf: split BTF support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Anton Protopopov <aspsk2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 1:53 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Wed, 4 Nov 2020 20:33:50 -0800
> Andrii Nakryiko <andrii@kernel.org> wrote:
>
> > This patch set adds support for generating and deduplicating split BTF. This
> > is an enhancement to the BTF, which allows to designate one BTF as the "base
> > BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> > kernel module BTF), which are building upon and extending base BTF with extra
> > types and strings.
> >
> > Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> > with continuous and transparent numbering scheme. This allows all the existing
> > users of BTF to work correctly and stay agnostic to the base/split BTFs
> > composition.  The only difference is in how to instantiate split BTF: it
> > requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> > or btf__parse_xxx_split() "constructors" explicitly.
> >
> > This split approach is necessary if we are to have a reasonably-sized kernel
> > module BTFs. By deduping each kernel module's BTF individually, resulting
> > module BTFs contain copies of a lot of kernel types that are already present
> > in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
> > kernel configuration with 700 modules built, non-split BTF approach results in
> > 115MBs of BTFs across all modules. With split BTF deduplication approach,
> > total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> > around 4MBs). This seems reasonable and practical. As to why we'd need kernel
> > module BTFs, that should be pretty obvious to anyone using BPF at this point,
> > as it allows all the BTF-powered features to be used with kernel modules:
> > tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
>
> I love to see this work going forward.
>

Thanks.

> My/Our (+Saeed +Ahern) use-case is for NIC-driver kernel modules.  I
> want drivers to define a BTF struct that describe a meta-data area that
> can be consumed/used by XDP, also available during xdp_frame to SKB
> transition, which happens in net-core. So, I hope BTF-IDs are also
> "available" from core kernel code?

I'll probably need a more specific example to understand what exactly
you are asking and how you see everything working together, sorry.

If you are asking about support for using BTF_ID_LIST() macro in a
kernel module, then right now we don't call resolve_btfids on modules,
so it's not supported there yet. It's trivial to add, but we'll
probably need to teach resolve_btfids to understand split BTF. We can
do that separately after the basic "infra" lands, though.

>
>
> > This patch set is a pre-requisite to adding split BTF support to pahole, which
> > is a prerequisite to integrating split BTF into the Linux kernel build setup
> > to generate BTF for kernel modules. The latter will come as a follow-up patch
> > series once this series makes it to the libbpf and pahole makes use of it.
> >
> > Patch #4 introduces necessary basic support for split BTF into libbpf APIs.
> > Patch #8 implements minimal changes to BTF dedup algorithm to allow
> > deduplicating split BTFs. Patch #11 adds extra -B flag to bpftool to allow to
> > specify the path to base BTF for cases when one wants to dump or inspect split
> > BTF. All the rest are refactorings, clean ups, bug fixes and selftests.
> >
> > v1->v2:
> >   - addressed Song's feedback.
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
