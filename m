Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8212AE9C
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfLZUsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:48:23 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40623 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfLZUsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:48:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id c17so20179209qkg.7;
        Thu, 26 Dec 2019 12:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOupSjJsR3wnGh3oZaKm83dSTdc/kQHfdz++o3RZ0Iw=;
        b=EVJS1j7V0F6WzYRC09sAObS7YJZlGWT1mfbrzcQ2vRKszbs4SlYYAuT8VcXk9HAh8b
         DHpqFOzTy4nFCV782aenq049RYrYe3+l9w0D+aY08wp7nnTBDQMtHtWj2VoOqX+r3DFy
         2CfruwDiq12jKWsokKOl4undhIm4NZBt0uoVxpH5jZtGBKbBcxRP/BoFMCTA15U+HwIb
         +IWdL7YxUbDmmzwLfrpxoQgfzfuvANIIyDp5kPh+GA75hnPz7IMIW08psETuYKIIINfa
         mobRhxoILxMFNZAq/ke/1YNfF3OIY+Q0yt386rwJ7UuO5gUZpFXXkyYJ9qIHvz5e4WGE
         013g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOupSjJsR3wnGh3oZaKm83dSTdc/kQHfdz++o3RZ0Iw=;
        b=Gbr/beaDE4nIUfah6RlIbqKJLgCcevu//fZ5K7u2n49DL9eDjYKD7C8SGpyVIGdjcV
         SaO2DIDdYQVTfSUxalH6FetWvKgQzEM/zraMh3nDIhBSWOhnIhtDY9kwySBKI2NmxFbk
         M+GryjuSfylYUHhSYLhjBkbq3C9crp0VzrRKoKQvrbHZ94BFuMVKJOA1wQ/VVjP0izDD
         N+189oVm66NWDrE/HvqRY6eB1h6q9y8DvaokBWUzksEqsHuzWun1BKfb8hdzo5Mdvbay
         QxJiROX5HbKWA15dfN6HnvK7jipsJpEescX2Rp56ikQumc9bwCKb1l5y3dKMy+G8Lhys
         FmGA==
X-Gm-Message-State: APjAAAV/Y7jKIKkGskLdeJTvGT369Y96Pk/9vAYCw395O+ukRWZ3MQ6f
        cQnahZp5O+CdSWbwTIfzUvKPyi4qTKyrLRSyaaA=
X-Google-Smtp-Source: APXvYqzNHi/f0bAEdMn9F7Sx3JpIMdKRaMgE7M6z0CHhmiBL8l5UMVjOntLw+vEC2hiMHiDwOq8e3mI6sGKFk6NbH6w=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr40229983qkg.92.1577393300859;
 Thu, 26 Dec 2019 12:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp> <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
 <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp> <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
 <20191226202512.abhyhdtetv46z5sd@kafai-mbp>
