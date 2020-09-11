Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ECB267698
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKXtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgIKXtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:49:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66084C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:49:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so1366875edq.6
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qllqntfNGTom0SHgxWrJdIF8lC9k67syIx/36aZKgp4=;
        b=jh6zUaRysYvlb2idTKxvdhUtuPEOtfncIsVQBGfgx9WSHfW2uLzdkkkO4z1hBuQsVP
         67/NUodVqjqYPxqDbPNgxMVQHY6su8ZDFBcdb5duf7myv/vm3dOR5s5FpCzXBlum2LMv
         s4OCmGBgFoBJmVyLXP3usav8/r78D1YhhttIdi1HU+knDUCJSygE/Vhc5SJGEKRJUPFA
         AO5smgKvVAdjR/nsCplL49QrBjvNWYM1HlMGs6PCakijsEd5aux7kIVUpFsmnpiP9Gr3
         Sg2BR4N53kCglBB5dM1GElM3ElfuAxlA9ejyKRCDAFIAZjrtv3TP65zABc2txLcLenRm
         gAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qllqntfNGTom0SHgxWrJdIF8lC9k67syIx/36aZKgp4=;
        b=W0Ov4d8Exds1mlNX1JMhoyvQzHkGfC9N1KdLmvjngvIfnt7QSVXwi7XcJd8TSXhfPt
         OCvqmJRQBvd2Jogb5Bt94rFZkt1VvOuv0Eu2Xq8eazVieru9i2YbLpVaZjn0tc7tWUjw
         zB5QB2xiQh1RIDAY2dxyMh2r42n4XfD0TupAZh5HsA8jfI5ympJ5qEguIz++CLxcpitl
         yU2IUvw0lzXWH4YPOTyr/JuL0vJtKEhkacvwyuECKm7mbd/9q2x4OvxK/qqO9Aszc3cR
         Ve760MTtSS6+WiSy4jEWHq+8fDKTrrEkxiwOKyBpBZjz+EiJH6uqW/oAz5IihVi52gZR
         j6vw==
X-Gm-Message-State: AOAM533fo4MzK561apirhfZqSPvY1/Q2sOehCWSbPmmG46sw6ZMe2Ovs
        01dI5RM5TWeFlJMWTJEUAUI=
X-Google-Smtp-Source: ABdhPJyptfjTddhnEObXXJGydMZOaa6JmCHEFbmlHeC+8xvWdrouCH3ulv2J86/RVC/bblbY2pky8g==
X-Received: by 2002:aa7:d585:: with SMTP id r5mr5239743edq.278.1599868175007;
        Fri, 11 Sep 2020 16:49:35 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id h13sm2401135ejl.77.2020.09.11.16.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 16:49:34 -0700 (PDT)
Date:   Sat, 12 Sep 2020 02:49:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200911234932.ncrmapwpqjnphdv5@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911232853.1072362-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 04:28:45PM -0700, Jakub Kicinski wrote:
> Hi!
> 
> This is the first (small) series which exposes some stats via
> the corresponding ethtool interface. Here (thanks to the
> excitability of netlink) we expose pause frame stats via
> the same interfaces as ethtool -a / -A.
> 
> In particular the following stats from the standard:
>  - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
>  - 30.3.4.3 aPAUSEMACCtrlFramesReceived
> 
> 4 real drivers are converted, hopefully the semantics match
> the standard.
> 
> v2:
>  - netdevsim: add missing static
>  - bnxt: fix sparse warning
>  - mlx5: address Saeed's comments
> 
> Jakub Kicinski (8):
>   ethtool: add standard pause stats
>   docs: net: include the new ethtool pause stats in the stats doc
>   netdevsim: add pause frame stats
>   selftests: add a test for ethtool pause stats
>   bnxt: add pause frame stats
>   ixgbe: add pause frame stats
>   mlx5: add pause frame stats
>   mlx4: add pause frame stats
> 
>  Documentation/networking/ethtool-netlink.rst  |  11 ++
>  Documentation/networking/statistics.rst       |  57 ++++++++-
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  17 +++
>  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  11 ++
>  .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  19 +++
>  .../net/ethernet/mellanox/mlx4/mlx4_stats.h   |  12 ++
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   9 ++
>  .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   9 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  29 +++++
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |   3 +
>  drivers/net/netdevsim/Makefile                |   2 +-
>  drivers/net/netdevsim/ethtool.c               |  64 +++++++++++
>  drivers/net/netdevsim/netdev.c                |   1 +
>  drivers/net/netdevsim/netdevsim.h             |  11 ++
>  include/linux/ethtool.h                       |  26 +++++
>  include/uapi/linux/ethtool_netlink.h          |  18 ++-
>  net/ethtool/pause.c                           |  57 ++++++++-
>  .../drivers/net/netdevsim/ethtool-pause.sh    | 108 ++++++++++++++++++
>  18 files changed, 456 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/netdevsim/ethtool.c
>  create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
> 
> -- 
> 2.26.2
> 

DSA used to override the "ethtool -S" callback of the host port, and
append its own CPU port counters to that.

So you could actually see pause frames transmitted by the host port and
received by the switch's CPU port:

# ethtool -S eno2 | grep pause
MAC rx valid pause frames: 1339603152
MAC tx valid pause frames: 0
p04_rx_pause: 0
p04_tx_pause: 1339603152

With this new command what's the plan?

Thanks,
-Vladimir
