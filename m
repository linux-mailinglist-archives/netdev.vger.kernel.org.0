Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB3E427149
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhJHTP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241495AbhJHTPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 15:15:35 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEFDC061570;
        Fri,  8 Oct 2021 12:13:39 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r1so23255535ybo.10;
        Fri, 08 Oct 2021 12:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6P+aEoRg9S8CkkTvUvonMX46KLoggKMFetFIeqvOyM=;
        b=ZhxUO74aqNgMlmu/dsi9hGadO+Ydvn+cF1cm1NamPqf8S+P58rxFx9dKVDsd80/dCU
         3h+OBHyfRaHitIsSRHvrH2fQP2hmarvBxH/eOnQXDsuTSmhlMbKgg7txP89NorBreaLJ
         RwRL1+TqAdQVhRRmE9ah6bTi3Vrg/Axv8CkMqhcHxf2m2x9FnAmn+pX2tmjQeKRkbgHF
         8Wu+wCIUTN0Nu/jtdaC/ZN6SS4XBd9OHq3mDcwVL14vmeIxWSkG4MfQviGCzhd2kbu/r
         0YDcIz79L4IEuyH/HRNKorz0sOeJu5A847as1dvCrYLvwG2k36/2xA8tTFa/6ojm0oev
         a8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6P+aEoRg9S8CkkTvUvonMX46KLoggKMFetFIeqvOyM=;
        b=OdWzTTBwOp3m905Merxoai4U0EDLeFbMVXVq4zAZOLvxxG4L3/RyqnOSL0nx+y/lKx
         ysmgGAZEjTN1wl+ek6qtTnrXOM8ZbDSWaDfKswbCz+siPnu9fFj3Oe8cD32I0csi5cwD
         tZPd5qDQX84hTUnWn0okI771W9GXS9cRO5f6Lh20DzPGcNTKzIGDBMZHkrHuAEz65/dO
         s2PjSBzK2vNIZljIowo7xChmyVFzorbFRN216jbP4ydmJUe+MZQWktvDmI6vlYRQrJ14
         0gy1c/dHZxozMBV2WWycR2b/1BWuE+ai9SRjXFxbfrxtF2lEci11APtTtxITvJF7y3M5
         3EGg==
X-Gm-Message-State: AOAM532sbDll1YA3y4M6FS/I8YM+08i6QUCR8j0l4S8+pcXrcSOZhId3
        Z6pf9YsebjRGf3A+gpY33zxnO9zXxBbNUBd5jS8=
