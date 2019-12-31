Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F9412D62E
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfLaEfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:35:40 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38709 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfLaEfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:35:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so13291930ljh.5
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 20:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HSpiwI9s4O/EziRMdZMFTUugUs0mUBaOxkNkmeopwNQ=;
        b=iUYw0o7+XJOUGoTvTe6bhrXu2hXu0zjKIVy95hfIrqSzkYxXP7ly103cbFGxcPcLgU
         +MzxlfrjcEKFPApcxeRRgPtDSjwji5OHjgI4vc4QQLirOEBMlfWcqtkG3yrjSbRhK997
         JMghloI2Jug35QlDTqCK1tX4qTVBH5k1Z30DtEdfG1Xi1XMnesKagvC6fbCNRL9W5j+I
         vfvdqe3neE1R/pGmQQrRojesvxzVbrqMxWhGeHALwVLnSVSDDtH/Ndum1ZyPoJa7sSQ8
         3WOYVYGJtngHpLDFZPt5yOH1V9wvjfw/x2Cekhb2+Q8iosMuKTz2WBvWOm3ym/xwVmDO
         VTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HSpiwI9s4O/EziRMdZMFTUugUs0mUBaOxkNkmeopwNQ=;
        b=KKwRpT20JpJZs3CCZa/I6BPtnCIgyNrhkg+dGYRyCLntbmG4BTAWDXk9szk/QQlW2L
         8qt13OaIUoUlO0TNUGVSU+mF9gkD88V6au6C0vBQUCTLH16ecJonMVXMyEucSnfm25oW
         xTHj36RQow7/Daylg1mbz58UukX/EeePZplTXBwKlD12wmcfuZ2+xZysDnMs1xl+3HdW
         ES4mqwYN4G8l/9612zQFyvhQ4siChrBkGKia4xy7R3L04qOCxklZ7gSgKRKf9TLto3KD
         CRWybtmJo1ryP8ryut4oaN8NZ1/HqkZskzJMVA6DhinaDnPj32xz4y8jxYcAiO205ICL
         n+xw==
X-Gm-Message-State: APjAAAXd7ofmL+z8PFsBSIYJRPDJhelEzU1AZc7tp+2O7F4QElF9OY9g
        5OfAdjMqm+FdmXmfOxAYQTTm7gwfuyEacOmfxCQdTA==
X-Google-Smtp-Source: APXvYqw9pKpIHVYqzHChu9RtfVxT0QHAILhm5glD7s/C+CFXzMz0oqAS5Fvcr5fU8IKJgpyl+Vz4Q+1N7uzO7Lv03lc=
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr38588764ljj.206.1577766937915;
 Mon, 30 Dec 2019 20:35:37 -0800 (PST)
MIME-Version: 1.0
References: <20191220001517.105297-1-olof@lixom.net> <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
 <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
In-Reply-To: <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Mon, 30 Dec 2019 20:35:27 -0800
Message-ID: <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
To:     Olof Johansson <olof@lixom.net>
Cc:     Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 1:19 PM Olof Johansson <olof@lixom.net> wrote:
>
> On Thu, Dec 19, 2019 at 6:07 PM Joe Perches <joe@perches.com> wrote:
> >
> > On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> > > Use "%zu" for size_t. Seen on ARM allmodconfig:
> > []
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
> > []
> > > @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
> > >       len = nstrides << wq->fbc.log_stride;
> > >       wqe = mlx5_wq_cyc_get_wqe(wq, ix);
> > >
> > > -     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
> > > +     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
> > >               mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
> > >       print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
> > >  }
> >
> > One might expect these 2 outputs to be at the same KERN_<LEVEL> too.
> > One is KERN_INFO the other KERN_WARNING
>
> Sure, but I'll leave that up to the driver maintainers to decide/fix
> -- I'm just addressing the type warning here.

Hi Olof, sorry for the delay, and thanks for the patch,

I will apply this to net-next-mlx5 and will submit to net-next myself.
we will fixup and address the warning level comment by Joe.

>
>
> -Olof
