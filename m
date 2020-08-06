Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6417123DF9C
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgHFRvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729705AbgHFRuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:50:11 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57736C061574;
        Thu,  6 Aug 2020 10:50:11 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x2so5977925ybf.12;
        Thu, 06 Aug 2020 10:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8UHleMBazRSAjivcnBja6O0vBcnfRU+sD5hTA4lBxyY=;
        b=YnJkR9pRs626Ju4veJYXUiX5afJoPSBg5sIPIEMGAOgLhc80HG5rxk2zvUjcIwsDVS
         g9ACFt6aJZwRbynC8TmhWvmOrdN32RMPufBHZZX9gN9vXsIWB0zB09LWsD2b2rl8MjiD
         ZDgUZDfSt+ufXX3QSjkaWjdX2L9VsSmTxb0qlAIv7N7FL1tCQ6E1TxA8dUlILwFJDRpM
         ssZpO0jS9B+6YgU5meGSrUzFPvvIqKRz068O99R0AXV8lPX1dOAlf2Mrae/mnp0Dd6ie
         XB76i4NnndknEtW1u/DLvFM8WmSwdtdIzsg8+AevQvQS+uu1eTqlcJag69F+K5w3nLv+
         BsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UHleMBazRSAjivcnBja6O0vBcnfRU+sD5hTA4lBxyY=;
        b=XQcsl65HxmeiKQjLgd9qguJzV8TQJV1Vbw9zAZaDmV96ATEFYgyXtw+VK3SxmvzpD0
         AiR6J9TMLCThCAB52v7wcnmwpGQd8fia6UfDMsVa0AJgLjMMCbSZjE1Apfplgmvop/+o
         X5SUXvaE3H0c+ZkC5s4JBUvS+8uSlZamgkwoDRUMM6IlMRhTvlqfLnAlecPRGAquMiHD
         FCk+hMidXHmxQrvWIFj4Rr9JQHMP/gI3pPC8fbEOnxocB6bhRRahIw7LonVxjDCvSyih
         fKgd6WYL6oxszqdcA50IyxWksfUXsudjIbMeGdEMu7+S90VQ8k369qko1Pq8PSXSGP4s
         Y7Ag==
X-Gm-Message-State: AOAM532EYRTSB9+UQIG6bXISkfGRRqjCcxsSQUEvc0IavwMVjYnXqOwU
        Q3bI7RBhnalS8PTGNDvOGnyYmetQQY72ZPRNYcY=
X-Google-Smtp-Source: ABdhPJzu9faZnv6CZX9Pq7ZInAP6XXIGsSVCif9fCygrKzUM1zf1RwiOEk6tQbAnzFH9/gPca6kL1AN+eQ/SExOOWtk=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr14688825ybg.459.1596736210259;
 Thu, 06 Aug 2020 10:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200802013219.864880-1-andriin@fb.com> <20200806173931.GJ71359@kernel.org>
In-Reply-To: <20200806173931.GJ71359@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Aug 2020 10:49:59 -0700
Message-ID: <CAEf4BzbQTg7ct0+JpSFY2rQ4H8j6vScb0z_wJ-PeFqDzS=aE7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Add generic and raw BTF parsing APIs to libbpf
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 10:39 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Sat, Aug 01, 2020 at 06:32:16PM -0700, Andrii Nakryiko escreveu:
> > It's pretty common for applications to want to parse raw (binary) BTF data
> > from file, as opposed to parsing it from ELF sections. It's also pretty common
> > for tools to not care whether given file is ELF or raw BTF format. This patch
> > series exposes internal raw BTF parsing API and adds generic variant of BTF
> > parsing, which will efficiently determine the format of a given fail and will
> > parse BTF appropriately.
> >
> > Patches #2 and #3 removes re-implementations of such APIs from bpftool and
> > resolve_btfids tools.
> >
> > Andrii Nakryiko (3):
> >   libbpf: add btf__parse_raw() and generic btf__parse() APIs
> >   tools/bpftool: use libbpf's btf__parse() API for parsing BTF from file
> >   tools/resolve_btfids: use libbpf's btf__parse() API
>
> I haven't checked which of the patches, or some in other series caused
> this on Clear Linux:
>
>   21 clearlinux:latest             : FAIL gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41, clang ver
> sion 10.0.1
>
>   gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41
>
>   btf.c: In function 'btf__parse_raw':
>   btf.c:625:28: error: 'btf' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>     625 |  return err ? ERR_PTR(err) : btf;
>         |         ~~~~~~~~~~~~~~~~~~~^~~~~
>

Yeah, fixed in https://patchwork.ozlabs.org/project/netdev/patch/20200805223359.32109-1-danieltimlee@gmail.com/

> This is what I have:
>
> [acme@quaco perf]$ git log -10 --oneline tools/lib/bpf
> 94a1fedd63ed libbpf: Add btf__parse_raw() and generic btf__parse() APIs
> 2e49527e5248 libbpf: Add bpf_link detach APIs
> 1acf8f90ea7e libbpf: Fix register in PT_REGS MIPS macros
> 50450fc716c1 libbpf: Make destructors more robust by handling ERR_PTR(err) cases
> dc8698cac7aa libbpf: Add support for BPF XDP link
> d4b4dd6ce770 libbpf: Print hint when PERF_EVENT_IOC_SET_BPF returns -EPROTO
> cd31039a7347 tools/libbpf: Add support for bpf map element iterator
> da7a35062bcc libbpf bpf_helpers: Use __builtin_offsetof for offsetof
> 499dd29d90bb libbpf: Add support for SK_LOOKUP program type
> 4be556cf5aef libbpf: Add SEC name for xdp programs attached to CPUMAP
> [acme@quaco perf]$
>
> >  tools/bpf/bpftool/btf.c             |  54 +------------
> >  tools/bpf/resolve_btfids/.gitignore |   4 +
> >  tools/bpf/resolve_btfids/main.c     |  58 +-------------
> >  tools/lib/bpf/btf.c                 | 114 +++++++++++++++++++---------
> >  tools/lib/bpf/btf.h                 |   5 +-
> >  tools/lib/bpf/libbpf.map            |   2 +
> >  6 files changed, 89 insertions(+), 148 deletions(-)
> >  create mode 100644 tools/bpf/resolve_btfids/.gitignore
> >
> > --
> > 2.24.1
> >
>
> --
>
> - Arnaldo
