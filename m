Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B776C3CFBA7
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhGTN2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:28:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50739 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239803AbhGTNVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:21:16 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9953858177C;
        Tue, 20 Jul 2021 10:01:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 20 Jul 2021 10:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Fbfjll
        +276W8sItskCenThre81QQRVpyey7VS1hHpAU=; b=m+FsyOY6f3VZxMb3tKxRgU
        F0V7B6iG40I9jDsoa9OooiCqLEiAUJ8kWfBsDcVuatejLzhEdl5BX+D++RCHm5Ux
        4h7aTvHBfqb55SMhG7p00RrNNjUkWNt4/e04BhSttGPW7VptDX/VNZ3fFvCKW3HZ
        QyXNv0UoGz9qRHvY6zCmGLBxH6he4V0Qoql81I4fMb9gOsEDtL0KaXnPaCgTVSEE
        B47gId/lOODTaOTtCRTMlr+ZRgMYy/UXW6woknGj5hZhW7F7TxPMH2wdg/RIBOn+
        FuG5WTOiI9vkPagtJ1nrh+x02MaLb1WUd/P8Hq9Or8dmXWG/LDpywFhOiVOeZdcA
        ==
X-ME-Sender: <xms:Udf2YExkO1NYl8uRsqGq9h_ioJwj8LjtyAw0N0-O7PWPJbbAZDVPHQ>
    <xme:Udf2YIQYbHJDVGiAPg21Zku_0mzAJOtE9Rbgbz0iBaDrGcRz0SXg4wIfSyJKM-1e-
    He23mXYH2FJicg>
X-ME-Received: <xmr:Udf2YGVgHd8on58C2op4ch-weH-lVmvCRcMtCC9iMRJh4uYPajJKim0jZiqh3SkTyMommiQ_Z5b-zr-0j-zyxBHi5rf6xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedvgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Udf2YCg1HBy1yvhnIH44zIPbfsynopGKk45IpC0jVWrl8esk-SHjiw>
    <xmx:Udf2YGBW6DxR0jx24K8O-ETVrR0x6Vo88pSmL0P_H0qOdimSNQw10A>
    <xmx:Udf2YDKj7Q29zYVpckqFRNnZ-9TK1Ldvjbm6eGEV1S_FpZsIq9AoWg>
    <xmx:Utf2YCzZmWRNuqkYssS24Qc7Fq8FEokBSJaD-jfSaZQv1mEaDfPVhw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jul 2021 10:01:52 -0400 (EDT)
Date:   Tue, 20 Jul 2021 17:01:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Message-ID: <YPbXTKj4teQZ1QRi@shredder>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:46:45PM +0300, Vladimir Oltean wrote:
> The explicit switchdev offloading API will see further extensions in the
> future.
> 
> The patches were split from a larger series for easier review:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210718214434.3938850-1-vladimir.oltean@nxp.com/

This is not what I meant. I specifically suggested to get the TX
forwarding offload first and then extending the API with an argument to
opt-in for the replay / cleanup:

https://lore.kernel.org/netdev/YPbU20%2Fcjkz04s8b@shredder/

> 
> Tobias Waldekranz (2):
>   net: bridge: disambiguate offload_fwd_mark
>   net: bridge: switchdev: recycle unused hwdoms
> 
> Vladimir Oltean (8):
>   net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
>   net: dpaa2-switch: refactor prechangeupper sanity checks
>   mlxsw: spectrum: refactor prechangeupper sanity checks
>   mlxsw: spectrum: refactor leaving an 8021q upper that is a bridge port
>   net: marvell: prestera: refactor prechangeupper sanity checks
>   net: switchdev: guard drivers against multiple obj replays on same
>     bridge port
>   net: bridge: switchdev: let drivers inform which bridge ports are
>     offloaded
>   net: bridge: switchdev object replay helpers for everybody
> 
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  69 +++-
>  .../ethernet/marvell/prestera/prestera_main.c |  99 +++--
>  .../marvell/prestera/prestera_switchdev.c     |  42 ++-
>  .../marvell/prestera/prestera_switchdev.h     |   7 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    | 347 ++++++++++++------
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
>  .../mellanox/mlxsw/spectrum_switchdev.c       |  28 +-
>  .../microchip/sparx5/sparx5_switchdev.c       |  48 ++-
>  drivers/net/ethernet/mscc/ocelot_net.c        | 115 ++++--
>  drivers/net/ethernet/rocker/rocker.h          |   9 +-
>  drivers/net/ethernet/rocker/rocker_main.c     |  34 +-
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    |  42 ++-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  34 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  14 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.h |   3 +
>  drivers/net/ethernet/ti/cpsw_new.c            |  32 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.c      |   4 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.h      |   3 +
>  include/linux/if_bridge.h                     |  60 +--
>  net/bridge/br_fdb.c                           |   1 -
>  net/bridge/br_if.c                            |  11 +-
>  net/bridge/br_mdb.c                           |   1 -
>  net/bridge/br_private.h                       |  61 ++-
>  net/bridge/br_switchdev.c                     | 254 +++++++++++--
>  net/bridge/br_vlan.c                          |   1 -
>  net/dsa/port.c                                |  83 ++---
>  26 files changed, 1059 insertions(+), 347 deletions(-)
> 
> -- 
> 2.25.1
> 
