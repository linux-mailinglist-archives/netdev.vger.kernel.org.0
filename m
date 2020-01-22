Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088071459F4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVQgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:36:43 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39924 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVQgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:36:43 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so5604676ila.6
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9FK8ILS4gKEGyvvYVDTxyD1X36SRBkx7WZjPTcSEcs=;
        b=Z4L3hfliSUQrUzbrj1MlCEkPPFxOpnSbzpAFcwm7qeWX4e/pbbIKKl209hP+fISEnP
         vmVHrOvykodYtrqi2vT3bv7pJiPqyBZ4bO45dftH0rj0+1VZj+L9Umq4BlCP+rNOXfSt
         Ux/NJVyDycljikm6ED400Wi05ogQbRJkkITNZA+wbYQbIcUVZsxKI+JoUDi3qEERB1fw
         p5e4a2hLYkRgLpOi5xhS+1sdSlyDYJeoYxh3dQzC+CAmhwVlEJDXqxJEs8Y/Wn+WvHus
         fLXyX1KKqSxHHgSSEMoTPwIQ5Jpqxn4nMYI8q4ihvpw74thK6KX+clWCLXmZKGhr5hkb
         3BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9FK8ILS4gKEGyvvYVDTxyD1X36SRBkx7WZjPTcSEcs=;
        b=RryflTZh5VJ08tTf2aOs0IYmFTe+f+btni26a0zH+IXWq02ltftXQlI5PsHaDTl1Rq
         g7tgHm0B0+BHzzq71PgCWLn+7GXKCXYMRxl6JSyR3wv8IHQavGu/3f+hcm4bCPE+cR0K
         +2Hl5SzSeIZWTXE8H9ECv839WinisfOvFyuH4t7PEG1STw7+frfDfjPym1lx50sbLQNR
         eKDQauQuIChLTa0xYRccXuZtCxwK/bRZLzWC6yMGMRITxQEyzJxSICStYorCBKVSYGOs
         Cy+up1bNIu1fkIwAiFlrwdgqbRGDvzhpZ7pYY+3dKAYz/KVU+DT4H5QkcAUX79a8aSuc
         0jrA==
X-Gm-Message-State: APjAAAVAgsRQnaR0KAQA/QTzyGaz4n/XWxBK5wwqVJccDWqmZxS8yoqe
        0on4J5lzgt5pZkUtekgkACeP6C0xV8seVVa5lNnKSw==
X-Google-Smtp-Source: APXvYqwedMrTFJR7YUejP+7khV4HmZtJkv4f0XHaUeXhywVWfDRT2A/C5vTr++prJAvCa1vkPR7LStortsglGNfTrDQ=
X-Received: by 2002:a92:afc5:: with SMTP id v66mr8200600ill.123.1579711002748;
 Wed, 22 Jan 2020 08:36:42 -0800 (PST)
MIME-Version: 1.0
References: <20191220001517.105297-1-olof@lixom.net> <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
 <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
 <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
 <CAOesGMhXHCz+ahs6whKsS32uECVry9Lk6BQxcvczPXgcoh6b6w@mail.gmail.com> <028a4905eaf02dce476e8cfc517b49760f57f577.camel@mellanox.com>
In-Reply-To: <028a4905eaf02dce476e8cfc517b49760f57f577.camel@mellanox.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Wed, 22 Jan 2020 08:36:31 -0800
Message-ID: <CAOesGMjLXRO4epU0CFymYWdGYNWB4BNOaVxmnst-On3QzHLRNw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:43 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Mon, 2020-01-20 at 19:20 -0800, Olof Johansson wrote:
> > Hi,
> >
> > On Mon, Dec 30, 2019 at 8:35 PM Saeed Mahameed
> > <saeedm@dev.mellanox.co.il> wrote:
> > > On Sat, Dec 21, 2019 at 1:19 PM Olof Johansson <olof@lixom.net>
> > > wrote:
> > > > On Thu, Dec 19, 2019 at 6:07 PM Joe Perches <joe@perches.com>
> > > > wrote:
> > > > > On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> > > > > > Use "%zu" for size_t. Seen on ARM allmodconfig:
> > > > > []
> > > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
> > > > > > b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
> > > > > []
> > > > > > @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct
> > > > > > mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
> > > > > >       len = nstrides << wq->fbc.log_stride;
> > > > > >       wqe = mlx5_wq_cyc_get_wqe(wq, ix);
> > > > > >
> > > > > > -     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index
> > > > > > 0x%x, len: %ld\n",
> > > > > > +     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index
> > > > > > 0x%x, len: %zu\n",
> > > > > >               mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
> > > > > >       print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
> > > > > > 16, 1, wqe, len, false);
> > > > > >  }
> > > > >
> > > > > One might expect these 2 outputs to be at the same KERN_<LEVEL>
> > > > > too.
> > > > > One is KERN_INFO the other KERN_WARNING
> > > >
> > > > Sure, but I'll leave that up to the driver maintainers to
> > > > decide/fix
> > > > -- I'm just addressing the type warning here.
> > >
> > > Hi Olof, sorry for the delay, and thanks for the patch,
> > >
> > > I will apply this to net-next-mlx5 and will submit to net-next
> > > myself.
> > > we will fixup and address the warning level comment by Joe.
> >
> > This seems to still be pending, and the merge window is soon here.
> > Any
> > chance we can see it show up in linux-next soon?
> >
> >
>
> Hi Olof,
>
> I am still preparing my next pull request which will include this patch
> I will send it soon to net-next branch, but still the patch will not
> hit linux-next until the merge window when netdev subsystem is pulled
> into linux-next..

Hi Saeed,

linux-next contains all the material that maintainers are queuing up
for the next merge window, during the -rc cycles of the previous
release, including the net-next branch.

In general, the guideline is to make sure that most patches are in
-next around -rc6/rc7 timeframe, to give them some time for test
before merge window opens.

So the fact that this hasn't been picked up and showed up there yet,
seems concerning -- but I don't know when Dave closes net for new
material like what you're staging.


-Olof
