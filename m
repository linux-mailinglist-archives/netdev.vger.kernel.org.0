Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E91F36245F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhDPPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:44:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60033 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233976AbhDPPo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:44:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BE6F85C0059;
        Fri, 16 Apr 2021 11:44:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=10P0UJ
        rfZQYbtzxDzTxZgqCgKOlqsSHh6Gp4urnkD10=; b=Ztue+JkLhTwKWdQp8CAz+6
        JX9ESh0ty7B7CDULVJ0eSzJP/fa778Gf0COhcgi+1cr4nalmcEGun7gPTSpn5Qea
        O3VJTmpfijj6brS9H9DCtEUVnMZrNuuHx/leBwiEpmUM13d+9JN8nKHZ0ygc0dRs
        8W3CKs1az32L15FmrspG32UuSndOSv5e5IBaL8NojVasQGoGEzpzqksvhjwUoyaB
        bKdk9yZjkMw/CocBkTcvxUV9RS+pUp0M5lb4Ya+fwv6YytIDH4N7n4sRcb9iTZQi
        6LfZYee6n2BzV+/nLlIZxFznLXIe0VedsrQWisNpSBX5E6yC8l2BTww8ED5F7e6A
        ==
X-ME-Sender: <xms:3rB5YMrIcpvMdlCl9EuYcw1HfoMQjN6zsuk-9dphDkQmq_nqYok7vg>
    <xme:3rB5YCoWc94B8mSAmUxF53cucimSZZv_hujz6NwM11YjftxBkj-1cyT48dM8eXfFu
    dUD1TZPVZRG0i0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepveejtdegteevlefgtdfgueekveegje
    duieetvdduvdetveffgfelgeegfeetgfeunecuffhomhgrihhnpehgihhthhhusgdrtgho
    mhdpshhhohifmhgrgidrtghomhenucfkphepkeegrddvvdelrdduheefrddukeejnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3rB5YBOEAu9RoVp2DS7kJYTao_rXmvF4dl1Jrr9vwz8OLrhejIb6aw>
    <xmx:3rB5YD66IodOfZK7V7W-ktIDVmAn9ak0Bzw6FfKXYEFB4GhNSnKa6w>
    <xmx:3rB5YL7EiG5Eti6lE_c_i-y65-uYWb7q58PMvYvO_EW31H0srMv_Lw>
    <xmx:37B5YO0m9a7mv6ndIMjx5FsPkNDKp_3sn1aRQmlCpHDYFRM229uYgw>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0103A240054;
        Fri, 16 Apr 2021 11:44:29 -0400 (EDT)
Date:   Fri, 16 Apr 2021 18:44:26 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 0/9] ethtool: add uAPI for reading standard stats
Message-ID: <YHmw2tmhFGWFTzPo@shredder.lan>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 07:27:43PM -0700, Jakub Kicinski wrote:
> Continuing the effort of providing a unified access method
> to standard stats, and explicitly tying the definitions to
> the standards this series adds an API for general stats
> which do no fit into more targeted control APIs.
> 
> There is nothing clever here, just a netlink API for dumping
> statistics defined by standards and RFCs which today end up
> in ethtool -S under infinite variations of names.
> 
> This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
> and RMON stats. AFAICT other RFCs only duplicate the IEEE
> stats.
> 
> This series does _not_ add a netlink API to read driver-defined
> stats. There seems to be little to gain from moving that part
> to netlink.
> 
> The netlink message format is very simple, and aims to allow
> adding stats and groups with no changes to user tooling (which
> IIUC is expected for ethtool).
> 
> On user space side we can re-use -S, and make it dump
> standard stats if --groups are defined.

Jakub, do you have a link for the user space patches? I would like to
test it with mlxsw given you already patched it (thanks!).

> 
> $ ethtool -S eth0 --groups eth-phy eth-mac eth-ctrl rmon

Given that you have now standardized these stats, do you plan to feed
them into some monitoring system? For example, Prometheus has an ethtool
exporter [1] and now I see that support is also being added to
node_exporter [2] where it really belongs. They obviously mentioned [3]
the problem with lack of standardization: "There is also almost no
standardization, so if you use multiple network card vendors, you have
to examine the data closely to find out what is useful to you and set up
your alerts and dashboards accordingly."

[1] https://github.com/Showmax/prometheus-ethtool-exporter
[2] https://github.com/prometheus/node_exporter/pull/1832
[3] https://tech.showmax.com/2018/11/scraping-ethtool-data-into-prometheus/

> Stats for eth0:
> eth-phy-SymbolErrorDuringCarrier: 0
> eth-mac-FramesTransmittedOK: 0
> eth-mac-FrameTooLongErrors: 0
> eth-ctrl-MACControlFramesTransmitted: 0
> eth-ctrl-MACControlFramesReceived: 1
> eth-ctrl-UnsupportedOpcodesReceived: 0
> rmon-etherStatsUndersizePkts: 0
> rmon-etherStatsJabbers: 0
> rmon-rx-etherStatsPkts64Octets: 1
> rmon-rx-etherStatsPkts128to255Octets: 0
> rmon-rx-etherStatsPkts1024toMaxOctets: 1
> rmon-tx-etherStatsPkts64Octets: 1
> rmon-tx-etherStatsPkts128to255Octets: 0
> rmon-tx-etherStatsPkts1024toMaxOctets: 1
> 
> v1:
> 
> Driver support for mlxsw, mlx5 and bnxt included.
> 
> Compared to the RFC I went ahead with wrapping the stats into
> a 1:1 nest. Now IDs of stats can start from 0, at a cost of
> slightly "careful" u64 alignment handling.
> 
> Jakub Kicinski (9):
>   docs: networking: extend the statistics documentation
>   docs: ethtool: document standard statistics
>   ethtool: add a new command for reading standard stats
>   ethtool: add interface to read standard MAC stats
>   ethtool: add interface to read standard MAC Ctrl stats
>   ethtool: add interface to read RMON stats
>   mlxsw: implement ethtool standard stats
>   bnxt: implement ethtool standard stats
>   mlx5: implement ethtool standard stats
> 
>  Documentation/networking/ethtool-netlink.rst  |  74 ++++
>  Documentation/networking/statistics.rst       |  44 +-
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 125 ++++++
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  37 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.c    | 142 +++++-
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  10 +
>  .../mellanox/mlxsw/spectrum_ethtool.c         | 129 ++++++
>  include/linux/ethtool.h                       |  95 ++++
>  include/uapi/linux/ethtool.h                  |  10 +
>  include/uapi/linux/ethtool_netlink.h          | 137 ++++++
>  net/ethtool/Makefile                          |   2 +-
>  net/ethtool/netlink.c                         |  10 +
>  net/ethtool/netlink.h                         |   8 +
>  net/ethtool/stats.c                           | 410 ++++++++++++++++++
>  net/ethtool/strset.c                          |  25 ++
>  15 files changed, 1248 insertions(+), 10 deletions(-)
>  create mode 100644 net/ethtool/stats.c
> 
> -- 
> 2.30.2
> 
