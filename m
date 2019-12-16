Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E401211FCB1
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 03:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLPCB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 21:01:29 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38328 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfLPCB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 21:01:29 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so1676831qki.5;
        Sun, 15 Dec 2019 18:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M/IbV1IcS68t0hn8ZjuIs9f2S9xVeDYxEV+U8+mSQFs=;
        b=IsySucYz3Ypq5m1h96X47Zrl+ji07AaPVmZ/kJi2tBJDfg7sW6DJT5jyUr4A4gESj+
         gGQ95Lzl7aGmaa6tV3rjdr/BRXQ6dzWY+FiWCWmpiEZoSmqtcZrxyFAguNS2oxmz0q97
         jqBo7+nqTUgfES3MmgY5UGvoUCfefRgFwvzOA4rpto+og8Z+jO5XEFlGsDskueJGKmmq
         a3pP/K31u0+/c36+Ex8fh1mLeu6lsn1JzJ6WCdRcL+PWUyVJ7tDJXQRDSLx4aXJAx7of
         daKkY+jxjmtUm/AAsyTJE30oihTsFEQ85AYy1XhpgdO0iMjpGQv3bBJt4OsS4Gij4qZz
         DVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M/IbV1IcS68t0hn8ZjuIs9f2S9xVeDYxEV+U8+mSQFs=;
        b=L4GSMVTFIDyVAMWXQvrdwVE/mEyArjN7usygXkuYqUoNXfN1KGfau5wtViskhbk73C
         IFR/vQQ+08tPYjwC4Dp8kexmbx0P74dCL4c2S7ZSr44GqdsD9gfjMihW2RX9wDRAXU14
         V6cVSK9gHn+DR44BfXBJeYmehymyhpluDq2Sox8HJWhA51GZMRUpogt88eBtJtFChPxJ
         WM4pVhdhF8UH5OzZklpnop1N5NznBO9ibcMq3Lm4D0k7I9vEGSasBDAkirYCcLaUeRKd
         4R51gLHB6P5UHNo/FF29UmW17xsKi2mKtXIs4ZMRDHcV3jRvDfWFAEOT8i0PsXGr+Y9L
         Ne2w==
X-Gm-Message-State: APjAAAWxkVqDSsTCaGy49wMH9Ii8iK/tIpC0UhcL/7911az7KYTzg5XW
        b6IhkqKfvaxPQQJSer2tTsjDl0nJeAc4HXM5U40=
X-Google-Smtp-Source: APXvYqw1djqQweKj1yB2WCa47bGvrzJj7c36bBxtB1pnGEGb8X2bx974sHniiaoOgOvbuFLO51Arxks4sa8KOdDYHgI=
X-Received: by 2002:a37:a685:: with SMTP id p127mr26102673qke.449.1576461687591;
 Sun, 15 Dec 2019 18:01:27 -0800 (PST)
MIME-Version: 1.0
References: <20191214014341.3442258-1-andriin@fb.com> <20191216003052.mdiw5fay37jqoakj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191216003052.mdiw5fay37jqoakj@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 15 Dec 2019 18:01:16 -0800
Message-ID: <CAEf4BzaiMVZzbQ=weG7Dw1OP6Zd_C9+=AXvv0BH6=TtCqXobdQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/17] Add code-generated BPF object skeleton support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 4:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 05:43:24PM -0800, Andrii Nakryiko wrote:
> > This patch set introduces an alternative and complimentary to existing =
libbpf
> > API interface for working with BPF objects, maps, programs, and global =
data
> > from userspace side. This approach is relying on code generation. bpfto=
ol
> > produces a struct (a.k.a. skeleton) tailored and specific to provided B=
PF
> > object file. It includes hard-coded fields and data structures for ever=
y map,
> > program, link, and global data present.
> >
> > Altogether this approach significantly reduces amount of userspace boil=
erplate
> > code required to open, load, attach, and work with BPF objects. It impr=
oves
> > attach/detach story, by providing pre-allocated space for bpf_links, an=
d
> > ensuring they are properly detached on shutdown. It allows to do away w=
ith by
> > name/title lookups of maps and programs, because libbpf's skeleton API,=
 in
