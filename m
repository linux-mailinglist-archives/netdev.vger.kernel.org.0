Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E45A10EF6E
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfLBSnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:43:06 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41755 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfLBSnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:43:06 -0500
Received: by mail-qt1-f193.google.com with SMTP id v2so774357qtv.8;
        Mon, 02 Dec 2019 10:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AnWD7sTCrH/sWowo7WOFM1CDDX20u+B+tWaH0Jnqtwk=;
        b=C/H55AzQsVIXNNR37eV61Ui6BsPj6qxnpiS4smZk4LFHMtNhrnyr4UBxDT8noF/KRi
         4FWHgATpEt1TvCf+lA8lvfY7OZm7F93zKsCIcy5uKJ6L4wMs6QEDoDJMzV0a7hfMLmsG
         uMbfEvCj/Ftyb4upOkqE/8UU7cXyEfRYhb6UOHa4lMXuwaKMUW7ChhwTK2x/DdX4MKN0
         UDvxtFJHv/Wdy9XNDXAwafvbvag8Az7r1dcwvItwXpCf/aSM22J85zLdlkaIt9QZL9oV
         JnCyScixf2nZbms22YbVdS3xs+24xjJcdlqaPaPbXzMXN4Qr0r7TcYeg/8jRUb0+bRzL
         JNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AnWD7sTCrH/sWowo7WOFM1CDDX20u+B+tWaH0Jnqtwk=;
        b=n0VUocufSNV0ecBx/O8vqrAiUfXWBy5e1pho+Jm2FsXWT4HNwWonQYpys83jhzZ6Pm
         ehQyNIn4z5/jjLFfVP16bq/MMpIeu6K0rnkvkUFeOukKWqE/b91LeILlXZPLiY2r+Nd0
         bXIJzrdc61gj3/COPhGAQpIrNzcGld0JfNtSihPBlCg1oiYU8uFyuYI/E5EwaeBBcmyV
         U2TGMt1vSnbiuDvvoCUybkQzjlFmsEutzVZ84xHUDrw54H7I0SxGdVbemreLha/uPJJm
         omaaI1LAAMU/IDNy5xWMwiFnSolpjEdLj1wrWKaWebNTQmmKYkD7NGnysVZZINh8e1k2
         vzcg==
X-Gm-Message-State: APjAAAUfu2pIYTfsIdwVKstNRMvv1DK+2ae1OQF8gdkXrtwV7AjjqGuj
        EfRr77fEm8Fwa7iDNxXITbE6ZHl0iTwotlzIvBA=
X-Google-Smtp-Source: APXvYqwIgwsCAJeW/GmVHa9v0gX68uVrUsI9VUspc7LOGfwihg3b/Uvp8JTHV9/ke+jwXgb2EQ+fGHCGnVhYxRtGJLo=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr835578qtj.59.1575312184786;
 Mon, 02 Dec 2019 10:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org> <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
 <87zhgappl7.fsf@toke.dk>
In-Reply-To: <87zhgappl7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 10:42:53 -0800
Message-ID: <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
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
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 10:09 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >>
> >> hi,
> >> adding support to link bpftool with libbpf dynamically,
> >> and config change for perf.
> >>
> >> It's now possible to use:
> >>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
> >
> > I wonder what's the motivation behind these changes, though? Why is
> > linking bpftool dynamically with libbpf is necessary and important?
> > They are both developed tightly within kernel repo, so I fail to see
> > what are the huge advantages one can get from linking them
> > dynamically.
>
> Well, all the regular reasons for using dynamic linking (memory usage,
> binary size, etc).

bpftool is 327KB with statically linked libbpf. Hardly a huge problem
for either binary size or memory usage. CPU instruction cache usage is
also hardly a concern for bpftool specifically.

> But in particular, the ability to update the libbpf
> package if there's a serious bug, and have that be picked up by all
> utilities making use of it.

I agree, and that works only for utilities linking with libbpf
dynamically. For tools that build statically, you'd have to update
tools anyways. And if you can update libbpf, you can as well update
bpftool at the same time, so I don't think linking bpftool statically
with libbpf causes any new problems.

> No reason why bpftool should be special in that respect.

But I think bpftool is special and we actually want it to be special
and tightly coupled to libbpf with sometimes very intimate knowledge
of libbpf and access to "hidden" APIs. That allows us to experiment
with new stuff that requires use of bpftool (e.g., code generation for
BPF programs), without having to expose and seal public APIs. And I
don't think it's a problem from the point of code maintenance, because
both live in the same repository and are updated "atomically" when new
features are added or changed.

Beyond superficial binary size worries, I don't see any good reason
why we should add more complexity and variables to libbpf and bpftool
build processes just to have a "nice to have" option of linking
bpftool dynamically with libbpf.


>
> -Toke
>
