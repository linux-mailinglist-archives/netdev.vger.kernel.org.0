Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB8260EA5
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 05:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfGFDtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 23:49:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36950 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGFDtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 23:49:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so510647qto.4;
        Fri, 05 Jul 2019 20:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bAjXEEE6xaO7eo6N+SXxu0e8F5JAk6jM9rnN023UKVs=;
        b=lMSxZJCrkBtqAc3dA15lNLO5hwlnz1e6OqFEVdBjwHlJq2ZsELjTYwHMDEzxPuVjf+
         2l3W8gDKotuw4JmCB4RHc1tUOk95qNNJXAOdJBbCDXlxIsUP6g06i4rPm1FbNIiuQtbY
         4oO+MwRzc7SDA9oXld2vDQg9BVWXkaDZOa1aJgOnGBT4tuJ8k6MSMg7YiTkHF2zWXGAP
         wCpOvI+Dbi69tIn4OuRwtLl2yGaRFKo/u4iyRxwIeQ43rRUlGHDUVn/Tq23cdbPCNyx3
         emjKxnb29qkA6Iw6PKqZJ1XnbwRGdbtmK4Rs10Z6H/JVXU43BuV1QFB0IX2NIO3UM6yW
         NS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bAjXEEE6xaO7eo6N+SXxu0e8F5JAk6jM9rnN023UKVs=;
        b=QQn1ZnTIfCKt4lz3UHrWhvrziYzOvu0Lg+dld4G5IMHrEMMfrKezbpptCuA8se/hWJ
         dYPlIU9TqQQwXssRyc/NOIAzgx8Tse42vXun9nXceeVF2PGI3rkO3kjYJ9idt8NuHZDa
         U2NFH16VznRw/Is8iOJe40PI3tmKi/x0cfxXnVhwRM5ZWRjr5t+z4Ru4b917mmAIqi8p
         2EiT65WdOolCSmzj4PDMM2Hkc3wbz6JS0Y2UrxX3xj/d8/rGIfnUl1OOcyV3Oh8vPrYd
         dKE4+JMiP6i4U0W7zPOGIDCL/PuFxxv71Oyk4q0I56aHUEjsu4gQ2JmrgVPbSppa9X0I
         N5pA==
X-Gm-Message-State: APjAAAXNcKZ6l619i5vLZcnZKpJlKkmdvyv8qTvGKM5vioz/OJMhehiF
        AvCOx8Xz1bX1mL2J5yHbwywleX20AngFzfulrI4=
X-Google-Smtp-Source: APXvYqwPRP7cnqU8kKjTs5KotKQCauoBq85i8kKBLXKE8ZgdEwEqtG8gxC1e9xDTWdlf/LhuMcqPCmGRjOQ0//4vcP8=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr6023063qvh.150.1562384975476;
 Fri, 05 Jul 2019 20:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190705155012.3539722-1-andriin@fb.com> <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
In-Reply-To: <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Jul 2019 20:49:23 -0700
Message-ID: <CAEf4BzbkAq=C5NF1_XRc1WNE-i7pavt48k9D7kEM_oTS3pWADA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] capture integers in BTF type info for map defs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 2:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/05/2019 05:50 PM, Andrii Nakryiko wrote:
> > This patch set implements an update to how BTF-defined maps are specified. The
> > change is in how integer attributes, e.g., type, max_entries, map_flags, are
> > specified: now they are captured as part of map definition struct's BTF type
> > information (using array dimension), eliminating the need for compile-time
> > data initialization and keeping all the metadata in one place.
> >
> > All existing selftests that were using BTF-defined maps are updated, along
> > with some other selftests, that were switched to new syntax.
> >
> > v4->v5:
> > - revert sample_map_ret0.c, which is loaded with iproute2 (kernel test robot);
> > v3->v4:
> > - add acks;
> > - fix int -> uint type in commit message;
> > v2->v3:
> > - rename __int into __uint (Yonghong);
> > v1->v2:
> > - split bpf_helpers.h change from libbpf change (Song).
> >
> > Andrii Nakryiko (4):
> >   libbpf: capture value in BTF type info for BTF-defined map defs
> >   selftests/bpf: add __uint and __type macro for BTF-defined maps
> >   selftests/bpf: convert selftests using BTF-defined maps to new syntax
> >   selftests/bpf: convert legacy BPF maps to BTF-defined ones
> >
> >  tools/lib/bpf/libbpf.c                        |  58 +++++----
> >  tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
> >  tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 ++---
> >  .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
> >  .../testing/selftests/bpf/progs/netcnt_prog.c |  20 ++--
> >  tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
> >  .../selftests/bpf/progs/socket_cookie_prog.c  |  13 +--
> >  .../bpf/progs/sockmap_verdict_prog.c          |  48 ++++----
> >  .../testing/selftests/bpf/progs/strobemeta.h  |  68 +++++------
> >  .../selftests/bpf/progs/test_btf_newkv.c      |  13 +--
> >  .../bpf/progs/test_get_stack_rawtp.c          |  39 +++----
> >  .../selftests/bpf/progs/test_global_data.c    |  37 +++---
> >  tools/testing/selftests/bpf/progs/test_l4lb.c |  65 ++++-------
> >  .../selftests/bpf/progs/test_l4lb_noinline.c  |  65 ++++-------
> >  .../selftests/bpf/progs/test_map_in_map.c     |  30 ++---
> >  .../selftests/bpf/progs/test_map_lock.c       |  26 ++---
> >  .../testing/selftests/bpf/progs/test_obj_id.c |  12 +-
> >  .../bpf/progs/test_select_reuseport_kern.c    |  67 ++++-------
> >  .../bpf/progs/test_send_signal_kern.c         |  26 ++---
> >  .../bpf/progs/test_sock_fields_kern.c         |  78 +++++--------
> >  .../selftests/bpf/progs/test_spin_lock.c      |  36 +++---
> >  .../bpf/progs/test_stacktrace_build_id.c      |  55 ++++-----
> >  .../selftests/bpf/progs/test_stacktrace_map.c |  52 +++------
> >  .../selftests/bpf/progs/test_tcp_estats.c     |  13 +--
> >  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  26 ++---
> >  .../selftests/bpf/progs/test_tcpnotify_kern.c |  28 ++---
> >  tools/testing/selftests/bpf/progs/test_xdp.c  |  26 ++---
> >  .../selftests/bpf/progs/test_xdp_loop.c       |  26 ++---
> >  .../selftests/bpf/progs/test_xdp_noinline.c   |  81 +++++--------
> >  .../selftests/bpf/progs/xdp_redirect_map.c    |  12 +-
> >  .../testing/selftests/bpf/progs/xdping_kern.c |  12 +-
> >  .../selftests/bpf/test_queue_stack_map.h      |  30 ++---
> >  .../testing/selftests/bpf/test_sockmap_kern.h | 110 +++++++++---------
> >  33 files changed, 559 insertions(+), 760 deletions(-)
>
> LGTM, applied, thanks! Shouldn't we also move __uint and __type macros
> into libbpf as otherwise people tend to redefine this over and over?


Yes, we need something like bpf_helpers.h as part of libbpf for
inclusion into BPF programs. It's on my todo list as part of BPF CO-RE
project as well.
