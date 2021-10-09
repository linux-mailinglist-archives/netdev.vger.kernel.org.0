Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120BD427951
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 13:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbhJILCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232161AbhJILCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 07:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D36F60F94;
        Sat,  9 Oct 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633777208;
        bh=1vcMdBFL7RhhxlnFXfgXfcb0QQDHgS5DxZlyQk+b8a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSYeleKJ35xQz5SBJen+a/IrSUJxvr+yDvrOvDZdmyuhM/k4M5BRFk0k65/H6y2AK
         HhySFSEvYO7JJ6Q2qHkNNIPwj/GeTkmG/qFymhy367ZkhXgP8nEINuDSrMEE1+jOsK
         Ui0G1yYPipfCqxLANHVtHt9gSjgt58SK2pJ1F9EjYS6gnLqs/83aNBPzJuDeZftP5W
         CAgjNfncAmr/SZ0AL8hIipD9FzxLYiXlBzSd8OFJWwXRImfy8N7SI6VSFJoSE0kyjM
         sz8d6IZFp4uNYLdCo1m04a6S1uz7mun4+gT1//w37kGEF/wGk5ww0GqTH5aa78duQ7
         0SErIQQfwE+GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 719AE60A53;
        Sat,  9 Oct 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: use dev_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163377720846.21740.10133198972390012435.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 11:00:08 +0000
References: <20211008175339.3753696-1-kuba@kernel.org>
In-Reply-To: <20211008175339.3753696-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        t.sailer@alumni.ethz.ch, jreuter@yaina.de, jpr@f6fbb.org,
        sridhar.samudrala@intel.com, jiri@resnulli.us,
        jes@trained-monkey.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 10:53:39 -0700 you wrote:
> Use dev_addr_set() instead of writing directly to netdev->dev_addr
> in various misc and old drivers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/bonding/bond_main.c   | 2 +-
>  drivers/net/hamradio/baycom_epp.c | 2 +-
>  drivers/net/hamradio/bpqether.c   | 2 +-
>  drivers/net/hamradio/dmascc.c     | 3 +--
>  drivers/net/hamradio/hdlcdrv.c    | 2 +-
>  drivers/net/hamradio/scc.c        | 2 +-
>  drivers/net/hamradio/yam.c        | 2 +-
>  drivers/net/net_failover.c        | 3 +--
>  drivers/net/ntb_netdev.c          | 2 +-
>  drivers/net/team/team.c           | 2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++--
>  drivers/net/wan/lapbether.c       | 2 +-
>  net/802/hippi.c                   | 2 +-
>  net/atm/br2684.c                  | 2 +-
>  net/netrom/nr_dev.c               | 2 +-
>  net/rose/rose_dev.c               | 2 +-
>  16 files changed, 17 insertions(+), 19 deletions(-)

Here is the summary with links:
  - [net-next] net: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/ea52a0b58e41

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


