Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765E74F3E7
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 07:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFVFkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 01:40:32 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:55098 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVFkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 01:40:32 -0400
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x5M5eC9L014968;
        Sat, 22 Jun 2019 14:40:13 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x5M5eC9L014968
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561182013;
        bh=JxBG390b3AdnCwZiQOKsk1HAVj5lXZJFRQcpOMWwHbY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vfztd4BrukAdjcSvvO2e/ZaIiyZ9mx12XbkLTV+W2nuoyC48frSlNAvAwwbP73Vyr
         Tn+tVvlKIzCwwccAQjVD1cg72WyVKXSwN1+zOr7lOr0xep66UxomKkozXKaAAqJ+CV
         SfVa4bLXejWLmgX1RRFqEBQRb5vCW/M+iBtN1UirSWuQ9L3Xh33Fs3k5t2oCFMw6Ld
         Z7kiY+Xf7S5QA3YRLzTg1M2Ye9HAaaVOTunAB6PxPorlGZDFETkls1kQhr8wgHXtMf
         YjfN2RgtEjH09lnD0+PgldC7gF8hrf52UOZ7yY1R/DkdUlmXGwi5iBOm4amb4+aKnQ
         LTT74SXqb15DQ==
X-Nifty-SrcIP: [209.85.222.54]
Received: by mail-ua1-f54.google.com with SMTP id v18so3739081uad.12;
        Fri, 21 Jun 2019 22:40:13 -0700 (PDT)
X-Gm-Message-State: APjAAAUuZhCGgH9XL0FGqr+jjF6Fh1RUhfsTRGXzsgdXdgTZS4cMprPS
        afVQByBwbpOU9AaM+w1rJfdhJIl9V7gAVvOKBM4=
X-Google-Smtp-Source: APXvYqzlKgWISF72/2l3BCTzXtxOrbxlLww7I4OL4+Gvksq0C26omqpvWWFe0eb5vghy8UgM0iBbJXyRxsNhrZQR8a0=
X-Received: by 2002:ab0:5ea6:: with SMTP id y38mr48367542uag.40.1561182012133;
 Fri, 21 Jun 2019 22:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190604101409.2078-1-yamada.masahiro@socionext.com>
 <20190604101409.2078-16-yamada.masahiro@socionext.com> <CAK8P3a08f25WYP5r57JHPcZWieS2+07=_qTphLosS4M2w8F0Zw@mail.gmail.com>
 <CAK7LNATt8BSrMfrOVjZ_SbA0awsh4CvRhu6TF3gYYynirpviWw@mail.gmail.com>
In-Reply-To: <CAK7LNATt8BSrMfrOVjZ_SbA0awsh4CvRhu6TF3gYYynirpviWw@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 22 Jun 2019 14:39:35 +0900
X-Gmail-Original-Message-ID: <CAK7LNATi1kX_j9-7CoT24hohgTCQB1dSc9j8DNdmjnmEg1-kRg@mail.gmail.com>
Message-ID: <CAK7LNATi1kX_j9-7CoT24hohgTCQB1dSc9j8DNdmjnmEg1-kRg@mail.gmail.com>
Subject: Re: [PATCH 15/15] kbuild: compile test UAPI headers to ensure they
 are self-contained
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Michal Marek <michal.lkml@markovi.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Palmer Dabbelt <palmer@sifive.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 2:12 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Sat, Jun 22, 2019 at 4:05 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Tue, Jun 4, 2019 at 12:16 PM Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> >
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1363,7 +1363,7 @@ CLEAN_DIRS  +=3D $(MODVERDIR) include/ksym
> > >  CLEAN_FILES +=3D modules.builtin.modinfo
> > >
> > >  # Directories & files removed with 'make mrproper'
> > > -MRPROPER_DIRS  +=3D include/config usr/include include/generated    =
      \
> > > +MRPROPER_DIRS  +=3D include/config include/generated          \
> > >                   arch/$(SRCARCH)/include/generated .tmp_objdiff
> > >  MRPROPER_FILES +=3D .config .config.old .version \
> > >                   Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS=
 GSYMS \
> >
> > This change seems to have caused a minor regression:
> >
> > $ make clean ; make clean
> > find: =E2=80=98*=E2=80=99: No such file or directory
>
> Hmm, I cannot reproduce this.
>
> I checked the latest linux-next.
>
>
> masahiro@grover:~/ref/linux-next$ git describe
> next-20190621
> masahiro@grover:~/ref/linux-next$ make clean; make clean
> masahiro@grover:~/ref/linux-next$
>
>

Ah, now I was able to reproduce it.

Will fix it soon. Thanks.



--=20
Best Regards
Masahiro Yamada
