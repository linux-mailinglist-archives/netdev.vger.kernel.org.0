Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDCB26B937
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgIPBHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 21:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgIPBHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 21:07:13 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4583C06174A;
        Tue, 15 Sep 2020 18:07:12 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e11so4130798ybk.1;
        Tue, 15 Sep 2020 18:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8rvtBX4vgtDOA20OKyn0AkigdrZY7xvJPqabnSeYFY=;
        b=YOHJ36Bav7Oimg+tE9xf9VOfKo+kPDdKW+D0Lu7tHU4XOyBahxHBEsCceghvLubzfV
         beJkWppSYvLTfBBbf+o9BIBiF//XwcCLXJtZ9XmrN+m2QZB7pZtDkwwWWUlMDueYsqhN
         xXdBJtouBTIUf9XFgpUaAs7d+VbX3MoR2zVf+K+tekijgpahXAbzCGPhhHlDJulrv7/i
         XGsxAVPU2bvCkhg7fSsx4RgheFLIxAc0uM7oT9bFJs41a+I7hIAJ/V2Q/V90CR413AGg
         sg53pSKQQ3CpG7O52aAyWFG1Vnyd7A9llrDApozsd1BsHEcmm4I+zwcOnI3BSzVIc/g+
         IMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8rvtBX4vgtDOA20OKyn0AkigdrZY7xvJPqabnSeYFY=;
        b=e/OlQaWLhXK4gArEfThSUlF7dLqknTiNfpjqQ9n0P/wxEY2G57GnWPZPkb2wP2cpdy
         zaeh8V6IT6ddWIliFKTGAMZzCUGKdNNNc/V0q1J738+GiwkjD/gjAY0DO+KDxvy+jYRO
         slmFrdvZnfd76Z37gdol7St6v4kd6e+JX8ksFop09E/n/Mxp0bBhKJ91sD6jrqgEofS8
         G31xXfw3LNiUo/9NX+Lty108sxzbEP2AfM/FHxzFcOx/QIjYfiNS7u8r3u/ZWAwo74RV
         NfH2ZG3etDltf8bBgEc0uJeHim/YSYBfbua3CejH2Z4isiWq40NfAdItzZBq4kw68q/y
         Om/g==
X-Gm-Message-State: AOAM532X9wvkgBtdqR082cbQvV3P5IzB+X1dT6AKaj88YVPOzESnaNPE
        Yzo/Q4rf++g1GY3KszSn/PxR1GbVRZ0/nHH356g=
X-Google-Smtp-Source: ABdhPJw6y4sV3yhfIgUeXPahzJ4oGx+nvipxKbf0GW4gIg6YFwoaQ5Er8IqPm04IQLfCVrMXfuFDv9tRK7hj+tQnBdA=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr17433468ybz.27.1600218432006;
 Tue, 15 Sep 2020 18:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200915234543.3220146-1-sdf@google.com>
In-Reply-To: <20200915234543.3220146-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Sep 2020 18:07:01 -0700
Message-ID: <CAEf4BzaVw78Vtwyz2Cvue3H9V3JT4wLcuKp9xmeK2oEHKj9b4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/5] Allow storage of flexible metadata
 information for eBPF programs
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 4:47 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Currently, if a user wants to store arbitrary metadata for an eBPF
> program, for example, the program build commit hash or version, they
> could store it in a map, and conveniently libbpf uses .data section to
> populate an internal map. However, if the program does not actually
> reference the map, then the map would be de-refcounted and freed.
>
> This patch set introduces a new syscall BPF_PROG_BIND_MAP to add a map
> to a program's used_maps, even if the program instructions does not
> reference the map.
>
> libbpf is extended to always BPF_PROG_BIND_MAP .rodata section so the
> metadata is kept in place.
> bpftool is also extended to print metadata in the 'bpftool prog' list.
>
> The variable is considered metadata if it starts with the
> magic 'bpf_metadata_' prefix; everything after the prefix is the
> metadata name.
>
> An example use of this would be BPF C file declaring:
>
>   volatile const char bpf_metadata_commit_hash[] SEC(".rodata") = "abcdef123456";
>
> and bpftool would emit:
>
>   $ bpftool prog
>   [...]
>         metadata:
>                 commit_hash = "abcdef123456"
>

[...]

>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
>
> YiFei Zhu (5):
>   bpf: Mutex protect used_maps array and count
>   bpf: Add BPF_PROG_BIND_MAP syscall
>   libbpf: Add BPF_PROG_BIND_MAP syscall and use it on .rodata section
>   bpftool: support dumping metadata
>   selftests/bpf: Test load and dump metadata with btftool and skel
>
>  .../net/ethernet/netronome/nfp/bpf/offload.c  |  18 +-
>  include/linux/bpf.h                           |   1 +
>  include/uapi/linux/bpf.h                      |   7 +
>  kernel/bpf/core.c                             |  15 +-
>  kernel/bpf/syscall.c                          |  79 ++++++-
>  net/core/dev.c                                |  11 +-
>  tools/bpf/bpftool/json_writer.c               |   6 +
>  tools/bpf/bpftool/json_writer.h               |   3 +
>  tools/bpf/bpftool/prog.c                      | 199 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |   7 +
>  tools/lib/bpf/bpf.c                           |  16 ++
>  tools/lib/bpf/bpf.h                           |   8 +
>  tools/lib/bpf/libbpf.c                        |  69 ++++++
>  tools/lib/bpf/libbpf.map                      |   1 +
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../selftests/bpf/prog_tests/metadata.c       | 141 +++++++++++++
>  .../selftests/bpf/progs/metadata_unused.c     |  15 ++
>  .../selftests/bpf/progs/metadata_used.c       |  15 ++
>  .../selftests/bpf/test_bpftool_metadata.sh    |  82 ++++++++
>  19 files changed, 678 insertions(+), 18 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
>  create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh
>
> --
> 2.28.0.618.gf4bc123cb7-goog
>

LGTM, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>
