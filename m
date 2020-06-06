Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F418D1F06D9
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgFFNvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgFFNvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 09:51:52 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B764DC03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 06:51:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b5so12413454iln.5
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 06:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F+9wkwDr0g/jeV+KxJCHUVeOp9M/qaTgyZ1qy5WGXvw=;
        b=nvzEP8Rn588dmc+IGLJKGZ1FouL34VjGLmyC9fU06866xCrsX6aE7c7WPEzSe8KS1F
         7ZQ+FBbLh+0W52xAFoXNBgEhLxcy7ZT8WQGNp6rd5N63XzqgQyjatZK38CgR11VHk47D
         HLdVEAssHz6ptHNnUB2DnP6dttRDh4B8S2ONtHUJT0Tis2zlfO9ZrBVk4oQRMp0kZg8t
         BHAKwPuIr2s2dle5but954xEG0TOC01taemiDMXsWzsn+/DtyG6iM8eKQ1SSatFsY/qF
         tWCYTMNwquXu+HhOChRG9XUCGR7wVx4g25SeT0r3j16jwhlKckBmfT4qISPjtsWJCotB
         y/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F+9wkwDr0g/jeV+KxJCHUVeOp9M/qaTgyZ1qy5WGXvw=;
        b=HIQ9QvLn5wdc4fkgYmcN9fFVf0ICw1hBBVfZOXyalSZuLW6NiCkIqynJZKLiqrpjIP
         tEEsF+jl/ANBwRQ4glEzMiSO4el69yzIRYX1OlO5uAveLRgAACZ5AhCl5uemnxp2VHuy
         3niwS6Ikos9pWWJp9dBDTnSpP/iDF+6ZTw4FfVQ5ARInMoypdy7CE/s7WY7YkxHl/pQ2
         4UJZ65kO2Fz1OPc3zlgcN5HW8Sh+6zYuGZVarihkcRyA4j8BjCrGEsEmrUU/fnf0KDqt
         0X3L7YYkWcPxSYLceldGKWGYMJS1jzBu1R1CHgBaZaOvXTn/h7wW6wpZ/t8vJF/tR+Kc
         0yKg==
X-Gm-Message-State: AOAM531qQgbnFoSgi/4W4lxtGG1hI3MmK3VYIn/trPRTxdEffV8vQ/Ib
        q5S7kXjQm+Fp3UB/a6J5MRvPD3JutW5wo0KrBjI=
X-Google-Smtp-Source: ABdhPJxdGkvq8vsc0SFmr23TgRiCh9on2OgwADp6aHmt1piaGifjLZ9USZtihoMeX/DR2JYvACI1STkYHAItcN2KZhk=
X-Received: by 2002:a05:6e02:144:: with SMTP id j4mr12900563ilr.214.1591451509906;
 Sat, 06 Jun 2020 06:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAEyMn7a5SwQtMxrrJ-C0Jy6THZcCCPXp5ouC+jRLH4ySK-8p_A@mail.gmail.com>
 <20200606134314.kphjg6mkdbcjsx6l@lion.mk-sys.cz> <CAEyMn7Y2BHT24cwBMKG5sTDek5MP2pcn+WKrn3OUkJtCsz4epw@mail.gmail.com>
In-Reply-To: <CAEyMn7Y2BHT24cwBMKG5sTDek5MP2pcn+WKrn3OUkJtCsz4epw@mail.gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sat, 6 Jun 2020 15:51:38 +0200
Message-ID: <CAEyMn7Y2vxKbNFoF7STy1EmJMQ6ZGpgscxAJPc7sDhfe+gmWgA@mail.gmail.com>
Subject: Re: ethtool build failure
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

Am Sa., 6. Juni 2020 um 15:47 Uhr schrieb Heiko Thiery <heiko.thiery@gmail.com>:
>
> Hi Michal,
>
> Am Sa., 6. Juni 2020 um 15:43 Uhr schrieb Michal Kubecek <mkubecek@suse.cz>:
> >
> > On Sat, Jun 06, 2020 at 03:24:22PM +0200, Heiko Thiery wrote:
> > > Hi Michael et all,
> > >
> > > I'm digging in the reason for a failure when building ethtool with
> > > buildroot [1].
> > >
> > > I see the following error:
> > > ---
> > > data/buildroot/buildroot-test/instance-0/output/host/bin/i686-linux-gcc
> > > -DHAVE_CONFIG_H -I.  -I./uapi  -D_LARGEFILE_SOURCE
> > > -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -D_LARGEFILE_SOURCE
> > > -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os   -static -c -o
> > > netlink/desc-rtnl.o netlink/desc-rtnl.c
> > > In file included from ./uapi/linux/ethtool_netlink.h:12,
> > >                  from netlink/desc-ethtool.c:7:
> > > ./uapi/linux/ethtool.h:1294:19: warning: implicit declaration of
> > > function '__KERNEL_DIV_ROUND_UP' [-Wimplicit-function-declaration]
> > >   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
> > >                    ^~~~~~~~~~~~~~~~~~~~~
> > > ./uapi/linux/ethtool.h:1294:8: error: variably modified 'queue_mask'
> > > at file scope
> > >   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
> > >         ^~~~~~~~~~
> > > ---
> >
> > Thank you for the report. This is fixed by first part of this patch:
> >
> >   https://patchwork.ozlabs.org/project/netdev/patch/bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz/
> >
> > I'm going to apply it (with the rest of the series) this weekend.
>
> I will try to apply this patch and check if the failure is gone.

I can confirm with the patch the failure is gone.

Many thanks for the fast help.
-- 
Heiko
