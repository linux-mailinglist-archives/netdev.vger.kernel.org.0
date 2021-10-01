Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9D41EE43
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhJANMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231564AbhJANMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 09:12:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF6E36135E;
        Fri,  1 Oct 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633093809;
        bh=9+H8qyX4RFS/DHdx3tUsn50o3LqqjiMs1OW0A3cJlJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XMEocUQhmEJlm3YzZu95jvKKT4Mph3DB4l7PMVcbsic9ZO4rDmFBPdul/fzrtGuwl
         ow9y52dqlYpXz814r/7am6RiRUxTyfjZXoWN419URF3RpGv25BbUSfgowkjohekVnD
         1aneEV/qnL1iusY5s165pMZyGyrLk7V73viwNdmQs8GYF1siBMWSQ7YnkM9Vzg/eEk
         wgjhQdgoiB6eInJqwfF5wbfV2nhWkDR/9JDMe0jyUkvLTtV470xYgWI3rSXXn3ZMXS
         SkdOesywbkr8moOGODp6bgSftvlRNJJ/nVk0ZJBPY7X4Bs3uEOMY+Dk7t+Muf3SPdQ
         HxNdSgUeuiIhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DEA9B609B9;
        Fri,  1 Oct 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/10] net/mlx5e: IPSEC RX, enable checksum complete
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163309380890.18892.12905958838273991886.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 13:10:08 +0000
References: <20210930231501.39062-2-saeed@kernel.org>
In-Reply-To: <20210930231501.39062-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        raeds@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 30 Sep 2021 16:14:52 -0700 you wrote:
> From: Raed Salem <raeds@nvidia.com>
> 
> Currently in Rx data path IPsec crypto offloaded packets uses
> csum_none flag, so checksum is handled by the stack, this naturally
> have some performance/cpu utilization impact on such flows. As Nvidia
> NIC starting from ConnectX6DX provides checksum complete value out of
> the box also for such flows there is no sense in taking csum_none path,
> furthermore the stack (xfrm) have the method to handle checksum complete
> corrections for such flows i.e. IPsec trailer removal and consequently
> checksum value adjustment.
> 
> [...]

Here is the summary with links:
  - [net,01/10] net/mlx5e: IPSEC RX, enable checksum complete
    https://git.kernel.org/netdev/net-next/c/f9a10440f0b1
  - [net,02/10] net/mlx5e: Keep the value for maximum number of channels in-sync
    https://git.kernel.org/netdev/net-next/c/9d758d4a3a03
  - [net,03/10] net/mlx5e: Improve MQPRIO resiliency
    https://git.kernel.org/netdev/net-next/c/7dbc849b2ab3
  - [net,04/10] net/mlx5: E-Switch, Fix double allocation of acl flow counter
    https://git.kernel.org/netdev/net-next/c/a586775f83bd
  - [net,05/10] net/mlx5: Force round second at 1PPS out start time
    https://git.kernel.org/netdev/net-next/c/64728294703e
  - [net,06/10] net/mlx5: Avoid generating event after PPS out in Real time mode
    https://git.kernel.org/netdev/net-next/c/99b9a678b2e4
  - [net,07/10] net/mlx5: Fix length of irq_index in chars
    https://git.kernel.org/netdev/net-next/c/ac8b7d50ae4c
  - [net,08/10] net/mlx5: Fix setting number of EQs of SFs
    https://git.kernel.org/netdev/net-next/c/f88c48763474
  - [net,09/10] net/mlx5e: Fix the presented RQ index in PTP stats
    https://git.kernel.org/netdev/net-next/c/dd1979cf3c71
  - [net,10/10] net/mlx5e: Mutually exclude setting of TX-port-TS and MQPRIO in channel mode
    https://git.kernel.org/netdev/net-next/c/3bf1742f3c69

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


