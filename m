Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91605CBFF1
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390122AbfJDQA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:00:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37941 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389968AbfJDQA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:00:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id j31so9233271qta.5;
        Fri, 04 Oct 2019 09:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x43H1WdVB+aQVcMTCl4K6HWVYDlcjHA+H+vCbPPnykA=;
        b=XmugAvUYqqNk1EWBTr1DPoDima0fEoFMd3XmyLWw9bSqlSBcVN/BYVbZwBZwVD2aHp
         V6NNYWCZfkqeBOBD3RLa1uVVq84N92wa3fC/x4Yy0snz4m9mgLXXnraaz0BGK79d4l9n
         nWcy8xDgQi5OMtg0t+dG83FwGg5f8Q8+ZOj2tDCCi1DH3Zqgbpt3ghfIQJwLkapYZ3/h
         LAv0EbE/ERmkFoulbvlo2+PjgRd+Vu6qijKUy217YcqnFlszSItH4vLn9e8PosZqFVlw
         Jb+spOQokoonmvdmQdxB9wivlJdiEihWDfaGtTotAdbsg4rQe7euiNwWp9/UMRPXzP27
         SR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x43H1WdVB+aQVcMTCl4K6HWVYDlcjHA+H+vCbPPnykA=;
        b=YFl5U4rAyNjuv3z3Fxw1oIIHy0+25v76vqIdUvJiqLI6gGY89kVyYhTM7et2r7qiTt
         SPEs231Lw15sh9HZM36oEQl/3JUPw73i89Bs8YrsH+wQi/Ics5dAjb45Da+K5jbr+Qfg
         uSTa2hQQbbXKjEJLY5i3VwwJsEOGP4XoXG8ZmJjXSZbR0YhKS0Wuo8qrEubZKQp+LB3A
         vhsqDBljHmH9qp7UoVJUsjVL4RS5autAZgSH8/NZ/rwQgzL9P2yX2ff8/PdYY/3dF/2E
         zZS3OShzbNcv8y7jPzrypY1v4sQMbUFvFCp2X+SQ/ChZrhghkETXjd/TNefjQkEzj79Y
         2/Vw==
X-Gm-Message-State: APjAAAXf9r1/OoC1VqqF46+TzDcWjy2CMEA2deKJ+vN0QZg7AS27hYYP
        kg73mLK3c0sPwH+83Oc2Qqb6iMqUAHZdp+IYDTw=
X-Google-Smtp-Source: APXvYqzdvGDxzugMwOFPLGeHsIPnrsYId4GUWInlc1uUZONT16Ue3Bm79Xu8bTkJWVJqdE0JgvQcl2SO3Yn2lZZKdlI=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr16485127qtn.117.1570204853511;
 Fri, 04 Oct 2019 09:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com> <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
In-Reply-To: <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 09:00:42 -0700
Message-ID: <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     David Ahern <dsahern@gmail.com>
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

On Fri, Oct 4, 2019 at 8:44 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/4/19 9:27 AM, Andrii Nakryiko wrote:
> > On Fri, Oct 4, 2019 at 7:47 AM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 10/3/19 3:28 PM, Andrii Nakryiko wrote:
> >>> Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
> >>> they are installed along the other libbpf headers. Also, adjust
> >>> selftests and samples include path to include libbpf now.
> >>
> >> There are side effects to bringing bpf_helpers.h into libbpf if this
> >> gets propagated to the github sync.
> >>
> >> bpf_helpers.h references BPF_FUNC_* which are defined in the
> >> uapi/linux/bpf.h header. That is a kernel version dependent api file
> >> which means attempts to use newer libbpf with older kernel headers is
> >> going to throw errors when compiling bpf programs -- bpf_helpers.h will
> >> contain undefined BPF_FUNC references.
> >
> > That's true, but I'm wondering if maintaining a copy of that enum in
> > bpf_helpers.h itself is a good answer here?
> >
> > bpf_helpers.h will be most probably used with BPF CO-RE and
> > auto-generated vmlinux.h with all the enums and types. In that case,
> > you'll probably want to use vmlinux.h for one of the latest kernels
> > anyways.
>
> I'm not following you; my interpretation of your comment seems like you
> are making huge assumptions.
>
> I build bpf programs for specific kernel versions using the devel
> packages for the specific kernel of interest.

Sure, and you can keep doing that, just don't include bpf_helpers.h?

What I was saying, though, especially having in mind tracing BPF
programs that need to inspect kernel structures, is that it's quite
impractical to have to build many different versions of BPF programs
for each supported kernel version and distribute them in binary form.
So people usually use BCC and do compilation on-the-fly using BCC's
embedded Clang.

BPF CO-RE is providing an alternative, which will allow to pre-compile
your program once for many different kernels you might be running your
program on. There is tooling that eliminates the need for system
headers. Instead we pre-generate a single vmlinux.h header with all
the types/enums/etc, that are then used w/ BPF CO-RE to build portable
BPF programs capable of working on multiple kernel versions.

So what I was pointing out there was that this vmlinux.h would be
ideally generated from latest kernel and not having latest
BPF_FUNC_xxx shouldn't be a problem. But see below about situation
being worse.

>
> >
> > Nevertheless, it is a problem and thanks for bringing it up! I'd say
> > for now we should still go ahead with this move and try to solve with
> > issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> > for someone, it's no worse than it is today when users don't have
> > bpf_helpers.h at all.
> >
>
> If this syncs to the github libbpf, it will be worse than today in the
> sense of compile failures if someone's header file ordering picks
> libbpf's bpf_helpers.h over whatever they are using today.

Today bpf_helpers.h don't exist for users or am I missing something?
bpf_helpers.h right now are purely for selftests. But they are really
useful outside that context, so I'm making it available for everyone
by distributing with libbpf sources. If bpf_helpers.h doesn't work for
some specific use case, just don't use it (yet?).

I'm still failing to see how it's worse than situation today.
