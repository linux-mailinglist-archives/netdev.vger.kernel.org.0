Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EAF178E4C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387719AbgCDKWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:22:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37773 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgCDKWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:22:00 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so783242pgl.4;
        Wed, 04 Mar 2020 02:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I473f1xOp0xcoMWJcjpZgjb3E6lfpmms9lzoIFvnCxw=;
        b=oBPRt+y4oU6gnbNSeAk4XBIEVcAjxjMq228H+/Kf1FVzxqZPtbXDx2lA2jlKcj/biY
         fG/RGMGcmrEFCg9dDC7ty3/HE0WtyL19YMCDaBKexJvIsCgBtG6nDkvJMeA0UcAa4Yat
         mlT8AjN/Ihe6sSztMgQILbSACeIXn0r4gKZbjjQxtn4uKXukNLwGp2cIHOB4tQMWi1O8
         /q5EcQTNJfhWWrmLgM+tfHSDgF1zxInkynQDfYwyiI+Jfuv7S9MpK/hMrxKPsooH7ES9
         l9OR5F3KSOAuQxuGccvg9gZxHVJspJxKWvjARF6aTmNR/nHxtUUSX8a1rY+uIlnzblVe
         cqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I473f1xOp0xcoMWJcjpZgjb3E6lfpmms9lzoIFvnCxw=;
        b=fUEtRry1qYUgZs85mLdAYrvubdHB0IIn8QzYg6dpNBUwUbrJmUToB4ZyO71YBwrRN+
         XPssowdYO8Wg9JX8Yev3O+bVpNWg/1QUUsNcZND1Utj0PuLg49KEQHCZd03DnuLaQH5E
         92+Jd1KpPkd86oK+6SqBZKNUNCIe6ooze3IBItGCFAZENHKq65U95wRtogm8JBDXS7tj
         9Rm/JePM06TJKwHVsf94ZRpR2AGpQ7AFSGyMwxtb3h3CbGBx181h2IAqQA2Al97TBWFR
         Hsu3/oH25ZnH029TCkRHPk02aZtyQbBPRyuhY67RKwm0Jae89HtTHZwKP2tDXueEDFF+
         kn7g==
X-Gm-Message-State: ANhLgQ3ehtei3+V3io1rU/JTr74OGF9mouixGPBE+iFDv+3nnXm3XAg+
        vMsvdI8QwnC9QdGakd3Z7tKeBiWC5d0WfDELtSM=
X-Google-Smtp-Source: ADFU+vsSfrM9BQwFeyP+XfNzdF7yaI72ARkLmWTSOk+5nI1rJvvwH2iEy8/o/nVhEv9EKoIYE2/Tn2seuagHTt0BorI=
X-Received: by 2002:a63:1246:: with SMTP id 6mr1947203pgs.4.1583317319277;
 Wed, 04 Mar 2020 02:21:59 -0800 (PST)
MIME-Version: 1.0
References: <20200303005035.13814-1-luke.r.nels@gmail.com> <20200303005035.13814-5-luke.r.nels@gmail.com>
 <20200303100228.GJ1224808@smile.fi.intel.com> <CADasFoCq7S2KRYg+ghAKt1e+hELzEMJaNH74sGdjM7E=z3KcnQ@mail.gmail.com>
In-Reply-To: <CADasFoCq7S2KRYg+ghAKt1e+hELzEMJaNH74sGdjM7E=z3KcnQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 4 Mar 2020 12:21:51 +0200
Message-ID: <CAHp75VezOTk4kURAkS6OQqPjdiYsPE292ix+WHAPvs8vGpCfGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/4] MAINTAINERS: Add entry for RV32G BPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 4:34 AM Luke Nelson <lukenels@cs.washington.edu> wro=
te:
> On Tue, Mar 3, 2020 at 2:02 AM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > > -BPF JIT for RISC-V (RV64G)
> > > +BPF JIT for 32-bit RISC-V (RV32G)
> > > +M:   Luke Nelson <luke.r.nels@gmail.com>
> > > +M:   Xi Wang <xi.wang@gmail.com>
> > > +L:   bpf@vger.kernel.org
> > > +S:   Maintained
> > > +F:   arch/riscv/net/
> > > +X:   arch/riscv/net/bpf_jit_comp.c
> > > +
> > > +BPF JIT for 64-bit RISC-V (RV64G)
> > >  M:   Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > > -L:   netdev@vger.kernel.org
> > > +L:   bpf@vger.kernel.org
> > >  S:   Maintained
> > >  F:   arch/riscv/net/
> > > +X:   arch/riscv/net/bpf_jit_comp32.c
> >
> > Obviously this breaks an order. Please, fix.
> > Hint: run parse-maintainers.pl after the change.

> Thanks for the comment!
>
> I'll change the entry names in v5 to be "BPF JIT for RISC-V (32-bit)"
> and "BPF JIT for RISC-V (64-bit)", similar to the x86 JIT entries.
> This will pass parse-maintainers.pl and the entries are still in
> order.

Thank you!

--=20
With Best Regards,
Andy Shevchenko
