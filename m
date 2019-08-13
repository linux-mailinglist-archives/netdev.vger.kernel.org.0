Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5028C371
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfHMVS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:18:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42464 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfHMVS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:18:28 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so19332842qtp.9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H+mnDYHuC3PokVpqw1Ig69wnCRxG9uUoa4v1omN5vMw=;
        b=NNKN0NpcLBGi+MLR2jgNsxjidmNMp5kIeJkMC5GGqSvb19ckWS81k+A+JKnN9O5Pq4
         jtu5nkezJGbfqE9wbTvg/A3q/V+qDTi3jdl4W1UNupN242hKHlt3aI/fKEeAmkzTXuYO
         WxmXAqFB/18zLGUog52qL+QxDK4n9PV7NUOarMaobm91zGNgQT5KmK5tgMRH8jV6vqn2
         iOFqSYIsTlIgz68/vv5xj/gpq3Hto1QdQXYWO30WMDNOMG7HKafP2fuZTjKS/wMuC4ZO
         +UnYgPOUPIhxE/Vwbh0hl29tomPqX6PNVr7kT4TnV9q1p6j3p+F8J1cQuwVv5edswSYN
         JYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H+mnDYHuC3PokVpqw1Ig69wnCRxG9uUoa4v1omN5vMw=;
        b=FsWqSGIZHMUqoKvikir1jKk2f5q6zSCA4kgmwh4qU5L6fsBC8BOtfw4A7t8bhoSYyw
         DRg6E+FatRk7NaK5jXmy+zYgCjlFOR9l6oyxS1M30AK3GwiqFd1G56IJBfL7sZGrNjN5
         D/EEFMFUiikNFp8/oSqmfRcAkQpKRse2NnXnGEoJ//d05haBQjjiqLVNvaCQ0iMmWPAs
         N9vLRKntFJY8mIH39YRlwfR0n39nlU80RZwNvyC9oBO8FlY0Z5ENI5gOXlQaSWxrj9te
         JevDMFqvqVKivzV4ALqnN01uc8IcUoR0264reK4CvuKGDWz6DEGU1eaj3yIvqUYC4Odg
         GyNw==
X-Gm-Message-State: APjAAAUsPIrkThfL121T7Jbt2DMQlf2ysR0pC9Rj5AqOjHnvpNrBWltE
        H5c6FHJReugxgvVPLLobg0PfWEtH16mtWgpm2NtsVb+7sShwLw==
X-Google-Smtp-Source: APXvYqzquR3v/OLu13FsOe1EBDCagSPoF8uws1CqGbYjwYIUWd6RYPa79CyTxRqKqbcuXmCkof4CMo39CPgLUdpkLVo=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr32994258qtq.93.1565731107446;
 Tue, 13 Aug 2019 14:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
 <CAEf4BzZ27SnYkQ=psqxeWadLhnspojiJGQrGB0JRuPkP+GTiNQ@mail.gmail.com> <CAAej5NbwZ80MNQYxP4NiJXheAn1DcSgm+O3zQQgCoP03HGHEgQ@mail.gmail.com>
In-Reply-To: <CAAej5NbwZ80MNQYxP4NiJXheAn1DcSgm+O3zQQgCoP03HGHEgQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 14:18:16 -0700
Message-ID: <CAEf4BzZqj-kuFC0Jv-i3k-sSdZE6ThihvqXvnss5rDR7ZRYGzQ@mail.gmail.com>
Subject: Re: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
To:     Fejes Ferenc <fejes@inf.elte.hu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 1:48 PM Fejes Ferenc <fejes@inf.elte.hu> wrote:
>
> Thanks for the answer, I really appreciate it. I tried omitting

Please reply inline, no top posting on kernel mailing lists.

> "cgroup/skb" to let libbpf guess the attach type, but I got the same
> error. Really interesting, because I got the error
> > libbpf: failed to load program 'cgroup_skb/egress'
> wich is weird because it shows that libbpf guess the program type
> correctly. So something definitely on my side - thank you for verifyng
> that - I try to investigate it!

What was the error message you got after you provided correct program
attach type?

>
> Ferenc
> Andrii Nakryiko <andrii.nakryiko@gmail.com> ezt =C3=ADrta (id=C5=91pont: =
2019.
> aug. 12., H, 20:27):
> >
> > On Mon, Aug 12, 2019 at 1:59 AM Fejes Ferenc <fejes@inf.elte.hu> wrote:
> > >
> > > Greetings!
> > >
> > > I found a strange error when I tried to load a BPF_CGROUP_INET_EGRESS
> > > prog with bpftool. Loading the same program from C code with
> > > bpf_prog_load_xattr works without problem.
> > >
> > > The error message I got:
> > > bpftool prog loadall hbm_kern.o /sys/fs/bpf/hbm type cgroup/skb
> >
> > You need "cgroup_skb/egress" instead of "cgroup/skb" (or try just
> > dropping it, bpftool will try to guess the type from program's section
> > name, which would be correct in this case).
> >
> > > libbpf: load bpf program failed: Invalid argument
> > > libbpf: -- BEGIN DUMP LOG ---
> > > libbpf:
> > > ; return ALLOW_PKT | REDUCE_CW;
> > > 0: (b7) r0 =3D 3
> > > 1: (95) exit
> > > At program exit the register R0 has value (0x3; 0x0) should have been
> > > in (0x0; 0x1)
> > > processed 2 insns (limit 1000000) max_states_per_insn 0 total_states =
0
> > > peak_states 0 mark_read 0
> > >
> > > libbpf: -- END LOG --
> > > libbpf: failed to load program 'cgroup_skb/egress'
> > > libbpf: failed to load object 'hbm_kern.o'
> > > Error: failed to load object file
> > >
> > >
> > > My environment: 5.3-rc3 / net-next master (both producing the error).
> > > Libbpf and bpftool installed from the kernel source (cleaned and
> > > reinstalled when I tried a new kernel). I compiled the program with
> > > Clang 8, on Ubuntu 19.10 server image, the source:
> > >
> > > #include <linux/bpf.h>
> > > #include "bpf_helpers.h"
> > >
> > > #define DROP_PKT        0
> > > #define ALLOW_PKT       1
> > > #define REDUCE_CW       2
> > >
> > > SEC("cgroup_skb/egress")
> > > int hbm(struct __sk_buff *skb)
> > > {
> > >         return ALLOW_PKT | REDUCE_CW;
> > > }
> > > char _license[] SEC("license") =3D "GPL";
> > >
> > >
> > > I also tried to trace down the bug with gdb. It seems like the
> > > section_names array in libbpf.c filled with garbage, especially the
> >
> > I did the same, section_names appears to be correct, not sure what was
> > going on in your case. The problem is that "cgroup/skb", which you
> > provided on command line, overrides this section name and forces
> > bpftool to guess program type as BPF_CGROUP_INET_INGRESS, which
> > restricts return codes to just 0 or 1, while for
> > BPF_CGROUP_INET_EGRESS i is [0, 3].
> >
> > > expected_attach_type fields (in my case, this contains
> > > BPF_CGROUP_INET_INGRESS instead of BPF_CGROUP_INET_EGRESS).
> > >
> > > Thanks!
