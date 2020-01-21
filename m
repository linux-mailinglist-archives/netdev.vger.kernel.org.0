Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBE01435DE
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 04:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgAUDUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 22:20:52 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44894 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAUDUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 22:20:52 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so1178455iln.11
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 19:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDcWE9EWGtVID/iKX16rez9xRzd/8Nb913yHk9dAMYM=;
        b=T5DUMBdxwLNNZ2G6qr8/JwsZn+Orq7oGwZHKldGB2lBt2xpg9AjyfbW2/wzCP9PSdm
         8CgNcUWgZa9614tn+w5aZLOx8tW88UzdZt/hmnm2yp/VClsrsP4l5QJfsoD6TuMd3dVE
         fmzAtzVsPouElzps7mYBPOH0HVkeS+xtAjSn/dpf+iG+W6x45PGkjEw3Hlh+8p2QR/fP
         bY7mC0S/30YPNLxD7TU3rd1Q7DEHzZ2vMbzHTpUOp0LnuxoIcqPaqpj0YWGSEVtJ8sfw
         KEgK6inoc29l49Yf8u+JVxMYKU030evP3NCibeYe+ThDYnvdckvBF2hhyl/nEY+sNUI2
         ms2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDcWE9EWGtVID/iKX16rez9xRzd/8Nb913yHk9dAMYM=;
        b=J4D40zW02v4WyS5BsXx+/HRX4R2XiI/JYQwuy1Q9mj+flcOX0hFnIrZi0AGXHkrZUD
         7QeHqo1+/b2T0iNrJ2VR+yQzPlSjmrlcCpf5DbtI/NaIDz/YGIvBtW9UTUnPW7S+cQmy
         B+PUprGO5K/gG1Dho+keFHcNc5Vq37na6zy7HpoO9tO9wHvKjyre5qVGEva5hyvfujP9
         6a2Cvit0iHgHsMllXCjKI8wFNHv1p0Cw3ZbPyPRi9JBz5bhK7TQXkhjCuA1GnXuX583M
         4GbwisHQmdICyp0+c87qPsyDKnptAFae/fyyf3c1U1P28dGe5Vs/Hk6S94r9H4iTS+Dw
         pD1g==
X-Gm-Message-State: APjAAAUbd/xposbYa4TVjnpS6iVi7i2U9E+Zaqc/qfSYVBPVgRO2zFju
        /VXcEIZ5hoI7Wsv0P54VSRoIww8YYgmtHxXJoJGggg==
X-Google-Smtp-Source: APXvYqx9zjbvVKABtdD59999UxaHDFsXuScZSoky+6zJEAyheszYYxPT63r0lZj7p1c8DjDNzhyUxBooXqS0Fhwfkxk=
X-Received: by 2002:a92:db49:: with SMTP id w9mr1812972ilq.277.1579576849943;
 Mon, 20 Jan 2020 19:20:49 -0800 (PST)
MIME-Version: 1.0
References: <20191220001517.105297-1-olof@lixom.net> <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
 <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com> <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
In-Reply-To: <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Mon, 20 Jan 2020 19:20:38 -0800
Message-ID: <CAOesGMhXHCz+ahs6whKsS32uECVry9Lk6BQxcvczPXgcoh6b6w@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
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

Hi,

On Mon, Dec 30, 2019 at 8:35 PM Saeed Mahameed
<saeedm@dev.mellanox.co.il> wrote:
>
> On Sat, Dec 21, 2019 at 1:19 PM Olof Johansson <olof@lixom.net> wrote:
> >
> > On Thu, Dec 19, 2019 at 6:07 PM Joe Perches <joe@perches.com> wrote:
> > >
> > > On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> > > > Use "%zu" for size_t. Seen on ARM allmodconfig:
> > > []
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
> > > []
> > > > @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
> > > >       len = nstrides << wq->fbc.log_stride;
> > > >       wqe = mlx5_wq_cyc_get_wqe(wq, ix);
> > > >
> > > > -     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
> > > > +     pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
> > > >               mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
> > > >       print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
> > > >  }
> > >
> > > One might expect these 2 outputs to be at the same KERN_<LEVEL> too.
> > > One is KERN_INFO the other KERN_WARNING
> >
> > Sure, but I'll leave that up to the driver maintainers to decide/fix
> > -- I'm just addressing the type warning here.
>
> Hi Olof, sorry for the delay, and thanks for the patch,
>
> I will apply this to net-next-mlx5 and will submit to net-next myself.
> we will fixup and address the warning level comment by Joe.

This seems to still be pending, and the merge window is soon here. Any
chance we can see it show up in linux-next soon?


Thanks,

-Olof
