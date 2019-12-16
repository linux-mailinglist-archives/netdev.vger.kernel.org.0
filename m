Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6D711FDA5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLPEpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:45:50 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33274 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfLPEpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 23:45:49 -0500
Received: by mail-pf1-f195.google.com with SMTP id y206so4908937pfb.0;
        Sun, 15 Dec 2019 20:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=E4lwTj2Piiy4VEJnXYOtgzWqyoOJ5LlYsCCzYknkahc=;
        b=HnxIhRBa7l63EMqC4GvPPZNtzIUHsqN8KrWMXXv42Rd6i3hnEMtTA8Zw7H83uk0OW4
         Pb5agjnBUmRIigCanawuhzuYQkwc09v7Klp+SGj0XdaCbmaLgEL1kO4SWzeGKJmcOL3F
         dVyOQ0LjqKeI/g/gKu220hl5GOQxJDJPy4PF/CAI1A1Sl91CMR0BhijCKDnmCToslUeQ
         gQHz0ujG5JApBEa5gCt1QDD9g/UeaDXOgXmtw7tw0/LvNuhHTIn/U27BrE7Mtnp2xjlT
         qDNTdcVZHQzUhwV3VXNxVjh+M05UF5z9HnC2pA2vIRN39ClF7fD1XhLR24KKsNuodZAT
         uV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=E4lwTj2Piiy4VEJnXYOtgzWqyoOJ5LlYsCCzYknkahc=;
        b=q/XURib6lHJ06K+ODeRDt2SZVR4ZLUH9SrTGSg7roVG0aiErHaLlqcbrlcXuJbikBF
         tM2rlitHdMJO6TMHwyB3XIZK0RDVXNKZNLjzUqTlSZdMUyQIAeXeQol1itsGz4R/5quQ
         Hvl2VMb9TbpS8jHSo31qp8WDU2d8PUPw16dHWstoNxnuRBWvFRuBe+/BFYQ8Uv2MLXT3
         Lvl2wM0rUU5L4VC5nM5xxkbJQX8RUx8gGVzh8dPywqwGbZLROlhN30v+Lvmpanu5ADuT
         CZlgQfsL6NbsoBMsVn9SwkC0bP0bNG19lYfL0AlEj4qjsTDBYEi8RCLGyvZv4tAS36Pr
         GNxw==
X-Gm-Message-State: APjAAAUmhzbioRcAKfZNrjqHpox6lZmgklNj/5YtKDQP+6kES/It4va1
        ochjgRaH40qAlL3wYVgeA9k=
X-Google-Smtp-Source: APXvYqxNgiIDucV7zGVyVzpTnqe5/a1OHu3ks57h1nT8ztmlniOmZF6ugmrSuj/5zGwwMERL3siO4w==
X-Received: by 2002:a63:fa50:: with SMTP id g16mr9291935pgk.202.1576471548343;
        Sun, 15 Dec 2019 20:45:48 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4748])
        by smtp.gmail.com with ESMTPSA id d23sm19750746pfo.176.2019.12.15.20.45.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 20:45:46 -0800 (PST)
Date:   Sun, 15 Dec 2019 20:45:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 00/17] Add code-generated BPF object skeleton
 support
Message-ID: <20191216044544.ulombnkyfs6mowsq@ast-mbp.dhcp.thefacebook.com>
References: <20191214014341.3442258-1-andriin@fb.com>
 <20191216003052.mdiw5fay37jqoakj@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaiMVZzbQ=weG7Dw1OP6Zd_C9+=AXvv0BH6=TtCqXobdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzaiMVZzbQ=weG7Dw1OP6Zd_C9+=AXvv0BH6=TtCqXobdQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 06:01:16PM -0800, Andrii Nakryiko wrote:
