Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E61767A4
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgCBWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:45:57 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46408 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgCBWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 17:45:57 -0500
Received: by mail-qt1-f195.google.com with SMTP id i14so1345693qtv.13
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 14:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xe7rkkZ8e9v04ote63kzOqh+CNhrdwEbVR3Wk+qf1M=;
        b=W4s0C6QpajEMOwiV9jzrrLNurI8rUEy6oR0pWDbNdqVsDXs+yg9bygAK76nr6Ita7E
         o33bI4XaoBQQrlMGN73WOWuJUpjbSyieGjC5LohVn/WQkaLaqQfZxqGdjVajEQXvq/0S
         6Mz2Ba9Hj56Jb7iTBuDRPkz9FUfBw+GjutsdDAr+Ryi8vVbmJwKXLCSL9USRAc1T+TVF
         pEmfpzRjtwe7lCwU1sTyrye3p1q1hodtUIQ/rJhlHsPNVlzsCJf7Gdoty3mlnHP99dVr
         KUopWH5U+KbPn05M06Yf1gs0RgrlWu+1VcfS6m3l5xsuT7lX08VYngPAAYQkseMwWfzo
         6e8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xe7rkkZ8e9v04ote63kzOqh+CNhrdwEbVR3Wk+qf1M=;
        b=dud/RW6HZcecG4PS4w7FQJQDbiOgHnl3ngaN+8j0kJsxeXvj/0N0OD+PiVgCiZwbmc
         TCLXtieXwZTpPvehgbqd7sdYlV0iywdT18DKsLm0m/nrGYlxpQoThJY1lLfw+u20vLjH
         ZvM1+8xex/+ugiR8UtDgWKdQwPb171wxX0t8scGXJJ6z9TnuE16I7TS+qk8dAns8sWOi
         68MLSLDRXMfJtbZWc/ZCCOMF11khDQ8IiaAqTj2CzEhbTY8rA9utr0zaVZIz+4k1neMr
         dzgvkxFrsL2RIJTAOR81UN4Hy+5g1F5GgKv3KKE3UVgTk4iLbApn3nzyIXpT1qb1Ad2L
         rHAA==
X-Gm-Message-State: ANhLgQ1T+zxd28KqnuSJTAZw2fWZF9ET69tNieff0MSpM0I5g5Hq8/RW
        Xy4/QLsY2/p76DsRNjgqElA0UI+q9AceYL6gctI=
X-Google-Smtp-Source: ADFU+vsGFiA4P34mMK4FrZX8YJMLWoDFigLxs6YXE5g30Gc616UcUqrHr7xPq28rzQ3wRIyP8D50LHOGsQMrvIzMgN4=
X-Received: by 2002:ac8:c4f:: with SMTP id l15mr1858121qti.177.1583189155880;
 Mon, 02 Mar 2020 14:45:55 -0800 (PST)
MIME-Version: 1.0
References: <CAA85sZsO9EaS8fZJqx6=QJA+7epe88UE2zScqw-KHZYDRMjk5A@mail.gmail.com>
 <32234f4c5b4adcaf2560098a01b1544d8d8d3c2c.camel@mellanox.com>
In-Reply-To: <32234f4c5b4adcaf2560098a01b1544d8d8d3c2c.camel@mellanox.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Mon, 2 Mar 2020 23:45:44 +0100
Message-ID: <CAA85sZuoiWSfMt8H+pjN-Ly=f2wNwG5tPiFZzcc6-1F3fqcO9Q@mail.gmail.com>
Subject: Re: [VXLAN] [MLX5] Lost traffic and issues
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 8:10 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Fri, 2020-02-28 at 16:02 +0100, Ian Kumlien wrote:
> > Hi,
> >
> > Including netdev - to see if someone else has a clue.
> >
> > We have a few machines in a cloud and when upgrading from 4.16.7 ->
> > 5.4.15 we ran in to
> > unexpected and intermittent problems.
> > (I have tested 5.5.6 and the problems persists)
> >
> > What we saw, using several monitoring points, was that traffic
> > disappeared after what we can see when tcpdumping on "bond0"
> >
> > We had tcpdump running on:
> > 1, DHCP nodes (local tap interfaces)
> > 2, Router instances on L3 node
> > 3, Local node (where the VM runs) (tap, bridge and eventually tap
> > interface dumping VXLAN traffic)
> > 4, Using port mirroring on the 100gbit switch to see what ended up on
> > the physical wire.
> >
> > What we can see is that from the four step handshake for DHCP only
> > two
> > steps works, the forth step will be dropped "on the nic".
> >
> > We can see it go out bond0, in tagged VLAN and within a VXLAN packet
> > -
> > however the switch never sees it.
>
> Hi,
>
> Have you seen the packets actually going out on one of the mlx5 100gbit
> legs ?

We disabled bond and made it go to only one interface to be able to snoop the
traffic (sorry, sometimes you forget things when writing them down)

And no, the traffic that was lost never reached the "wire" to our knowledge

> > There has been a few mlx5 changes wrt VXLAN which can be culprits but
> > it's really hard to judge.
> >
> > dmesg |grep mlx
> > [    2.231399] mlx5_core 0000:0b:00.0: firmware version: 16.26.1040
> > [    2.912595] mlx5_core 0000:0b:00.0: Rate limit: 127 rates are
> > supported, range: 0Mbps to 97656Mbps
> > [    2.935012] mlx5_core 0000:0b:00.0: Port module event: module 0,
> > Cable plugged
> > [    2.949528] mlx5_core 0000:0b:00.1: firmware version: 16.26.1040
> > [    3.638647] mlx5_core 0000:0b:00.1: Rate limit: 127 rates are
> > supported, range: 0Mbps to 97656Mbps
> > [    3.661206] mlx5_core 0000:0b:00.1: Port module event: module 1,
> > Cable plugged
> > [    3.675562] mlx5_core 0000:0b:00.0: MLX5E: StrdRq(1) RqSz(8)
> > StrdSz(64) RxCqeCmprss(0)
> > [    3.846149] mlx5_core 0000:0b:00.1: MLX5E: StrdRq(1) RqSz(8)
> > StrdSz(64) RxCqeCmprss(0)
> > [    4.021738] mlx5_core 0000:0b:00.0 enp11s0f0: renamed from eth0
> > [    4.021962] mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0
> >
> > I have tried turning all offloads off, but the problem persists as
> > well - it's really weird that it seems to be only some packets.
> >
> > To be clear, the bond0 interface is 2*100gbit, using 802.1ad (LACP)
> > with layer2+3 hashing.
> > This seems to be offloaded in to the nic (can it be turned off?) and
> > messages about modifying the "lag map" was
> > quite frequent until we did a firmware upgrade - even with upgraded
> > firmware, it continued but to a lesser extent.
> >
> > With 5.5.7 approaching, we would want a path forward to handle
> > this...
>
>
> What type of mlx5 configuration you have (Native PV virtualization ?
> SRIOV ? legacy mode or switchdev mode ? )

We have:
tap -> bridge -> ovs -> bond (one legged) -switch-fabric-> <other-end>

So a pretty standard openstack setup

> The only change that i could think of is the lag multi-path support we
> added, Roi can you please take a look at this ?

I'm also trying to get a setup working where i could try reverting changes
but so far we've only had this problem with mlx5_core...
Also the intermittent but reliable patterns are really weird...

All traffic seems fine, except vxlan traffic :/

(The problem is that the actual machines that has the issue is in production
with 8x V100 nvidia cards... Kinda hard to justify having them "offline" ;))
