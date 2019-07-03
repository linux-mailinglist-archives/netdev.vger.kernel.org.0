Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6B5EF84
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfGCXH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:07:27 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37692 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCXH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:07:26 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so4201347ljf.4
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j3jNf7k3x2oS0L8a3r/CtdN6GNGTrhGqHoOQJnQQ9vs=;
        b=g3FHjSn9ulgktyZfGQMeS0RW83jrw2WQgYV/n3RoUcyNOVFfEweE/kTC5XoLrx2vom
         cH7M7OBTyCQysmfIPuJDUDStha0PllnbdB9jTxcK5ZB9VIERo4gyKo7j/Rr3J3qpK2vf
         /+6j8C2zMmdtKALdfXR1O8YkNLMyYtd6lNSRuMe605HAHa+nPcSXrNCh7f14YyDAsxDq
         /2KDqoWoQIrxBjOIThGlV0/2ofLCGs+qVvUv+Ir7dI1R1b6y5hmx5sW7tC2dC1poBsr3
         OPxc3AAGYaMXAixDQOnL3FTwgGrTAoOehwZNk+yQWgnJD11xyQKdS/5rM3nwta8BcE6j
         9utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j3jNf7k3x2oS0L8a3r/CtdN6GNGTrhGqHoOQJnQQ9vs=;
        b=eMFPI6ckFuZ76ucH1jN0ui8LPvUMJLQCN7ghAObXxYv99eAHG2F0nILty27ZRK/Y6Z
         0BTNgmF8dI90zpb+42N640yEEiHsCSLy7b3xs6ERQDrTcVkg28QsOtaLziYvBfr7DKFj
         88IOSViFpsVGLGPSd0T0MHfsm1qdrLvBNBl80UJ2tUz/SCSCIaYzMBrrsdXTMPZFnjAJ
         zGnl+VKBLj0XH2PL3yhsxft1cT1J8dCkVkA7uEnKNOREzJd8QhQ/BOR0Mf2b5xwgseIo
         LZ7xJca7+wRmhdViFIbJ/vviVJNY57Ot8HbM2OHtKGSHvpFHQs8yNJTmKAfcvgROKGOs
         3BVg==
X-Gm-Message-State: APjAAAWYCzmBVY/7BTbb3IGwkV5XEO/8tpQR93aThdz4696CYBi2s8JE
        1W+xfclKJ/8az1MHyiGxG1HFRHKAXp8dbahqhLwAvA==
X-Google-Smtp-Source: APXvYqwaV5Fn0JdLvHGbrjpMxuwTJQgN+8EYxT+CFJtxb4q1qDSItY/yELlkxpIxwun7KMu69m350ktuy8HeaJOqx+c=
X-Received: by 2002:a05:651c:95:: with SMTP id 21mr282017ljq.128.1562195244894;
 Wed, 03 Jul 2019 16:07:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190702235442.1925-1-saeedm@mellanox.com> <20190703.134700.1755482990570068688.davem@davemloft.net>
 <20190703.134935.540885263693556753.davem@davemloft.net>
In-Reply-To: <20190703.134935.540885263693556753.davem@davemloft.net>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Wed, 3 Jul 2019 16:07:11 -0700
Message-ID: <CALzJLG97wQ8EE+XwuCO-wuS0YcYQmSfzu12TFJupp3AAg76U=w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
To:     David Miller <davem@davemloft.net>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 1:49 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Wed, 03 Jul 2019 13:47:00 -0700 (PDT)
>
> > From: Saeed Mahameed <saeedm@mellanox.com>
> > Date: Tue, 2 Jul 2019 23:55:07 +0000
> >
> >> This humble 2 patch series from Shay adds the support for devlink fw
> >> versions query to mlx5 driver.
> >>
> >> In the first patch we implement the needed fw commands to support this
> >> feature.
> >> In the 2nd patch we implement the devlink callbacks themselves.
> >>
> >> I am not sending this as a pull request since i am not sure when my ne=
xt
> >> pull request is going to be ready, and these two patches are straight
> >> forward net-next patches.
> >
> > Series applied to net-next, thanks.
>
> This doesn't build, there is some dependency...
>
> [davem@localhost net-next]$ make -s -j14
> In file included from ./include/linux/mlx5/driver.h:51,
>                  from drivers/net/ethernet/mellanox/mlx5/core/fw.c:33:
> drivers/net/ethernet/mellanox/mlx5/core/fw.c: In function =E2=80=98mlx5_r=
eg_mcqi_query=E2=80=99:
> ./include/linux/mlx5/device.h:68:36: error: invalid application of =E2=80=
=98sizeof=E2=80=99 to incomplete type =E2=80=98union mlx5_ifc_mcqi_reg_data=
_bits=E2=80=99
>  #define MLX5_UN_SZ_DW(typ) (sizeof(union mlx5_ifc_##typ##_bits) / 32)
>                                     ^~~~~


Yep, My bad :(, I thought [1] was part of my last pull, but it wasn't
One way to solve this is if you pull latest mlx5-next branch form:
git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git
All patches there already passed review on net-next and rdma-next mailing l=
ists.

Or just  wait for my next pull request.

sorry for this!


[1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/comm=
it/?h=3Dmlx5-next&id=3Da82e0b5bdac29d9719d3ca2df01494a7947351aa