X-Google-Smtp-Source: ABdhPJzufjIpwztj86Jr7QW9U5giKr+qvPr+UEyNJQqFro+ysgzj/GxBL1tfoF2UqEoko0A2tluFglVNvos/hAWpWi4=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr5587861ybj.504.1633720418669;
 Fri, 08 Oct 2021 12:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211007194438.34443-1-quentin@isovalent.com>
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Oct 2021 12:13:27 -0700
Message-ID: <CAEf4BzZd0FA6yX4WzK6GZFW2VbBgEJ=oJ=f4GzkapCkbAGUNrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/12] install libbpf headers when using the library
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 12:44 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Libbpf is used at several locations in the repository. Most of the time,
> the tools relying on it build the library in its own directory, and include
> the headers from there. This works, but this is not the cleanest approach.
> It generates objects outside of the directory of the tool which is being
> built, and it also increases the risk that developers include a header file
> internal to libbpf, which is not supposed to be exposed to user
> applications.
>
> This set adjusts all involved Makefiles to make sure that libbpf is built
> locally (with respect to the tool's directory or provided build directory),
> and by ensuring that "make install_headers" is run from libbpf's Makefile
> to export user headers properly.
>
> This comes at a cost: given that the libbpf was so far mostly compiled in
> its own directory by the different components using it, compiling it once
> would be enough for all those components. With the new approach, each
> component compiles its own version. To mitigate this cost, efforts were
> made to reuse the compiled library when possible:
>
> - Make the bpftool version in samples/bpf reuse the library previously
>   compiled for the selftests.
> - Make the bpftool version in BPF selftests reuse the library previously
>   compiled for the selftests.
> - Similarly, make resolve_btfids in BPF selftests reuse the same compiled
>   library.
> - Similarly, make runqslower in BPF selftests reuse the same compiled
>   library; and make it rely on the bpftool version also compiled from the
>   selftests (instead of compiling its own version).
> - runqslower, when compiled independently, needs its own version of
>   bpftool: make them share the same compiled libbpf.
>
> As a result:
>
> - Compiling the samples/bpf should compile libbpf just once.
> - Compiling the BPF selftests should compile libbpf just once.
> - Compiling the kernel (with BTF support) should now lead to compiling
>   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
> - Compiling runqslower individually should compile libbpf just once. Same
>   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.
>
> (Not accounting for the boostrap version of libbpf required by bpftool,
> which was already placed under a dedicated .../boostrap/libbpf/ directory,
> and for which the count remains unchanged.)
>
> A few commits in the series also contain drive-by clean-up changes for
> bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. Please
> refer to individual commit logs for details.
>
> v4:
>   - Make the "libbpf_hdrs" dependency an order-only dependency in
>     kernel/bpf/preload/Makefile, samples/bpf/Makefile, and
>     tools/bpf/runqslower/Makefile. This is to avoid to unconditionally
>     recompile the targets.
>   - samples/bpf/.gitignore: prefix objects with a "/" to mark that we
>     ignore them when at the root of the samples/bpf/ directory.
>   - libbpf: add a commit to make "install_headers" depend on the header
>     files, to avoid exporting again if the sources are older than the
>     targets. This ensures that applications relying on those headers are
>     not rebuilt unnecessarily.
>   - bpftool: uncouple the copy of nlattr.h from libbpf target, to have it
>     depend on the source header itself. By avoiding to reinstall this
>     header every time, we avoid unnecessary builds of bpftool.
>   - samples/bpf: Add a new commit to remove the FORCE dependency for
>     libbpf, and replace it with a "$(wildcard ...)" on the .c/.h files in
>     libbpf's directory. This is to avoid always recompiling libbpf/bpftool.
>   - Adjust prefixes in commit subjects.
>
> v3:
>   - Remove order-only dependencies on $(LIBBPF_INCLUDE) (or equivalent)
>     directories, given that they are created by libbpf's Makefile.
>   - Add libbpf as a dependency for bpftool/resolve_btfids/runqslower when
>     they are supposed to reuse a libbpf compiled previously. This is to
>     avoid having several libbpf versions being compiled simultaneously in
>     the same directory with parallel builds. Even if this didn't show up
>     during tests, let's remain on the safe side.
>   - kernel/bpf/preload/Makefile: Rename libbpf-hdrs (dash) dependency as
>     libbpf_hdrs.
>   - samples/bpf/.gitignore: Add bpftool/
>   - samples/bpf/Makefile: Change "/bin/rm -rf" to "$(RM) -r".
>   - samples/bpf/Makefile: Add missing slashes for $(LIBBPF_OUTPUT) and
>     $(LIBBPF_DESTDIR) when buildling bpftool
>   - samples/bpf/Makefile: Add a dependency to libbpf's headers for
>     $(TRACE_HELPERS).
>   - bpftool's Makefile: Use $(LIBBPF) instead of equivalent (but longer)
>     $(LIBBPF_OUTPUT)libbpf.a
>   - BPF iterators' Makefile: build bpftool in .output/bpftool (instead of
>     .output/), add and clean up variables.
>   - runqslower's Makefile: Add an explicit dependency on libbpf's headers
>     to several objects. The dependency is not required (libbpf should have
>     been compiled and so the headers exported through other dependencies
>     for those targets), but they better mark the logical dependency and
>     should help if exporting the headers changed in the future.
>   - New commit to add an "install-bin" target to bpftool, to avoid
>     installing bash completion when buildling BPF iterators and selftests.
>
> v2: Declare an additional dependency on libbpf's headers for
>     iterators/iterators.o in kernel/preload/Makefile to make sure that
>     these headers are exported before we compile the object file (and not
>     just before we link it).
>
> Quentin Monnet (12):
>   libbpf: skip re-installing headers file if source is older than target
>   bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
>   bpftool: install libbpf headers instead of including the dir
>   tools/resolve_btfids: install libbpf headers when building
>   tools/runqslower: install libbpf headers when building
>   bpf: preload: install libbpf headers when building
>   bpf: iterators: install libbpf headers when building
>   samples/bpf: update .gitignore
>   samples/bpf: install libbpf headers when building
>   samples/bpf: do not FORCE-recompile libbpf
>   selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
>   bpftool: add install-bin target to install binary only
>
>  kernel/bpf/preload/Makefile                   | 25 ++++++++---
>  kernel/bpf/preload/iterators/Makefile         | 39 +++++++++++------
>  samples/bpf/.gitignore                        |  4 ++
>  samples/bpf/Makefile                          | 42 ++++++++++++++-----
>  tools/bpf/bpftool/Makefile                    | 39 ++++++++++-------
>  tools/bpf/bpftool/gen.c                       |  1 -
>  tools/bpf/bpftool/prog.c                      |  1 -
>  tools/bpf/resolve_btfids/Makefile             | 17 +++++---
>  tools/bpf/resolve_btfids/main.c               |  4 +-
>  tools/bpf/runqslower/Makefile                 | 22 ++++++----
>  tools/lib/bpf/Makefile                        | 24 +++++++----
>  tools/testing/selftests/bpf/Makefile          | 26 ++++++++----
>  .../selftests/bpf/test_bpftool_build.sh       |  4 ++
>  13 files changed, 171 insertions(+), 77 deletions(-)
>
> --
> 2.30.2
>

Tons of ungrateful work, thank you! Applied to bpf-next.

I did a few clean ups (from my POV), see comments on relevant patches.
Also in a bunch of Makefiles I've moved `| $(LIBBPF_OUTPUT)` to the
same line if the line wasn't overly long. 80 characters is not a law,
and I preferred single-line Makefile target definitions, if possible.

There is one problem in bpftool's Makefile, but it works with a
limited case of single file today. Please follow up with a proper fix.

Btw, running make in bpftool's directory, I'm getting:

make[1]: Entering directory '/data/users/andriin/linux/tools/lib/bpf'
make[1]: Entering directory '/data/users/andriin/linux/tools/lib/bpf'
make[1]: Nothing to be done for 'install_headers'.
make[1]: Leaving directory '/data/users/andriin/linux/tools/lib/bpf'
make[1]: Leaving directory '/data/users/andriin/linux/tools/lib/bpf'

Not sure how useful those are, might be better to disable that.

When running libbpf's make, we constantly getting this annoying warning:

Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h'
differs from latest version at 'include/uapi/linux/netlink.h'
Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h'
differs from latest version at 'include/uapi/linux/if_link.h'

If you will get a chance, maybe you can get rid of that as well? I
don't think we need to stay up to date with netlink.h and if_link.h,
so this seems like just a noise.

There was also

make[4]: Nothing to be done for 'install_headers'.

when building the kernel. It probably is coming from either
bpf_preload or iterators, but maybe also resolve_btfids, I didn't try
to narrow this down. Also seems like a noise, tbh. There are similar
useless notifications when building selftests/bpf. If it doesn't take
too much time to clean all that up, I'd greatly appreciate that!

But really great work, thanks for sticking with it!