In-Reply-To: <20191226202512.abhyhdtetv46z5sd@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Dec 2019 12:48:09 -0800
Message-ID: <CAEf4BzagEe4sbUfz6=Y6MHCsAAUAVe1GKi_XJUNu8xpHdd_mAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 12:25 PM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Dec 26, 2019 at 11:02:26AM -0800, Andrii Nakryiko wrote:
> > On Tue, Dec 24, 2019 at 8:50 AM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > > > On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > > > > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > This patch adds a bpf_dctcp example.  It currently does not do
> > > > > > > no-ECN fallback but the same could be done through the cgrp2-bpf.
> > > > > > >
> > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > ---
> > > > > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
> > > > > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
> > > > > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
> > > > > > >  3 files changed, 656 insertions(+)
> > > > > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > > > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > > > > > >
> > > > > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..7ba8c1b4157a
> > > > > > > --- /dev/null
> > > > > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > @@ -0,0 +1,228 @@
> > > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > > > > +#define __BPF_TCP_HELPERS_H
> > > > > > > +
> > > > > > > +#include <stdbool.h>
> > > > > > > +#include <linux/types.h>
> > > > > > > +#include <bpf_helpers.h>
> > > > > > > +#include <bpf_core_read.h>
> > > > > > > +#include "bpf_trace_helpers.h"
> > > > > > > +
> > > > > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > >
> > > > > > Should we try to put those BPF programs into some section that would
> > > > > > indicate they are used with struct opts? libbpf doesn't use or enforce
> > > > > > that (even though it could to derive and enforce that they are
> > > > > > STRUCT_OPS programs). So something like
> > > > > > SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> > > > > > convention is very useful for consistency and to do a quick ELF dump
> > > > > > and see what is where. WDYT?
> > > > > I did not use it here because I don't want any misperception that it is
> > > > > a required convention by libbpf.
> > > > >
> > > > > Sure, I can prefix it here and comment that it is just a
> > > > > convention but not a libbpf's requirement.
> > > >
> > > > Well, we can actually make it a requirement of sorts. Currently your
> > > > code expects that BPF program's type is UNSPEC and then it sets it to
> > > > STRUCT_OPS. Alternatively we can say that any BPF program in
> > > > SEC("struct_ops/<whatever>") will be automatically assigned
> > > > STRUCT_OPTS BPF program type (which is done generically in
> > > > bpf_object__open()), and then as .struct_ops section is parsed, all
> > > > those programs will be "assembled" by the code you added into a
> > > > struct_ops map.
> > > Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
> > > phase (during collect_reloc time).  I will make this change.
> > >
> >
> > Can you please extend exiting logic in __bpf_object__open() to do
> > this? See how libbpf_prog_type_by_name() is used for that.
> Does it have to call libbpf_prog_type_by_name() if everything
> has already been decided by the earlier
> bpf_object__collect_struct_ops_map_reloc()?

We can certainly change the logic to omit guessing program type if
it's already set to something else than UNSPEC.

But all I'm asking is that instead of using #fname"_sec" section name,
is to use "struct_ops/"#fname, because it's consistent with all other
program types. If you do that, then you don't have to do anything
extra (well, add single entry to section_defs, of course), it will
just work as is.

>
> >
> > > >
> > > > It's a requirement "of sorts", because even if user doesn't do that,
> > > > stuff will still work, if user manually will call
> > > > bpf_program__set_struct_ops(prog). Which actually reminds me that it
> > > > would be good to add bpf_program__set_struct_ops() and
> > > Although there is BPF_PROG_TYPE_FNS macro,
> > > I don't see moving bpf_prog__set_struct_ops(prog) to LIBBPF_API is useful
> > > while actually may cause confusion and error.  How could __set_struct_ops()
> > > a prog to struct_ops prog_type help a program, which is not used in
> > > SEC(".struct_ops"), to be loaded successfully as a struct_ops prog?
> > >
> > > Assigning a bpf_prog to a function ptr under the SEC(".struct_ops")
> > > is the only way for a program to be successfully loaded as
> > > struct_ops prog type.  Extra way to allow a prog to be changed to
> > > struct_ops prog_type is either useless or redundant.
> >
> > Well, first of all, just for consistency with everything else. We have
> > such methods for all prog_types, so I'd like to avoid a special
> > snowflake one that doesn't.
> Yes, for consistency is fine as I mentioned in the earlier reply,
> as long as it is understood the usefulness of it.
>
> > Second, while high-level libbpf API provides all the magic to
> > construct STRUCT_OPS map based on .struct_ops section types,
> > technically, user might decide to do that using low-level map creation
> > API, right?
> How?
>
> Correct that the map api is reused as is in SEC(".struct_ops").
>
> For prog, AFAICT, it is not possible to create struct_ops
> prog from raw and use it in struct_ops map unless more LIBBPF_API
> is added.  Lets put aside the need to find the btf_vmlinux
> and its btf-types...etc.  At least, there is no LIBBPF_API to
> set prog->attach_btf_id.  Considering the amount of preparation
> is needed to create a struct_ops map from raw,  I would like
> to see a real use case first before even considering what else
> is needed and add another LIBBPF_API that may not be used.

To be clear, I don't think anyone in their right mind should do this
by hand. I'm just saying that in the end it's not magic, just calls to
low-level map APIs. See above, though, all I care is consistent
pattern for sections names: "program_type/<whatever-makes-sense>".
