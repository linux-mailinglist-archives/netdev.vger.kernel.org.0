Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1191180BE6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCJWy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:54:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33691 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:54:28 -0400
Received: by mail-lj1-f196.google.com with SMTP id f13so175200ljp.0;
        Tue, 10 Mar 2020 15:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pM+fYvbMj208ZugLVIlwzQSq8U/Lp8tMyL5uivacVmA=;
        b=GSfKkP5zcJ8A4aodAIuq0ilAKhP4Rq6yj/nrtwybQaTs16kld6EGsl/zEXbBUiQsXf
         F6/UspwzJib8joQAgayDie7ROUBjoKfGWwTCpXBClputDx2fm0rtIe3VWvTpY/gTmwrJ
         gHYyIXPlgbCK7ZDNiJovvz3ykddA8NNFr/fx/NELy20KXIRMCUrrFh66pxQtrF7Jcw1d
         oYiuPxuFZOmSop4rSXTdVE8daNt8RD6FXvT+QNrSCH1/TeOXQEoicTaQ4U8EHj+2X0fn
         dWbwkpZKirCeXyWZXpvRqwSifv/wJVrYcc5guZY5F27ml3nNVpCcNuYeUeFJwNyACbwo
         jyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pM+fYvbMj208ZugLVIlwzQSq8U/Lp8tMyL5uivacVmA=;
        b=Bft7683SC4GNgEc1VmAzdUbYMJptkgSODytkCMdhwxe20O5T9rmiTs53VHbSCcCaJg
         tAnTylfMbPNZv1pBn5egzuFybd9KFX/6pg4YdORDTKh3iTS6EcLyTtIfPdPHyXNuxAp8
         +t9+QJPVudJ8p19cVzyTpntiPTYRtvEBXEwjn7HgXeTVwIcStzJU/UDXHqZM4yavQH0u
         B6TLYFK69RLXAm30n61Oqk9mQ0cXbvquO3/hA9wWsKlsWVmXDZiioHt51XdTre2+fn0s
         Ac7ulpMcpYL7GnhZA6b4NxBHWTmZjnpeYCbE0roFK0Oo9lcCgzUmT6+9/DZYUR9wMVv3
         n31A==
X-Gm-Message-State: ANhLgQ2fgLTGQq2bYgKIIWU6cuS+iRD3e+TI+ieTIwPzH65knmftJYZW
        Dy+u0HaX4tDr19nrpFYfWnAPfHf9hbTFVJVyQgA=
X-Google-Smtp-Source: ADFU+vslyVXgsyZDAG4Ek8+SytaHrTuAvuG46JbJ56ZeiV9ymE2pW6mXIUp2obdoJOV18Uoh0YTUxd3TpmT0Jt096gc=
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr277269ljn.212.1583880865895;
 Tue, 10 Mar 2020 15:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200310183624.441788-1-songliubraving@fb.com>
 <20200310183624.441788-2-songliubraving@fb.com> <65be9b45-059a-fc41-fd47-a6b9d7cda418@isovalent.com>
In-Reply-To: <65be9b45-059a-fc41-fd47-a6b9d7cda418@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 10 Mar 2020 15:54:14 -0700
Message-ID: <CAADnVQJhSEE3nuWupoUGgOU_0+OnKg4c_buMCSLyoQY3J9a_Ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpftool: only build bpftool-prog-profile
 with clang >= v11
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 3:45 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-03-10 11:36 UTC-0700 ~ Song Liu <songliubraving@fb.com>
> > bpftool-prog-profile requires clang of version 11.0.0 or newer. If
> > bpftool is built with older clang, show a hint of to the user.
> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >  tools/bpf/bpftool/Makefile | 13 +++++++++++--
> >  tools/bpf/bpftool/prog.c   |  2 ++
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index 20a90d8450f8..05a37f0f76a9 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -60,6 +60,15 @@ LIBS = $(LIBBPF) -lelf -lz
> >  INSTALL ?= install
> >  RM ?= rm -f
> >  CLANG ?= clang
> > +CLANG_VERS = $(shell $(CLANG) --version | head -n 1 | awk '{print $$3}')
> > +CLANG_MAJ = $(shell echo $(CLANG_VERS) | cut -d '.' -f 1)
>
> This will produce error messages on stderr if clang is not installed on
> the system.
>
> > +WITHOUT_SKELETONS = -DBPFTOOL_WITHOUT_SKELETONS
> > +
> > +ifeq ($(shell test $(CLANG_MAJ) -ge 11; echo $$?),0)
>
> Not exactly what I had in mind. I thought about the feature detection
> facility we have under tools/build/feature/, as is used for e.g.
> detecting libbfd. It would allow to check the feature is available,
> instead of tying the build to a numeric version number.

+1
I think the global data feature is actually present in v10.
Version check won't work for backported clangs.
So please do feature check.
