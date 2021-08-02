Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2711F3DDF25
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhHBS3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhHBS3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 14:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F5ED610FF;
        Mon,  2 Aug 2021 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627928983;
        bh=wLXyblv1IR8M3cala1vUy/uIkGzkGtc+XiFAdHfe2pY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=D2jdk+xQUFnRFOSRUZzFt239J1BQKksm2uQmHPAHiOjEjfKUA2u26ENQ6/hZ6WynF
         D8KY+N0Ym7yPjTbg4lvFvB7cmhkBrqUQZ7ifCCyGuyBbRPZBNKLvHUbHTWCvEBOtSG
         XoU3tZ5L5qmiREJOfoPX5gbKnVlnDUjm4C2pt70l2zK8XaQ59EEsjN+CNdxvqUTZ79
         D6XrFA/aS1W7BiDCYjR9+K5/fzCPBbqsq58NTCw3y/HpR9/I5ZZLFnepPk9OwYWcuO
         kz3PDJKvtMVIcM4lT1fPu4cTA5c6K98eb06h02vpsWA0pLnZ/CtXKj5vDFrb72zYc2
         iawonkl//dneQ==
Received: by mail-wr1-f49.google.com with SMTP id b13so11668698wrs.3;
        Mon, 02 Aug 2021 11:29:42 -0700 (PDT)
X-Gm-Message-State: AOAM5328gfuDI6eE88MBMe0Ag60AFThVHI7NWQEcSList/k7MmBFqi7O
        yl6PsXeebYSKLt8COujVNh3flC+vnTo+0oC7WTE=
X-Google-Smtp-Source: ABdhPJwq0uZi3cQZZld48fcVUpftWF+zfHYl86BwwV49+GTtvbzkUho4A5X6ItxbtEAm0onOX2tbsV2iMxl9UX2BSJo=
X-Received: by 2002:adf:fd90:: with SMTP id d16mr20072378wrr.105.1627928981585;
 Mon, 02 Aug 2021 11:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210802144813.1152762-1-arnd@kernel.org> <20210802162250.GA12345@corigine.com>
In-Reply-To: <20210802162250.GA12345@corigine.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 20:29:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
Message-ID: <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        oss-drivers@corigine.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 6:23 PM Simon Horman <simon.horman@corigine.com> wrote:
> On Mon, Aug 02, 2021 at 04:47:28PM +0200, Arnd Bergmann wrote:
> > ---
> > This version seems to pass my randconfig builds for the moment,
> > but that doesn't mean it's correct either. Please have a closer
> > look before this gets applied.

Thank you for taking a look, it seems I have done a particularly bad
job rebasing
the patch on top of the previous fix, leaving only the wrong bits ;-)

> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > index e1a5a79e27c7..3a752e57c1e5 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> > @@ -12,6 +12,7 @@ config MLX5_CORE
> >       depends on MLXFW || !MLXFW
> >       depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
> >       depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
> > +     depends on NET_MAY_USE_SWITCHDEV
> >       help
> >         Core driver for low level functionality of the ConnectX-4 and
> >         Connect-IB cards by Mellanox Technologies.
>
> MLX5_CORE does not appear to cover code that calls
> switchdev_bridge_port_offload.

Ah right, I did get a link failure with my test build, but it was an
unrelated one:

ld: drivers/net/ethernet/mellanox/mlx5/core/esw/sample.o: in function
`mlx5_esw_sample_skb':
sample.c:(.text+0x5b4): undefined reference to `psample_sample_packet'

I think that one needs

--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -90,6 +90,7 @@ config MLX5_BRIDGE
 config MLX5_CLS_ACT
        bool "MLX5 TC classifier action support"
        depends on MLX5_ESWITCH && NET_CLS_ACT
+       depends on PSAMPLE=y || PSAMPLE=MLX5_CORE
        default y
        help
          mlx5 ConnectX offloads support for TC classifier action (NET_CLS_ACT),

but this is unrelated and I have not tested that.

> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> > index 12871c8dc7c1..dee3925bdaea 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> > @@ -5,6 +5,7 @@
> >
> >  config MLXSW_CORE
> >       tristate "Mellanox Technologies Switch ASICs support"
> > +     depends on NET_MAY_USE_SWITCHDEV
> >       select NET_DEVLINK
> >       select MLXFW
> >       help
>
> I think it is MLXSW_SPECTRUM rather than MLXSW_CORE
> that controls compilation of spectrum_switchdev.c
> which calls switchdev_bridge_port_offload.
>
> But MLXSW_SPECTRUM seems to already depend on BRIDGE || BRIDGE=n

Ok.

> > diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> > index b82758d5beed..a298d19e8383 100644
> > --- a/drivers/net/ethernet/netronome/Kconfig
> > +++ b/drivers/net/ethernet/netronome/Kconfig
> > @@ -21,6 +21,7 @@ config NFP
> >       depends on PCI && PCI_MSI
> >       depends on VXLAN || VXLAN=n
> >       depends on TLS && TLS_DEVICE || TLS_DEVICE=n
> > +     depends on NET_MAY_USE_SWITCHDEV
> >       select NET_DEVLINK
> >       select CRC32
> >       help
>
> This seems wrong, the NFP driver doesn't call
> switchdev_bridge_port_offload()

Ah right, I actually noticed that earlier and then forgot to remove that hunk.

Also: is this actually intended or should the driver call
switchdev_bridge_port_offload() like the other switchdev drivers do?

> > diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> > index 07192613256e..a73c6c236b25 100644
> > --- a/drivers/net/ethernet/ti/Kconfig
> > +++ b/drivers/net/ethernet/ti/Kconfig
> > @@ -93,6 +93,7 @@ config TI_CPTS
> >  config TI_K3_AM65_CPSW_NUSS
> >       tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
> >       depends on OF && TI_K3_UDMA_GLUE_LAYER
> > +     depends on NET_MAY_USE_SWITCHDEV
> >       select NET_DEVLINK
> >       select TI_DAVINCI_MDIO
> >       imply PHY_TI_GMII_SEL
>
> I believe this has already been addressed by the following patch in net
>
> b0e81817629a ("net: build all switchdev drivers as modules when the bridge is a module")

I think the fix was wrong here, and that hunk should be reverted.
The dependency was added to a bool option, where it does not have
the intended effect.

I think this is the only remaining thing needed from my patch, so
the NET_MAY_USE_SWITCHDEV option is not needed either,
and it could be written as:

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 07192613256e..e49006a96d49 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -93,6 +93,7 @@ config TI_CPTS
 config TI_K3_AM65_CPSW_NUSS
        tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
        depends on OF && TI_K3_UDMA_GLUE_LAYER
+       depends on (BRIDGE && NET_SWITCHDEV) || BRIDGE=n || NET_SWITCHDEV=n
        select NET_DEVLINK
        select TI_DAVINCI_MDIO
        imply PHY_TI_GMII_SEL
@@ -110,7 +111,6 @@ config TI_K3_AM65_CPSW_NUSS
 config TI_K3_AM65_CPSW_SWITCHDEV
        bool "TI K3 AM654x/J721E CPSW Switch mode support"
        depends on TI_K3_AM65_CPSW_NUSS
-       depends on BRIDGE || BRIDGE=n
        depends on NET_SWITCHDEV
        help
         This enables switchdev support for TI K3 CPSWxG Ethernet

If this looks correct to you, I can submit it as a standalone patch.

      Arnd
