Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86155165280
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBSW0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:26:49 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41204 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbgBSW0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:26:49 -0500
Received: by mail-qt1-f193.google.com with SMTP id l21so1468295qtr.8;
        Wed, 19 Feb 2020 14:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=77QMWZNt2P60hLQ8k2WkobTZOYuQcji0wAgaq/fXtCM=;
        b=KFkBY2olxZYCK+/8EzDemlFkDrs6pvRfKvSFrDMPzFEDUhPzJJ4aL+kFi6/ysz3K+Q
         KwW8kGJ+wtfnCNFktmYryzjVLMZoq6okfL0dhySDfdWC8qccjisFZa6cbxyR0CbNU8v/
         Vqgtk9s8lN5QP4z7BQL2+PXlRnUI+hzSUpn1jBa58sz3KvcjKUfAgm9OmbfK+L7SG36x
         y7xeE4CFzb9mtkb5QebGDp7GBQtN5jZIkVrSyRvjNoKPWa79u/sVbVCR/rtbZn8SBdvt
         S52dPpqRaUcCBlhzy8jVHVlpXhJCRoiUgO/PsKNr1qPu03+1iUvtKKUZ6V0GNxePHcJy
         mTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=77QMWZNt2P60hLQ8k2WkobTZOYuQcji0wAgaq/fXtCM=;
        b=CcsEqrXCJpspqX8DiokqYWxIGdcqEzV8Js0Gz+uxpYERF7wqx/NFjrdmMYNP/NbxIF
         OqE9h0mva18eg5UrCreAICioVRTTHAtq7d1KeLo4R0uQUH2ZH+/0/HxJt8xkU/O2OQyf
         /GzO3+GWQs/Fi2GiGRkBXCkgNAaPq+RWVpqeEeLIdGr+Nz2K4Rz8lWRjqnRqJrh75F/u
         tg7W7dhn04heILZ4d96AhWeSpW5jRTErHtyTOA++322PuLRUGkttKrvvUv4hyaO9ilPw
         kk4GqlZ55A0cO0SgkgkYN70K9NilVGqXHqO6Hix6/39oc5LpL7NCWWPy24PL2Sn9I4Sl
         +mvw==
X-Gm-Message-State: APjAAAWM7+iEY+XTnpUT00vC60TtYsBIr507ePmqhu+ezmTiujN2beJV
        xuz19Q77RO/Tcnop9ARwVApZJbAQ6SmS+0IJJGo=
X-Google-Smtp-Source: APXvYqz3a4ETeSJ5fGaTDg5stUvGWjGnVZRnuL45qseQ2+wWXS+F973/E91acebkXk/T6RuR5NdcLVXrNcqB+TKtGQ8=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr23557464qtl.171.1582151207577;
 Wed, 19 Feb 2020 14:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20200219133012.7cb6ac9e@carbon> <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon> <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon> <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon> <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
In-Reply-To: <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Feb 2020 14:26:36 -0800
Message-ID: <CAEf4BzZgjJjGLzcrzMhTLU8ESSCSxdAHuDPd52aQU1zVKxqBzg@mail.gmail.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 1:59 PM Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
>
> Hello!
>
> On Wed, 19 Feb 2020 at 14:06, Jesper Dangaard Brouer <brouer@redhat.com> =
wrote:
> >
> > On Wed, 19 Feb 2020 10:38:45 -0800
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > On Wed, Feb 19, 2020 at 10:29 AM Jesper Dangaard Brouer
> > > <brouer@redhat.com> wrote:
> > > >
> > > > On Wed, 19 Feb 2020 09:38:50 -0800
> > > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > > On Wed, Feb 19, 2020 at 9:04 AM Jesper Dangaard Brouer
> > > > > <brouer@redhat.com> wrote:
> > > > > >
> > > > > > On Wed, 19 Feb 2020 08:41:27 -0800
> > > > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > > On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
> > > > > > > <brouer@redhat.com> wrote:
> > > > > > > >
> > > > > > > > I'm willing to help out, such that we can do either version=
 or feature
