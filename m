Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642CE3C3BBA
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhGKLPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 07:15:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1743EC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 04:12:56 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bu12so27329705ejb.0
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 04:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4VjI0dQU7YjtbI20JO/PvGo26wrqfD9+dK0FQk8igs=;
        b=it5n9o3vEc7OohKZ+e7HAx7AMImr2A4fi+vzJf6JBhdRw5Sir4mReNkeK5jR4wGT6g
         DWmNEzdIsdN5G6BhgjW9TAP54EiX+PJBgwZ9cZywd2tnJFVQoq4fstwywj5iBAiR6mDk
         gB3dpIzRXwrnSYPiiWmXFHurRF8aCDzFrIZYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4VjI0dQU7YjtbI20JO/PvGo26wrqfD9+dK0FQk8igs=;
        b=WKgUYLvKut0ecaRIb1bj4rziAC5Hp6utpprnfWKB51Dh+0qbnIA1C0KGo6wJLkoZH8
         m4zK2gWUS1a/LipkxT/hrTBE0ifwCB+SQP7/4btB6z0Pp7TN9LkIHQVeaiFYXjDry8Ra
         s/IOUdWCa7N/Ye/M6ue1Q1MUy2ioErSaCOLnjmkTudZki3v4muK+WwbhCk9HBHzLWa4s
         LuxGKPsAnlzL8UQ3g0hbEB10G9OUO+D5sJOgkALUr42JIBuweDVfEPEQWLuC55oLhwXo
         QpIZ7EXWR4hZnXcmVrhMvyZdh/MwdyIuE1aL6jTIy8hiZx5EYL018kZ9wLOOCmmWTBCi
         OC1w==
X-Gm-Message-State: AOAM533bWI4sYIBxegrZyvRM0Dv9rGYW0qcZlxH0HukYz3snh/1J/dSX
        S1/boGopJlo5H1CdNJci2jxcd/9jnRzK1+bmauueZQ==
X-Google-Smtp-Source: ABdhPJwxwNl6K1KHRbJubyyvykn5HatU7G3I0xIu+dd1UyyHmCLChPZ5PewPS5e+Xyk+kp7K/0IYhr+6IOjn2eCE8IY=
X-Received: by 2002:a17:907:990f:: with SMTP id ka15mr48049577ejc.132.1626001974480;
 Sun, 11 Jul 2021 04:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
 <162566940335.13544.6152983012879947638.git-patchwork-notify@kernel.org>
 <fe6efc85-17d3-0fb9-4f61-db5b72bce8e7@nvidia.com> <d08ccca0-e399-4a8f-d8f9-62251959d716@nvidia.com>
In-Reply-To: <d08ccca0-e399-4a8f-d8f9-62251959d716@nvidia.com>
From:   Alexander Mihalicyn <alexander@mihalicyn.com>
Date:   Sun, 11 Jul 2021 14:12:43 +0300
Message-ID: <CAJqdLrqCMsXuYKjzD8_kreZe2NzK1tek550Tmth2XiGoOxjLcg@mail.gmail.com>
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
To:     Roi Dayan <roid@nvidia.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, Roi.

I will send a patch soon.

On Sun, Jul 11, 2021 at 2:09 PM Roi Dayan <roid@nvidia.com> wrote:
>
>
>
> On 2021-07-11 1:59 PM, Roi Dayan wrote:
> >
> >
> > On 2021-07-07 5:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> >> Hello:
> >>
> >> This patch was applied to iproute2/iproute2.git (refs/heads/main):
> >>
> >> On Wed,  7 Jul 2021 15:22:01 +0300 you wrote:
> >>> We started to use in-kernel filtering feature which allows to get only
> >>> needed tables (see iproute_dump_filter()). From the kernel side it's
> >>> implemented in net/ipv4/fib_frontend.c (inet_dump_fib),
> >>> net/ipv6/ip6_fib.c
> >>> (inet6_dump_fib). The problem here is that behaviour of "ip route save"
> >>> was changed after
> >>> c7e6371bc ("ip route: Add protocol, table id and device to dump
> >>> request").
> >>> If filters are used, then kernel returns ENOENT error if requested table
> >>> is absent, but in newly created net namespace even RT_TABLE_MAIN table
> >>> doesn't exist. It is really allocated, for instance, after issuing
> >>> "ip l set lo up".
> >>>
> >>> [...]
> >>
> >> Here is the summary with links:
> >>    - [PATCHv5,iproute2] ip route: ignore ENOENT during save if
> >> RT_TABLE_MAIN is being dumped
> >>
> >> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=459ce6e3d792
> >>
> >>
> >> You are awesome, thank you!
> >> --
> >> Deet-doot-dot, I am a bot.
> >> https://korg.docs.kernel.org/patchwork/pwbot.html
> >>
> >>
> >
> >
> > Hi,
> >
> > I didn't get a chance to check but after this commit the utility ss
> > is crashing from libnetlink.c
> >
> > (gdb) bt
> > #0  0x0000000000000000 in ?? ()
> > #1  0x0000000000418980 in rtnl_dump_done (a=0x7fffffffdc00, h=0x449c80)
> > at libnetlink.c:734
> > #2  rtnl_dump_filter_l (rth=rth@entry=0x7fffffffdcf0,
> > arg=arg@entry=0x7fffffffdc00) at libnetlink.c:893
> > #3  0x00000000004197a2 in rtnl_dump_filter_nc
> > (rth=rth@entry=0x7fffffffdcf0, filter=filter@entry=0x40cdf0
> > <show_one_inet_sock>,
> >      arg1=arg1@entry=0x7fffffffdca0, nc_flags=nc_flags@entry=0) at
> > libnetlink.c:957
> > #4  0x0000000000406dc7 in inet_show_netlink (dump_fp=dump_fp@entry=0x0,
> > protocol=protocol@entry=255, f=0x42e900 <current_filter>) at ss.c:3638
> > #5  0x0000000000404db3 in raw_show (f=0x42e900 <current_filter>) at
> > ss.c:3939
> >
> >
> > if I revert this commit I can run the ss utility ok.
> >
> > Thanks,
> > Roi
>
> I found for me ss crashed using a->errhndlr but it could be null
> in rtnl_dump_done()
>
> I see a second usage of a->errhndlr in rtnl_dump_error()
>
>
