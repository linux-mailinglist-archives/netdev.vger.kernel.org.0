Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B5D5A933
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfF2F4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:56:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41032 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfF2F4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:56:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id c11so6858067qkk.8;
        Fri, 28 Jun 2019 22:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0k0aPZ8oUp4nQaGfIDOA3ffw11whWH367Fh8ceN4Ew=;
        b=qH5j6PIjubvo8l0Jey5IcowZwql9IueoZRjCM/LcWMC8z0xaQTRYd1wMC59u+D33M4
         NOi2jrsgU5NUPEir2NHYAs22z1ZhxKf91H/giqak6lSXpKxz0J2uxO1qKIY/PdvafWpl
         iESr9s05K1VlPQ2237bgNXycadwHdkglv1hXLPZprgz8k1yP/SxOPg6xSDdH00xGdhmC
         0hRF5Ud32yo2DRmZNjnzfLHL2R9Vh1s9P+l+Nn2965oQFcD0n6Qepg8MYEdvObeg3PIG
         cSveBF/w0xSc4jpImfLsOIrDgqiqbHcZdpbZSOmmxWYTYkeDzlq5X01qOuuoRIR5Thco
         bdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W0k0aPZ8oUp4nQaGfIDOA3ffw11whWH367Fh8ceN4Ew=;
        b=tCPM062f3+Ukq0TXkImcIJOtDu7u3Lw5wwRJ7xE7gPTHZW+3ZT1qFbnB2QgvooFbK7
         a9SH355MilT2dRhnH3xwiVDQtZRzT/ud9Tn6uaL4ZIY5dX5VffSiUAk5EJYK6oegFc1r
         noaz6SCyerGVqkhGg+a7ifgQ/0kE6vfRn4rY3KwwL+DVUIDf68wSyiPbw6ighOE0kU4g
         OkomIghcGPZnwq4i+lqCqcBfOiA6Civ7V00TSgKR1J/PyPOQOHW/DPpM7Z6h1zRphb5l
         sHQ2s4hAK//V4GMWDWtiIKw95oG4rSe+FAMjDoBwNNMZQGk3DoFrbApEsNPgLyE/AM1w
         BXiQ==
X-Gm-Message-State: APjAAAXlRF+H6gSlXEzskq3UF4OQP+vS6hQjfBLyPvpyscrJjbzngAWS
        4z3xQiVkVE6WP2R9g5JriGl1KT5D0VCjrtGMKcc=
X-Google-Smtp-Source: APXvYqwm5CI8EYDYBblVBsdZeSkR/vz36SGKmkF8ABDOfiSInJeTjCahndEw2rEXMRMRyPerpZJHm8eC+J5McjS5Jxw=
X-Received: by 2002:a37:a643:: with SMTP id p64mr12205427qke.36.1561787795269;
 Fri, 28 Jun 2019 22:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061235.602633-1-andriin@fb.com> <20190626061235.602633-2-andriin@fb.com>
 <7de14b2b-a663-eed9-8f70-fb6bd5ea84d8@iogearbox.net> <CAEf4Bzb4U73jb80eCv+JoFGFd2ACXK4j6d=ZeVOoRH1d0f-dPg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb4U73jb80eCv+JoFGFd2ACXK4j6d=ZeVOoRH1d0f-dPg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 22:56:24 -0700
Message-ID: <CAEf4BzZ9qjbRJBQsX7WHJ4YXwJ_1=vw5BocTiX=ToEqxOYnMQA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: add perf buffer API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 2:45 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 27, 2019 at 2:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 06/26/2019 08:12 AM, Andrii Nakryiko wrote:
> > > BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
> > > to user space for additional processing. libbpf already has very low-level API
> > > to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
> > > use and requires a lot of code to set everything up. This patch adds
> > > perf_buffer abstraction on top of it, abstracting setting up and polling
> > > per-CPU logic into simple and convenient API, similar to what BCC provides.
> > >
> > > perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
> > > map entries. It accepts two user-provided callbacks: one for handling raw
> > > samples and one for get notifications of lost samples due to buffer overflow.
> > >
> > > perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> > > utilizing epoll instance.
> > >
> > > perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.
> > >
> > > All APIs are not thread-safe. User should ensure proper locking/coordination if
> > > used in multi-threaded set up.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > Aside from current feedback, this series generally looks great! Two small things:
> >
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 2382fbda4cbb..10f48103110a 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -170,13 +170,16 @@ LIBBPF_0.0.4 {
> > >               btf_dump__dump_type;
> > >               btf_dump__free;
> > >               btf_dump__new;
> > > -             btf__parse_elf;
> > >               bpf_object__load_xattr;
> > >               bpf_program__attach_kprobe;
> > >               bpf_program__attach_perf_event;
> > >               bpf_program__attach_raw_tracepoint;
> > >               bpf_program__attach_tracepoint;
> > >               bpf_program__attach_uprobe;
> > > +             btf__parse_elf;
> > >               libbpf_num_possible_cpus;
> > >               libbpf_perf_event_disable_and_close;
> > > +             perf_buffer__free;
> > > +             perf_buffer__new;
> > > +             perf_buffer__poll;
> >
> > We should prefix with libbpf_* given it's not strictly BPF-only and rather
> > helper function.
>
> Well, perf_buffer is an object similar to `struct btf`, `struct
> bpf_program`, etc. So it seems appropriate to follow this
> "<object>__<method>" convention. Also, `struct libbpf_perf_buffer` and
> `libbpf_perf_buffer__new` looks verbose and pretty ugly, IMO.
>
> >
> > Also, we should convert bpftool (tools/bpf/bpftool/map_perf_ring.c) to make
> > use of these new helpers instead of open-coding there.
>
> Yep, absolutely, will do that as well, thanks for pointing me there!

This turned out to require much bigger changes, as bpftool needed way
more low-level control over structure of events and attachment
policies (custom cpu index and map key). So I ended up having two
APIs:
1. simple common-case perf_buffer__new with 2 callbacks, that attaches
to all CPUs (up to max_elements of map)
2. perf_buffer__new_raw, that allows to provide custom
perf_event_attr, callback that accepts pointer to raw perf event and
allows to specify any set of cpu/map keys.

bpftool uses the latter one. Please see v3.

>
> >
> > Thanks,
> > Daniel
