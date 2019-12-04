Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73AE1130F3
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfLDRkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:40:13 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37786 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:40:13 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so244480lfc.4;
        Wed, 04 Dec 2019 09:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oHB3In8TJ1BoCV3yfap7FG1+zu7GC+PatNJi/jkJ27I=;
        b=hbu9w8wL5kU21nC4Jlndxk45Zim9mXAingOu5sCV6Bz8G5uoLAWrDCbTkJkWEVs7rI
         vX0qoW9oDhTHObJPHKvWMOyZqDRF2kyYcIyENI/1UnPtdE1kZ071fSoXDg8AD611hMTT
         n+vqleKxuST2C98p+/minoqhQliHmuoY0Z2slwtJA8zA4W3E/MGmT1tbrsKCp2U1s9L2
         mE7UkOyhi+sOSKVGalPNq2xw2uQNlCHIwk3IWYVICfSvd4TZcXFWtobRgDT7FP/zL/rs
         kOiEygnrod05ifzqQn4Ec6EBbLUfKHVsEcyHtj5cip60SjIsTV6/CSQZhRZXYq+Y/UFm
         iO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oHB3In8TJ1BoCV3yfap7FG1+zu7GC+PatNJi/jkJ27I=;
        b=Q36g5P5YCCE/Gyy/mjM96+awojrhUWGjidpS65xESBazkHL5Uc/mFfKheDf5dEGCyv
         8hx05eUL3djQgjDzluigMCFdtOU1ivxTo361HTppdHFxHSXhRMS7YWxK8hVU5fduVeBU
         D+wZE/gb/7pC7wdEzgp1mrtlUK5SOMauqD/qxVp/irPutQ1VpRYtC3FzNhl5Lo8qEG3D
         trMivjk289R0Q9Ux6JeRCm0aQa8kZ8lodhNGw93CmiROfri6riwPF/l+VoJyYv6SLinX
         05WIqNE7YTYnXsmvbZHrlA9f3OsVJX5uPSyqZyhGogBudoDSgVEYZINL6s2qnZYAgxEx
         ZEsg==
X-Gm-Message-State: APjAAAXPpopVGQZGcfmLakDLUm5VXenh52rsIWgvFhM4fTW4RpS81QbP
        m6or+7xE1UgFFumEXiTqfWCqgea5cDOVuR72Hho=
X-Google-Smtp-Source: APXvYqyPEupUr7tGIzShjf7qHeDrPAasDt0WdGU+LboeMyuNSjbt7jEx6hQU6c+7Rz9evygBa/WupWihLONa8TAWcSM=
X-Received: by 2002:ac2:5237:: with SMTP id i23mr1937122lfl.100.1575481210398;
 Wed, 04 Dec 2019 09:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk> <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <877e3cpdc9.fsf@toke.dk>
In-Reply-To: <877e3cpdc9.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Dec 2019 09:39:59 -0800
Message-ID: <CAADnVQJeC9FQDXhv34KTiFSRq-=x4cBaspj-bTXdQ1=7prphcA@mail.gmail.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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

On Wed, Dec 4, 2019 at 2:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Dec 2, 2019 at 1:15 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Ah, that is my mistake: I was getting dynamic libbpf symbols with this
> >> approach, but that was because I had the version of libbpf.so in my
> >> $LIBDIR that had the patch to expose the netlink APIs as versioned
> >> symbols; so it was just pulling in everything from the shared library.
> >>
> >> So what I was going for was exactly what you described above; but it
> >> seems that doesn't actually work. Too bad, and sorry for wasting your
> >> time on this :/
> >
> > bpftool is currently tightly coupled with libbpf and very likely
> > in the future the dependency will be even tighter.
> > In that sense bpftool is an extension of libbpf and libbpf is an extens=
ion
> > of bpftool.
> > Andrii is working on set of patches to generate user space .c code
> > from bpf program.
> > bpftool will be generating the code that is specific for the version
> > bpftool and for
> > the version of libbpf. There will be compatibility layers as usual.
> > But in general the situation where a bug in libbpf is so criticial
> > that bpftool needs to repackaged is imo less likely than a bug in
> > bpftool that will require re-packaging of libbpf.
> > bpftool is quite special. It's not a typical user of libbpf.
> > The other way around is more correct. libbpf is a user of the code
> > that bpftool generates and both depend on each other.
> > perf on the other side is what typical user space app that uses
> > libbpf will look like.
> > I think keeping bpftool in the kernel while packaging libbpf
> > out of github was an oversight.
> > I think we need to mirror bpftool into github/libbpf as well
> > and make sure they stay together. The version of libbpf =3D=3D version =
of bpftool.
> > Both should come from the same package and so on.
> > May be they can be two different packages but
> > upgrading one should trigger upgrade of another and vice versa.
> > I think one package would be easier though.
> > Thoughts?
>
> Yup, making bpftool explicitly the "libbpf command line interface" makes
> sense and would help clarify the relationship between the two. As Jiri
> said, we are already moving in that direction packaging-wise...

Awesome. Let's figure out the logistics.
Should we do:
git mv tools/bpf/bpftool/ tools/lib/bpf/
and appropriate adjustment to Makefiles ?
or keep it where it is and only add to
https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh ?
