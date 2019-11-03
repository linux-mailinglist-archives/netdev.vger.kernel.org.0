Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C686ED2C8
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 10:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfKCJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 04:57:41 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35869 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfKCJ5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 04:57:40 -0500
Received: by mail-ua1-f65.google.com with SMTP id z9so368376uan.3;
        Sun, 03 Nov 2019 01:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g+QlAwAK6bQlh/cWTEgPR/8pCDAU7kFbrkVp1jUM3t0=;
        b=Q3BZfEUAItgE8ZRK+nJxI8uENSpOYRJkKIl99+p3hcpNFrqEHYZ9fVqhbTdPJK0AzV
         k18ksCgA+1QfIl61kkcVNTerV3124ggtCXt8raYzj7lDnmZ6WpB4niwxLDyqJ8ZpdUq/
         Zsg8OH6gpbnu0XElv0vgr/s6dsxmEGGIwZHdQOgyr/4B5jBQWzJUo2oJ4X2HRdiBNsRQ
         DAKiwn0aPqOypkizD89IyS7Nlfo77ON/4fNoyOTVIMQGLSC2qtePSIcz4DV9/xK0dzSl
         YOVu2OZIQKMSOk/t268mk6LpvR5YQmqMPzkszGIHKuxZWZfmPLTRCEraKl25IzpjGwLG
         dLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g+QlAwAK6bQlh/cWTEgPR/8pCDAU7kFbrkVp1jUM3t0=;
        b=Nz4QKpK94LTFuajn59RmBEzi2hHNPECdzfrPcEMP3om8E3cCZpJ6hJ8fAgQesrbh3V
         YCZxSIeXsw4CJLVyWJ7Ag8cEi1VEQClAqx4urGWcSBleiUQ7MlLG4tKUYuON1t7lF9L1
         hR0FseBudwItY7bweOhmYJrCQOTuLq+QIOlJxUlCpbCyUQGqh6/t7vEq849O4b+R9Wka
         ESvV5Ui0y9cbVtHAGXhhoSRknjIZ0/aya5hZ0LHU9gOqaLQT/ua1a89LJJaYh0R5KrcO
         wembbgq50qF/1sMHYRjNLVvFOo1jtKVed82VqNnWIkSoZ8Nz7HDn0aDxZk4IVMsuotc6
         lRhg==
X-Gm-Message-State: APjAAAW1C0DoTJPjFrHE3cqq7fjRhZe/LA+vWdq569IvUyNzFkDf6Wiz
        qpRPsB1IsUoO5GXktfo6nrN++DlEpNei9qeCX/g=
X-Google-Smtp-Source: APXvYqzU3u1QLkj1XmpAAdPd8RTPJBt4PWMxt3Enh23yjQG8/a8lMNSfNqYNAGaNFGGQmCTYgCKJWR8Wr43r1r4U4L8=
X-Received: by 2002:ab0:d8c:: with SMTP id i12mr9885832uak.57.1572775059623;
 Sun, 03 Nov 2019 01:57:39 -0800 (PST)
MIME-Version: 1.0
References: <20191101130817.11744-1-ethercflow@gmail.com> <CAEf4Bzand8qSxqmryyxMNg3FNL-pgokJ4taRrtGq07rdbEjsbA@mail.gmail.com>
In-Reply-To: <CAEf4Bzand8qSxqmryyxMNg3FNL-pgokJ4taRrtGq07rdbEjsbA@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Sun, 3 Nov 2019 17:57:36 +0800
Message-ID: <CABtjQmZugRi4d-UfNtyqUir9FpgjmVWQUi3W2E=MoLi-JV91wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Unless there is a real reason for all this complexity (in which case,
> please spell it out in commit or comments), I think this could be so
> much simpler.

Yes, it could be so much simpler than this implement.

> - you don't have to use perf_buffer to pass data back, just use global da=
ta;
> - you can add a filter for PID to only capture data triggered by test
> process and avoid the noise;

Yes, I'll use map instead of perf buffer to communicate.

> - why all those set_affinity dances? Is it just because you used
> existing perf_buffer test which did that to specifically test
> perf_buffer delivering data across every CPU core? Seems like your
> test doesn't care about that...

I used fd2path_loadgen to get hundreds of syscalls between multi usleep, wh=
ich
may cause it's sched to different cores, but as you say, this test
doesn't care about
that... I'll remove them with perf buffer.

> - do we really need a separate binary generating hundreds of syscalls?
> It's hard to synchronize with test and it seems much simpler to just
> trigger necessary syscalls synchronously from the test itself, no?

This is my fault, necessary syscalls synchronously from the test
itself is enough.

> I have a bunch of more minutia nits, but most of them will go away if
> you simplify your testing approach anyway, so I'll postpone them till
> then.

Thanks a lot. I'll modify a simplified version then recommitted.

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=
=882=E6=97=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=881:49=E5=86=99=E9=81=93=EF=
=BC=9A

>
> On Fri, Nov 1, 2019 at 6:08 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > trace fstat events by raw tracepoint sys_enter:newfstat, and handle eve=
nts
> > only produced by fd2path_loadgen, the fd2path_loadgen call fstat on sev=
eral
> > different types of files to test bpf_get_file_path's feature.
> > ---
>
> Unless there is a real reason for all this complexity (in which case,
> please spell it out in commit or comments), I think this could be so
> much simpler.
>
> - you don't have to use perf_buffer to pass data back, just use global da=
ta;
> - you can add a filter for PID to only capture data triggered by test
> process and avoid the noise;
> - why all those set_affinity dances? Is it just because you used
> existing perf_buffer test which did that to specifically test
> perf_buffer delivering data across every CPU core? Seems like your
> test doesn't care about that...
> - do we really need a separate binary generating hundreds of syscalls?
> It's hard to synchronize with test and it seems much simpler to just
> trigger necessary syscalls synchronously from the test itself, no?
>
> I have a bunch of more minutia nits, but most of them will go away if
> you simplify your testing approach anyway, so I'll postpone them till
> then.
>
> >  tools/testing/selftests/bpf/Makefile          |   8 +-
> >  tools/testing/selftests/bpf/fd2path_loadgen.c |  75 ++++++++++
> >  .../selftests/bpf/prog_tests/get_file_path.c  | 130 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_get_file_path.c  |  58 ++++++++
> >  4 files changed, 269 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/fd2path_loadgen.c
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_pat=
h.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_pat=
h.c
> >
>
> [...]
