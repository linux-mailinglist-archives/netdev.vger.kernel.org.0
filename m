Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA812E88F8
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 23:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhABW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 17:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbhABW01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 17:26:27 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FCFC061573;
        Sat,  2 Jan 2021 14:25:46 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id k4so22443172ybp.6;
        Sat, 02 Jan 2021 14:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avY5RmPLcCE/9xmKkt4hTetpHwa/Sr/9+j/k/Vxitbs=;
        b=XJmL+uVD29D7YsU+lWThZtABQ2VtHFN/Sa938Vu0nu4Kg/7NM1FRy6vgAJXbh+ejV3
         r/XGPs79+xmb70vjHL8fahTEDGwwIDRLnrLGAXKQqgP56gZBjj9Z1OGFsnEFPWd8Dmcu
         HUME9foRghbKrGKnwT+9G1+Wt42xT4zyhsEoqF375STn+atcdXJsIznHKGe+JXFDetei
         XNjBMoE78TRbop0iSLhltprrksH9P7J+uYsowO055qPE+vMBJ3RENmvwYSwCzS2wJG9Z
         WF/S27WllKPv/EnhTPo0y6Q+GsNNJpyn2EjUbXZZY9Kng7lY/W4Q+SoQel4i5guSNdMn
         wpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avY5RmPLcCE/9xmKkt4hTetpHwa/Sr/9+j/k/Vxitbs=;
        b=prPsCGSGxDKz7lZqj3Nf9GX2jrCUWEu1pXvgheQQ/X3XkhLhqncYeVZe3qQWx8s6LK
         R9AGfWt7d+IzbJWss+pdzUlfoQcPhbgVxf/bV7qNPRLyIY+ZJjUCJ9wwYbKja3FlRXvp
         PfPE1uRPR0idDdNv7tYmrnOJHsYc1+KQQKu7WQpV6agOqPzAwQH7exEEXpdxOYKay7wO
         43XKs+ar25MXI6oqou7ki61AfPKAviEqwQRbNrbbv5ZSFKHvedCSxxiUoad8Qb0r0kcB
         akLGQpPflT4hkVIJIlnVmUWle228t5F5EshIr7uNMpAMX27tYkT+xG+pg7e7LK3OeeIt
         jdOA==
X-Gm-Message-State: AOAM531yMNgE4IcKvFVosmc+0gEPx/OD05OKsDK3Uy3u66OSFBMv3gsT
        52//rm5qWkeNZYIyT/hcLNIuTblY0Od1T9tzrDWARL/8
X-Google-Smtp-Source: ABdhPJx4pHQUmCj+6LEz4sWjx2M9wvyQIeaoqjOXvtKyUofxXbVVF17sNnfHJ3eiHe4I6NAt3f3TvjffSOaXfpdk3nw=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr91883751ybg.27.1609626345652;
 Sat, 02 Jan 2021 14:25:45 -0800 (PST)
MIME-Version: 1.0
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin> <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin> <20201230090333.GA577428@krava> <20201230132759.GB577428@krava>
In-Reply-To: <20201230132759.GB577428@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 2 Jan 2021 14:25:34 -0800
Message-ID: <CAEf4BzYbeQqzK2n9oz6wqysVj35k+VZC7DZrXFEtjUM6eiyvOA@mail.gmail.com>
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 5:28 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Dec 30, 2020 at 10:03:37AM +0100, Jiri Olsa wrote:
> > On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> > > Hi Jiri
> > >
> > > On 12/29/20 18:34, Jiri Olsa wrote:
> > > > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > > > Hi
> > > > >
> > > > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > > > stage
> > > > >
> > > > >         FAILED unresolved symbol udp6_sock
> > > > >
> > > > > I cross compile for arm64. My .config is attached.
> > > > >
> > > > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > > >
> > > > > Have you seen this before? I couldn't find a specific report about this
> > > > > problem.
> > > > >
> > > > > Let me know if you need more info.
> > > >
> > > > hi,
> > > > this looks like symptom of the gcc DWARF bug we were
> > > > dealing with recently:
> > > >
> > > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> > > >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > > >
> > > > what pahole/gcc version are you using?
> > >
> > > I'm on gcc 9.3.0
> > >
> > >     aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> > >
> > > I was on pahole v1.17. I moved to v1.19 but I still see the same problem.
> >
> > I can reproduce with your .config, but make 'defconfig' works,
> > so I guess it's some config option issue, I'll check later today
>
> so your .config has
>   CONFIG_CRYPTO_DEV_BCM_SPU=y
>
> and that defines 'struct device_private' which
> clashes with the same struct defined in drivers/base/base.h
>
> so several networking structs will be doubled, like net_device:
>
>         $ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
>         [2731] STRUCT 'net_device' size=2240 vlen=133
>         [113981] STRUCT 'net_device' size=2240 vlen=133
>
> each is using different 'struct device_private' when it's unwinded
>
> and that will confuse BTFIDS logic, becase we have multiple structs
> with the same name, and we can't be sure which one to pick
>
> perhaps we should check on this in pahole and warn earlier with
> better error message.. I'll check, but I'm not sure if pahole can
> survive another hastab ;-)
>
> Andrii, any ideas on this? ;-)

It's both unavoidable and correct from the C type system's
perspective, so there is nothing for pahole to warn about. We used to
have (for a long time) a similar clash with two completely different
ring_buffer structs. Eventually they just got renamed to avoid
duplication of related structs (task_struct and tons of other). But
both BTF dedup and CO-RE relocation algorithms are designed to handle
this correctly, so perhaps BTFIDS should be able to handle this as
well?

>
> easy fix is the patch below that renames the bcm's structs,
> it makes the kernel to compile.. but of course the new name
> is probably wrong and we should push this through that code
> authors

In this case, I think renaming generic device_private name is a good
thing regardless.

>
> jirka
>
>
> ---

[...]
