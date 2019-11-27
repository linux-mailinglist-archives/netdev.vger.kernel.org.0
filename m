Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E588D10B763
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfK0UYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:24:32 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33253 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfK0UYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:24:31 -0500
Received: by mail-qk1-f193.google.com with SMTP id c124so16321692qkg.0;
        Wed, 27 Nov 2019 12:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SgUjfcTX/7GXiJyA43XWcDT1cnpp+UReYglDGXWdON0=;
        b=ry4rBZW57I0rDcZPHlpUxh07oaqemIldRXSpEpydrz1a8HsqWcYY3RDBzAfxHIE0li
         tcjDwokDv7Hkc+QS8z/+oFDxLi+xJOySIZCDAKNnvJUtwg4jO5TM7+Ryv02mpVtdcU9m
         cI4h+TQ7kZrSClQ+sFeMZ4iLyPDnoddczRTeWVKHAUNOIirnVO65605Fc9g91jLqrdgZ
         ewlII6VuCVDJbelP/tmPSC8Cn5L7Y/u+JiA6+9h1g9KYsZ8j1NoW2xxG9309BNMgVQjp
         YK9wWhGms9yLP0FOEVVlkGikR2tzyf+u94ZQEYmx6W26aaPpZEWgYfvwFL8EzfC5k5JV
         oV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SgUjfcTX/7GXiJyA43XWcDT1cnpp+UReYglDGXWdON0=;
        b=ISna9d7ygYhX69i1+DK5WMRNV5h9iTYfIUjaeaVSnxF+/3woYnPpICenk4cFIv5TBS
         1fq+Lb43W1WEQJ/p+W0l6S7syivtYNVoD1tekRaK47whP6wSG2eN7HtnCym7n/zj1Gh6
         mFDqKfBUsDuZg4A4b1iW/fz/ThjiXvc+bvTd7hfOG3/bMxkk2Xh1XLrno+L3x1JzKSfL
         HqjDGcwGZphJ7IXj3Et31QpBxgqXVQkGcXLii6Zx+NVItewLnbFoUF1Xo3rvjF5Yiipe
         zp+h4cqFhdrC0b3aVoLIiNILvx5jgZ2N00VXVg6Y40mcTRfB0joeyQIfmHYrgJGMZ6N+
         6k+g==
X-Gm-Message-State: APjAAAURE0wcGeyDN7eG0oszG8ifuTZ0ehUzCRdsCDkqDiVcsqpNkHgA
        Dxjw+G0oz4XudYQse4ZGNQ7E/foKtpqPUXEoGZA=
X-Google-Smtp-Source: APXvYqzQ3j5bso0l8WXxfmVDikzFct/L8BmxkhKEItQRWdWLvVEkAIp77SzQbhi7jl/QGFbYaLlAkssUVwfkaIlONCc=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr6519127qki.437.1574886270399;
 Wed, 27 Nov 2019 12:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org> <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
In-Reply-To: <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Nov 2019 12:24:19 -0800
Message-ID: <CAEf4BzaDxnF0Ppfo5r5ma3ht033bWjQ78oiBzB=F40_Np=AKhw@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 8:38 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > adding support to link bpftool with libbpf dynamically,
> > and config change for perf.
> >
> > It's now possible to use:
> >   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1
> >
> > which will detect libbpf devel package with needed version,
> > and if found, link it with bpftool.
> >
> > It's possible to use arbitrary installed libbpf:
> >   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
> >
> > I based this change on top of Arnaldo's perf/core, because
> > it contains libbpf feature detection code as dependency.
> > It's now also synced with latest bpf-next, so Toke's change
> > applies correctly.
>
> I don't like it.
> Especially Toke's patch to expose netlink as public and stable libbpf api.
> bpftools needs to stay tightly coupled with libbpf (and statically
> linked for that reason).
> Otherwise libbpf will grow a ton of public api that would have to be stable
> and will quickly become a burden.

I second that. I'm currently working on adding few more APIs that I'd
like to keep unstable for a while, until we have enough real-world
usage (and feedback) accumulated, before we stabilize them. With
LIBBPF_API and a promise of stable API, we are going to over-stress
and over-design APIs, potentially making them either too generic and
bloated, or too limited (and thus become deprecated almost at
inception time). I'd like to take that pressure off for a super-new
and in flux APIs and not hamper the progress.

I'm thinking of splitting off those non-stable, sort-of-internal APIs
into separate libbpf-experimental.h (or whatever name makes sense),
and let those be used only by tools like bpftool, which are only ever
statically link against libbpf and are ok with occasional changes to
those APIs (which we'll obviously fix in bpftool as well). Pahole
seems like another candidate that fits this bill and we might expose
some stuff early on to it, if it provides tangible benefits (e.g., BTF
dedup speeds ups, etc).

Then as APIs mature, we might decide to move them into libbpf.h with
LIBBPF_API slapped onto them. Any objections?
