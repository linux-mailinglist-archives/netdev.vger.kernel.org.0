Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C004517937B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbgCDPfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:35:06 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34020 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388024AbgCDPfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:35:05 -0500
Received: by mail-qk1-f193.google.com with SMTP id f3so2007830qkh.1;
        Wed, 04 Mar 2020 07:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4RuF7jp06Gdp9+c9iYskCOTXb6vXMZn80rDacpfYvA=;
        b=nYfm1EWfWF3B3Cl2NTdBNc6KwOTd3NqyvdqdbP1UtzWsetwd25N3fgCGmwOgXoFH8e
         sg2DMNr5Rrd5iZzD6kqyoC+QLoAJMggnQQx9zbDWeohjgr++N6WUtJYQSKla5ceUoOUA
         Skh42L/yaoo8RAxVJOzjjYlvoi1SkAowVwj/lII2QK1T0YtFR3FXbQUoXRlibq86m8MI
         d4sEi0sCh23sKXXn288akG5A04JmoY4GdYsLk19PZxV0Mdq7pqQshbAzJU8Jc9ql6myP
         WebJ/DlCJm0mCUDZ2YXeKsbRAXom0pH8XBo/hITIzTAQDyEgigX5Ii6mxsAHxgohkBx0
         PZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4RuF7jp06Gdp9+c9iYskCOTXb6vXMZn80rDacpfYvA=;
        b=IPbkncYZDBswWFwi1Z3WWqUIKxhTPqjBgJNiqUxS1rHTmjL9qJKcXgHPTRBAXJq4tZ
         uj3IV09HpJItTDCdvhglibk0FsiNRgbiZg7lkhuvhJ0f9ntdKOvIhFC2r4SfU0jL4Eu0
         /suexAbnbPL8GNqwAg/EaD/l8K3APrG9P9dIjPU//8JxIb7Q7GZ/4n1t3+X7fAvDxHhB
         iud02FguPDRld1E0t+V3NlJiGW3Vb+642fi6ZB6zs9g05CoznXjgLNAh1T8cjeGIgBOu
         /hYptHiGPlZAWd79ZjKrBz6tQXnEJu/alGiyGPdVfYk7/hE1dJcTUK9Dv/4/loFK45X0
         WDgQ==
X-Gm-Message-State: ANhLgQ3pz8a6Mtr/E+Dcw6gnUwpmz2n6Lt1FnDIAWRn1QUQzU/NyI+eY
        T0w9D+rXhcWhEoaH4uK3RGZH5kokMA7sQVyxrKs=
X-Google-Smtp-Source: ADFU+vsfF6f/QsPVQD8JAsdWPqh3ED1MmSoB4yziYJP4/R5Jfvnw4k+GhEKPA4TN+IN9dV7x3kvVqt9lKpc1mbGJULA=
X-Received: by 2002:a05:620a:99d:: with SMTP id x29mr3476120qkx.39.1583336104782;
 Wed, 04 Mar 2020 07:35:04 -0800 (PST)
MIME-Version: 1.0
References: <20200303003233.3496043-1-andriin@fb.com> <47bbaa27-a112-b4a5-6251-d8aad31937a5@iogearbox.net>
In-Reply-To: <47bbaa27-a112-b4a5-6251-d8aad31937a5@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Mar 2020 07:34:53 -0800
Message-ID: <CAEf4BzZjboTyWE9LjdnRu+5ja2WqtHZRgEtMJc4w8B0F_wY-kw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/3] Convert BPF UAPI constants into enum values
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 7:21 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> > Convert BPF-related UAPI constants, currently defined as #define macro, into
> > anonymous enums. This has no difference in terms of usage of such constants in
> > C code (they are still could be used in all the compile-time contexts that
> > `#define`s can), but they are recorded as part of DWARF type info, and
> > subsequently get recorded as part of kernel's BTF type info. This allows those
> > constants to be emitted as part of vmlinux.h auto-generated header file and be
> > used from BPF programs. Which is especially convenient for all kinds of BPF
> > helper flags and makes CO-RE BPF programs nicer to write.
> >
> > libbpf's btf_dump logic currently assumes enum values are signed 32-bit
> > values, but that doesn't match a typical case, so switch it to emit unsigned
> > values. Once BTF encoding of BTF_KIND_ENUM is extended to capture signedness
> > properly, this will be made more flexible.
> >
> > As an immediate validation of the approach, runqslower's copy of
> > BPF_F_CURRENT_CPU #define is dropped in favor of its enum variant from
> > vmlinux.h.
> >
> > v2->v3:
> > - convert only constants usable from BPF programs (BPF helper flags, map
> >    create flags, etc) (Alexei);
> >
> > v1->v2:
> > - fix up btf_dump test to use max 32-bit unsigned value instead of negative one.
> >
> >
> > Andrii Nakryiko (3):
> >    bpf: switch BPF UAPI #define constants used from BPF program side to
> >      enums
> >    libbpf: assume unsigned values for BTF_KIND_ENUM
> >    tools/runqslower: drop copy/pasted BPF_F_CURRENT_CPU definiton
> >
> >   include/uapi/linux/bpf.h                      | 175 ++++++++++-------
> >   tools/bpf/runqslower/runqslower.bpf.c         |   3 -
> >   tools/include/uapi/linux/bpf.h                | 177 +++++++++++-------
> >   tools/lib/bpf/btf_dump.c                      |   8 +-
> >   .../bpf/progs/btf_dump_test_case_syntax.c     |   2 +-
> >   5 files changed, 224 insertions(+), 141 deletions(-)
> >
>
> Applied, thanks!

Great, thanks! This is a huge usability boost for BPF programs relying
on vmlinux.h!
