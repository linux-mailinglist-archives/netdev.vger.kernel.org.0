Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C324A12824B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTSld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:41:33 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39166 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTSlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:41:32 -0500
Received: by mail-qk1-f193.google.com with SMTP id c16so8423625qko.6;
        Fri, 20 Dec 2019 10:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZ5lrqoLLu6y+PrtHjtJBiOJrs3V4dK5DGuS5TsFXZ8=;
        b=pHVvtKpQ3jJEYhLKsEcRGVko0VpO7Fd3ovqhvg4Fg2ovV51AtmXRemj2I437tLHplD
         MJFUdB9US8XpvJJc1nXAKO0WJGb4GSWk1dScOD+bL/lSMYmwuoW+gL0dkBFzgF75rhXY
         1pl0SJZ0H+iibiXfZP3XGhq1XhbDy06kt9bNUPTi+Xj7ZkMWaJrvbAb5YhpHEOMWRb7A
         4PhvEQ41UeJWCrZj4uolhetw98mjCrY/3vI2u7EKmDgOSjY4s6S2vIIfxBMJXzND8K9V
         fGIxvqfWl1obAWjkNbiH2WujWNM2+QxZHK5eNrD3FeeHwLMMyrNCZBdhYLsbgMSlc39l
         ZzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZ5lrqoLLu6y+PrtHjtJBiOJrs3V4dK5DGuS5TsFXZ8=;
        b=MWVIsr3aonEFACl/6fq8AJvvYbGXXGbExTi0CawdnS2hfLJJTFisnfMfHXyMpm8s4B
         KAvYFfVoyIlvG6LmdZJITQxLR4eNejdWFyUTQ+WZNxHSIoG+yYYfSClhPeHk/xWEb0Dt
         UnxB/+dlTTd8Fu1yA2vuqU+o+N9M+3HhW4sOgONjWSCweoOdCTdJD6hTw0/rfMeCM3it
         eJ9mKW8Q8g8jG1Z3Ugr02wk1sQF47M4NVAZd9eqZUvNkIkn5ECF1kRnzxY0TU72oSA3X
         0EXZcj51uI83tIJWmAl4Oy0EcRsq7X9PgekBhcJTCawg90ALB0NuIk2IShxzGU1C2Mqk
         xYjA==
X-Gm-Message-State: APjAAAWLBbHtaubl80v15/svWwsVND6T1LuwlS++OR6ojSDYzb5gRV6j
        Dv4i1wwcYZOgWs8sx6eN7EEqX7zrzClhP6PmZt4=
X-Google-Smtp-Source: APXvYqztb7qcDKGM6hlj5vcGUCnL9MnSBTNplkxJdlvYH8CKH9pyNF6wc7r95Ls3jGTuNP7Rw/pc2FZ9I/kNqczaOss=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr14972182qkj.36.1576867291650;
 Fri, 20 Dec 2019 10:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004751.1652774-1-kafai@fb.com>
 <6ca4e58d-4bb3-bb4b-0fe2-e10a29a53d1f@fb.com> <20191220072150.flfxsix4s6jndswn@kafai-mbp>
 <20191220165158.bc6mp7w5ooof262h@kafai-mbp>
In-Reply-To: <20191220165158.bc6mp7w5ooof262h@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 10:41:20 -0800
Message-ID: <CAEf4BzZDSaw18f3je0=+kG38F0+3G1zcB48T_He2H5LhJQ3ygg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/13] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin Lau <kafai@fb.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 8:52 AM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Dec 19, 2019 at 11:22:17PM -0800, Martin Lau wrote:
>
> > [ ... ]
> >
> > > > +/* __bpf_##_name (e.g. __bpf_tcp_congestion_ops) is the map's value
> > > > + * exposed to the userspace and its btf-type-id is stored
> > > > + * at the map->btf_vmlinux_value_type_id.
> > > > + *
> > > > + * The *_name##_dummy is to ensure the BTF type is emitted.
> > > > + */
> > > > +
> > > >   #define BPF_STRUCT_OPS_TYPE(_name)                              \
> > > > -extern struct bpf_struct_ops bpf_##_name;
> > > > +extern struct bpf_struct_ops bpf_##_name;                        \
> > > > +                                                         \
> > > > +static struct __bpf_##_name {                                    \
> > > > + BPF_STRUCT_OPS_COMMON_VALUE;                            \
> > > > + struct _name data ____cacheline_aligned_in_smp;         \
> > > > +} *_name##_dummy;
> > >
> > > There are other ways to retain types in debug info without
> > > creating new variables. For example, you can use it in a cast
> > > like
> > >      (void *)(struct __bpf_##_name *)v
> > hmm... What is v?
> Got it.  "v" could be any dummy pointer in a function.
> I will use (void) instead of (void *) to avoid compiler warning.
>

This discussion inspired me to try this:

#define PRESERVE_TYPE_INFO(type) ((void)(type *)0)

... somewhere in any function ...

PRESERVE_TYPE_INFO(struct whatever_struct);

And it works! We should probably put this helper macro somewhere in
include/linux/bpf.h and use it consistently for cases like this.

> >
> > > Not sure whether we could easily find a place for such casting or not.
> This can be done in bpf_struct_ops_init().
>
> Thanks for the tips!
