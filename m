Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820BD3CB11F
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 05:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhGPDbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 23:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhGPDbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 23:31:10 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E682C06175F;
        Thu, 15 Jul 2021 20:28:15 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id l5so9045181iok.7;
        Thu, 15 Jul 2021 20:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4Wm/WcfvChzY1n3xKdeSo/L+Jjb58D+mQ8SN2mRuWcI=;
        b=F4blgolhuYvulz5Nk3jwBKcI8qg6ito7gHyeajxUACwyS2QfqU0zTvsabKlZwasChS
         WNeyDIxLQMTKN/sGwy9ZwAPXhayJzeMpVbn+C72FBn+RVVFAan8dz1VZ29kpN9LQsHsV
         D9qQmeIGLVeKzCLHsP4uw8p71gGOHacSsL6DfRATY6BtLQ/6ySE9wrS5q4u6ZXsIcsul
         lLqA06TiU46zDetVjkopHPTdD9aD7P9z0kNQIwR5relz4cPyypB4Z2JqqrV5Ddsb+xQ4
         VUeULoQ/UQ55dkup24cf9eWv349b3fkSGRz+JicV2Rq7j6Q0sh4cGb52YzzGy9mKVZww
         7BNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4Wm/WcfvChzY1n3xKdeSo/L+Jjb58D+mQ8SN2mRuWcI=;
        b=Kr469vVP2KETWgepzE+alkOZyuTpDF1Kj9WZW6aPEMRk+gUFeIFuHAwU1vmjGq4l9F
         xC5068kJUKueZCKZ6mPvdfq8wFjCeXCyYggv6O7vs+4iMQAunqMQWQKZ5wxNAeVVA5oS
         4i7ttBOscBJACNYd8/LjNgUcCoa1w55mhf9JOa5gvCdwRNa1LqQNWgCFEQ96NT27VmfZ
         7FH/2d8k6GMNB3Mx8owkbGGGfwoABEq4sbHgHw/7rERFhDUYMg6m5oNgw3hbEs0Le6ML
         8+cRVfcaGoXTpRY8juKng8/xBH+LmipxdG4v9KB9RDWKj4oook9d7MXKVujobChTycPe
         AThQ==
X-Gm-Message-State: AOAM532WY2Q/exb5jPE6G6i9RKGKUxu62liW8eOGIGStmY3DXyi9bsTa
        8T02SDfyuT2esRYAZEo8HzKNVFDp+WbIgA==
X-Google-Smtp-Source: ABdhPJzTBPgxZW6QcvRqJh8mEm0iHCBVaEB74uti13bmyD1t89bhSRv3DkCiW1F5Ha0c8Af/wRSQcw==
X-Received: by 2002:a5d:858b:: with SMTP id f11mr5736438ioj.156.1626406094817;
        Thu, 15 Jul 2021 20:28:14 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x16sm3957554ila.84.2021.07.15.20.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 20:28:14 -0700 (PDT)
Date:   Thu, 15 Jul 2021 20:28:08 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Message-ID: <60f0fcc88e369_41062086b@john-XPS-13-9370.notmuch>
In-Reply-To: <20210714141532.28526-1-quentin@isovalent.com>
References: <20210714141532.28526-1-quentin@isovalent.com>
Subject: RE: [PATCH bpf-next 0/6] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet wrote:
> As part of the effort to move towards a v1.0 for libbpf [0], this set
> improves some confusing function names related to BTF loading from and to
> the kernel:
> 
> - btf__load() becomes btf__load_into_kernel().
> - btf__get_from_id becomes btf__load_from_kernel_by_id().
> - A new version btf__load_from_kernel_by_id_split() extends the former to
>   add support for split BTF.
> 
> The old functions are not removed yet, but marked as deprecated.
> 
> The last patch is a trivial change to bpftool to add support for dumping
> split BTF objects by referencing them by their id (and not only by their
> BTF path).
> 
> [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
> 
> Quentin Monnet (6):
>   libbpf: rename btf__load() as btf__load_into_kernel()
>   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
>   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
>   libbpf: explicitly mark btf__load() and btf__get_from_id() as
>     deprecated
>   libbpf: add split BTF support for btf__load_from_kernel_by_id()
>   tools: bpftool: support dumping split BTF by id
> 
>  tools/bpf/bpftool/btf.c                      |  2 +-
>  tools/bpf/bpftool/btf_dumper.c               |  2 +-
>  tools/bpf/bpftool/map.c                      |  4 ++--
>  tools/bpf/bpftool/prog.c                     |  6 +++---
>  tools/lib/bpf/btf.c                          | 15 ++++++++++++---
>  tools/lib/bpf/btf.h                          | 10 ++++++++--
>  tools/lib/bpf/libbpf.c                       |  4 ++--
>  tools/lib/bpf/libbpf.map                     |  7 +++++++
>  tools/perf/util/bpf-event.c                  |  4 ++--
>  tools/perf/util/bpf_counter.c                |  2 +-
>  tools/testing/selftests/bpf/prog_tests/btf.c |  2 +-
>  11 files changed, 40 insertions(+), 18 deletions(-)
> 
> -- 
> 2.30.2
> 

For the series.

Acked-by: John Fastabend <john.fastabend@gmail.com>
