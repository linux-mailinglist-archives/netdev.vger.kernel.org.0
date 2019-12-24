Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8235129E52
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 08:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfLXHCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 02:02:08 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37437 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfLXHCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 02:02:07 -0500
Received: by mail-qk1-f195.google.com with SMTP id 21so15439477qky.4;
        Mon, 23 Dec 2019 23:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6WMlhNYljVx4fqcFwvkQVwW/hWHhMZYIqjCowPZnuQ=;
        b=KCSIZn1z/5QKU6hoI3gpxJlgBnhnnZMPv7xMSxzwiNYDrGsD231v4SVBduQhm6/ufC
         xQbCr8VswRk5NcBeL4rIr3JmWKNKpUfR0x2eaGwwJB2D68YoeKqFeQj9qarOyCoHU6OI
         jr5Sx2lVNH/xo2cnyMeSTsRwbP7mxZvKQybKUHBEBvXhr+F81lIPzwh7OAgwJe4KgSCC
         a4UIQVSBTCj4YWpDCh+6VFE8KTWzTfjS++eMAnstnWRvzVEo1MqdRTt0QM6ILFUukZ+u
         /CL1tqhJuoJB1CnX5u5CDvvJeWL8x3geSvPK+MuSUH+oHQWo0oB1kEStXY/ySgtKc9tb
         L8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6WMlhNYljVx4fqcFwvkQVwW/hWHhMZYIqjCowPZnuQ=;
        b=QmllmjIvIFT1RgPdkkIh5cYmKWfUgR6i4y9Z4aQaj30VH6/FMCGaGpaTrC+YYhTn8w
         /w8mCFjQhcpzN/c8V9R/C47Y6x5WPzEM+eagAVI5/fmy725ljmwk1Flq8Bj9PuaBL6rD
         3zItt/79yTQrrtlMZo+eB2q/v8ztSocKxS92hL+GVg5Au57wYHrj024gYKEBM7z/IJzC
         vJsHNM7Yh9YrcQ3xM0VIT9+mVtSzUPAlrvT9NF5NlGr6cbPKiL7SHTxlVKFBodI1jZsu
         qSdjt+3Jj70lnsdcVFIfovGKBMT42CIdZnSYgZdocW/nPIoI8HtxNGHgCXXf04mzKDkV
         f3pA==
X-Gm-Message-State: APjAAAWt1ZcC7SMQy22zqrxIlTLZtrCvHxAtVqChbW3vYocLMG91+8+P
        +yxcjFIT0p61PJVc/gdXasJDg/WYMObWK5abDVY=
X-Google-Smtp-Source: APXvYqyZSbZBdslEFL0LLI5LdcAnVyjbWvMFao9nISr88WHezTkc0EQapuokyrcSOQsLFKtqQZsu7mFtjjPGm1VdH2E=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr29525784qkg.92.1577170926357;
 Mon, 23 Dec 2019 23:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com> <20191224013140.ibn33unj77mtbkne@kafai-mbp>
In-Reply-To: <20191224013140.ibn33unj77mtbkne@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 23:01:55 -0800
Message-ID: <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
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

On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch adds a bpf_dctcp example.  It currently does not do
> > > no-ECN fallback but the same could be done through the cgrp2-bpf.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
> > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
> > >  3 files changed, 656 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > new file mode 100644
> > > index 000000000000..7ba8c1b4157a
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > @@ -0,0 +1,228 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#ifndef __BPF_TCP_HELPERS_H
> > > +#define __BPF_TCP_HELPERS_H
> > > +
> > > +#include <stdbool.h>
> > > +#include <linux/types.h>
> > > +#include <bpf_helpers.h>
> > > +#include <bpf_core_read.h>
> > > +#include "bpf_trace_helpers.h"
> > > +
> > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec", fname, ret_type, __VA_ARGS__)
> >
> > Should we try to put those BPF programs into some section that would
> > indicate they are used with struct opts? libbpf doesn't use or enforce
> > that (even though it could to derive and enforce that they are
> > STRUCT_OPS programs). So something like
> > SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> > convention is very useful for consistency and to do a quick ELF dump
> > and see what is where. WDYT?
> I did not use it here because I don't want any misperception that it is
> a required convention by libbpf.
>
> Sure, I can prefix it here and comment that it is just a
> convention but not a libbpf's requirement.