> > > > > > > > detection, to either skip compiling specific test programs =
or at least
> > > > > > > > give users a proper warning of they are using a too "old" L=
LVM version.
> > > > > > > ...
> > > > > > > > progs/test_core_reloc_bitfields_probed.c:47:13: error: use =
of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-dec=
laration]
> > > > > > > >         out->ub1 =3D BPF_CORE_READ_BITFIELD_PROBED(in, ub1)=
;
> > > > > > >
> > > > > > > imo this is proper warning message already.
> > > > > >
> > > > > > This is an error, not a warning.  The build breaks as the make =
process stops.
> > > > > >
> > > > >
> > > > > Latest Clang was a requirement for building and running all selft=
ests
> > > > > for a long time now. There were few previous discussions on maili=
ng
> > > > > list about this and each time the conclusion was the same: latest
> > > > > Clang is a requirement for BPF selftests.
> > > >
> > > > The latest Clang is 9.0.1, and it doesn't build with that.
> > >
> > > Latest as in "latest built from sources".
> >
> > When I download a specific kernel release, how can I know what LLVM
> > git-hash or version I need (to use BPF-selftests)?
> >
> > Do you think it is reasonable to require end-users to compile their own
> > bleeding edge version of LLVM, to use BPF-selftests?
> >
> > I do hope that some end-users of BPF-selftests will be CI-systems.
> > That also implies that CI-system maintainers need to constantly do
> > "latest built from sources" of LLVM git-tree to keep up.  Is that a
> > reasonable requirement when buying a CI-system in the cloud?
>
> We [1] are end users of kselftests and many other test suites [2]. We
> run all of our testing on every git-push on linux-stable-rc, mainline,
> and linux-next -- approximately 1 million tests per week. We have a
> dedicated engineering team looking after this CI infrastructure and
> test results, and as such, I can wholeheartedly echo Jesper's
> sentiment here: We would really like to help kernel maintainers and
> developers by automatically testing their code in real hardware, but
> the BPF kselftests are difficult to work with from a CI perspective.
> We have caught and reported [3] many [4] build [5] failures [6] in the
> past for libbpf/Perf, but building is just one of the pieces. We are
> unable to run the entire BPF kselftests because only a part of the
> code builds, so our testing is very limited there.
>
> We hope that this situation can be improved and that our and everyone
> else's automated testing can help you guys too. For this to work out,
> we need some help.

Is it hard to make sure that your CIs install latest builds of Clang,
though? See [0], Clang has even latest Clang 11 snapshots available
(though BPF selftests need only Clang 10 right now). In fact, libbpf's
Github repo just got a support for building latest kernel + building
latest selftests + running selftests in QEMU, performed for each PR
([1]), in Travis CI. Making selftests silently being not built/run if
Clang is too old will just hide problems without anyone noticing.

  [0] http://apt.llvm.org/
  [1] https://travis-ci.org/libbpf/libbpf/jobs/651838387?utm_medium=3Dnotif=
ication&utm_source=3Dgithub_status

>
> [1] https://lkft.linaro.org/
> [2] https://www.youtube.com/watch?v=3DR3H9fPhPf54&t=3D1m26s
> [3] https://lore.kernel.org/bpf/CA+G9fYtAQGwf=3DOoEvHwbJpitcfhpfhy-ar+6FR=
rWC_-ti7sUTg@mail.gmail.com/
> [4] https://lore.kernel.org/stable/CA+G9fYtxRoK6D1_oMf9zQj8MW0JtPdphDDO1N=
HcYQcoFNL5pjw@mail.gmail.com/
> [5] https://lore.kernel.org/bpf/CA+G9fYssgDcBkiNGSV7BmjE4Tj1j1_fa4VTJFv3N=
=3D2FHzewQLg@mail.gmail.com/
> [6] https://lore.kernel.org/bpf/CA+G9fYsK8zn3jqF=3DWz6=3D8BBx4i1JTkv2h-LC=
bjE11UJkcz_NEA@mail.gmail.com/
