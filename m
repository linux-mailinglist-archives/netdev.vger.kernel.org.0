Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C541136F3
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 22:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLDVQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 16:16:26 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40221 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfLDVQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 16:16:26 -0500
Received: by mail-qk1-f195.google.com with SMTP id a137so1364627qkc.7;
        Wed, 04 Dec 2019 13:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qWxHlyMaMWXIw2do8zu3nxMsa0ahGnGnhYvLjpZOGZs=;
        b=ECc62Mdu8Al3A5i2QIZsoJshjwx4ogtIK+I7b7cPOlRBCeNMAQOsnLsfcweLZCSuNZ
         tO741m2v9mwXZ9pd+lXAzGrH1ETJYT7Z0CYrRuZecfNAEb9AlrGLY6wt1zCzrga/Z97y
         c8QFnTh/RZmeEU4KeJCC94kNH97JWteYDQy+jgmXFX7a+ULDqSqIPfsmpvTmVMhPkJOG
         Y6jWQCerxyfF/wAH2hC8QZnmyHCKuLgWMEX4FhYYePYXdSswX/EO9f44CGP5kzQ7KyBF
         N4dvUlz1JytTWt2W9StLVdKrMMQdX3e83NFJ/TlXP553/IhPq9h5DCaJBxoMdXcdwiOe
         p+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qWxHlyMaMWXIw2do8zu3nxMsa0ahGnGnhYvLjpZOGZs=;
        b=Ybk/uMumcHok4HY88vetf2CtJsoGF60x+kg9qdTo1Y1YrdPyEspUSGAM05gQcqEdKt
         5aXp1CiRqzfKlidVfNG6hf/ydh+wOuWwtUbGwbJe2GmDU4RLsM4weMe2jzhh9sMd1Xf5
         95Fyyk/tpDoqQY1I9yytM46CKP0q3KxJsb6y3G1xMU0eAzxAnYVo++8lqXkfJnwFFAqh
         PbYl5p8GoKI+Oa2Su/d86Eq9L0SMJyVdGZGLhw4jxBKHW8YDWRZ1YpXfHQLm/QQCeVkf
         TOuVkgncRAFMvU2wulobGuRj/m1le1Yp3YVAAefl5YnOxp4NZatm27kI/Psmhky6jRpR
         ipmg==
X-Gm-Message-State: APjAAAXhhdjnd8UBiodHogarZPwOzPA41aTt3L6MZkWrNCGwSguWDjYx
        2bbhHDCCNZ4+xfppX68VeJ1utrkSm3sbqSWNLsA=
X-Google-Smtp-Source: APXvYqyMZB9pJRKXHa2KpH3q6kC3yN+427hwbFU3jkfDG9CrDmxCNW+uuCaMmX3RL467WYMCvnAu4hpCyiAahmz/FJg=
X-Received: by 2002:a37:6285:: with SMTP id w127mr5304028qkb.437.1575494184923;
 Wed, 04 Dec 2019 13:16:24 -0800 (PST)
MIME-Version: 1.0
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk> <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
In-Reply-To: <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Dec 2019 13:16:13 -0800
Message-ID: <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 9:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Dec 2, 2019 at 1:15 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > Ah, that is my mistake: I was getting dynamic libbpf symbols with this
> > approach, but that was because I had the version of libbpf.so in my
> > $LIBDIR that had the patch to expose the netlink APIs as versioned
> > symbols; so it was just pulling in everything from the shared library.
> >
> > So what I was going for was exactly what you described above; but it
> > seems that doesn't actually work. Too bad, and sorry for wasting your
> > time on this :/
>
> bpftool is currently tightly coupled with libbpf and very likely
> in the future the dependency will be even tighter.
> In that sense bpftool is an extension of libbpf and libbpf is an extensio=
n
> of bpftool.
> Andrii is working on set of patches to generate user space .c code
> from bpf program.
> bpftool will be generating the code that is specific for the version
> bpftool and for
> the version of libbpf. There will be compatibility layers as usual.
> But in general the situation where a bug in libbpf is so criticial
> that bpftool needs to repackaged is imo less likely than a bug in
> bpftool that will require re-packaging of libbpf.
> bpftool is quite special. It's not a typical user of libbpf.
> The other way around is more correct. libbpf is a user of the code
> that bpftool generates and both depend on each other.
> perf on the other side is what typical user space app that uses
> libbpf will look like.
> I think keeping bpftool in the kernel while packaging libbpf
> out of github was an oversight.

I wonder what big advantage having bpftool in libbpf's Github repo
brings, actually? The reason we need libbpf on github is to allow
other projects like pahole to be able to use libbpf from submodule.
There is no such need for bpftool.

I agree about preference to release them in sync, but that could be
easily done by releasing based on corresponding commits in github's
libbpf repo and kernel repo. bpftool doesn't have to physically live
next to libbpf on Github, does it?

Calling github repo a "mirror" is incorrect. It's not a 1:1 copy of
files. We have a completely separate Makefile for libbpf, and we have
a bunch of stuff we had to re-implement to detach libbpf code from
kernel's non-UAPI headers. Doing this for bpftool as well seems like
just more maintenance. Keeping github's Makefile in sync with kernel's
Makefile (for libbpf) is PITA, I'd rather avoid similar pains for
bpftool without a really good reason.

> I think we need to mirror bpftool into github/libbpf as well
> and make sure they stay together. The version of libbpf =3D=3D version of=
 bpftool.
> Both should come from the same package and so on.
> May be they can be two different packages but
> upgrading one should trigger upgrade of another and vice versa.
> I think one package would be easier though.
> Thoughts?
