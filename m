Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E710D21BEB8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgGJUqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGJUqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:46:14 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6E4C08C5DC;
        Fri, 10 Jul 2020 13:46:14 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so6621630qkg.5;
        Fri, 10 Jul 2020 13:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=erTEeMiR9eRBV/VUxOEgctkr+sYfZE4NGNUsVEgyRnU=;
        b=bhqjkIgaoBpFkY2Uobl4PdYEv8g/nUuHhTxmveKvIKjYSt27zeS1QVbL7rK+IHBmow
         7BlWGL2XBSX2UC4TlxK7RW107EgKxiWzPoNr4cYGCRbyc9KX0DRmHttlKh/l7zyc5jTY
         fNSlpsiVz8fSslWNs02xvtbhpJ1VGfmYFFNvy6Sip0g8q4a+IC7YUUuLk9iA+0pSaV1E
         /jl6bzJRIc6QC9JfLO95ImVH4l2S9WzzLd8Vi4iZoSamsx7RMZq+oxU07fsiyZ2hrJDI
         hIV0D9wUbqgj8shIBYQsDDdPkvWNXbFl3Gru8xCSIDs/oSxLhr7SzKOYcrlSuMrK6iWT
         qAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=erTEeMiR9eRBV/VUxOEgctkr+sYfZE4NGNUsVEgyRnU=;
        b=FVkXrbrftJ6nvg8UaUBrwUsgVUKmI0W4zKcd49tdh9COLf2uRBnMkEwQ+00bsje9Yf
         ZDIlM4faN+vCsXlqqc5nYDON5oTrlRyXKaJDR3tI/iNT0rjOvmvmLmzhjJnPmRcuXqFx
         qVJZp9v5MRRSBK5aq6JJHd0kIgxLOikefhyjez2bqOUBb7TTlZ21Nmr76aYW6nZY75f+
         hP2l5hdCyvFn2i9QgM0YP5A9FKIC7/tX5doXsEmfTBUzo+7Zc7EBrv0dn0vlVRA31C3M
         9jFb4WIO/j0iEnmWobDVoJZxiUnYQRxVwFEYkzPh2joRbWZJ+IKdsPXL1fYhMUG5u++e
         nndw==
X-Gm-Message-State: AOAM530pXom/CFUQuUA/OYrk4yEI/O47bi+JL2gbGZpEI56Q+lW+6sbI
        TsqvJ9/8LC8EV519P+sZvxkQyt6gpHGs9yIes+I=
X-Google-Smtp-Source: ABdhPJyVbPGdhf4Z1XQ3/FZWEY0seUTuWppPuL1WrCKFddA2g816s/Yp3GGYVj0sDS7aoHXpR3rgRttzRIFcCNHbT2I=
X-Received: by 2002:a05:620a:1666:: with SMTP id d6mr72559108qko.449.1594413973338;
 Fri, 10 Jul 2020 13:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200710193754.3821104-1-jolsa@kernel.org>
In-Reply-To: <20200710193754.3821104-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 13:46:02 -0700
Message-ID: <CAEf4BzbejJeaG-kffJf-tM_a7kMDET7n3Nu4dJB+jKRicc90Qw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/9] bpf: Add d_path helper - preparation changes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 12:38 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> this patchset does preparation work for adding d_path helper,
> which still needs more work, but the initial set of patches
> is ready and useful to have.
>
> This patchset adds:
>   - support to generate BTF ID lists that are resolved during
>     kernel linking and usable within kernel code with following
>     macros:
>
>       BTF_ID_LIST(bpf_skb_output_btf_ids)
>       BTF_ID(struct, sk_buff)
>
>     and access it in kernel code via:
>       extern u32 bpf_skb_output_btf_ids[];
>
>   - resolve_btfids tool that scans elf object for .BTF_ids
>     section and resolves its symbols with BTF ID values
>   - resolving of bpf_ctx_convert struct and several other
>     objects with BTF_ID_LIST
>
> v6 changes:
>   - added acks
>   - added general make rule to resolve_btfids Build [Andrii]
>   - renamed .BTF.ids to .BTF_ids [Andrii]
>   - added --no-fail option to resolve_btfids [Andrii]
>   - changed resolve_btfids test to work over BTF from object
>     file, so we don't depend on vmlinux BTF [Andrii]
>   - fixed few typos [Andrii]
>   - fixed the out of tree build [Andrii]
>
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/d_path
>
> thanks,
> jirka
>
>
> ---

You've missed fixing bpf_get_task_stack_proto with your
BTF_IDS_LIST/BTF_ID macro. It's currently failing in subtests. With
BTF_IDS_LIST/BTF_ID trivial fix it works again. Please fix that before
this can be applied.

btf_data.c could also use some name-conflicting entries, just to make
sure that kind (struct vs typedef) is taken into account. Maybe just
add some dummy `typedef int S;` or something?

So with the above, please add for the next revision:

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>

> Jiri Olsa (9):
>       bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
>       bpf: Compile resolve_btfids tool at kernel compilation start
>       bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros
>       bpf: Resolve BTF IDs in vmlinux image
>       bpf: Remove btf_id helpers resolving
>       bpf: Use BTF_ID to resolve bpf_ctx_convert struct
>       bpf: Add info about .BTF_ids section to btf.rst
>       tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
>       selftests/bpf: Add test for resolve_btfids
>
>  Documentation/bpf/btf.rst                               |  36 +++++
>  Makefile                                                |  25 +++-
>  include/asm-generic/vmlinux.lds.h                       |   4 +
>  include/linux/btf_ids.h                                 |  87 ++++++++++++
>  kernel/bpf/btf.c                                        | 103 ++------------
>  kernel/trace/bpf_trace.c                                |   9 +-
>  net/core/filter.c                                       |   9 +-
>  scripts/link-vmlinux.sh                                 |   6 +
>  tools/Makefile                                          |   3 +
>  tools/bpf/Makefile                                      |   9 +-
>  tools/bpf/resolve_btfids/Build                          |  10 ++
>  tools/bpf/resolve_btfids/Makefile                       |  77 +++++++++++
>  tools/bpf/resolve_btfids/main.c                         | 721 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/include/linux/btf_ids.h                           |  87 ++++++++++++
>  tools/include/linux/compiler.h                          |   4 +
>  tools/testing/selftests/bpf/Makefile                    |  14 +-
>  tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 107 ++++++++++++++
>  tools/testing/selftests/bpf/progs/btf_data.c            |  26 ++++
>  18 files changed, 1234 insertions(+), 103 deletions(-)
>  create mode 100644 include/linux/btf_ids.h
>  create mode 100644 tools/bpf/resolve_btfids/Build
>  create mode 100644 tools/bpf/resolve_btfids/Makefile
>  create mode 100644 tools/bpf/resolve_btfids/main.c
>  create mode 100644 tools/include/linux/btf_ids.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
>  create mode 100644 tools/testing/selftests/bpf/progs/btf_data.c
>