> > conjunction with generated code from bpftool, is filling in hard-coded =
fields
> > with actual pointers to corresponding struct bpf_map/bpf_program/bpf_li=
nk.
> >
> > Also, thanks to BPF array mmap() support, working with global data (var=
iables)
> > from userspace is now as natural as it is from BPF side: each variable =
is just
> > a struct field inside skeleton struct. Furthermore, this allows to have
> > a natural way for userspace to pre-initialize global data (including
> > previously impossible to initialize .rodata) by just assigning values t=
o the
> > same per-variable fields. Libbpf will carefully take into account this
> > initialization image, will use it to pre-populate BPF maps at creation =
time,
> > and will re-mmap() BPF map's contents at exactly the same userspace mem=
ory
> > address such that it can continue working with all the same pointers wi=
thout
> > any interruptions. If kernel doesn't support mmap(), global data will s=
till be
> > successfully initialized, but after map creation global data structures=
 inside
> > skeleton will be NULL-ed out. This allows userspace application to grac=
efully
> > handle lack of mmap() support, if necessary.
> >
> > A bunch of selftests are also converted to using skeletons, demonstrati=
ng
> > significant simplification of userspace part of test and reduction in a=
mount
> > of code necessary.
> >
> > v3->v4:
> > - add OPTS_VALID check to btf_dump__emit_type_decl (Alexei);
> > - expose skeleton as LIBBPF_API functions (Alexei);
> > - copyright clean up, update internal map init refactor (Alexei);
>
> Applied. Thanks.
>
> I really liked how much more concise test_fentry_fexit() test has become.
> I also liked how renaming global variable s/test1_result/_test1_result/
> in bpf program became a build time error for user space part:
> ../prog_tests/fentry_fexit.c:49:35: error: =E2=80=98struct fentry_test__b=
ss=E2=80=99 has no member named =E2=80=98test1_result=E2=80=99; did you mea=
n =E2=80=98_test1_result=E2=80=99?
>   printf("%lld\n", fentry_skel->bss->test1_result);
> Working with global variables is so much easier now.
>
> I'd like you to consider additional feature request.
> The following error:
> -BPF_EMBED_OBJ(fentry, "fentry_test.o");
> -BPF_EMBED_OBJ(fexit, "fexit_test.o");
> +BPF_EMBED_OBJ(fexit, "fentry_test.o");
> +BPF_EMBED_OBJ(fentry, "fexit_test.o");
> will not be caught.
> I think skeleton should get smarter somehow to catch that too.
>
> One option would be to do BPF_EMBED_OBJ() as part of *.skel.h but then
> accessing the same embedded .o from multiple tests will not be possible a=
nd
> what stacktrace_build_id.c and stacktrace_build_id_nmi.c are doing won't =
work
> anymore. Some sort of build-id/sha1 of .o can work, but it will be caught
> in run-time. I think build time would be better.
> May be generate new macro in skel.h that user space can instantiate
> instead of using common BPF_EMBED_OBJ ?
>

All those issues are actually very easy to solve. As part of bla.skel.h:

....

#ifndef __BLA__SKEL_EMBEDDED
#define __BLA__SKEL_EMBEDDED
BPF_EMBED_OBJ(<some_identifier>, <path_to_.o>);
#endif

extern struct bpf_embed_data <some_identifier>_embed;

/* we can have a variant of bla__create_skeleton() that just uses
above <some_identifier>_embed */

....


That seems to solve all the problems you mentioned. But it creates the
problem of knowing/specifying <some_identifier> and <path_to_.o>.
While we can "dictate" <some_identifier> (e.g., based on object file
name), <path_to_.o> sometimes might need to be overridden, depending
on specifics of build system.


But I guess we can follow convention-driven way, and in addition to
above do something like:


#ifndef __BLA__SKEL__OBJ_PATH
#define __BLA__SKEL__OBJ_PATH "<whatever path was provided to bpftool
to generate skeleton>"
#endif


/* then just use __BLA__SKEL__OBJ_PATH for BPF_EMBED_OBJ,
 * which user can override before including skeleton on userspace side
 */

WDYT?
