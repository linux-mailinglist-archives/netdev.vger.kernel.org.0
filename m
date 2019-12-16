Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF5F11FC2F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLPAa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 19:30:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36756 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfLPAa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 19:30:57 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so2206143pjc.3;
        Sun, 15 Dec 2019 16:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=qoyT4VnZpf60nh4iMWARLDY/385v76kr93Iyz32FNE4=;
        b=rwNK/Tw/ZssSAqFNUrxG+eHWekN9ElkOkXWDCuPHmGjtEuTTN6fXE/QT4fBxksvUeD
         AdKOGzXqYbh63A1/G9SkcGh4GHoUzut8lkuoVhcLGByMaQeZsI+9uxCDRS55+c1NvrAo
         Z2aIyrXREqhFagr48lxIlBwlsr7TZzMTvkfQpz+AjScAiXTsij3KDrpbbJe3pxH+8fYP
         p/6i1Fns3Dcdll6E1s6F8senkBfMPlhzckmkcf2er+bk/2Dr26dvUcAjlHWzOd5Q4mEA
         SFqZWGru5hG7ajAW+YMWfnNcb69Nyo76jfW95CS5xNajMpk5XeGY6guPl+p5IzANssd3
         jFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qoyT4VnZpf60nh4iMWARLDY/385v76kr93Iyz32FNE4=;
        b=n77mXHwOpWoY6X0/GgkI3799cLd1NfjWECOC1XyuHATQ5v33/vlqHkKEIcZ+5ThgnC
         oQfznAXNaMSlhCcI2qQyw1kTcjwWGUG8qLS2t77VqCKcL/Pq/Mkdavlje0YwdGRl4CtR
         5YlqNpFoL8INEexwd7Ped+Dwg5QLEd8LGgvdkp3OljWIs17DzQ+zYycMdKSf0i0BKren
         QOfnU+je1I8hQGmnJgV0XBppFwpAPxwRA5lQc262wnND2Kg67ia7/RfLA0FmUEFFpTfk
         ePo1oM4DQbf7YFX8GjFvJs+w6Mstjt4pzsf0Nsqdlv9TSmb0HOhzl2KvGF0ElEWG0bpA
         OmiQ==
X-Gm-Message-State: APjAAAUqmWluoDQVpEJTpLIITxqZmwLg80KavdVY1hDgQ+G5q7UvzI1h
        Wmo8h8128QQysdaiAQo39rs=
X-Google-Smtp-Source: APXvYqzhOPOiE32biGY36rlTKShrwlmPFBGja7XNHKvFwsMyiKvJFJXn8cHlSQW3fFW59qD/MjblOg==
X-Received: by 2002:a17:90a:804a:: with SMTP id e10mr14840386pjw.41.1576456257038;
        Sun, 15 Dec 2019 16:30:57 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::935c])
        by smtp.gmail.com with ESMTPSA id a12sm18046994pga.11.2019.12.15.16.30.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 16:30:56 -0800 (PST)
Date:   Sun, 15 Dec 2019 16:30:54 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 00/17] Add code-generated BPF object skeleton
 support
Message-ID: <20191216003052.mdiw5fay37jqoakj@ast-mbp.dhcp.thefacebook.com>
References: <20191214014341.3442258-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:43:24PM -0800, Andrii Nakryiko wrote:
> This patch set introduces an alternative and complimentary to existing libbpf
> API interface for working with BPF objects, maps, programs, and global data
> from userspace side. This approach is relying on code generation. bpftool
> produces a struct (a.k.a. skeleton) tailored and specific to provided BPF
> object file. It includes hard-coded fields and data structures for every map,
> program, link, and global data present.
> 
> Altogether this approach significantly reduces amount of userspace boilerplate
> code required to open, load, attach, and work with BPF objects. It improves
> attach/detach story, by providing pre-allocated space for bpf_links, and
> ensuring they are properly detached on shutdown. It allows to do away with by
> name/title lookups of maps and programs, because libbpf's skeleton API, in
> conjunction with generated code from bpftool, is filling in hard-coded fields
> with actual pointers to corresponding struct bpf_map/bpf_program/bpf_link.
> 
> Also, thanks to BPF array mmap() support, working with global data (variables)
> from userspace is now as natural as it is from BPF side: each variable is just
> a struct field inside skeleton struct. Furthermore, this allows to have
> a natural way for userspace to pre-initialize global data (including
> previously impossible to initialize .rodata) by just assigning values to the
> same per-variable fields. Libbpf will carefully take into account this
> initialization image, will use it to pre-populate BPF maps at creation time,
> and will re-mmap() BPF map's contents at exactly the same userspace memory
> address such that it can continue working with all the same pointers without
> any interruptions. If kernel doesn't support mmap(), global data will still be
> successfully initialized, but after map creation global data structures inside
> skeleton will be NULL-ed out. This allows userspace application to gracefully
> handle lack of mmap() support, if necessary.
> 
> A bunch of selftests are also converted to using skeletons, demonstrating
> significant simplification of userspace part of test and reduction in amount
> of code necessary.
> 
> v3->v4:
> - add OPTS_VALID check to btf_dump__emit_type_decl (Alexei);
> - expose skeleton as LIBBPF_API functions (Alexei);
> - copyright clean up, update internal map init refactor (Alexei);

Applied. Thanks.

I really liked how much more concise test_fentry_fexit() test has become.
I also liked how renaming global variable s/test1_result/_test1_result/
in bpf program became a build time error for user space part:
../prog_tests/fentry_fexit.c:49:35: error: ‘struct fentry_test__bss’ has no member named ‘test1_result’; did you mean ‘_test1_result’?
  printf("%lld\n", fentry_skel->bss->test1_result);
Working with global variables is so much easier now.

I'd like you to consider additional feature request.
The following error:
-BPF_EMBED_OBJ(fentry, "fentry_test.o");
-BPF_EMBED_OBJ(fexit, "fexit_test.o");
+BPF_EMBED_OBJ(fexit, "fentry_test.o");
+BPF_EMBED_OBJ(fentry, "fexit_test.o");
will not be caught.
I think skeleton should get smarter somehow to catch that too.

One option would be to do BPF_EMBED_OBJ() as part of *.skel.h but then
accessing the same embedded .o from multiple tests will not be possible and
what stacktrace_build_id.c and stacktrace_build_id_nmi.c are doing won't work
anymore. Some sort of build-id/sha1 of .o can work, but it will be caught
in run-time. I think build time would be better.
May be generate new macro in skel.h that user space can instantiate
instead of using common BPF_EMBED_OBJ ?