Well, we can actually make it a requirement of sorts. Currently your
code expects that BPF program's type is UNSPEC and then it sets it to
STRUCT_OPS. Alternatively we can say that any BPF program in
SEC("struct_ops/<whatever>") will be automatically assigned
STRUCT_OPTS BPF program type (which is done generically in
bpf_object__open()), and then as .struct_ops section is parsed, all
those programs will be "assembled" by the code you added into a
struct_ops map.

It's a requirement "of sorts", because even if user doesn't do that,
stuff will still work, if user manually will call
bpf_program__set_struct_ops(prog). Which actually reminds me that it
would be good to add bpf_program__set_struct_ops() and
bpf_program__is_struct_ops() APIs for completeness, similarly to how
KP's LSM patch set does.

BTW, libbpf will emit debug message for every single BPF program it
doesn't recognize section for, so it is still nice to have it be
something more or less standardized and recognizable by libbpf.

>
> >
> > > +

[...]

> >
> > Can all of these types come from vmlinux.h instead of being duplicated here?
> It can but I prefer leaving it as is in bpf_tcp_helpers.h like another
> existing test in kfree_skb.c.  Without directly using the same struct in
> vmlinux.h,  I think it is a good test for libbpf.
> That remind me to shuffle the member ordering a little in tcp_congestion_ops
> here.

Sure no problem. When I looked at this it was a bit discouraging on
how much types I'd need to duplicate, but surely we don't want to make
an impression that vmlinux.h is the only way to achieve this.

>
> >
> > > +
> > > +#define min(a, b) ((a) < (b) ? (a) : (b))
> > > +#define max(a, b) ((a) > (b) ? (a) : (b))
> > > +#define min_not_zero(x, y) ({                  \
> > > +       typeof(x) __x = (x);                    \
> > > +       typeof(y) __y = (y);                    \
> > > +       __x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
> > > +
> >
> > [...]
> >
> > > +static struct bpf_object *load(const char *filename, const char *map_name,
> > > +                              struct bpf_link **link)
> > > +{
> > > +       struct bpf_object *obj;
> > > +       struct bpf_map *map;
> > > +       struct bpf_link *l;
> > > +       int err;
> > > +
> > > +       obj = bpf_object__open(filename);
> > > +       if (CHECK(IS_ERR(obj), "bpf_obj__open_file", "obj:%ld\n",
> > > +                 PTR_ERR(obj)))
> > > +               return obj;
> > > +
> > > +       err = bpf_object__load(obj);
> > > +       if (CHECK(err, "bpf_object__load", "err:%d\n", err)) {
> > > +               bpf_object__close(obj);
> > > +               return ERR_PTR(err);
> > > +       }
> > > +
> > > +       map = bpf_object__find_map_by_name(obj, map_name);
> > > +       if (CHECK(!map, "bpf_object__find_map_by_name", "%s not found\n",
> > > +                   map_name)) {
> > > +               bpf_object__close(obj);
> > > +               return ERR_PTR(-ENOENT);
> > > +       }
> > > +
> >
> > use skeleton instead?
> Will give it a spin.
>
> >
> > > +       l = bpf_map__attach_struct_ops(map);
> > > +       if (CHECK(IS_ERR(l), "bpf_struct_ops_map__attach", "err:%ld\n",
> > > +                 PTR_ERR(l))) {
> > > +               bpf_object__close(obj);
> > > +               return (void *)l;
> > > +       }
> > > +
> > > +       *link = l;
> > > +
> > > +       return obj;
> > > +}
> > > +
