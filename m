Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F18432AC6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfFCI2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:28:21 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:41110 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfFCI2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 04:28:21 -0400
Received: by mail-ua1-f68.google.com with SMTP id n2so6165888uad.8;
        Mon, 03 Jun 2019 01:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDoCDFTeq/DV5924Jr300cDXUIemOxujb3aLvb1Pkn0=;
        b=izqSZAFsSv7SOmGqsDoVfN9penvenlTefSopGisyHYiY/XskElii9B/+HWXg3LY744
         T5f2psSGpD9PJU7SbhE5E1k/7fbwKQu6BzfoPagMmVWs3mtkea2i9t8bVk9XEUKpi+iP
         stYqxHiW7ZczPEF3yWAmhGks+gpi73T7NJzTTy+q8uNFPSSPGDe5IkisuivboMSetRKF
         xQiX4fRkLAkVxfrUr+w/3FEQTD/SSydjPobocRo2lRJxoy4qzAhiqul6RFmKFgZZbXgx
         3R925AMT8OJf9H/lfFDk4RFZ8qei57vUyS3sBrdVOft5CaSurYGwoCpT01zEyVJdahHk
         jEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDoCDFTeq/DV5924Jr300cDXUIemOxujb3aLvb1Pkn0=;
        b=jJhfqZIfbCA+keYbRrjuHSkeaqOaZV7YzTheelELSUoZWXYEGRJeXZAEhUKLuS71KL
         woKFa+SEZgxgjLrF8MvsUOpZqZ2N0Y65UwMg9vTRLjBYpsuMCBr7wGqosXy7IoWxgQ+v
         38oWaz2suQ6wbSHkZWxrdYzq2X8VQRvlqynN5/S4pLJXtYKnDKJTB1SeqkAjHJSolVC9
         Y3TKO961n/Swu1AZuBeLUhve3b40rdWEE7NwTzThRyZ0NebqXLEwh+yck3Kd26cI5g++
         PNvPGRb+D6TF6RJCkzj58AsSgO8gaTwPeyp37hs3GvTA7ZRcu4lvOHPP16kDaWaEl3Wi
         1oGg==
X-Gm-Message-State: APjAAAXkpZh3KdTN402bNZsEFESEbX1tWRoBSOtmSirmzzCvwdJFibEj
        XHlmI/WIT9vSsIccXGuHFh7st1CMwQW2BFDbhk4=
X-Google-Smtp-Source: APXvYqwHPHJVbjOmU3beNqvuieIuS0+sxO+hdF3ELDqayT2TnNjKZYL7ukuC99dJpgkpMcNMhWFjx76wOKe6XdqAvus=
X-Received: by 2002:ab0:4e12:: with SMTP id g18mr11891564uah.1.1559550500034;
 Mon, 03 Jun 2019 01:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <1559532216-12114-1-git-send-email-92siuyang@gmail.com> <CADvbK_eUYhP=pSLqHdBp8E3-NJP28=jErSSvW5moO9WVK=X8XQ@mail.gmail.com>
In-Reply-To: <CADvbK_eUYhP=pSLqHdBp8E3-NJP28=jErSSvW5moO9WVK=X8XQ@mail.gmail.com>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Mon, 3 Jun 2019 16:27:41 +0800
Message-ID: <CAKgHYH1_Jcie=qP-TWRLMXV4OTCe8hm6qZzs2bu4Ciooo2hFiQ@mail.gmail.com>
Subject: Re: [PATCH] ipvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
To:     Xin Long <lucien.xin@gmail.com>
Cc:     davem <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, petrm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com, uehaibing@huawei.com,
        Hangbin Liu <liuhangbin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on your explanation, I found that the patch I submitted is useless.
Great thanks and sorry for the trouble.

On Mon, Jun 3, 2019 at 3:54 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Jun 3, 2019 at 11:22 AM Young Xiao <92siuyang@gmail.com> wrote:
> >
> > Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
> > overflow on the underlying interface.
> >
> > Attempting the set IFF_ALLMULTI on the underlying interface would cause an
> > error and the log message:
> >
> > "allmulti touches root, set allmulti failed."
> s/root/roof
>
> I guess this patch was inspired by:
>
> commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556
> Author: Peter Christensen <pch@ordbogen.com>
> Date:   Thu May 8 11:15:37 2014 +0200
>
>     macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
>
> I could trigger this error on macvlan prior to this patch with:
>
>   # ip link add mymacvlan1 link eth2 type macvlan mode bridge
>   # ip link set mymacvlan1 up
>   # ip link set mymacvlan1 allmulticast on
>   # ip link set mymacvlan1 down
>   # ip link set mymacvlan1 allmulticast off
>   # ip link set mymacvlan1 allmulticast on
>
> but not on ipvlan, could you?
>
> macvlan had this problem, as lowerdev's allmulticast is cleared when doing
> dev_stop and set when doing dev_open, which doesn't happen on ipvlan.
>
> So I'd think this patch fixes nothing unless you want to add
> dev_set_allmulti(1/-1) in ipvlan_open/stop(), but that's another topic.
>
> did I miss something?
>
> >
> > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > ---
> >  drivers/net/ipvlan/ipvlan_main.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> > index bbeb162..523bb83 100644
> > --- a/drivers/net/ipvlan/ipvlan_main.c
> > +++ b/drivers/net/ipvlan/ipvlan_main.c
> > @@ -242,8 +242,10 @@ static void ipvlan_change_rx_flags(struct net_device *dev, int change)
> >         struct ipvl_dev *ipvlan = netdev_priv(dev);
> >         struct net_device *phy_dev = ipvlan->phy_dev;
> >
> > -       if (change & IFF_ALLMULTI)
> > -               dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI? 1 : -1);
> > +       if (dev->flags & IFF_UP) {
> > +               if (change & IFF_ALLMULTI)
> > +                       dev_set_allmulti(phy_dev, dev->flags & IFF_ALLMULTI ? 1 : -1);
> > +       }
> >  }
> >
> >  static void ipvlan_set_multicast_mac_filter(struct net_device *dev)
> > --
> > 2.7.4
> >
