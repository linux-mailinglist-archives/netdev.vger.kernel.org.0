Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590FB5C0E9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfGAQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:10:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37689 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfGAQKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:10:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh12so7578959plb.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N2Uf2cCAYbzuCUem1tyG4B47u6mWDhxVH7gcw4H7xAc=;
        b=DnUnhLNKaqz03i/Ct4xF9QTy8PszygnzQjTRtd499X153pcWJ4rHQlxnfFvx4L7UVg
         ml5VYmSCSl822IlshDoQjtejtkgmQrP/h97GxoYPmY2JW70CokiDtH1mDSZJpNgEWGDR
         BiI+TMiTxK7+Wvk1eFlejThBnXJP7OqNYqf/xfP2FO+DmAYniS7/bDNsyCrTTUQb146x
         r3uEsPs98g6QhjoBIAT2DGXtjHy7gII9m7A6JpXahDf65A1U3O7sbqn6cXVYbrxwIu1e
         Aa6kQuq0Fi6hG6MxPvtVzZWuCSibrpvY/rkbtsw6JUTvJEA/aflsCwglXFrmR99woOmm
         6GLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N2Uf2cCAYbzuCUem1tyG4B47u6mWDhxVH7gcw4H7xAc=;
        b=NSvSj9ZkvKZ6HEEznjyuTtiJa0xJM7JwAxv5ygnzBOoFilAS6TvSmVFSFRjJ0LvR0W
         2tiDmKhLi2RSiJd9X6H3xxHWrZnqtute7OlzSJXPDjsspOEZEYeKvc5EGqv0o4TZowNP
         5zZUf0g0rNkPsTYCyqpvBnpzqLdz1C4OzWfDoXqi7ZNyRHVhDGTKfO8vmOJQ9/9OG93h
         lGHioyf5MBCvS3CIsuqnjMOgQS0J0LgElOZRd1wHJs6pGCE/jQPsYCJDDsflAdraTQxh
         UMbnAnqQKzCEeEUc4rIqFRA0hlWRt/CNY/nEdASlou7MkY4O/8x4gYdFSKxCQoLJN8P2
         bjUw==
X-Gm-Message-State: APjAAAVywmL0BbrYyzcVh9dulqxRCsLoL37Km1oWpb/iN0xAnkeJPCnW
        491R41OhaEG44vwG+rhwH5jQyQ==
X-Google-Smtp-Source: APXvYqwdVMK7/BppSCHOF5OQ1Bo+N5aJNmlh2C8q0CoeYbFxIB3M5kGOJecqDzC4qxGvc1M87CO4tw==
X-Received: by 2002:a17:902:205:: with SMTP id 5mr27893497plc.165.1561997447087;
        Mon, 01 Jul 2019 09:10:47 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a21sm13878695pfi.27.2019.07.01.09.10.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 09:10:46 -0700 (PDT)
Date:   Mon, 1 Jul 2019 09:10:45 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com, songliubraving@fb.com
Subject: Re: [PATCH v4 bpf-next 0/9] libbpf: add bpf_link and tracing attach
 APIs
Message-ID: <20190701161045.GE6757@mini-arch>
References: <20190629034906.1209916-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629034906.1209916-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28, Andrii Nakryiko wrote:
> This patchset adds the following APIs to allow attaching BPF programs to
> tracing entities:
> - bpf_program__attach_perf_event for attaching to any opened perf event FD,
>   allowing users full control;
> - bpf_program__attach_kprobe for attaching to kernel probes (both entry and
>   return probes);
> - bpf_program__attach_uprobe for attaching to user probes (both entry/return);
> - bpf_program__attach_tracepoint for attaching to kernel tracepoints;
> - bpf_program__attach_raw_tracepoint for attaching to raw kernel tracepoint
>   (wrapper around bpf_raw_tracepoint_open);
> 
> This set of APIs makes libbpf more useful for tracing applications.
> 
> All attach APIs return abstract struct bpf_link that encapsulates logic of
> detaching BPF program. See patch #2 for details. bpf_assoc was considered as
> an alternative name for this opaque "handle", but bpf_link seems to be
> appropriate semantically and is nice and short.
> 
> Pre-patch #1 makes internal libbpf_strerror_r helper function work w/ negative
> error codes, lifting the burder off callers to keep track of error sign.
> Patch #2 adds bpf_link abstraction.
> Patch #3 adds attach_perf_event, which is the base for all other APIs.
> Patch #4 adds kprobe/uprobe APIs.
> Patch #5 adds tracepoint API.
> Patch #6 adds raw_tracepoint API.
> Patch #7 converts one existing test to use attach_perf_event.
> Patch #8 adds new kprobe/uprobe tests.
> Patch #9 converts some selftests currently using tracepoint to new APIs.
> 
> v3->v4:
> - proper errno handling (Stanislav);
> - bpf_fd -> prog_fd (Stanislav);
> - switch to fprintf (Song);
Reviewed-by: Stanislav Fomichev <sdf@google.com>

Thanks!

> v2->v3:
> - added bpf_link concept (Daniel);
> - didn't add generic bpf_link__attach_program for reasons described in [0];
> - dropped Stanislav's Reviewed-by from patches #2-#6, in case he doesn't like
>   the change;
> v1->v2:
> - preserve errno before close() call (Stanislav);
> - use libbpf_perf_event_disable_and_close in selftest (Stanislav);
> - remove unnecessary memset (Stanislav);
> 
> [0] https://lore.kernel.org/bpf/CAEf4BzZ7EM5eP2eaZn7T2Yb5QgVRiwAs+epeLR1g01TTx-6m6Q@mail.gmail.com/
> 
> Andrii Nakryiko (9):
>   libbpf: make libbpf_strerror_r agnostic to sign of error
>   libbpf: introduce concept of bpf_link
>   libbpf: add ability to attach/detach BPF program to perf event
>   libbpf: add kprobe/uprobe attach API
>   libbpf: add tracepoint attach API
>   libbpf: add raw tracepoint attach API
>   selftests/bpf: switch test to new attach_perf_event API
>   selftests/bpf: add kprobe/uprobe selftests
>   selftests/bpf: convert existing tracepoint tests to new APIs
> 
>  tools/lib/bpf/libbpf.c                        | 359 ++++++++++++++++++
>  tools/lib/bpf/libbpf.h                        |  21 +
>  tools/lib/bpf/libbpf.map                      |   8 +-
>  tools/lib/bpf/str_error.c                     |   2 +-
>  .../selftests/bpf/prog_tests/attach_probe.c   | 155 ++++++++
>  .../bpf/prog_tests/stacktrace_build_id.c      |  50 +--
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  31 +-
>  .../selftests/bpf/prog_tests/stacktrace_map.c |  43 +--
>  .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  15 +-
>  .../selftests/bpf/progs/test_attach_probe.c   |  55 +++
>  10 files changed, 644 insertions(+), 95 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
> 
> -- 
> 2.17.1
> 
