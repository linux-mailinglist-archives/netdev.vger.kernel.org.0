Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520E03220A0
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhBVUGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhBVUGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:06:42 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E995C061574;
        Mon, 22 Feb 2021 12:06:02 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id o186so7206194vso.1;
        Mon, 22 Feb 2021 12:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3JsEiVKM8ArUIsf19H/75dOFga4rhuq6aHG4m3F/mY=;
        b=TDtevoOTMxyP6qUr7WaKNGt8QX9GWT+Zd443MKp/uRn11JVbIBNLRhgnU+fAOwxNgP
         m4Kse+fcsRs33hoYZRQPE/JOEDqEuAmLRfBZj6m9w71zcj70g4DLgc7qZEJMy6B7/Q2T
         kKSk3KlPhXJtgVug+Bv28bx2QAbmhGyDnMoKIVxtNYT9PCYdeh16ZfZpQ/miCcUKhCAt
         SrvmL43guxs53VIDBH9MkRuomTEtGGjFSTZzRLeBsYS33r4utdMYha6rEOYaa6XLps9c
         VFwYPJgmkN+vMf1mDDAHEbnU+vQaHutuxB+WPQhI/b58cz+S5MOJMzyrZFnmZrWYZjyX
         ubbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3JsEiVKM8ArUIsf19H/75dOFga4rhuq6aHG4m3F/mY=;
        b=EW0pwR4xYwlSHQi3s6QFDncYx3myq+douJKjOXQeFNdBWRf+kh6WdmuEEgWrHlHlHp
         tle5oKuln9X87G3Nqnx8i1IlyrW8oobw53FW+xPD208q/fA4pNOiQB4AE9UwCooGXPZ0
         xDE3xTXj++xL6fN50jdHrhXN6Fk6q9HBxkob/b9IkgoVaspssvf0QsBCSS9hdYA31nhz
         THD0LyvOVbYb5lshzCGROgVnTg22UPoJfdVcuP6p+VOWZzRsRUeAs/ZKYbkMvzzu3uJG
         PKR5EGDmCMpEI9NDumSzMAvJC+rJONiNAz6va45gFg8JgzwngUMumIdzpdvVNrSha5xp
         ndxg==
X-Gm-Message-State: AOAM5309wPmTwAhrzPmsht7stTrD71grHGqsHnMJw++cZnrhoqOshBVn
        2xAtmQF9V4VnXG0we9Qo2m92Pnnn9ciWWvpCkgc=
X-Google-Smtp-Source: ABdhPJxEUBBoB6ho2q6vGiynYDUYWwzyWVHAZpO1ZUoYmqSwZ6+zx0bLlb6i7U4shtd/u4ccsSktWbSmcyrumlaGw7A=
X-Received: by 2002:a67:e9c9:: with SMTP id q9mr14290519vso.6.1614024361007;
 Mon, 22 Feb 2021 12:06:01 -0800 (PST)
MIME-Version: 1.0
References: <20210220171307.128382-1-grantseltzer@gmail.com> <CAEf4BzYMvLg=B=ppjJpyr9VrjCFZepqyBKqgeaG8CakvpWq-Tw@mail.gmail.com>
In-Reply-To: <CAEf4BzYMvLg=B=ppjJpyr9VrjCFZepqyBKqgeaG8CakvpWq-Tw@mail.gmail.com>
From:   Grant Seltzer Richman <grantseltzer@gmail.com>
Date:   Mon, 22 Feb 2021 15:05:49 -0500
Message-ID: <CAO658oUGKCrE8f-OvAD=1qZOOeFEYub=bLUZC1hCCQ_jVaps8g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] Add CONFIG_DEBUG_INFO_BTF check to bpftool
 feature command
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Yonghong Song <yhs@fb.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Networking <netdev@vger.kernel.org>,
        Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I submitted a new patch that includes CONFIG_DEBUG_INFO_BTF_MODULES. I
renamed the patch to include this change so it's showing up as a new
thread, I also fixed the time issue, apologies for the confusion!

On Mon, Feb 22, 2021 at 2:22 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Feb 22, 2021 at 7:34 AM grantseltzer <grantseltzer@gmail.com> wrote:
> >
> > This adds the CONFIG_DEBUG_INFO_BTF kernel compile option to output of
> > the bpftool feature command. This is relevant for developers that want
> > to use libbpf to account for data structure definition differences
> > between kernels.
> >
> > Signed-off-by: grantseltzer <grantseltzer@gmail.com>
>
> Signed-off-by should have a properly capitalized (where it makes
> sense) real name of the author. Is it Grant Seltzer then?
>
> > ---
> >  tools/bpf/bpftool/feature.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> > index 359960a8f..b90cc6832 100644
> > --- a/tools/bpf/bpftool/feature.c
> > +++ b/tools/bpf/bpftool/feature.c
> > @@ -336,6 +336,8 @@ static void probe_kernel_image_config(const char *define_prefix)
> >                 { "CONFIG_BPF_JIT", },
> >                 /* Avoid compiling eBPF interpreter (use JIT only) */
> >                 { "CONFIG_BPF_JIT_ALWAYS_ON", },
> > +               /* Kernel BTF debug information available */
> > +               { "CONFIG_DEBUG_INFO_BTF", },
>
> How about checking CONFIG_DEBUG_INFO_BTF_MODULES as well (i.e.,
> "Kernel module BTF information is available")?
>
> >
> >                 /* cgroups */
> >                 { "CONFIG_CGROUPS", },
> > --
> > 2.29.2
> >
