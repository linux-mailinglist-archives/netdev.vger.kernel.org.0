Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DE42CC17
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhJMUwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhJMUwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08E2161130;
        Wed, 13 Oct 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634158208;
        bh=VfitLwgHil1ou//d+Q/TEYC5vj6QqvO+ZbvoA/lhM1c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ViKfzqD6Hqk2zWh8GKzoyjgd7IOTW2ujEu54/q6uNKT2gqmoT5zv65UwLflS11YUz
         Vo0KqRvFlVZdOYGHpmJTK9xnkeAercuFs5fSEZPiDqW017iLWZLg00WWHPDEanTCFa
         vRezVPdelYzBmVrBtsoEj5sy+MuGJDj3iB6aPZ84Fzb+uIbn048bUks4dIXCsxTi+4
         ZwTphRvAvKpR2Ai57iTWaT1puKHrd7upJP47RYnHRCFDkgSz2IoCqIvgD16mwIkJck
         8TLnAHIgyOcqMNUGHtUE6FaxQfO7okk3xGS0boR6rFCBtCrmOTkyStiFH+j3lwyR+R
         52WV1ch2/7VMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1187609CF;
        Wed, 13 Oct 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/6] net/mlx5: Fix cleanup of bridge delayed work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163415820798.8139.6832798095217662429.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 20:50:07 +0000
References: <20211012205323.20123-2-saeed@kernel.org>
In-Reply-To: <20211012205323.20123-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, shayd@nvidia.com, vladbu@nvidia.com,
        leonro@nvidia.com, maorg@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 12 Oct 2021 13:53:18 -0700 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Currently, bridge cleanup is calling to cancel_delayed_work(). When this
> function is finished, there is a chance that the delayed work is still
> running. Also, the delayed work is queueing itself.
> As a result, we might execute the delayed work after the bridge cleanup
> have finished and hit a null-ptr oops[1].
> 
> [...]

Here is the summary with links:
  - [net,1/6] net/mlx5: Fix cleanup of bridge delayed work
    https://git.kernel.org/netdev/net/c/2266bb1e122a
  - [net,2/6] net/mlx5e: Allow only complete TXQs partition in MQPRIO channel mode
    https://git.kernel.org/netdev/net/c/ca20dfda05ae
  - [net,3/6] net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path
    https://git.kernel.org/netdev/net/c/94b960b9deff
  - [net,4/6] net/mlx5e: Switchdev representors are not vlan challenged
    https://git.kernel.org/netdev/net/c/b2107cdc43d8
  - [net,5/6] net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp
    https://git.kernel.org/netdev/net/c/0bc73ad46a76
  - [net,6/6] net/mlx5e: Fix division by 0 in mlx5e_select_queue for representors
    https://git.kernel.org/netdev/net/c/84c8a87402cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


