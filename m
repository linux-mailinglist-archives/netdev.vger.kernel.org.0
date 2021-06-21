Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D03AE583
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFUJFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFUJFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 05:05:04 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6FCC061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 02:02:25 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t17so8741692lfq.0
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nq3WNLZDD5TUkqUq2T7xdTTFqt8QZMxPPek1GdjMl5o=;
        b=M6jGMhTNj9uXP03+2FLYoJLxmCiNYeikOTKx0N7ZrSDZyxsqQdxOC7rkXs54sDRIdm
         yoIJJG3F8BL77ZJ4/2ZkgOiO5HNRyaucEN8krsvqMkgPOpX981SQ5CFKXHbf0vxDoLrw
         3s4gxG6ELt5enw3rmAJ1aVHwLGjDDkuZ1xiSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nq3WNLZDD5TUkqUq2T7xdTTFqt8QZMxPPek1GdjMl5o=;
        b=FhesctB1EHoCHLS3Id0juaYEdB6/z+0ygZwNKqdcSmbVvss7vmvPDlsXC4gvtvjN1R
         VKxaMHwzeyLXrFgQiSxowt9PtCAMxvPfvwGSGggmvGlB/CDhDYyB7HMZ3mA0Q84N/Dm/
         NYVUBjuzjxQCUCqgqP2FuKwAO4s6N4wncBgrv2+LvysDlARlQqLduro2Sf5gDFyCOjk3
         PI6XY4KDP8qkZNo83w2X1Gw9mHI3EuqdtYvPAmV4XM5iBGJVcHYgZhiKe5l65ylcfcJ7
         GVfO08SXxw2MpjmnpeFEp8KoAgPrYiOohRNnVaH1RSFbSmAI/4JYoeRMUCJ9YDfih0C3
         jM0Q==
X-Gm-Message-State: AOAM533QgU/bgX2rugazhKLUezTi7Sm5ni2JhEvQtitmK1dq+vsuZyBE
        VrRKXWymXko22xVZ9VRrFYborWw30NEwhtR9fD4SnA==
X-Google-Smtp-Source: ABdhPJxcORZTI+CnqMEeMcoOmhmNiHs5AdCZXgv+zwbf1dsl255ey/bFramLzM3YYgdZiwH9G8yDYATX/pAuIwxRkWc=
X-Received: by 2002:a19:ae0b:: with SMTP id f11mr3223902lfc.13.1624266143342;
 Mon, 21 Jun 2021 02:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com>
 <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com> <CANP3RGdrpb+KiD+a29zTSU3LKR8Qo6aFdo4QseRvPdNhZ_AOJw@mail.gmail.com>
In-Reply-To: <CANP3RGdrpb+KiD+a29zTSU3LKR8Qo6aFdo4QseRvPdNhZ_AOJw@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 21 Jun 2021 10:02:12 +0100
Message-ID: <CACAyw9948drqRE=0tC=5OrdX=nOVR3JSPScXrkdAv+kGD_P3ZA@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 at 19:30, Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> On Fri, Jun 18, 2021 at 4:55 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Fri, 18 Jun 2021 at 11:55, Maciej =C5=BBenczykowski
> > <zenczykowski@gmail.com> wrote:
> > >
> > > This reverts commit d37300ed182131f1757895a62e556332857417e5.
> > >
> > > This breaks Android userspace which expects to be able to
> > > fetch programs with just read permissions.
> >
> > Sorry about this! I'll defer to the maintainers what to do here.
> > Reverting leaves us with a gaping hole for access control of pinned
> > programs.
>
> Not sure what hole you're referring to.  Could you provide more details/e=
xplanation?
>
> It seems perfectly reasonable to be able to get a program with just read =
privs.
> After all, you're not modifying it, just using it.

Agreed, if that was what the kernel is doing. What you get with
BPF_F_RDONLY is a fully read-write fd, since the rest of the BPF
subsystem doesn't check program fd flags. Hence my fix to only allow
O_RDWR, which matches what the kernel actually does. Otherwise any
user with read-only access can get a R/W fd.

> AFAIK there is no way to modify a program after it was loaded, has this c=
hanged?

You can't modify the program, but you can detach it, for example. Any
program related bpf command that takes a program fd basically.

> if so, the checks should be on the modifications not the fd fetch.

True, unfortunately that code doesn't exist. It's also not
straightforward to write and probably impossible to backport.

> I guess one could argue fetching with write only privs doesn't make sense=
?
>
> Anyway... userspace is broken... so revert is the answer.
>
> In Android the process loading/pinning bpf maps/programs is a different
> process (the 'bpfloader') to the users (which are far less privileged)

If the revert happens you need to make sure that all of your pinned
state is only readable by the bpfloader user. And everybody else,
realistically.

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
