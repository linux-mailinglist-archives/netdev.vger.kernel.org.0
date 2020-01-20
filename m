Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698FD143326
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgATVA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:00:27 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44424 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:00:26 -0500
Received: by mail-qt1-f193.google.com with SMTP id w8so871577qts.11;
        Mon, 20 Jan 2020 13:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VQ+GdhZxzN9nLfpgX9IxRVtlqBky78upQxgIvlUTRO0=;
        b=NBc2Q5ad06i24N8mOKCL845ZVy+ujPfi9RBGUNzQtEEFG4/8bmSi/donUXXwJ1N71Y
         LSDgtkx9hwumwnpljKgb+ryOssu7jsEhbyzZ8dxOSIGX8OiMU0alsdMwwwbbaRGeB1PT
         ZlfiaNNOWttrRlCCxv/CjE0xSWiXc1l7pN4MUasYxr9lxApRSX55uhFau6n6HCjLUj0u
         w+feAqSwILqzzIbBe8zBU7cFT7oJMg646KFtVfkiVp3v7cSpoWI3KY35FZ4/bwWlOrGF
         u3TBLRFw0Xx56HWxcvQuJcWGYkH6TCy73cgjT1Q694EzAciA+c6SVPAgahCtVU2PXSSU
         45fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VQ+GdhZxzN9nLfpgX9IxRVtlqBky78upQxgIvlUTRO0=;
        b=hG9pzMKuq5WZUjZOcX3WF4ytlizSzyZXHH66ABHyrZ/O5UfP2D1/1vYia72RXsbpIO
         fsc01Xei1QtdCzCzS0JrNSOArqSkWiFgcBNfZjd7g1uS8/UJ+ue0RQB5H0sthfq7jc4A
         mSARnQ07mlMovK8+0RXSADs/EDoqI8vmKnSHx3sqQMDC3KKdxnLAT7MWIoCLIHEGJqNT
         P1S8cup7weIhoDDtBwrTQHm05Mt1s1uWI7hNp9o3fYNsTT25+ptKRyoZj8dbJMZPZGfX
         /ZYACqoYuE4aQ2yBaaKPF7CSBFFJL6A52bF83fxrDoT04UdQYHGn0UNVbTwVYqRay0Od
         Sktg==
X-Gm-Message-State: APjAAAVre1+dyo6tKIkVkf88TJ1+xl9M9adaCIT4k4/9ZZNzMPYTzNTc
        b8AS4osokOoJgRBdTe4pr3QIHuNM0IyICWgK640=
X-Google-Smtp-Source: APXvYqwEPU4xurzWUVBVkjOCNXZiOSX0Z04FaiBCkpyvjBsziwOuEFBAX0ydhhSkW4AJoK7PvMHYKvVMg4OLoukxoR4=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr1257133qtj.59.1579554025526;
 Mon, 20 Jan 2020 13:00:25 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
 <157926820131.1555735.1177228853838027248.stgit@toke.dk> <CAEf4BzbAV0TmEUL=62jz+RD6SPmu927z-dhGL9JHepcAOGMSJA@mail.gmail.com>
 <875zh6p9pg.fsf@toke.dk> <CAEf4BzZ7x4F_-bjGg7TdzXcin6c1BAT6OKe53ujh1tx-GB6-ZQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ7x4F_-bjGg7TdzXcin6c1BAT6OKe53ujh1tx-GB6-ZQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 13:00:14 -0800
Message-ID: <CAEf4BzYN3Gx2dsAoHZLxhv=oVVUgoKacZ3eoWYuwB4tW5t6W1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/10] tools/runqslower: Use consistent
 include paths for libbpf
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:35 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 20, 2020 at 4:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > > On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > >>
> > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > >>
> > >> Fix the runqslower tool to include libbpf header files with the bpf/
> > >> prefix, to be consistent with external users of the library. Also en=
sure
> > >> that all includes of exported libbpf header files (those that are ex=
ported
> > >> on 'make install' of the library) use bracketed includes instead of =
quoted.
> > >>
> > >> To not break the build, keep the old include path until everything h=
as been
> > >> changed to the new one; a subsequent patch will remove that.
> > >>
> > >> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are ta=
ken from selftests dir")
> > >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > >> ---
> > >>  tools/bpf/runqslower/Makefile         |    5 +++--
> > >>  tools/bpf/runqslower/runqslower.bpf.c |    2 +-
> > >>  tools/bpf/runqslower/runqslower.c     |    4 ++--
> > >>  3 files changed, 6 insertions(+), 5 deletions(-)
> > >>
> > >> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Ma=
kefile
> > >> index b62fc9646c39..9f022f7f2593 100644
> > >> --- a/tools/bpf/runqslower/Makefile
> > >> +++ b/tools/bpf/runqslower/Makefile
> > >> @@ -5,6 +5,7 @@ LLC :=3D llc
> > >>  LLVM_STRIP :=3D llvm-strip
> > >>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
> > >>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
> > >> +INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(abspath ../../=
lib/bpf)
> > >>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
> > >
> > > drop LIBBPF_SRC, it's not used anymore
> >
> > It is: in the rule for building libbpf there's a '-C $(LIBBPF_SRC)'
> >
>
> Ah, right, missed that one. Looked a bit weird to have $(abspath
> ../../lib/bpf) used in INCLUDES and then separate LIBBPF_SRC
> definition there, maybe
>
> LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
> INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(LIBBPF_SRC)

Never mind, you delete it in later patch anyway.

>
> > -Toke
> >
