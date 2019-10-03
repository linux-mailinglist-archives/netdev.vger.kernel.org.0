Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45685C9C6E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 12:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfJCKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 06:37:37 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:44016 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfJCKhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 06:37:36 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x93AbNR8004089;
        Thu, 3 Oct 2019 19:37:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x93AbNR8004089
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1570099044;
        bh=n1PGXVvMl6n5rOY+jPDvgNuS8cWYEdmV5YtD+HFJn0A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kkuURiblyI9hPRD2Am3ni0EbtBFyhkDf3Ux1pllNGSWCGRJh2lz3661jTFvNjOPet
         9r79JDB7tkf0noYXkn/SWgB1M+RDl4EAsEBL3gP5YTXqAGe0FMSuyHVIE/01tNbU4K
         QBuXv/PvXMOk6x/DhJeD05U4d5Chuurbsh12sKqqP0AKcj1GDVEkn4CGvLYC1008Ad
         O5Nwlv8K371NaRRx393FqpAqnUdPusvWS290p4vIyq9CQ+RRsifLB/B2VUNFB6eOB1
         6CrXGltHwL6MW4pJnmOMcOoln4+bvyD+fMpTvx5S55h7O1KvIXuRUolVxogRBvJ2jK
         Rwj30t763b0HA==
X-Nifty-SrcIP: [209.85.217.53]
Received: by mail-vs1-f53.google.com with SMTP id v19so1358297vsv.3;
        Thu, 03 Oct 2019 03:37:24 -0700 (PDT)
X-Gm-Message-State: APjAAAWqnVBrBj/gwT+riOfLbKLA0NXGz7+6SlePF1nzEJc0YzP5CK7O
        jlAJR79knMJytwjegRt1pzPXs+F0pzAqYpJw5s0=
X-Google-Smtp-Source: APXvYqwjodpygq++B1e36Zfn5tPGl4dsCKAK3qEhLmC8Jk1EtgiEuAkIOdYPl5KPu16KcZ42HDUceOxLIO/eOpgxeFY=
X-Received: by 2002:a67:1a41:: with SMTP id a62mr4732113vsa.54.1570099043250;
 Thu, 03 Oct 2019 03:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
 <20191002231448.GA10649@khorivan> <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
In-Reply-To: <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 3 Oct 2019 19:36:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com>
Message-ID: <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 3:28 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> On Thu, 3 Oct 2019 at 01:14, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>=
 wrote:
> >
> > On Wed, Oct 02, 2019 at 09:41:15AM +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > >On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
> > ><yamada.masahiro@socionext.com> wrote:
> > >>
> > >[...]
> > >> > Yes, the BPF samples require clang/LLVM with BPF support to build.=
 Any
> > >> > suggestion on a good way to address this (missing tools), better t=
han
> > >> > the warning above? After the commit 394053f4a4b3 ("kbuild: make si=
ngle
> > >> > targets work more correctly"), it's no longer possible to build
> > >> > samples/bpf without support in the samples/Makefile.
> > >>
> > >>
> > >> You can with
> > >>
> > >> "make M=3Dsamples/bpf"
> > >>
> > >
> > >Oh, I didn't know that. Does M=3D support "output" builds (O=3D)?

No.
O=3D points to the output directory of vmlinux,
not of the external module.

You cannot put the build artifacts from samples/bpf/
in a separate directory.



> > >I usually just build samples/bpf/ with:
> > >
> > >  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/
> > >
> > >
> > >Bj=C3=B6rn
> >
> > Shouldn't README be updated?
> >
>
> Hmm, the M=3D variant doesn't work at all for me. The build is still
> broken for me. Maybe I'm missing anything obvious...
>
>
> > --
> > Regards,
> > Ivan Khoronzhuk



--=20
Best Regards
Masahiro Yamada
