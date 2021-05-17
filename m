Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC93822E7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhEQCwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:52:42 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:19062 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhEQCwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 22:52:40 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 14H2oqi6003301;
        Mon, 17 May 2021 11:50:52 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 14H2oqi6003301
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1621219852;
        bh=GgOSs8zrb6fLGJr3oX36VWe647ayOr3nv+9MJ33ntoU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o2QF8k95BMd8yhaXpsSiR12h1WwoGQhuf6AogBWQhx0hd6uZim4vlBPqoOtsyyeQQ
         cvU0I/NGzjEBHN6ahVL2tBSNez3Xr8xH1cByT+nQiwp6D+c1Mpzma1cjbVCZr1y7Gu
         R8P1XgddxgdgdtWSQr8lt7ZNlxhUU4llODBzipDIkRQfGLvbhbxTEqZ41FzvrTbiou
         tjJc4+JWh6kT6xsIxCIlpwHROtMNycDo9qyNZmTc+ocbbDrKhOsxW9ClbBljB9bgAq
         EOEHueRbdgTkZhDFS4gjiCRwoGMR7btphCV3/DhLSS4IRaF5gAbXGyqcbfmWlWazIU
         zbq0R1XRmUplg==
X-Nifty-SrcIP: [209.85.210.182]
Received: by mail-pf1-f182.google.com with SMTP id w1so1304944pfu.0;
        Sun, 16 May 2021 19:50:52 -0700 (PDT)
X-Gm-Message-State: AOAM530HiufWOQlo4/mOUIBiR9hP5Ukp/gRQPa40892Ft6NdoKl0+r1e
        TeCLp/SbAlHhzHjKyYDWd2KW8i+HFMzc54G+Tow=
X-Google-Smtp-Source: ABdhPJxHRD6T/mKjM2LPR3y2zbxRWMIy2ygj/8UQJQ2AC/w5yjA+g2CgCkcdSnelIqt5K0XEhroFgs1hNWdr3p9PtXM=
X-Received: by 2002:aa7:94af:0:b029:28e:80ff:cc1d with SMTP id
 a15-20020aa794af0000b029028e80ffcc1dmr57693078pfl.63.1621219851803; Sun, 16
 May 2021 19:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210512065201.35268-1-masahiroy@kernel.org> <20210512065201.35268-2-masahiroy@kernel.org>
 <CAEf4BzbsuivHaX0SHdBBV6+wpdtViFXOw=oWLyytzcRPiq+QSg@mail.gmail.com>
In-Reply-To: <CAEf4BzbsuivHaX0SHdBBV6+wpdtViFXOw=oWLyytzcRPiq+QSg@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 17 May 2021 11:50:14 +0900
X-Gmail-Original-Message-ID: <CAK7LNAThrg9BCCoyPwpxzha86DhjsHUFjzD_xMV7U+bsdpVXzg@mail.gmail.com>
Message-ID: <CAK7LNAThrg9BCCoyPwpxzha86DhjsHUFjzD_xMV7U+bsdpVXzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kbuild: remove libelf checks from top Makefile
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(+CC: Josh, Peter)

On Thu, May 13, 2021 at 4:36 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 11, 2021 at 11:52 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > I do not see a good reason why only the libelf development package must
> > be so carefully checked.
> >
> > Kbuild generally does not check host tools or libraries.
> >
> > For example, x86_64 defconfig fails to build with no libssl development
> > package installed.
> >
> > scripts/extract-cert.c:21:10: fatal error: openssl/bio.h: No such file or directory
> >    21 | #include <openssl/bio.h>
> >       |          ^~~~~~~~~~~~~~~
> >
> > To solve the build error, you need to install libssl-dev or openssl-devel
> > package, depending on your distribution.
> >
> > 'apt-file search', 'dnf provides', etc. is your frined to find a proper
> > package to install.
> >
> > This commit removes all the libelf checks from the top Makefile.
> >
> > If libelf is missing, objtool will fail to build in a similar pattern:
> >
> > .../linux/tools/objtool/include/objtool/elf.h:10:10: fatal error: gelf.h: No such file or directory
> >    10 | #include <gelf.h>
> >
> > You need to install libelf-dev, libelf-devel, or elfutils-libelf-devel
> > to proceed.
> >
> > Another remarkable change is, CONFIG_STACK_VALIDATION (without
> > CONFIG_UNWINDER_ORC) previously continued to build with a warning,
> > but now it will treat missing libelf as an error.
> >
> > This is just a one-time installation, so it should not matter to break
> > a build and make a user install the package.
> >
> > BTW, the traditional way to handle such checks is autotool, but according
> > to [1], I do not expect the kernel build would have similar scripting
> > like './configure' does.
> >
> > [1]: https://lore.kernel.org/lkml/CA+55aFzr2HTZVOuzpHYDwmtRJLsVzE-yqg2DHpHi_9ePsYp5ug@mail.gmail.com/
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >
>
> resolve_btfids part looks good to me:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> >  Makefile                  | 78 +++++++++++----------------------------
> >  scripts/Makefile.build    |  2 -
> >  scripts/Makefile.modfinal |  2 -
> >  3 files changed, 22 insertions(+), 60 deletions(-)
> >
>
> [...]



-- 
Best Regards
Masahiro Yamada
