Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DCBC45B3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfJBBtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:49:36 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:28970 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfJBBtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:49:36 -0400
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x921nVMp020028;
        Wed, 2 Oct 2019 10:49:31 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x921nVMp020028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569980972;
        bh=LjA8My+d4AXL7V4tiUE7HhNcYoSR/qp9wLGs+QBy8Xg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hvi8hapQfUO2Bu8gbSviT13DPPT0YHHo+bgu1tRSU9/8EHHPjBejRa/EctiRhaImt
         niq3xWX9oVIdVuccVCyuSgKm1nW0sLgmGNyqB6uYgshPq1RDHwQSedgcRrfRWmAYAa
         eOjn9v6lvjmaIr7EHGiiBo+5OozvMQBr7+FPf5LvG6gqGBSOhlFShfQiwycNMM59o2
         dHG1tK05agxCYI34w3fglCEAd9ARGdOi9hvoTz2nMe918b3jxoZvxdGf4ZRBQEDYP0
         wwc8jbbgboN4gve9LVlM7PJ6aR4xwn1yPtUoaJPTxM0wIDC2xdj65b1QFRRtBuG4md
         goIJSBcQECLtg==
X-Nifty-SrcIP: [209.85.217.46]
Received: by mail-vs1-f46.google.com with SMTP id m22so10811250vsl.9;
        Tue, 01 Oct 2019 18:49:31 -0700 (PDT)
X-Gm-Message-State: APjAAAUJlg3M1pm3qvcEPUA3og8Si73ux+7fnwRTVeuIGA1qXb0C2jlF
        nKw2ZwhfUqPK5C8tXa278NCPMFbdCgK3m7tFSpE=
X-Google-Smtp-Source: APXvYqxCAYyFoQZyJNti5pJOkHTE9th8RVVwPpDGWczMD67cVLZzOytCkyRv+ymTayZa3BXEKEhJUzcQUJmbrHVeDHU=
X-Received: by 2002:a67:7c03:: with SMTP id x3mr529092vsc.155.1569980970468;
 Tue, 01 Oct 2019 18:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 2 Oct 2019 10:48:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
Message-ID: <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
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

On Tue, Oct 1, 2019 at 11:16 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Tue, 1 Oct 2019 at 14:33, Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > Hi Bjorn
> >
> > On Tue, Oct 1, 2019 at 7:14 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> > >
> [...]
> > >  subdir-$(CONFIG_SAMPLE_VFS)            +=3D vfs
> > > +subdir-$(CONFIG_SAMPLE_BPF)            +=3D bpf
> >
> >
> > Please keep samples/Makefile sorted alphabetically.
> >
>
> Thank you, I'll address that in the v2!
>
> >
> >
> >
> > I am not checking samples/bpf/Makefile, but
> > allmodconfig no longer compiles for me.
> >
> >
> >
> > samples/bpf/Makefile:209: WARNING: Detected possible issues with includ=
e path.
> > samples/bpf/Makefile:210: WARNING: Please install kernel headers
> > locally (make headers_install).
> > error: unable to create target: 'No available targets are compatible
> > with triple "bpf"'
> > 1 error generated.
> > readelf: Error: './llvm_btf_verify.o': No such file
> > *** ERROR: LLVM (llc) does not support 'bpf' target
> >    NOTICE: LLVM version >=3D 3.7.1 required
> >

So, samples/bpf intentionally opts out the normal build
because most of people fail to build it.

It must be fixed somehow
before supporting it in samples/Makefile.



> Yes, the BPF samples require clang/LLVM with BPF support to build. Any
> suggestion on a good way to address this (missing tools), better than
> the warning above? After the commit 394053f4a4b3 ("kbuild: make single
> targets work more correctly"), it's no longer possible to build
> samples/bpf without support in the samples/Makefile.


You can with

"make M=3Dsamples/bpf"



--
Best Regards
Masahiro Yamada
