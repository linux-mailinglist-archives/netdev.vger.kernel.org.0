Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E3A3D6792
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhGZS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhGZS5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 14:57:40 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDF0C061757;
        Mon, 26 Jul 2021 12:38:08 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s19so16693411ybc.6;
        Mon, 26 Jul 2021 12:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=btxaT5E+I9Dek4XnALC+KhuXbinpHZEGoANUZq1L950=;
        b=TVChJ6YlKmQ4Y3DHGvgC2aJBMD9y7VUX1LF1a8xgANQvQnpqw6Okc3bNTBI+u/Eu+g
         BpGfbM8vHf92jgzkD1NW/qoPtB9Tth9N4fpiEfNZimETtgGYM0tf5qIvuiSVJGVoFWln
         i4VuX5etO4nyJ5xbVC3ZJXxkzZ/ocZ4oTJQ5ittBfAuLE7BUWoavItL3z9PsO7cu3XWT
         ocEX1/O4SvQAvZC9zZe1q1C9322iH7MmuoWYwv2hCgaVeUD9oDf+m+E2kdZWJs/yrX61
         4o5phKOMn8FJu2XUB4x8Q8R+dshUyJzeSPfLQbJe6xUhtg4Tu0anCJtnVmZvg+RJwMNB
         TOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=btxaT5E+I9Dek4XnALC+KhuXbinpHZEGoANUZq1L950=;
        b=JZMV41KKNikcheM0JsAA0Q0+k6eaM3Ddf+peIwRvwOUBdy97yGAxHlZH2bnPw9wq2v
         lQvET4M+GWcEipYBwq+z8XCoTtdr4Rxm/xqq1N7az36+bWKR2LakQRhPHiIh4Qy4OkXL
         UlItN7sKQnt7dBBy98/ASY0KFBYZiZmYwKUpxzqZiqBWHP7DUwI8Uctofv9WQAVZA9iE
         OXp6jv3UPHS5AoFBq5KcjXEHeHGd61zH1XsGqy8x2khipf5NFTCco3eqq/nnAI3H9umd
         gFcuAi5NYLXorQoOnfSYB0HPa17q9gp/AVeDzrrTe+VJxOjGLWEpMYCxiuuvdCh8r1F9
         3FdQ==
X-Gm-Message-State: AOAM532UMnuN3GNR3bPQBHVudqkuXbHMs1hfqoDgZ8ELZpUoSnsgrqN0
        Ix3+Z8TI5d592xRP4YRZFqj/WwXt9O9WBI9vLDs=
X-Google-Smtp-Source: ABdhPJz5r/R4pgHYBVt7dZBXMKi61XdEE3IFNv8CfxCjxPScq+5ga4ZFSZ8LK8mo4VG5XEWjiP0rdOONlHp7skmuCfc=
X-Received: by 2002:a25:9942:: with SMTP id n2mr26605995ybo.230.1627328287645;
 Mon, 26 Jul 2021 12:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Jul 2021 12:37:56 -0700
Message-ID: <CAEf4Bza3nAgUVdaP6sh9XG4oMdawCp55UeAB3Lgjf9opCw_UnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: Move CO-RE logic into separate file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 5:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Split CO-RE processing logic from libbpf into separate file
> with an interface that doesn't dependend on libbpf internal details.
> As the next step relo_core.c will be compiled with libbpf and with the kernel.
> The _internal_ interface between libbpf/CO-RE and kernel/CO-RE will be:
> int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
>                              int insn_idx,
>                              const struct bpf_core_relo *relo,
>                              int relo_idx,
>                              const struct btf *local_btf,
>                              struct bpf_core_cand_list *cands);
> where bpf_core_relo and bpf_core_cand_list are simple types
> prepared by kernel and libbpf.
>
> Though diff stat shows a lot of lines inserted/deleted they are moved lines.
> Pls review with diff.colorMoved.
>
> Alexei Starovoitov (4):
>   libbpf: Cleanup the layering between CORE and bpf_program.
>   libbpf: Split bpf_core_apply_relo() into bpf_program indepdent helper.
>   libbpf: Move CO-RE types into relo_core.h.
>   libbpf: Split CO-RE logic into relo_core.c.
>

LGTM. Applied to bpf-next, fixed typo in patch 3 subject, and also
made few adjustments. Let me know if you object to any of them:

1. I felt like the original copyright year should be preserved when
moving code into a new file, so I've changed relo_core.h's year to
2019. Hope that's fine.
2. relo_core.c didn't have a Copyright line, so I added the /*
Copyright (c) 2019 Facebook */ as well.
3. I trimmed down the list of #includes in core_relo.c, because most
of them were absolutely irrelevant and just preserved as-is from
libbpf.c Everything seems to compile just fine without those.

>  tools/lib/bpf/Build             |    2 +-
>  tools/lib/bpf/libbpf.c          | 1344 +------------------------------
>  tools/lib/bpf/libbpf_internal.h |   81 +-
>  tools/lib/bpf/relo_core.c       | 1326 ++++++++++++++++++++++++++++++
>  tools/lib/bpf/relo_core.h       |  102 +++
>  5 files changed, 1473 insertions(+), 1382 deletions(-)
>  create mode 100644 tools/lib/bpf/relo_core.c
>  create mode 100644 tools/lib/bpf/relo_core.h
>
> --
> 2.30.2
>
