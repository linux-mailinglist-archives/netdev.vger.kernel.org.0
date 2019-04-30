Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E663ED90
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfD3APp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:15:45 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:28682 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbfD3APp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:15:45 -0400
X-Greylist: delayed 33991 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2019 20:15:43 EDT
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x3U0Fd25000867;
        Tue, 30 Apr 2019 09:15:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x3U0Fd25000867
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1556583340;
        bh=q+wnSYJgkuXCqwUQQQG2fqHF1PoqjJGwSyWrsWQE94c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xZwit9Hy6Z7yHd7FKiZxqkHlA/bLXU/WykOGiv+L1JwBrATQrlPAKQ7rkLHbGGJIH
         Nb8ntDBv0s6xoSvW8K+4STy0Ak/FmWU+3oy9xNZBb0ff/CJslJi7rfLxJ8KYsbK8Ev
         YnLTI7v+EJdEtml9aA8Qoa1CBoEvNfzlzKWiihqso/WUwdcq3JpjukLgPFDIC7GlDw
         aB1RWiZ5si3OXdz3zU/9TmwHDXzI60L6Na86T/7ZslTCe/7nADk45F7CN+KW9RXcyW
         wzoHv69N/GiXTD+zg4U7MWHfIf21Pmy6EIFIOpCQGhPg/yP1irYDqAd7tqNovKKp2D
         zfXf93X5OTCWA==
X-Nifty-SrcIP: [209.85.217.53]
Received: by mail-vs1-f53.google.com with SMTP id g127so7000845vsd.6;
        Mon, 29 Apr 2019 17:15:40 -0700 (PDT)
X-Gm-Message-State: APjAAAVEUl1/DSl2xQzYovpasi6f2RPeCn+k8wa4aqMLAXiYC0ParJQ0
        +344hUGzTegnpXNrZtNcV1Y4lvJh8Pd1VSCmPL4=
X-Google-Smtp-Source: APXvYqxJ7rTBWuDPzw87BgOp3DuLMtn+EoCbWyN0RkUTb1ATihGYEaPQMWglwlBdQmpgTqHdSgJ6IWLuEEkmT9yLzKU=
X-Received: by 2002:a67:f105:: with SMTP id n5mr34539591vsk.181.1556583339164;
 Mon, 29 Apr 2019 17:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <1556549259-16298-1-git-send-email-yamada.masahiro@socionext.com> <ec1d2c14-ae27-38c7-9b79-4e323161d6f5@netronome.com>
In-Reply-To: <ec1d2c14-ae27-38c7-9b79-4e323161d6f5@netronome.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 30 Apr 2019 09:15:03 +0900
X-Gmail-Original-Message-ID: <CAK7LNARBOtOMr-=FRh0K1nMFLijRjRCMHYb0L=NY7KZQGydVrQ@mail.gmail.com>
Message-ID: <CAK7LNARBOtOMr-=FRh0K1nMFLijRjRCMHYb0L=NY7KZQGydVrQ@mail.gmail.com>
Subject: Re: [PATCH] bpftool: exclude bash-completion/bpftool from .gitignore pattern
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Sirio Balmelli <sirio@b-ad.ch>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,


On Tue, Apr 30, 2019 at 12:33 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-04-29 23:47 UTC+0900 ~ Masahiro Yamada <yamada.masahiro@socionext.co=
m>
> > tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
> > intended to ignore the following build artifact:
> >
> >   tools/bpf/bpftool/bpftool
> >
> > However, the .gitignore entry is effective not only for the current
> > directory, but also for any sub-directories.
> >
> > So, the following file is also considered to be ignored:
> >
> >   tools/bpf/bpftool/bash-completion/bpftool
> >
> > It is obviously version-controlled, so should be excluded from the
> > .gitignore pattern.
> >
> > You can fix it by prefixing the pattern with '/', which means it is
> > only effective in the current directory.
> >
> > I prefixed the other patterns consistently. IMHO, '/' prefixing is
> > safer when you intend to ignore specific files.
> >
> > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > ---
>
> Hi,
>
> =E2=80=9CFiles already tracked by Git are not affected=E2=80=9D by the .g=
itignore (says
> the relevant man page), so bash completion file is not ignored. It would
> be if we were to add the sources to the index of a new Git repo. But
> sure, it does not cost much to make the .gitignore cleaner.

Right, git seems to be flexible enough.


But, .gitignore is useful to identify
build artifacts in general.
In fact, other than git, some projects
already parse this.

For example, tar(1) supports:

     --exclude-vcs-ignores
           read exclude patterns from the VCS ignore files


As of writing, this option works only to some extent,
but I thought this would be useful to create a source
package without relying on "git archive".

When I tried "tar --exclude-vcs-ignores", I noticed
tools/bpf/bpftool/bash-completion/bpftool was not
contained in the tarball.

That's why I sent this patch.

I can add more info in v2 to clarify
my motivation though.





> >
> >  tools/bpf/bpftool/.gitignore | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignor=
e
> > index 67167e4..19efcc8 100644
> > --- a/tools/bpf/bpftool/.gitignore
> > +++ b/tools/bpf/bpftool/.gitignore
> > @@ -1,5 +1,5 @@
> >  *.d
> > -bpftool
> > -bpftool*.8
> > -bpf-helpers.*
> > -FEATURE-DUMP.bpftool
> > +/bpftool
> > +/bpftool*.8
> > +/bpf-helpers.*
>
> Careful when you add all those slashes, however. "bpftool*.8" and
> "bpf-helpers.*" should match files under Documentation/, so you do NOT
> want to prefix them with just a "/".

OK, I should not have touched what I was unsure about.
Will fix in v2.


> Quentin
>
> > +/FEATURE-DUMP.bpftool
> >
>



--
Best Regards
Masahiro Yamada
