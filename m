Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C870F255F1
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfEUQpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 12:45:06 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45965 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 12:45:06 -0400
Received: by mail-yw1-f66.google.com with SMTP id w18so7521513ywa.12
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtQiFJwRqTS2zQ5F/k0dr2/nxeZZ+dGh17LJ03jzC+k=;
        b=ifqz3q5Zkl8TTjm1D6oemSQ9+BNkhPvwRdtisTRoUFo106rvlea9X3tL+aR3+FzYP8
         UunmLx3AXt/P7J/6v5z9x1sSl/QhyPnnvw7BLJdwskGiyYEw92tbYgUdrtVkPKZOjFso
         MNEAvDhMOvLyOLbqHQ7ls2h3K9AxFZH1fd3GSYoepMafIgHoJGU2Lv/mk4IWT2xnI2M2
         m7MLVEFWHG7BR2AO14uT+pJCO9bC+d9bcDVf0OOz3VHBrrtz4XFEUph/sN45CjPkd+z6
         cgMmmkFG96xXShImRMRieiD/xP8zG6pTfWTwzu8lfopau6yb0LAw6+OdC8O8y9cBeYw7
         9GXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtQiFJwRqTS2zQ5F/k0dr2/nxeZZ+dGh17LJ03jzC+k=;
        b=kUi+ZhKirJGmYcJcq/q8vOnMFzFyqPLMtYLa3nx6COBGgJiOU/foMPi7H/Dzkn5NVo
         /yhy+3720C3hJFa+ThuyBlhusV2FDK8dlgQfzfjJw6vYE8B4eUbz3Uoyw98TfmW13kDE
         pW+i+ZveQL9BOlT/jotigTrebEyhpq6rz+1PGyiuh+5VEDLwAg50CM3hfKKDmekSPz0I
         BbjcNHxxGFolKBx69LuEnu3i92ZK5FUQk3b26TTmaumJL6QqfuioHB0JAkdSXP0Em/t9
         siZErBGkudkYBqzWrNnHJd5MilLVtrpL6SyUhn8a5Bcr2PzNsCzHOh5zasxc/NvOs6u0
         jAOQ==
X-Gm-Message-State: APjAAAUx5CxnyiRuaPedMnzuTE0cgvfUVS+T8H90BYIDqzSF49mooukr
        PkGQ2jaXF+N854+ydZn6qGD3kYwwB3dU/e68YkI=
X-Google-Smtp-Source: APXvYqyQXiq2MbcTv8VQ5PFm+rkcBC6uhP88SsyNH86YtZjKzh8tmKIVJH5tcyloMUgByyATrmuj2ELCQ8VOQsFjg+A=
X-Received: by 2002:a81:34c8:: with SMTP id b191mr38612122ywa.500.1558457105288;
 Tue, 21 May 2019 09:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com> <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
In-Reply-To: <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 21 May 2019 19:44:53 +0300
Message-ID: <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 7:36 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> On Tue, May 21, 2019 at 4:24 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> >
> > On Mon, May 20, 2019 at 3:19 PM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > At most case, we use the ConnectX-5 NIC on compute node for VMs,
> > > but we will offload forwarding rules to NICs on gateway node.
> > > On the gateway node, we will install multiple NICs and set them to
> > > different dockers which contain different net namespace, different
> > > routing table. In this way, we can specify the agent process on one
> > > docker. More dockers mean more high throughput.
> >
> > The vport (uplink and VF) representor netdev stands for the e-switch
> > side of things. If you put different
> > vport devices to different namespaces, you will not be able to forward
> > between them. It's the NIC side of things
> > (VF netdevice) which can/should be put to namespaces.
> >
> > For example, with SW veth devices, suppose I we have two pairs
> > (v0,v1), (v2, v3) -- we create
> > a SW switch (linux bridge, ovs) with the uplink and v0/v2 as ports all
> > in a single name space
> > and we map v1 and v3 into application containers.
> >
> > I am missing how can you make any use with vport reps belonging to the
> > same HW e-switch
> > on different name-spaces, maybe send chart?
>    +---------------------------------------------------------+
>    |                                                         |
>    |                                                         |
>    |       docker01                 docker02                 |
>    |                                                         |
>    | +-----------------+      +------------------+           |
>    | |    NIC (rep/vf) |      |       NIC        |           |
>    | |                 |      |                  |   host    |
>    | |   +--------+    |      |   +---------+    |           |
>    | +-----------------+      +------------------+           |
>    |     |        |               |         |                |
>    +---------------------------------------------------------+
>          |        |               |         |
>          |        |         phy_port2       | phy_port3
>          |        |               |         |
>          |        |               |         |
> phy_port0|        |phy_port1      |         |
>          |        |               |         |
>          v        +               v         +
>
> For example, there are two NIC(4 phy ports) on the host, we set the
> one NIC to docker01(all rep and vf of this nic are set to docker01).
> and other one NIC are set to docker02. The docker01/docker02 run our
> agent which use the tc command to offload the rule. The NIC of
> docker01 will receive packets from phy_port1
> and do the QoS , NAT(pedit action) and then forward them to phy_port0.
> The NIC of docker02 do this in the same way.

I see, so in the case you described about, you are going to move **all** the
representors of a certain e-switch into **one** name-space -- this is something
we don't have to block. However, I think we did wanted to disallow moving
sub-set of the port reps into a name-space. Should look into that.

Or.
