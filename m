Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929A53CCB2E
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhGRV5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGRV5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 17:57:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5BEC061762;
        Sun, 18 Jul 2021 14:54:41 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r135so24677190ybc.0;
        Sun, 18 Jul 2021 14:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9j1NWnlbjiSB+YS5FOue9N8gotu/EDm4p2Vpx7w+TB0=;
        b=JdBncGJcVy1N7d6pyHtdLvzJFtv/elzIMW9Ke0j/aQQbVu4ob/Rk+4/oZOKI8I95mX
         GUkkTJNDEm5+njVW9GQBOnN/Lx5d/cqYM8zILEj0ZGeDvQdRxez2Hl2TkToP++M2jOkV
         ZQ5NdKJNoJ1eStj49EI3coroBtFXjNlKYOfjAV7iPeJwCnirxjMY+1x8i8YRbaKyJ3p8
         GuV1cDPRbEJpBILS9Uez9X+htfGKzG5xfRPVuJdl+flhTyc0ytMYna6CJoCmaG4SFolM
         5u/Lrk4tN/pVJliV4Xxhf9MJG/trbQgwmI7L3R8sqaPLsW7c8pAjr94Wi3gITHdsViZu
         cuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9j1NWnlbjiSB+YS5FOue9N8gotu/EDm4p2Vpx7w+TB0=;
        b=iipsfF0SBdLR8jau3R7YfIdxCSCpUKMB1LLVXOVJ0VQF+jMWaigPIMDAIvsT2v0IOb
         2xBVLVhb4MWACujUFUENbYbnbUtagmulydJyqsfAWgJrzUNT9mJ/3bgowC2rYpOkjJMO
         izpWWiCMAuOqSvX4z2rc0Mmm+fMpeU/tpVnKqeeYHw/Stz6vKiJo0lI+QZ17WHiny3xn
         XtPSf+Dsq2t+mlC9+BZzuIlmcF+dWSoiHKQMq2F3ZSHYePkcsxkkZ/2QW2ANqg2vHju9
         oSCTTWPWnYDJJhFftVfk7F/9tL/+doUBniepG8a3D/38USLMbW1Xy4i2D6FaaaK8ZKm0
         KhTQ==
X-Gm-Message-State: AOAM530C23Oh+VMrXDqgXS+i7id+lCi5YipU0tClPBCBL6l4ktNCGqSg
        kJbsadQhhNUcibtdXfHVUC6iaw/DeqEVbbIrBSc=
X-Google-Smtp-Source: ABdhPJxi9hEYY1Rma5JOio9CxD2CjVJXBqV9KgzBDkgfXMP6dHpl4SMScCNq367PiaagDX0X3Xso89Tdw96kXOCK7TQ=
X-Received: by 2002:a25:bd09:: with SMTP id f9mr27126985ybk.27.1626645280871;
 Sun, 18 Jul 2021 14:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210718065039.15627-1-msuchanek@suse.de> <c621c6c6-ad2d-5ce0-3f8c-014daf7cad64@iogearbox.net>
 <20210718193655.GP24916@kitsune.suse.cz>
In-Reply-To: <20210718193655.GP24916@kitsune.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 18 Jul 2021 14:54:29 -0700
Message-ID: <CAEf4Bza4Fd4vnJLHYKN_VE3=hcLSnxUN-YMN4iv=B5h+y+wCdg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove from kernel tree.
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 12:36 PM Michal Such=C3=A1nek <msuchanek@suse.de> w=
rote:
>
> On Sun, Jul 18, 2021 at 09:04:16PM +0200, Daniel Borkmann wrote:
> > On 7/18/21 8:50 AM, Michal Suchanek wrote:
> > > libbpf shipped by the kernel is outdated and has problems. Remove it.
> > >
> > > Current version of libbpf is available at
> > >
> > > https://github.com/libbpf/libbpf

This patch made me day :) libbpf sources in the kernel tree is *the
source* of libbpf. Quoting Details section ([0]) of libbpf README:

  Details

  This is a mirror of bpf-next Linux source tree's tools/lib/bpf
directory plus its supporting header files.

  All the gory details of syncing can be found in scripts/sync-kernel.sh sc=
ript.

  Some header files in this repo (include/linux/*.h) are reduced
versions of their counterpart files at bpf-next's
tools/include/linux/*.h to make compilation successful.

> > >
> > > Link: https://lore.kernel.org/bpf/b07015ebd7bbadb06a95a5105d9f6b4ed58=
17b2f.camel@debian.org/
> > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> >
> > NAK, I'm not applying any of this. If there are issues, then fix them. =
If
>
> They are fixed in the github version.
>
> > you would have checked tools/lib/bpf/ git history, you would have found
> > that libbpf is under active development in the upstream kernel tree and
>
> So is the github version.

See above, Github is a projection of the kernel sources. Yes, Makefile
here and on Github are different, but that's by necessity. We do ask
all distros to package libbpf from the Github version, but there are
kernel projects (bpftool, perf, selftests) using libbpf from the
kernel sources themselves.

>
> > you could have spared yourself this patch.
>
> You could have spared me a lot of problems if there was only one source
> for libbpf.
>
> Can't you BPF people agree on one place to develop the library?

We can. We did. We even wrote that down. And we do develop libbpf in
one place, here. Github repo only accepts PRs for Github Makefile and
various parts of CI process which is Github-specific.

>
> Thanks
>
> Michal
