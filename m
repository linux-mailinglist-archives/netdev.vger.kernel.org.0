Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CFA246ED
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 06:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfEUEgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 00:36:25 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43616 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfEUEgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 00:36:25 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so15083500oth.10
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 21:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4GPvP+YFrEqy8aOBVWOF1zSCy+nFlcbScDTG7+E9Xc=;
        b=uVs3iKDC6N1uuuFZ2hM+1IGzj/Amf09ZXdt13wtK0GAuNPsTnTcM3rYRLGBQ2GGa4q
         LWD88AKvgm8pZjMV7GRR8unP/0DIwwtoG7UqQZ+MHG4Z1dOV3FeBBX9UrU5Pu49UyGKL
         kS03+oGDqeT1YjGEuuvviacmmCBrixIj/43U9++FVCEm0XQfB5DTwziKc4cNi9xEZ3sO
         BSsGayYQJZPsZpLWJNxHOxkZQ4DUrKaPr97zP/2VwUpLEGCv/KeCfVldRAQXv3xNxCvO
         QlpMNTUGM7NouYro/fsXsnxse2SkZ81q2X9rIA3ccOicNWoYlrxAmBiT2VGHg2HhK0tX
         UpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4GPvP+YFrEqy8aOBVWOF1zSCy+nFlcbScDTG7+E9Xc=;
        b=SeU8D1gjmfacsP4arwZ0z6dVfYD7RgheQghohoePlC+qU9to595NVxpJZTceiZD1Th
         PiAR+Y+0wN0yRd03raW3WhqohClw0Yt00syebD71unu0G689LsUeKFLPzX3faa+gT4fC
         mfF6P1wICR/qIchJkwaeMJnVlVJy93nNGTZcLvn2mgQJTxSr/lvpxrFSQxxafzkIL8xB
         wsNJjsHA7HMid4IMRaHANar7GWmsOHbD+jVFtuoR3rNH7xb6I004RHg99dK21EY1RG7H
         4p+aBz4lsDseCuZNMHLFmYLKolt7DTjCo73AthavWWnyDt2PgBwD8bx3JCfI0mhVp7ol
         ieVA==
X-Gm-Message-State: APjAAAUXba4fOhQGezqU5nbmm8vrCpQbmYTcEsXIwpH0HPQrva8M+BFA
        wWCMaLTMKK5GDPHEDM7ZCMwBuWr9QluHakQC+1o=
X-Google-Smtp-Source: APXvYqx3m3xdhAdJ2FMb2fI2IIqAeXrRjdpNO2VHKmrZ9oxV4FhR5D5x7G44QNkkZZ+tXz/0t0lWZm33FL1JqbzE/mg=
X-Received: by 2002:a9d:638f:: with SMTP id w15mr35811144otk.16.1558413384740;
 Mon, 20 May 2019 21:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com> <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
In-Reply-To: <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 21 May 2019 12:35:48 +0800
Message-ID: <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 4:24 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Mon, May 20, 2019 at 3:19 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > At most case, we use the ConnectX-5 NIC on compute node for VMs,
> > but we will offload forwarding rules to NICs on gateway node.
> > On the gateway node, we will install multiple NICs and set them to
> > different dockers which contain different net namespace, different
> > routing table. In this way, we can specify the agent process on one
> > docker. More dockers mean more high throughput.
>
> The vport (uplink and VF) representor netdev stands for the e-switch
> side of things. If you put different
> vport devices to different namespaces, you will not be able to forward
> between them. It's the NIC side of things
> (VF netdevice) which can/should be put to namespaces.
>
> For example, with SW veth devices, suppose I we have two pairs
> (v0,v1), (v2, v3) -- we create
> a SW switch (linux bridge, ovs) with the uplink and v0/v2 as ports all
> in a single name space
> and we map v1 and v3 into application containers.
>
> I am missing how can you make any use with vport reps belonging to the
> same HW e-switch
> on different name-spaces, maybe send chart?
   +---------------------------------------------------------+
   |                                                         |
   |                                                         |
   |       docker01                 docker02                 |
   |                                                         |
   | +-----------------+      +------------------+           |
   | |    NIC (rep/vf) |      |       NIC        |           |
   | |                 |      |                  |   host    |
   | |   +--------+    |      |   +---------+    |           |
   | +-----------------+      +------------------+           |
   |     |        |               |         |                |
   +---------------------------------------------------------+
         |        |               |         |
         |        |         phy_port2       | phy_port3
         |        |               |         |
         |        |               |         |
phy_port0|        |phy_port1      |         |
         |        |               |         |
         v        +               v         +

For example, there are two NIC(4 phy ports) on the host, we set the
one NIC to docker01(all rep and vf of this nic are set to docker01).
and other one NIC are set to docker02. The docker01/docker02 run our
agent which use the tc command to offload the rule. The NIC of
docker01 will receive packets from phy_port1
and do the QoS , NAT(pedit action) and then forward them to phy_port0.
The NIC of docker02 do this in the same way.



>
> >
> > The commit abd3277287c7 ("net/mlx5e: Disallow changing name-space for VF representors")
> > disallow it, but we can change it now for gateway use case.
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > index 91e24f1..15e932f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > @@ -1409,7 +1409,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
> >         netdev->watchdog_timeo    = 15 * HZ;
> >
> >
> > -       netdev->features         |= NETIF_F_HW_TC | NETIF_F_NETNS_LOCAL;
> > +       netdev->features         |= NETIF_F_HW_TC;
> >         netdev->hw_features      |= NETIF_F_HW_TC;
> >
> >         netdev->hw_features    |= NETIF_F_SG;
> > --
> > 1.8.3.1
> >
