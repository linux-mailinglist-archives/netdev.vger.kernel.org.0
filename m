Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B10137A0D
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 00:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgAJXTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 18:19:03 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35935 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgAJXTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 18:19:03 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so3828336ljg.3;
        Fri, 10 Jan 2020 15:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sDCm2fAgdbf9iSd/cGIS/CChQu2q61Zn9eY7u0OfUvA=;
        b=mSXSzvDisimwy4fkPM0YoB3LyDLUDwqWRyHDDL9TbdonJkxVuiWmNym9tx/UBqT/oy
         6YyoKqxhS9fU2n/yHjkdK/4+dWFx80x6lGGx4ruh0cLAJwHoASZQo0QaqjFECG0yrNN7
         TbLzcJubxPIWx14YYb3VytxYW/tOw0lsHTOfF76XMnpFYUuZ7aZ6omUmN7D+ob09G+7B
         y306y84V1d4qg9kP6oYcVS5FmbYeB2MXPegicIZWqJK7A0kDC1wknXUtB/b6nG/TQ6vc
         v7vrI/Oh+C9/RDE3+jI5vVi9FDgAZcb51u6HuQXb7o/cR/5xo67iIdyoADeuKbQFQRYQ
         X0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sDCm2fAgdbf9iSd/cGIS/CChQu2q61Zn9eY7u0OfUvA=;
        b=VbSlsvy6S9zx7Dh3mbwJoy9Pg14lYmFHgD4YW4+IKZdNpimA8lgJ2n+OaCiyesXtiU
         SNo+qPssErTGRUPONz6VuqCf+fS3fI/I+WZOPE2pQs1QbPOUupCj64WDWDY0UF4cM8P3
         chIIPsJ/7k9+395h+OuOY+gNr9OpD79SRHQOoLIogAgGXR8MO69p4Oi6sHcOpU3lnGU+
         of+ymcLlBP8fW06SB1DrElyF+xnSGsmSotsEYtajmK8tqYAViCSW1WsQ2ywuJBT5DhXB
         u6tMprn7NhOzZiqv8YrAETE+dI+19/COuc1NSGivx1xo0YqiFEjPaCXtj6aJG4dED3U9
         gdug==
X-Gm-Message-State: APjAAAXRIDo6iP6bWDUKjlW8E5fHXJIZbnsR7M+RgxgjmccTSM57yXq+
        8G0Dt8w20EkIyuxMSTWGc/9JnT14zMtunP0JMus=
X-Google-Smtp-Source: APXvYqyaEFKCy5sJpJYQlDZvnYhNy46CPEXRLWAVXF7WAT3sWxG5jqbHave+p4yRBIPkNC2TJa/MqW6xq+4teZD3kgY=
X-Received: by 2002:a2e:58c:: with SMTP id 134mr4241974ljf.12.1578698341335;
 Fri, 10 Jan 2020 15:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20191018105657.4584ec67@canb.auug.org.au> <20191028110257.6d6dba6e@canb.auug.org.au>
 <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
In-Reply-To: <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jan 2020 15:18:50 -0800
Message-ID: <CAADnVQLo5HEjTpTTRm=BtExuKifPtCJm+Hu_WP6yeyV-Er55Qg@mail.gmail.com>
Subject: Re: Re: linux-next: build warning after merge of the bpf-next tree
To:     Alexandre Ghiti <alexandre@ghiti.fr>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, zong.li@sifive.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 2:28 PM Alexandre Ghiti <alexandre@ghiti.fr> wrote:
>
> Hi guys,
>
> On 10/27/19 8:02 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > On Fri, 18 Oct 2019 10:56:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> Hi all,
> >>
> >> After merging the bpf-next tree, today's linux-next build (powerpc
> >> ppc64_defconfig) produced this warning:
> >>
> >> WARNING: 2 bad relocations
> >> c000000001998a48 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_start
> >> c000000001998a50 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_end
> >>
> >> Introduced by commit
> >>
> >>    8580ac9404f6 ("bpf: Process in-kernel BTF")
> > This warning now appears in the net-next tree build.
> >
> >
> I bump that thread up because Zong also noticed that 2 new relocations for
> those symbols appeared in my riscv relocatable kernel branch following
> that commit.
>
> I also noticed 2 new relocations R_AARCH64_ABS64 appearing in arm64 kernel.
>
> Those 2 weak undefined symbols have existed since commit
> 341dfcf8d78e ("btf: expose BTF info through sysfs") but this is the fact
> to declare those symbols into btf.c that produced those relocations.
>
> I'm not sure what this all means, but this is not something I expected
> for riscv for
> a kernel linked with -shared/-fpie. Maybe should we just leave them to
> zero ?
>
> I think that deserves a deeper look if someone understands all this
> better than I do.

Are you saying there is a warning for arm64 as well?
Can ppc folks explain the above warning?
What does it mean "2 bad relocations"?
The code is doing:
extern char __weak _binary__btf_vmlinux_bin_start[];
extern char __weak _binary__btf_vmlinux_bin_end[];
Since they are weak they should be zero when not defined.
What's the issue?