> On Sun, Dec 15, 2019 at 4:30 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 05:43:24PM -0800, Andrii Nakryiko wrote:
> > > This patch set introduces an alternative and complimentary to existing libbpf
> > > API interface for working with BPF objects, maps, programs, and global data
> > > from userspace side. This approach is relying on code generation. bpftool
> > > produces a struct (a.k.a. skeleton) tailored and specific to provided BPF
> > > object file. It includes hard-coded fields and data structures for every map,
> > > program, link, and global data present.
> > >
> > > Altogether this approach significantly reduces amount of userspace boilerplate
> > > code required to open, load, attach, and work with BPF objects. It improves
> > > attach/detach story, by providing pre-allocated space for bpf_links, and
> > > ensuring they are properly detached on shutdown. It allows to do away with by
> > > name/title lookups of maps and programs, because libbpf's skeleton API, in
> > > conjunction with generated code from bpftool, is filling in hard-coded fields
> > > with actual pointers to corresponding struct bpf_map/bpf_program/bpf_link.
> > >
> > > Also, thanks to BPF array mmap() support, working with global data (variables)
> > > from userspace is now as natural as it is from BPF side: each variable is just
> > > a struct field inside skeleton struct. Furthermore, this allows to have
> > > a natural way for userspace to pre-initialize global data (including
> > > previously impossible to initialize .rodata) by just assigning values to the
> > > same per-variable fields. Libbpf will carefully take into account this
> > > initialization image, will use it to pre-populate BPF maps at creation time,
> > > and will re-mmap() BPF map's contents at exactly the same userspace memory
> > > address such that it can continue working with all the same pointers without
> > > any interruptions. If kernel doesn't support mmap(), global data will still be
> > > successfully initialized, but after map creation global data structures inside
> > > skeleton will be NULL-ed out. This allows userspace application to gracefully
> > > handle lack of mmap() support, if necessary.
> > >
> > > A bunch of selftests are also converted to using skeletons, demonstrating
> > > significant simplification of userspace part of test and reduction in amount
> > > of code necessary.
> > >
> > > v3->v4:
> > > - add OPTS_VALID check to btf_dump__emit_type_decl (Alexei);
> > > - expose skeleton as LIBBPF_API functions (Alexei);
> > > - copyright clean up, update internal map init refactor (Alexei);
> >
> > Applied. Thanks.
> >
> > I really liked how much more concise test_fentry_fexit() test has become.
> > I also liked how renaming global variable s/test1_result/_test1_result/
> > in bpf program became a build time error for user space part:
> > ../prog_tests/fentry_fexit.c:49:35: error: ‘struct fentry_test__bss’ has no member named ‘test1_result’; did you mean ‘_test1_result’?
> >   printf("%lld\n", fentry_skel->bss->test1_result);
> > Working with global variables is so much easier now.
> >
> > I'd like you to consider additional feature request.
> > The following error:
> > -BPF_EMBED_OBJ(fentry, "fentry_test.o");
> > -BPF_EMBED_OBJ(fexit, "fexit_test.o");
> > +BPF_EMBED_OBJ(fexit, "fentry_test.o");
> > +BPF_EMBED_OBJ(fentry, "fexit_test.o");
> > will not be caught.
> > I think skeleton should get smarter somehow to catch that too.
> >
> > One option would be to do BPF_EMBED_OBJ() as part of *.skel.h but then
> > accessing the same embedded .o from multiple tests will not be possible and
> > what stacktrace_build_id.c and stacktrace_build_id_nmi.c are doing won't work
> > anymore. Some sort of build-id/sha1 of .o can work, but it will be caught
> > in run-time. I think build time would be better.
> > May be generate new macro in skel.h that user space can instantiate
> > instead of using common BPF_EMBED_OBJ ?
> >
> 
> All those issues are actually very easy to solve. As part of bla.skel.h:
> 
> ....
> 
> #ifndef __BLA__SKEL_EMBEDDED
> #define __BLA__SKEL_EMBEDDED
> BPF_EMBED_OBJ(<some_identifier>, <path_to_.o>);
> #endif
> 
> extern struct bpf_embed_data <some_identifier>_embed;
> 
> /* we can have a variant of bla__create_skeleton() that just uses
> above <some_identifier>_embed */
> 
> ....
> 
> 
> That seems to solve all the problems you mentioned. But it creates the
> problem of knowing/specifying <some_identifier> and <path_to_.o>.
> While we can "dictate" <some_identifier> (e.g., based on object file
> name), <path_to_.o> sometimes might need to be overridden, depending
> on specifics of build system.
> 
> 
> But I guess we can follow convention-driven way, and in addition to
> above do something like:
> 
> 
> #ifndef __BLA__SKEL__OBJ_PATH
> #define __BLA__SKEL__OBJ_PATH "<whatever path was provided to bpftool
> to generate skeleton>"
> #endif
> 
> 
> /* then just use __BLA__SKEL__OBJ_PATH for BPF_EMBED_OBJ,
>  * which user can override before including skeleton on userspace side
>  */
> 
> WDYT?

Another idea...
How about __weak definition of BPF_EMBED_OBJ ?
via generated macro inside .skel.h ?
With another method like test_pkt_access__open_and_load() that
doesn't take _embed ?
Then BPF_EMBED_OBJ_DECLARE() can be removed?

