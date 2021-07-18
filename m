Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5743CCB32
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhGRV6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhGRV6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 17:58:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D2BC061762;
        Sun, 18 Jul 2021 14:55:16 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a16so24601809ybt.8;
        Sun, 18 Jul 2021 14:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eveSL79fIO473idt3HKry68bIqrgOKyaUGuLZHQDq4o=;
        b=RxEURirprLtNAPe/SG7ygypPUBIGDbJu7ZxunILTdeP60VJXbkfph5slETy6nrYYwc
         +fuwO82JebWo9JpXQQOmXl7AkSrLlNitbLzGssaL3mlet/7p2dhpIcEaeLJmbZ7tESyr
         Pon1huY9z5qV/MBjnUFMu6ee9S3x86JlqzqaN4njrSDGTYDEDvCuc5icrrQrtvXo9foG
         jYb5OsrMuk/KruD+jPYIHXXjB/+0X35nxDGBw+1ujqASLY0Q9p4L7wjtH55MqLGyxWMN
         8PC7hT4O2ujA/UZ7ccq9JO//Ayru1GuKACV1t14cttaOv0/dx6tZdWiJiSKEnLjvUS98
         RwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eveSL79fIO473idt3HKry68bIqrgOKyaUGuLZHQDq4o=;
        b=bsUOQ46bt87wn/S9s+5wAHFd1F7NPpfQsrCb9zfH/eWg5z9OD50olqmCOwlogiK/Gt
         p5Lz0SfmAtW3wUWJR/WSDzBaRXKPkMyhrk2XS1TxiUnHzCYgjBNc7eOod93CPKnA1lbN
         s6n4d9pr55IkJ2ZW18piBcW6ybKuCOM9asH0FQgEfSEL8yR7UFnPLUMcOWEJiso2OBjR
         1jRZgbWOm/mz3Oo0BhYoMeCjdlLx5bhBDPdAqoGnpVx0/EeSqHl8fvW7d3PJR5iBB74I
         J+zRSjXc7jUawlN8wSsq4KkwPLKfj6Ggzq47loukdLB2fewt3G5Cxojz23gQu/mGwxsx
         E7dQ==
X-Gm-Message-State: AOAM530aqxJptVUbiLZUnx/ZyS4D5+cbPnfC6U46DLd2i8lZ8Uxi9KNR
        iQ2fX3TDIFQ8W3oOOZwGjY8gD91pMOOX1J7NsdE=
X-Google-Smtp-Source: ABdhPJwWdylJkAom1a6yZ2KBQ4hwAC+q4SyV8RNzxMWOraKtYQZ3UCzXBASX2sg1TbqC5eQUYPc1j70PXMLBGFjzZKc=
X-Received: by 2002:a25:b741:: with SMTP id e1mr28061396ybm.347.1626645315867;
 Sun, 18 Jul 2021 14:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210718065039.15627-1-msuchanek@suse.de> <c621c6c6-ad2d-5ce0-3f8c-014daf7cad64@iogearbox.net>
 <20210718193655.GP24916@kitsune.suse.cz> <CAEf4Bza4Fd4vnJLHYKN_VE3=hcLSnxUN-YMN4iv=B5h+y+wCdg@mail.gmail.com>
In-Reply-To: <CAEf4Bza4Fd4vnJLHYKN_VE3=hcLSnxUN-YMN4iv=B5h+y+wCdg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 18 Jul 2021 14:55:04 -0700
Message-ID: <CAEf4BzY_QYz6eQY9if5-xu8_pLb-b1sCrd3Q6VXWxCvJ9tFpMA@mail.gmail.com>
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

On Sun, Jul 18, 2021 at 2:54 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Jul 18, 2021 at 12:36 PM Michal Such=C3=A1nek <msuchanek@suse.de>=
 wrote:
> >
> > On Sun, Jul 18, 2021 at 09:04:16PM +0200, Daniel Borkmann wrote:
> > > On 7/18/21 8:50 AM, Michal Suchanek wrote:
> > > > libbpf shipped by the kernel is outdated and has problems. Remove i=
t.
> > > >
> > > > Current version of libbpf is available at
> > > >
> > > > https://github.com/libbpf/libbpf
>
> This patch made me day :) libbpf sources in the kernel tree is *the
> source* of libbpf. Quoting Details section ([0]) of libbpf README:

  [0] https://github.com/libbpf/libbpf#details

>
>   Details
>
>   This is a mirror of bpf-next Linux source tree's tools/lib/bpf
> directory plus its supporting header files.
>
>   All the gory details of syncing can be found in scripts/sync-kernel.sh =
script.
>
>   Some header files in this repo (include/linux/*.h) are reduced
> versions of their counterpart files at bpf-next's
> tools/include/linux/*.h to make compilation successful.
>
> > > >
> > > > Link: https://lore.kernel.org/bpf/b07015ebd7bbadb06a95a5105d9f6b4ed=
5817b2f.camel@debian.org/
> > > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > >
> > > NAK, I'm not applying any of this. If there are issues, then fix them=
. If
> >
> > They are fixed in the github version.
> >
> > > you would have checked tools/lib/bpf/ git history, you would have fou=
nd
> > > that libbpf is under active development in the upstream kernel tree a=
nd
> >
> > So is the github version.
>
> See above, Github is a projection of the kernel sources. Yes, Makefile
> here and on Github are different, but that's by necessity. We do ask
> all distros to package libbpf from the Github version, but there are
> kernel projects (bpftool, perf, selftests) using libbpf from the
> kernel sources themselves.
>
> >
> > > you could have spared yourself this patch.
> >
> > You could have spared me a lot of problems if there was only one source
> > for libbpf.
> >
> > Can't you BPF people agree on one place to develop the library?
>
> We can. We did. We even wrote that down. And we do develop libbpf in
> one place, here. Github repo only accepts PRs for Github Makefile and
> various parts of CI process which is Github-specific.
>
> >
> > Thanks
> >
> > Michal
