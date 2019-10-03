Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14104CAD4A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389364AbfJCRiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:38:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36309 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389289AbfJCRiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:38:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so4771264qtf.3;
        Thu, 03 Oct 2019 10:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v8XmbpBJ+gEOl64AXh0Pf5wUInfxzFXC/UuayhxnpMk=;
        b=rt5dCao8iPmw1012acsU1AIGQu5XI7yo1HPVSYHPXrSMOcd4OXUbPr2F8CgMZMT2Vr
         SnMhXp8KkKNNRd9s19tX150S3ane4rzcWnvJ8aWgD9sTgRUFBVvE/+AGljtYcB4/GX4m
         OW//ICaWEOqtwltNl1CV9RxQVoEQ7i2BPQ/6oU5fJHIu0ZciTQEY4zKFHDzDV27YM3v9
         i0PKmb8L+VMJM7iL+PrSc5SdP5wAcry9zrO73Az9jvdwM12dScIHvg96eI/uiNrnSiK8
         IygOtBQJChONiYYF+aPzda+mZorupmFfNulolHkSi6QpLdvbn8RINVwRJa7y2xvJGyRW
         T5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v8XmbpBJ+gEOl64AXh0Pf5wUInfxzFXC/UuayhxnpMk=;
        b=rACBuNocL7olThEFYr9sZI1L11a0niCppFAp5XzSCcSBRpwPG+KWQEyCKNlGWwIsIZ
         L/0gZ/FX7GddEcjG2ln0vlSFPWCdtm4euU9on3ugkjBdGoVgD/FHkXgAVbbdjdmkKwUe
         97j/3wPO9BoPU64snNY0gtLzpB4z7UNna9QmEpofRiZ12HFdh0AzXUPYSPxewzfSKXYk
         +QuP35vuxd8UAgJFujGhTe9eQhtSK4LA1czMC6ePyt/oYmW9sojPylBAGDfkLffT7+uD
         3vEt0gG/yAIyfhhQs6zkk53gAWl2FOW/jcxvHIxoYLHKQh+9MK2LHdJ7jYi9zDfn8XjK
         u4HQ==
X-Gm-Message-State: APjAAAX00mXxMJkJy80R9ulYkhWBSKDlTTFthlcSioGludriCfuS5aXi
        seKpdn6/a/WnWd8gZTHo89j+7LVI3dZIfkhmA4c=
X-Google-Smtp-Source: APXvYqys6FXV9SDmyMY1yhxPBTgUjw4e+dhiseP2HSsqO9/a/3VQxdSlt7+Lj/R/ECIo3B0/D/LRtEor6+F5b2EUnFQ=
X-Received: by 2002:a05:6214:2e4:: with SMTP id h4mr9656529qvu.127.1570124283426;
 Thu, 03 Oct 2019 10:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
 <20191002231448.GA10649@khorivan> <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
 <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com>
 <CAJ+HfNhx+gQmRMb18UDRrmzciDYUbdezUh9bRhWG8_HTUCLk9w@mail.gmail.com> <CAEf4BzbZxa3iGZEWB03rdL+7ErmhdpB0e3aeOQvbLPu0o8XFqw@mail.gmail.com>
In-Reply-To: <CAEf4BzbZxa3iGZEWB03rdL+7ErmhdpB0e3aeOQvbLPu0o8XFqw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 3 Oct 2019 19:37:51 +0200
Message-ID: <CAJ+HfNi1cTvCxcgjU4r03eJt_mc7L4Zwn7vfgWHAPWyjH0q4Bw@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
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

On Thu, 3 Oct 2019 at 19:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wr=
ote:
>
> On Thu, Oct 3, 2019 at 3:52 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> >
> > On Thu, 3 Oct 2019 at 12:37, Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> > >
> > > On Thu, Oct 3, 2019 at 3:28 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gma=
il.com> wrote:
> > > >
> > > > On Thu, 3 Oct 2019 at 01:14, Ivan Khoronzhuk <ivan.khoronzhuk@linar=
o.org> wrote:
> > > > >
> > > > > On Wed, Oct 02, 2019 at 09:41:15AM +0200, Bj=C3=B6rn T=C3=B6pel w=
rote:
> > > > > >On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
> > > > > ><yamada.masahiro@socionext.com> wrote:
> > > > > >>
> > > > > >[...]
> > > > > >> > Yes, the BPF samples require clang/LLVM with BPF support to =
build. Any
> > > > > >> > suggestion on a good way to address this (missing tools), be=
tter than
> > > > > >> > the warning above? After the commit 394053f4a4b3 ("kbuild: m=
ake single
> > > > > >> > targets work more correctly"), it's no longer possible to bu=
ild
> > > > > >> > samples/bpf without support in the samples/Makefile.
> > > > > >>
> > > > > >>
> > > > > >> You can with
> > > > > >>
> > > > > >> "make M=3Dsamples/bpf"
> > > > > >>
> > > > > >
> > > > > >Oh, I didn't know that. Does M=3D support "output" builds (O=3D)=
?
> > >
> > > No.
> > > O=3D points to the output directory of vmlinux,
> > > not of the external module.
> > >
> > > You cannot put the build artifacts from samples/bpf/
> > > in a separate directory.
> > >
> >
> > Hmm, I can't even get "make M=3Dsamples/bpf/" to build. Am I missing
> > something obvious?
>
> There were 3 or 4 separate fixes submitted for samples/bpf yesterday,
> maybe you are hitting some of those issues. Try to pull latest (not
> sure if bpf or bpf-next tree). I tried make M=3Dsamples/bpf and it
> worked for me.
>

Yeah, it was PEBKAC. "make M=3Dsamples/bpf" works if you have a proper
.config + "make prepare" ;-)

I guess I need to change my workflow. I build all my kernels "O=3D", and
did so with samples/bpf as well. Everything ended up in the same
output directory. Now I need to have all this build output in source
tree, and need to manage the .config files in where the source is at.
Oh well... I'll stop complaining now. :-)

Thanks,
Bj=C3=B6rn

> >
> > Prior 394053f4a4b3 "make samples/bpf/" and "make O=3D/foo/bar
> > samples/bpf/" worked, but I guess I can live with that...
> >
> >
> > Thanks!
> > Bj=C3=B6rn
> >
> >
> > >
> > >
> > > > > >I usually just build samples/bpf/ with:
> > > > > >
> > > > > >  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/
> > > > > >
> > > > > >
> > > > > >Bj=C3=B6rn
> > > > >
> > > > > Shouldn't README be updated?
> > > > >
> > > >
> > > > Hmm, the M=3D variant doesn't work at all for me. The build is stil=
l
> > > > broken for me. Maybe I'm missing anything obvious...
> > > >
> > > >
> > > > > --
> > > > > Regards,
> > > > > Ivan Khoronzhuk
> > >
> > >
> > >
> > > --
> > > Best Regards
> > > Masahiro Yamada
