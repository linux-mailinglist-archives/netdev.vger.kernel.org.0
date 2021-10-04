Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03742170C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhJDTNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbhJDTM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:12:58 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDECC061749;
        Mon,  4 Oct 2021 12:11:09 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id a7so10838097yba.6;
        Mon, 04 Oct 2021 12:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ldJNHVIkPgoS+Nd9Y4xZ86PC0X15+PtogxTJuikgUZk=;
        b=Hv+zOBC5fJRWejR1NgU7v/waUv4qc/v1pTR+qsuxhhjl6iUmPVK4PXlgFeJXwtYeL2
         /p3lxmLSzRiEaWcS4SiGhg0V55UCwSo4tvkJ/G4LC3WW434JRrR6VOihV17sfo5AHxp2
         yIzJ0mCvt7ZDKMuwLkAi/J/MNzgmkl3IL0tEu7sz2oB6ub+Juh6DYZ8POl6badWnd++K
         roNvuvDc/s+tKm//zJ+m08Bhxm8zLrRySzNHd7Gh+yAuA2bYaceqtloTlSw8XHeFoC5y
         pk2q/BZNBp7tyAgVyBkFhDwz/PDjlEawE57mTrAsMDBRKu3tagd/GURaaroLtSbpoyUt
         wwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldJNHVIkPgoS+Nd9Y4xZ86PC0X15+PtogxTJuikgUZk=;
        b=l64kuQTqTEDDRzZ5vG0UwHQkX/8CgncYrWZJZPliZV3wG5Ygy5XKih0n4+MgZttY80
         9tEU0BLit/HNEjl1kR2JeQ7UTdekn/u/YiJSxM6TN5MN4ZdStdv9ULB4eRW3c5GZKKVz
         VGnLjasHMprCFTouxOQoPu4B3FbxFqiS1wJx5L9W3DiIGyMGLNl01p/pe8BQHlo5MxkF
         ukUZBCdU/GYhNoXLgK86rpJxd6nQ0JKhaWEglBS5FwGcK3nqdjJBorzHrjv3JWE8tzVE
         kV/Vyxobgc5njWeoIdXEP/XH1kfKYKl326mmSt+YAc3HdHp5r0LGV3AOYbtvBtB/ZG/c
         8TjQ==
X-Gm-Message-State: AOAM533NBS3eSk8zax1ioaRPf4bqWCm2LIOtKPN6ehrkiVzctAs03bHD
        Eow5gHTAZkFuaCCBXBffPlW5dnm1cxoDZQ4wzsfFCQN04/g=
X-Google-Smtp-Source: ABdhPJxmqvnM0v7c3IE7E/yZ64Z+oT4GlkT2KB4NRI6bvhHg7EOS9zYvnhQIBbnEOpbTKitNCErCHJZx4rVDos2lZdY=
X-Received: by 2002:a25:1884:: with SMTP id 126mr17102603yby.114.1633374668735;
 Mon, 04 Oct 2021 12:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
 <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com> <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com>
In-Reply-To: <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Oct 2021 12:10:57 -0700
Message-ID: <CAEf4Bzb=jP3kU6O6QhZR6pcYn-7bkP8fr5ZDirWzf46WKEWA8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 2, 2021 at 3:12 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Sat, 2 Oct 2021 at 21:27, Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > > >
> > > > API headers from libbpf should not be accessed directly from the
> > > > library's source directory. Instead, they should be exported with "make
> > > > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > > > installs the headers properly when building.
> >
> > > >
> > > > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > > > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > > > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
> > >
> > > Would it make sense for libbpf's Makefile to create include and output
> > > directories on its own? We wouldn't need to have these order-only
> > > dependencies everywhere, right?
> >
> > Good point, I'll have a look at it.
> > Quentin
>
> So libbpf already creates the include (and parent $(DESTDIR))
> directory, so I can get rid of the related dependencies. But I don't
> see an easy solution for the output directory for the object files.
> The issue is that libbpf's Makefile includes
> tools/scripts/Makefile.include, which checks $(OUTPUT) and errors out

Did you check what benefits the use of tools/scripts/Makefile.include
brings? Last time I had to deal with some non-trivial Makefile
problem, this extra dance with tools/scripts/Makefile.include and some
related complexities didn't seem very justified. So unless there are
some very big benefits to having tool's Makefile.include included, I'd
rather simplify libbpf's in-kernel Makefile and make it more
straightforward. We have a completely independent separate Makefile
for libbpf in Github, and I think it's more straightforward. Doesn't
have to be done in this change, of course, but I was curious to hear
your thoughts given you seem to have spent tons of time on this
already.

> if the directory does not exist. This prevents us from creating the
> directory as part of the regular targets. We could create it
> unconditionally before running any target, but it's ugly; and I don't
> see any simple workaround.
>
> So I'll remove the deps on $(LIBBPF_INCLUDE) and keep the ones on
> $(LIBBPF_OUTPUT).
