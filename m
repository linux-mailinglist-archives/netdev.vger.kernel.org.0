Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA55165204
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBSV74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:59:56 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46491 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbgBSV74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:59:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id z26so1336401lfg.13
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ksLrbQyLmMpH3V/nWRjswdR5Z4MipnZDnDoXli6uZqA=;
        b=H9OYh3xP0O2Ia/lUTz5eZpeQeDHYpw2oKUlnCMcwT1fie/XSHCFh3UCE9HqysQ+Z/s
         ewTrWc5H7qgfmy3YXQ7t/7uYoPhnmNm0BuAxlE+ZkeWi8THyVCl8QbU787CmOMm5Sexd
         uH8a1Rk2DVKGGh4Sqe6bY/m96RygsFUSzR46DN8mvJ87oA0DW1J6PiUFt+rQvB/leC1h
         x8maa+5J7pFXqzSaDjt1QNdc4qbbwlQk7aDnjdrkgDHD5pucxEoBBNVUFwAKsBkeNPjs
         vni5HpMKiVmbaxUVUY72k0++kAggnbkm3cPMlc0BHJmabjwIj6MyDsFZUzQ7y6UUAfFG
         42OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ksLrbQyLmMpH3V/nWRjswdR5Z4MipnZDnDoXli6uZqA=;
        b=nMBr5GkssrEkmZvkKStzt/FJNEUnN55xvd6XFNyuZAp7L85iDYoSdu7rWiWD1eaHJa
         QvICOQwoV5Nm+Z/JLu1aUkMwJkT5+A6qmECVjYb3OyOBNmcqAOPa6kYaUlFLv3Xsh0UB
         0ErFYy7QAH2EuFzEZH0rT52QbqI7tEEBeTe+Bj1V1z2ZQGynICpB2a8JC4fpuItMRyE2
         +d4v+NKXw0RxliZuQ7gIqm1paMy0NhsYMNKrFHJdyWVr/kymRolN+jRd0MzcGZkf4uER
         eKtwkq4P3rxXeU243ncbcfon308D5xmVSpn64tTytD/49K6OS3behPb/zd6d2PNXGT4k
         iRsA==
X-Gm-Message-State: APjAAAXPPe1kN62XKeC6l4c9GVg/GbI2+JiKFy1hh6Yr5kaQOSS50Rd9
        e7aPysIxX9KPf5654txyCBGIaad6CxwVKQ2AWq0YkA==
X-Google-Smtp-Source: APXvYqxZRiyGI61+SK+fL2zjORehLhniKQSInFOoP5IFX6m3wHazgjgfKPz7GVi/MCLW4aPzw6G0yWW1RSX2Mc9ngWQ=
X-Received: by 2002:ac2:5f65:: with SMTP id c5mr13136448lfc.207.1582149593210;
 Wed, 19 Feb 2020 13:59:53 -0800 (PST)
MIME-Version: 1.0
References: <20200219133012.7cb6ac9e@carbon> <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon> <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon> <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
In-Reply-To: <20200219210609.20a097fb@carbon>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 19 Feb 2020 15:59:41 -0600
Message-ID: <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Wed, 19 Feb 2020 at 14:06, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Wed, 19 Feb 2020 10:38:45 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Feb 19, 2020 at 10:29 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Wed, 19 Feb 2020 09:38:50 -0800
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > On Wed, Feb 19, 2020 at 9:04 AM Jesper Dangaard Brouer
> > > > <brouer@redhat.com> wrote:
> > > > >
> > > > > On Wed, 19 Feb 2020 08:41:27 -0800
> > > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > > On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
> > > > > > <brouer@redhat.com> wrote:
> > > > > > >
> > > > > > > I'm willing to help out, such that we can do either version or feature
> > > > > > > detection, to either skip compiling specific test programs or at least
> > > > > > > give users a proper warning of they are using a too "old" LLVM version.
> > > > > > ...
> > > > > > > progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
> > > > > > >         out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);
> > > > > >
> > > > > > imo this is proper warning message already.
> > > > >
> > > > > This is an error, not a warning.  The build breaks as the make process stops.
> > > > >
> > > >
> > > > Latest Clang was a requirement for building and running all selftests
> > > > for a long time now. There were few previous discussions on mailing
> > > > list about this and each time the conclusion was the same: latest
> > > > Clang is a requirement for BPF selftests.
> > >
> > > The latest Clang is 9.0.1, and it doesn't build with that.
> >
> > Latest as in "latest built from sources".
>
> When I download a specific kernel release, how can I know what LLVM
> git-hash or version I need (to use BPF-selftests)?
>
> Do you think it is reasonable to require end-users to compile their own
> bleeding edge version of LLVM, to use BPF-selftests?
>
> I do hope that some end-users of BPF-selftests will be CI-systems.
> That also implies that CI-system maintainers need to constantly do
> "latest built from sources" of LLVM git-tree to keep up.  Is that a
> reasonable requirement when buying a CI-system in the cloud?

We [1] are end users of kselftests and many other test suites [2]. We
run all of our testing on every git-push on linux-stable-rc, mainline,
and linux-next -- approximately 1 million tests per week. We have a
dedicated engineering team looking after this CI infrastructure and
test results, and as such, I can wholeheartedly echo Jesper's
sentiment here: We would really like to help kernel maintainers and
developers by automatically testing their code in real hardware, but
the BPF kselftests are difficult to work with from a CI perspective.
We have caught and reported [3] many [4] build [5] failures [6] in the
past for libbpf/Perf, but building is just one of the pieces. We are
unable to run the entire BPF kselftests because only a part of the
code builds, so our testing is very limited there.

We hope that this situation can be improved and that our and everyone
else's automated testing can help you guys too. For this to work out,
we need some help.

[1] https://lkft.linaro.org/
[2] https://www.youtube.com/watch?v=R3H9fPhPf54&t=1m26s
[3] https://lore.kernel.org/bpf/CA+G9fYtAQGwf=OoEvHwbJpitcfhpfhy-ar+6FRrWC_-ti7sUTg@mail.gmail.com/
[4] https://lore.kernel.org/stable/CA+G9fYtxRoK6D1_oMf9zQj8MW0JtPdphDDO1NHcYQcoFNL5pjw@mail.gmail.com/
[5] https://lore.kernel.org/bpf/CA+G9fYssgDcBkiNGSV7BmjE4Tj1j1_fa4VTJFv3N=2FHzewQLg@mail.gmail.com/
[6] https://lore.kernel.org/bpf/CA+G9fYsK8zn3jqF=Wz6=8BBx4i1JTkv2h-LCbjE11UJkcz_NEA@mail.gmail.com/
