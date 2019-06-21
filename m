Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493C34F071
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 23:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFUVVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 17:21:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37867 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUVVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 17:21:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so4212113pfa.4
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 14:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lf/zzWbu1p+7OZLhl2YtTpKCGw8MMulN9uhF5nuMqCI=;
        b=r3U4/GAx1NlqiBaFHo4dgUuRt4R1I113stunqIxHWb8g8lre/apwMg5gHcounI4nsG
         sCkUj3QnxtRPW+v0FYbq189D3k5Cv9RW+0Jv1k6CWP9UDa0NKdp/EmqZLHScc7C/zOMQ
         3JqLXMwnpW5bbP4vGKo1r+qafrfYTu4ZcYJIuqbdEamPS4eo+bZh/hOdbSY6VxJXN3Ws
         6OnD21PM9KCRrVg2KIfLg2ZRKQil+RlryMWz9sX3FPsCO6Y5EMvQe6mxDlz0dIzKA4Vy
         7mnPZTW3hgv4PtV0b442JOlQHiojqkWv7GP73l5LOT9Xp09/KFblinDc7hOetX2uBIFN
         GG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lf/zzWbu1p+7OZLhl2YtTpKCGw8MMulN9uhF5nuMqCI=;
        b=mhBm7i9xT2+/wpJYAFh+KsUGaRbMWz00rJBA33zpHj7BbGyZ9mN7zb61XH02JVRK16
         NrZjdq0AmBT36JMFaSETDzZSw49UHWlsphxW9ZlvjMjN4d1Dfq+cu9hs5lP5m7B4kdn1
         2tcSuz4HYwNbTHyVNdFDo13JjJAcI8kaciyax2uZ6TEm9Z3/QknDirl5Awt3xM8mLg8f
         mAujJaE2mAUYXiywH3TrNQeNjwN9KCSfGseB7xE1NptbWzowwKYlx3YSfQK8z/SXpgrr
         9DWlgukix4z9g/h8FJCUoYz4iqgqjDUYtwkMC3vGdUslXqMeDJnU7dm6Hn050Fi2Mc4M
         vCsQ==
X-Gm-Message-State: APjAAAUiWIcJn7JBy9BvNCeCaBH1eCdPtoSxRDYbE2vOa6PgagJXJ6zt
        PlYC3x0aR5oHFYnfZIqJ+ywx5Q==
X-Google-Smtp-Source: APXvYqxeI+sdlGgEjcfeFJKlxpAJ9zOhTuvdbI3+rOcVFkRl6SEr8gF4p42xLM8MfC54zCNdCDwqGQ==
X-Received: by 2002:a17:90a:ad89:: with SMTP id s9mr9313573pjq.41.1561152072111;
        Fri, 21 Jun 2019 14:21:12 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id x3sm4205768pja.7.2019.06.21.14.21.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 14:21:11 -0700 (PDT)
Date:   Fri, 21 Jun 2019 14:21:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/7] libbpf: add tracing attach APIs
Message-ID: <20190621212110.GG1383@mini-arch>
References: <20190621045555.4152743-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621045555.4152743-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20, Andrii Nakryiko wrote:
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
> Pre-patch #1 makes internal libbpf_strerror_r helper function work w/ negative
> error codes, lifting the burder off callers to keep track of error sign.
> Patch #2 adds attach_perf_event, which is the base for all other APIs.
> Patch #3 adds kprobe/uprobe APIs.
> Patch #4 adds tracepoint/raw_tracepoint APIs.
> Patch #5 converts one existing test to use attach_perf_event.
> Patch #6 adds new kprobe/uprobe tests.
> Patch #7 converts all the selftests currently using tracepoint to new APIs.
> 
> v1->v2:
> - preserve errno before close() call (Stanislav);
> - use libbpf_perf_event_disable_and_close in selftest (Stanislav);
> - remove unnecessary memset (Stanislav);
Reviewed-by: Stanislav Fomichev <sdf@google.com>

Thanks!

> Andrii Nakryiko (7):
>   libbpf: make libbpf_strerror_r agnostic to sign of error
>   libbpf: add ability to attach/detach BPF to perf event
>   libbpf: add kprobe/uprobe attach API
>   libbpf: add tracepoint/raw tracepoint attach API
>   selftests/bpf: switch test to new attach_perf_event API
>   selftests/bpf: add kprobe/uprobe selftests
>   selftests/bpf: convert existing tracepoint tests to new APIs
> 
>  tools/lib/bpf/libbpf.c                        | 346 ++++++++++++++++++
>  tools/lib/bpf/libbpf.h                        |  17 +
>  tools/lib/bpf/libbpf.map                      |   6 +
>  tools/lib/bpf/str_error.c                     |   2 +-
>  .../selftests/bpf/prog_tests/attach_probe.c   | 151 ++++++++
>  .../bpf/prog_tests/stacktrace_build_id.c      |  49 +--
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  24 +-
>  .../selftests/bpf/prog_tests/stacktrace_map.c |  42 +--
>  .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  14 +-
>  .../bpf/prog_tests/task_fd_query_rawtp.c      |  10 +-
>  .../bpf/prog_tests/task_fd_query_tp.c         |  51 +--
>  .../bpf/prog_tests/tp_attach_query.c          |  56 +--
>  .../selftests/bpf/progs/test_attach_probe.c   |  55 +++
>  13 files changed, 651 insertions(+), 172 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
> 
> -- 
> 2.17.1
> 
