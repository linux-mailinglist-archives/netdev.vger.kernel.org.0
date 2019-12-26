Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530CE12AE29
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 20:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLZTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 14:02:39 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37648 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLZTCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 14:02:39 -0500
Received: by mail-qt1-f193.google.com with SMTP id w47so22935478qtk.4;
        Thu, 26 Dec 2019 11:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FObIispKpyf2G1I3J0ZcpVwC/VArnaqEtMfJyaRVn2c=;
        b=AiailQx9cBJXMfg/f3YL8dqse9CV8SutR7lJsLq7ok5/R5bVHmwd7iLEdsPjn844D3
         TQS3NiNmuWUleoQLMjhmkVlUa5fHETXTV+WQLtDOzG1Zpj5iu7TV7fag6pjZwn3jK2sn
         fKcVq4/TdjqgjR4S6xEIaNDTHx7pPZaGwLnFpKiDr2ayP+rLYbLsANRu84HU8x7kuZ5P
         gWsmUadEv15sWat7AfyIfLuX5v62E5BzYyLUb/LjLnsbpkeKbm2X/C8AMBAL8BoRRJQC
         YgJ2S0BE1K6aUYsEWq6+rvApDlc6AB99snlzRT3oIkff06rXQkRLFXYmSGZ8w3obDOS9
         KIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FObIispKpyf2G1I3J0ZcpVwC/VArnaqEtMfJyaRVn2c=;
        b=msMxO5jG6PL1rcl5rVDiCte1lP9TP2FwZVerpAh24LZgm14D4KLfoCNaWGcCDgGAqi
         0GcBfDxfKfQIJL/lbIzWLI3DGQSr+Ijl86Rf1wDag0tefolXe7TOp6PFk0vCEtuaZDXm
         3stxlFt3a9Rze0gQqkFyu/2/zPoV+4B7qhSHOca8Y0XLBqdj715jcscyt5atgTWbL3/M
         oIZIEBm0hrGuz/fLeGJm88RN0NFuxOayXPMLw5x8sLHq2lMqddxY5vQuzT45kApWQpws
         HtmHgeQ2XdNwooA3EZVsKH8+1GbpkI7rL2Vs7k2CglsyDB7GXfH2CjNv7fs/WTMG8jMb
         lUXg==
X-Gm-Message-State: APjAAAUeju5tH4feoBD8o8TCwmQpbp8OFda3p7Hg/TVCW2qV0zsDYhLT
        Kci/DHvgGqjZEgyBIEm2ShwXFX12ouPNB1BCjoI=
X-Google-Smtp-Source: APXvYqxaf5F1UboTDk11Wj5PtqKCnYS6Bf+AiBJdtub4vzGf94S0DUUfASVr+Cr1UeAX2Zv8kQInxbqfcTtNOhfW8hg=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr34509449qtl.171.1577386957840;
 Thu, 26 Dec 2019 11:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp> <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
 <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp>
In-Reply-To: <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Dec 2019 11:02:26 -0800
Message-ID: <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
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

On Tue, Dec 24, 2019 at 8:50 AM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch adds a bpf_dctcp example.  It currently does not do
> > > > > no-ECN fallback but the same could be done through the cgrp2-bpf.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
> > > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
> > > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
> > > > >  3 files changed, 656 insertions(+)
> > > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > new file mode 100644
> > > > > index 000000000000..7ba8c1b4157a
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > @@ -0,0 +1,228 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > > +#define __BPF_TCP_HELPERS_H
> > > > > +
> > > > > +#include <stdbool.h>
> > > > > +#include <linux/types.h>
> > > > > +#include <bpf_helpers.h>
> > > > > +#include <bpf_core_read.h>
> > > > > +#include "bpf_trace_helpers.h"
> > > > > +
> > > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > >
> > > > Should we try to put those BPF programs into some section that would
> > > > indicate they are used with struct opts? libbpf doesn't use or enforce
> > > > that (even though it could to derive and enforce that they are
> > > > STRUCT_OPS programs). So something like
> > > > SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> > > > convention is very useful for consistency and to do a quick ELF dump
> > > > and see what is where. WDYT?
> > > I did not use it here because I don't want any misperception that it is
> > > a required convention by libbpf.
> > >
> > > Sure, I can prefix it here and comment that it is just a
> > > convention but not a libbpf's requirement.
> >
> > Well, we can actually make it a requirement of sorts. Currently your
> > code expects that BPF program's type is UNSPEC and then it sets it to
> > STRUCT_OPS. Alternatively we can say that any BPF program in
> > SEC("struct_ops/<whatever>") will be automatically assigned
> > STRUCT_OPTS BPF program type (which is done generically in
> > bpf_object__open()), and then as .struct_ops section is parsed, all
> > those programs will be "assembled" by the code you added into a
> > struct_ops map.
> Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
> phase (during collect_reloc time).  I will make this change.
>

Can you please extend exiting logic in __bpf_object__open() to do
this? See how libbpf_prog_type_by_name() is used for that.

> >
> > It's a requirement "of sorts", because even if user doesn't do that,
> > stuff will still work, if user manually will call
> > bpf_program__set_struct_ops(prog). Which actually reminds me that it
> > would be good to add bpf_program__set_struct_ops() and
> Although there is BPF_PROG_TYPE_FNS macro,
> I don't see moving bpf_prog__set_struct_ops(prog) to LIBBPF_API is useful
> while actually may cause confusion and error.  How could __set_struct_ops()
> a prog to struct_ops prog_type help a program, which is not used in
> SEC(".struct_ops"), to be loaded successfully as a struct_ops prog?
>
> Assigning a bpf_prog to a function ptr under the SEC(".struct_ops")
> is the only way for a program to be successfully loaded as
> struct_ops prog type.  Extra way to allow a prog to be changed to
> struct_ops prog_type is either useless or redundant.

Well, first of all, just for consistency with everything else. We have
such methods for all prog_types, so I'd like to avoid a special
snowflake one that doesn't.

Second, while high-level libbpf API provides all the magic to
construct STRUCT_OPS map based on .struct_ops section types,
technically, user might decide to do that using low-level map creation
API, right? So not making unnecessary assumptions and providing
complete APIs is a good thing, IMO. Especially if it costs basically
nothing in terms of code and maintenance.

>
> If it is really necessary to have __set_struct_ops() as a API
> for completeness, it can be added...
>
> > bpf_program__is_struct_ops() APIs for completeness, similarly to how
> is_struct_ops() makes sense.
>
> > BTW, libbpf will emit debug message for every single BPF program it
> > doesn't recognize section for, so it is still nice to have it be
> > something more or less standardized and recognizable by libbpf.
> I can make this debug (not error) message go away too after
> setting the BPF_PROG_TYPE_STRUCT_OPS automatically at open time.

Yep, that would be great.
