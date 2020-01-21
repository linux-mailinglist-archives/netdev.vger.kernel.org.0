Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3FC1434CF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAUAnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:43:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41059 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUAnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:43:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so903711ljc.8;
        Mon, 20 Jan 2020 16:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MkxVpkj1L/adI2wMhsZ5ahtdW6aCQqf2r6PjbRYhDUc=;
        b=dZ1awvxMcrnEKYwMzrqTRi2pwnOM1B5AEpM5WeGi/zFyuzcBUSETgpwjirtQ358y6Z
         EFNOO3SLwuri1vDF5uO6cCRQDwLLkI0K7dUzsY7rF2MxA0AS+w+l1Rk2UJj9u9y+S9jg
         ORg7FsklegjviEhG0dwRt/0Z4CtiY7xb0aaO6pUrA8lu66Kx8ca2A+a2gtpYgNaFoMA5
         jCIpX/nQPF/I7vKX7ZDEGZHU3PW95G0oAsZY18VzoI6dVY2g8tazNhztC3HUUZr9DCY6
         cyDc0LKwr9gFXVBpSzWwmih7u3zc9QksSbwtx/fvxag2DlCU7xqS+ypGRbKjm0KqL6ef
         paVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MkxVpkj1L/adI2wMhsZ5ahtdW6aCQqf2r6PjbRYhDUc=;
        b=l0Z6V6oXpvQc5CFbpuk2z0wbYmiZ33VkOx8X+vEO+2lRmwcyDGF4DxEDw0mIBFlm3K
         RqS6RDTm06ZDi7SlNFZKJx62nXAjzeazrSQoYo/2P/ISGMN++olNgeR0NxmiTd5/rzwY
         YcH3ECDQwcI07tCb0e+IM47wbW4sjt/hukxWO2bN9J0sPoopzmWivA4dudLUHUrEBI8L
         nIDKkecStyMxiypy8FvBAXqLUNKgqkBNTIUYY/QPouQNrScgmvF3x4RCQnsDpHAogZZw
         5jYi+6G3lxrwcnX+FJwNvCS0jn3kb7g8V3WIh61xiAP0y8Ck9bYwxEeNq91fphwZ6phc
         +txg==
X-Gm-Message-State: APjAAAVgY6H0k2NhAbK7kQdUd/NGYj42Zph1HxiEquZvoe8NAgZsiTSQ
        IZaWh6VsHwPeGgOY0LRmxackTEobKsA8bxPBYko=
X-Google-Smtp-Source: APXvYqwpJtOxiIXoHoUtrlZrb0KiFLyLCl9gkZiPVlHWlnXXyT2SdA7nT9wRgOs30BN7Y/opbJ0qHzAMOBPFfx5aM0M=
X-Received: by 2002:a2e:8016:: with SMTP id j22mr14020495ljg.24.1579567425227;
 Mon, 20 Jan 2020 16:43:45 -0800 (PST)
MIME-Version: 1.0
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk> <CAEf4BzYNp81_bOFSEZR=AcruC2ms76fCWQGit+=2QZrFAXpGqg@mail.gmail.com>
In-Reply-To: <CAEf4BzYNp81_bOFSEZR=AcruC2ms76fCWQGit+=2QZrFAXpGqg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Jan 2020 16:43:33 -0800
Message-ID: <CAADnVQLji59JiB5MF0ct5i2q_M_4hq7k-F9pgKBAcxGYQjVDNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/11] tools: Use consistent libbpf include
 paths everywhere
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 2:21 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 20, 2020 at 5:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > We are currently being somewhat inconsistent with the libbpf include pa=
ths,
> > which makes it difficult to move files from the kernel into an external
> > libbpf-using project without adjusting include paths.
> >
> > Having the bpf/ subdir of $INCLUDEDIR in the include path has never bee=
n a
> > requirement for building against libbpf before, and indeed the libbpf p=
kg-config
> > file doesn't include it. So let's make all libbpf includes across the k=
ernel
> > tree use the bpf/ prefix in their includes. Since bpftool skeleton gene=
ration
> > emits code with a libbpf include, this also ensures that those can be u=
sed in
> > existing external projects using the regular pkg-config include path.
> >
> > This turns out to be a somewhat invasive change in the number of files =
touched;
> > however, the actual changes to files are fairly trivial (most of them a=
re simply
> > made with 'sed'). The series is split to make the change for one tool s=
ubdir at
> > a time, while trying not to break the build along the way. It is struct=
ured like
> > this:
> >
> > - Patch 1-3: Trivial fixes to Makefiles for issues I discovered while c=
hanging
> >   the include paths.
> >
> > - Patch 4-8: Change the include directives to use the bpf/ prefix, and =
updates
> >   Makefiles to make sure tools/lib/ is part of the include path, but wi=
thout
> >   removing tools/lib/bpf
> >
> > - Patch 9-11: Remove tools/lib/bpf from include paths to make sure we d=
on't
> >   inadvertently re-introduce includes without the bpf/ prefix.
> >
> > Changelog:
> >
> > v5:
> >   - Combine the libbpf build rules in selftests Makefile (using Andrii'=
s
> >     suggestion for a make rule).
> >   - Re-use self-tests libbpf build for runqslower (new patch 10)
> >   - Formatting fixes
> >
> > v4:
> >   - Move runqslower error on missing BTF into make rule
> >   - Make sure we don't always force a rebuild selftests
> >   - Rebase on latest bpf-next (dropping patch 11)
> >
> > v3:
> >   - Don't add the kernel build dir to the runqslower Makefile, pass it =
in from
> >     selftests instead.
> >   - Use libbpf's 'make install_headers' in selftests instead of trying =
to
> >     generate bpf_helper_defs.h in-place (to also work on read-only file=
systems).
> >   - Use a scratch builddir for both libbpf and bpftool when building in=
 selftests.
> >   - Revert bpf_helpers.h to quoted include instead of angled include wi=
th a bpf/
> >     prefix.
> >   - Fix a few style nits from Andrii
> >
> > v2:
> >   - Do a full cleanup of libbpf includes instead of just changing the
> >     bpf_helper_defs.h include.
> >
> > ---
> >
>
> Looks good, it's a clear improvement on what we had before, thanks!
>
> It doesn't re-build bpftool when bpftool sources changes, but I think
> it was like that even before, so no need to block on that. Would be
> nice to have a follow up fixing that, though. $(wildcard
> $(BPFTOOL_DIR)/*.[ch] $(BPFTOOL_DIR)/Makefile) should do it, same as
> for libbpf.
>
> So, for the series:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Tested-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
