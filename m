Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460702761C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 08:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfEWGjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 02:39:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43744 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfEWGjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 02:39:01 -0400
Received: by mail-io1-f68.google.com with SMTP id v7so3939486iob.10;
        Wed, 22 May 2019 23:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cd4nIxL8cIdTtSfJ8zlgayG/NlTJsxYK4pUmR0DUFBM=;
        b=MW1eC6dZ2sztolccPFu+mxN1WXnWPfIVVnKOxypJW0LmbZkypJyOjCHECVKfzjdZAg
         77FcGNqb9ggMM90DzFuyy8ojHzYARaWEiIuzZmy83pViE3+wkZF3OczFtBw8yGLItk/n
         jNPPYNPm0oQwddfGCCdxDXyrkNwirrLeGsZm7yplsFzVUyEVYYC0s8f2GlCLsy6roBPb
         nfuLx8ytfJHW1JrRiODQiXchuUiMk6HOdNPSKAGDEyXhweO8W05qftBZTe3oKXNZ1LKo
         tVo+AWDmp568392vkaHWULbVTT4Xp9Sn4kkXDTG5r2t7upzQe/HPjlaGL237Leic4T2e
         7e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cd4nIxL8cIdTtSfJ8zlgayG/NlTJsxYK4pUmR0DUFBM=;
        b=dbB0PrHp+z2QbhPKwVgWOpMuarSuovBHBaPw5BCIiNpzlWchHrXOWzlP/oB4Uat5je
         daIh1DLESLxuA2kjvidID5Wk/B+y0FIKb94kxlJDGuDNLszfM0Vhir9TWKXSKR+g3i4m
         w0OB5JxffQwKMoa6NHf8n/3sWZ6/BxJLL2EpcyvmKg70nD3F6n3i6S4gECYVvde2bB+q
         ZMYS15ii64aizk9jdzxrtY2OdfVlncibJr9fwmXh22dFSSFoQAHAeF7deGiziktSHiN2
         GT49UMTK8zlqN9z9p18hAIiBRrdrHyrKXoA38V1ZkgyUY23qUGmfD1urTuOwI4g6kqSv
         6r1A==
X-Gm-Message-State: APjAAAXzmgsLNcBcDxlrJz2wOXb0w/nfQT1UOGeFKOkD/CjBR9/N624S
        1au56WPVuqXyM2jckCz6dKjVvBS6cEGfiPCnMFE=
X-Google-Smtp-Source: APXvYqyZny2pWBnwjK1nAWdAG8D9+sUGbvRCrOcW7wMjAJekYfqeQPkCovp6HpdibEkbvL9bxXOuonu8BvtwVFGSe0Y=
X-Received: by 2002:a05:6602:e:: with SMTP id b14mr3000473ioa.116.1558593540093;
 Wed, 22 May 2019 23:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190522092323.17435-1-bjorn.topel@gmail.com> <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
 <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com>
In-Reply-To: <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 22 May 2019 23:38:24 -0700
Message-ID: <CAH3MdRX6gocSFJCkuMuhko+0eheWqKq4Y4X-Tb3q=hzMW5buyw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 1:46 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Wed, 22 May 2019 at 20:13, Y Song <ys114321@gmail.com> wrote:
> >
> > On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmai=
l.com> wrote:
> > >
> > > Add three tests to test_verifier/basic_instr that make sure that the
> > > high 32-bits of the destination register is cleared after an ALU32
> > > and/or/xor.
> > >
> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> >
> > I think the patch intends for bpf-next, right? The patch itself looks
> > good to me.
> > Acked-by: Yonghong Song <yhs@fb.com>
> >
>
> Thank you. Actually, it was intended for the bpf tree, as a test
> follow up for this [1] fix.
Then maybe you want to add a Fixes tag and resubmit?
>
>
> Cheers,
> Bj=C3=B6rn
>
> [1] https://lore.kernel.org/bpf/CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m1n=
AYETJD+Vfg@mail.gmail.com/
>
> > > ---
> > >  .../selftests/bpf/verifier/basic_instr.c      | 39 +++++++++++++++++=
++
> > >  1 file changed, 39 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/verifier/basic_instr.c b/too=
ls/testing/selftests/bpf/verifier/basic_instr.c
> > > index ed91a7b9a456..4d844089938e 100644
> > > --- a/tools/testing/selftests/bpf/verifier/basic_instr.c
> > > +++ b/tools/testing/selftests/bpf/verifier/basic_instr.c
> > > @@ -132,3 +132,42 @@
> > >         .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > >         .result =3D ACCEPT,
> > >  },
> > > +{
> > > +       "and32 reg zero extend check",
> > > +       .insns =3D {
> > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > > +       BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
> > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > +       .result =3D ACCEPT,
> > > +       .retval =3D 0,
> > > +},
> > > +{
> > > +       "or32 reg zero extend check",
> > > +       .insns =3D {
> > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > > +       BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
> > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > +       .result =3D ACCEPT,
> > > +       .retval =3D 0,
> > > +},
> > > +{
> > > +       "xor32 reg zero extend check",
> > > +       .insns =3D {
> > > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > > +       BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
> > > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > > +       .result =3D ACCEPT,
> > > +       .retval =3D 0,
> > > +},
> > > --
> > > 2.20.1
> > >
