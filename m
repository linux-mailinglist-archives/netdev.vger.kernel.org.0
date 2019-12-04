Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C171122A2
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 06:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfLDFwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 00:52:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38466 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfLDFwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 00:52:25 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so5074232lfm.5;
        Tue, 03 Dec 2019 21:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nzbDYaqYcFJ64Z60Mv6NcLPPMn+RWAQ/vTfwfbpf8UM=;
        b=RanmOx1fbrh/niQDf8eEp6XpWFsE8t6H2dRZhxA+ByP/6AKoTCz+pAgeswWb14vmW9
         XUBinc2AdNVUAN5h0YnDkUv1UFWndLC99RYa1ZKCRbSwaDsIQIti1KbV61ZLi1OsTHEb
         AgmMXG//SUcCqzw6fBbSk7ovUPY7M8TQu5HJb7+KlFRV1W+Xrw+P02UeqB4SUwFhwA2x
         XsB4TKlaXJGZ5PmRe5t5FkSVRKHGOE4w6YXe8FINPFJB4q6J8PNSa5px1uYIduZdcthX
         0QkABRoz6wl/cnKJ1OTClpQrMKkYYmpB5GTvitBR5gtgc2JMV4Hq1up4ZhXj2qd1ERbh
         +d8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nzbDYaqYcFJ64Z60Mv6NcLPPMn+RWAQ/vTfwfbpf8UM=;
        b=iEKN+ThH/WGnbtz2zxR0ZtnnAafQowU7dnDEaEz/H2grkvIWOTqaAjhJzAUgbuPm8T
         U4sGFYZeXAbVTIVtq5+w2iS45QsEOeKpSB7uBHnM08uP3+TBS2LKyKdcAfVpS4yqw6cN
         ZtrRDDHUi05ScL8KQcG6G5+v6AQS4hfYFamCNFWmbB+mqOjsC9iuf/Q2yQRo0Ez9fxuz
         xOxS0hRp29vpFJ16zH5RCZQq4hBqYmw2FUKInUAtjlkfGFiVhFoRWYKozZCY71pmpi1N
         SAPNpOy29dsFHfE1U21TPGFqQzAZ113SzP9Rq5Wch3RnPHXlQbGpYLv/iYDVwBp3hVum
         GVkg==
X-Gm-Message-State: APjAAAX85Jva4ROo2ygkYPtWQEPkPVBk2PAcpVBjAYrs7W99KHHoTHIf
        HZBNluHstUXk/pQ6noHtQPzbQgwUMVov0HiGzy0=
X-Google-Smtp-Source: APXvYqxUV1VzjISq9pBDyL917A+0YWgy6WfDZ55v0BKyRopOIgWIDEKFAyvUryo082rae4zUOK78S7pACe4CB1qsQ9k=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr913547lfp.162.1575438742853;
 Tue, 03 Dec 2019 21:52:22 -0800 (PST)
MIME-Version: 1.0
References: <20191202131847.30837-1-jolsa@kernel.org> <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
In-Reply-To: <87wobepgy0.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Dec 2019 21:52:11 -0800
Message-ID: <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
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

On Mon, Dec 2, 2019 at 1:15 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Ah, that is my mistake: I was getting dynamic libbpf symbols with this
> approach, but that was because I had the version of libbpf.so in my
> $LIBDIR that had the patch to expose the netlink APIs as versioned
> symbols; so it was just pulling in everything from the shared library.
>
> So what I was going for was exactly what you described above; but it
> seems that doesn't actually work. Too bad, and sorry for wasting your
> time on this :/

bpftool is currently tightly coupled with libbpf and very likely
in the future the dependency will be even tighter.
In that sense bpftool is an extension of libbpf and libbpf is an extension
of bpftool.
Andrii is working on set of patches to generate user space .c code
from bpf program.
bpftool will be generating the code that is specific for the version
bpftool and for
the version of libbpf. There will be compatibility layers as usual.
But in general the situation where a bug in libbpf is so criticial
that bpftool needs to repackaged is imo less likely than a bug in
bpftool that will require re-packaging of libbpf.
bpftool is quite special. It's not a typical user of libbpf.
The other way around is more correct. libbpf is a user of the code
that bpftool generates and both depend on each other.
perf on the other side is what typical user space app that uses
libbpf will look like.
I think keeping bpftool in the kernel while packaging libbpf
out of github was an oversight.
I think we need to mirror bpftool into github/libbpf as well
and make sure they stay together. The version of libbpf =3D=3D version of b=
pftool.
Both should come from the same package and so on.
May be they can be two different packages but
upgrading one should trigger upgrade of another and vice versa.
I think one package would be easier though.
Thoughts?
