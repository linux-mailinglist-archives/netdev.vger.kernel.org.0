Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262D0121A13
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfLPTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:36:12 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34309 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLPTgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:36:12 -0500
Received: by mail-qv1-f66.google.com with SMTP id o18so3216406qvf.1;
        Mon, 16 Dec 2019 11:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1YXniKZULlvso9xctHGNXBf1MVFm4BFGMIU7Y5H105w=;
        b=BUh3eFdjfUIJ+/UZ1kyq52cA7yE0a8cxvOpN/6F9ubnMh5IBb60JLEZAukXXnerPvM
         VF2IkkxDTaWJlI4qi8ymyv3Vn8wViYJSnODlvos/CmHTkLKR5mtekpDeStdtC6jQDka4
         ZSSbxbjg9Y+Yfkwg4fZxazzinPKLX2Yar3ZXURhNtmbuxOe3dKk9VdV/e26Juf8+uwro
         7FVvDGpx+VL7zAALP/dX6hjwRtclEUhAncP7xriUoe4VGKOFpaN4xoX0048CAwFfYfek
         sqU+nmyKMzfHDGNbIeKaaR44M3WnAFkCV4dxDMw/1QmxD9313EIXAnjvQCzxef9BeoCJ
         LXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1YXniKZULlvso9xctHGNXBf1MVFm4BFGMIU7Y5H105w=;
        b=sDQ8UOwp04SiUMZ8L2/J/Jk547fmMeiAbDjuDk23oRNgQXiWMprbm8w3enxCr4vFFx
         I6z+UbK+itMK5TOufFybqylE+Ibo8I5PF8Q7MKZb1kEovTOygunZo7rKf/pugI+g8/Ld
         aqX8SXBCTY6Om07WzvFcRONgDxWPDp2O1HvFCQTQuvwogpvQdQzItSK/m7+VFA2Ene28
         79S/Y+43bnDTxfOa7nknTKZnHu1QUmNvM88eThnoEuhe23aJxKsiDKTVRzTGtx3iMkF8
         1psDeTmnojfSTaD55acOVSR8CNfoPsM6NlB+It5bA4oLGec9bA+V5J5sdJK6x7mqQJ5a
         UPwg==
X-Gm-Message-State: APjAAAXkshb1QwqFyhtBEzmxAIjSw9hEs4KnzEptdLu+sEZgBEAy/w2M
        7/D3v8GKOJ1W8yLwrPJPJ/UzL9sEe1Iuj+kqDOE=
X-Google-Smtp-Source: APXvYqwuv6n3RAzeFFmnJLnRvA1wNuX57To5oLsqDeojtCMcuih1jwNxzWtNqiNlJ2gBwlVumd0g8IMhZIZuAxmWs6w=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr999338qvy.224.1576524970837;
 Mon, 16 Dec 2019 11:36:10 -0800 (PST)
MIME-Version: 1.0
References: <20191214014341.3442258-1-andriin@fb.com> <20191216003052.mdiw5fay37jqoakj@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaiMVZzbQ=weG7Dw1OP6Zd_C9+=AXvv0BH6=TtCqXobdQ@mail.gmail.com> <20191216044544.ulombnkyfs6mowsq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191216044544.ulombnkyfs6mowsq@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 11:35:59 -0800
Message-ID: <CAEf4BzY2R3-=pwxOsLLWwiC=MSJUQ8eZjZ+uAbzmdDeHAspyrw@mail.gmail.com>
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

On Sun, Dec 15, 2019 at 8:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Dec 15, 2019 at 06:01:16PM -0800, Andrii Nakryiko wrote:
> > On Sun, Dec 15, 2019 at 4:30 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Dec 13, 2019 at 05:43:24PM -0800, Andrii Nakryiko wrote:
> > > > This patch set introduces an alternative and complimentary to exist=
ing libbpf
> > > > API interface for working with BPF objects, maps, programs, and glo=
bal data
> > > > from userspace side. This approach is relying on code generation. b=
pftool
> > > > produces a struct (a.k.a. skeleton) tailored and specific to provid=
ed BPF
> > > > object file. It includes hard-coded fields and data structures for =
every map,
> > > > program, link, and global data present.
> > > >
> > > > Altogether this approach significantly reduces amount of userspace =
boilerplate
> > > > code required to open, load, attach, and work with BPF objects. It =
improves
> > > > attach/detach story, by providing pre-allocated space for bpf_links=
, and
> > > > ensuring they are properly detached on shutdown. It allows to do aw=
ay with by
> > > > name/title lookups of maps and programs, because libbpf's skeleton =
API, in
> > > > conjunction with generated code from bpftool, is filling in hard-co=
ded fields
> > > > with actual pointers to corresponding struct bpf_map/bpf_program/bp=
f_link.
> > > >
> > > > Also, thanks to BPF array mmap() support, working with global data =
(variables)
> > > > from userspace is now as natural as it is from BPF side: each varia=
ble is just
> > > > a struct field inside skeleton struct. Furthermore, this allows to =
have
> > > > a natural way for userspace to pre-initialize global data (includin=
g
> > > > previously impossible to initialize .rodata) by just assigning valu=
es to the
> > > > same per-variable fields. Libbpf will carefully take into account t=
his
> > > > initialization image, will use it to pre-populate BPF maps at creat=
ion time,
> > > > and will re-mmap() BPF map's contents at exactly the same userspace=
 memory
> > > > address such that it can continue working with all the same pointer=
s without
> > > > any interruptions. If kernel doesn't support mmap(), global data wi=
ll still be
> > > > successfully initialized, but after map creation global data struct=
ures inside
> > > > skeleton will be NULL-ed out. This allows userspace application to =
gracefully
> > > > handle lack of mmap() support, if necessary.
> > > >
> > > > A bunch of selftests are also converted to using skeletons, demonst=
rating
> > > > significant simplification of userspace part of test and reduction =
in amount
> > > > of code necessary.
> > > >
> > > > v3->v4:
> > > > - add OPTS_VALID check to btf_dump__emit_type_decl (Alexei);
> > > > - expose skeleton as LIBBPF_API functions (Alexei);
> > > > - copyright clean up, update internal map init refactor (Alexei);
> > >
> > > Applied. Thanks.
> > >
> > > I really liked how much more concise test_fentry_fexit() test has bec=
ome.
> > > I also liked how renaming global variable s/test1_result/_test1_resul=
t/
> > > in bpf program became a build time error for user space part:
> > > ../prog_tests/fentry_fexit.c:49:35: error: =E2=80=98struct fentry_tes=
t__bss=E2=80=99 has no member named =E2=80=98test1_result=E2=80=99; did you=
 mean =E2=80=98_test1_result=E2=80=99?
> > >   printf("%lld\n", fentry_skel->bss->test1_result);
> > > Working with global variables is so much easier now.
> > >
> > > I'd like you to consider additional feature request.
> > > The following error:
> > > -BPF_EMBED_OBJ(fentry, "fentry_test.o");
> > > -BPF_EMBED_OBJ(fexit, "fexit_test.o");
> > > +BPF_EMBED_OBJ(fexit, "fentry_test.o");
> > > +BPF_EMBED_OBJ(fentry, "fexit_test.o");
> > > will not be caught.
> > > I think skeleton should get smarter somehow to catch that too.
> > >
> > > One option would be to do BPF_EMBED_OBJ() as part of *.skel.h but the=
n
> > > accessing the same embedded .o from multiple tests will not be possib=
le and
> > > what stacktrace_build_id.c and stacktrace_build_id_nmi.c are doing wo=
n't work
> > > anymore. Some sort of build-id/sha1 of .o can work, but it will be ca=
ught
> > > in run-time. I think build time would be better.
> > > May be generate new macro in skel.h that user space can instantiate
> > > instead of using common BPF_EMBED_OBJ ?
> > >
> >
> > All those issues are actually very easy to solve. As part of bla.skel.h=
:
> >
> > ....
> >
> > #ifndef __BLA__SKEL_EMBEDDED
> > #define __BLA__SKEL_EMBEDDED
> > BPF_EMBED_OBJ(<some_identifier>, <path_to_.o>);
> > #endif
> >
> > extern struct bpf_embed_data <some_identifier>_embed;
> >
> > /* we can have a variant of bla__create_skeleton() that just uses
> > above <some_identifier>_embed */
> >
> > ....
> >
> >
> > That seems to solve all the problems you mentioned. But it creates the
> > problem of knowing/specifying <some_identifier> and <path_to_.o>.
> > While we can "dictate" <some_identifier> (e.g., based on object file
> > name), <path_to_.o> sometimes might need to be overridden, depending
> > on specifics of build system.
> >
> >
> > But I guess we can follow convention-driven way, and in addition to
> > above do something like:
> >
> >
> > #ifndef __BLA__SKEL__OBJ_PATH
> > #define __BLA__SKEL__OBJ_PATH "<whatever path was provided to bpftool
> > to generate skeleton>"
> > #endif
> >
> >
> > /* then just use __BLA__SKEL__OBJ_PATH for BPF_EMBED_OBJ,
> >  * which user can override before including skeleton on userspace side
> >  */
> >
> > WDYT?
>
> Another idea...
> How about __weak definition of BPF_EMBED_OBJ ?
> via generated macro inside .skel.h ?
> With another method like test_pkt_access__open_and_load() that
> doesn't take _embed ?
> Then BPF_EMBED_OBJ_DECLARE() can be removed?
>

So I like the idea of not having to do BPF_EMBED_OBJ. It can't be done
cleanly with BPF_EMBED_OBJ, but skeleton can auto-generate array with
embedded contents of object file used for skeleton generation. That
will solve all the issues of keeping skeleton and object file contents
in sync. I'll post a follow up patch with that change.
