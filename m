Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B36403834
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347048AbhIHKvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhIHKvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE6CA61163;
        Wed,  8 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631098207;
        bh=rsbp5GJMvtdJqWGy2TUS6LEWTShIYCZ2+zQ7bAk+tSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NL12UFLpcowi5qg2xrvOkytscobwFpbYYJYStWuriCHqay0r640dlTcl46eohFT6A
         44cwYTD4QLJxKxewW45jeTLr2rOw8FzA+tnQ/2RzEoWPif1TQE4RYDxZCS4eVNyfNr
         8MKSPJu6TgfdCnPrSbXTw8Nc9l76K7iDHW2svtq/kIswVTefc7y2hoQKjrvbkIfWIY
         r4glHw+t0EgFx26eD+aUC9helVKA+NDFN3HyAi73s4QVoQB0BTfPYychDnNBVf1ySn
         SyfvuQzIRqqEMTsNa+L+Ch8iaJteFyHSI7yC4SQbxoSbdoyoplupdP+ka7aS6GLB2P
         E7IqntDhGRIOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA8FB60A6D;
        Wed,  8 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/7] net/mlx5: Bridge, fix uninitialized variable usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109820689.21737.2273802109235024092.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:50:06 +0000
References: <20210907212420.28529-2-saeed@kernel.org>
In-Reply-To: <20210907212420.28529-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vladbu@nvidia.com, colin.king@canonical.com,
        tim.gardner@canonical.com, naresh.kamboju@linaro.org,
        linux-kernel@vger.kernel.org, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 14:24:14 -0700 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> In some conditions variable 'err' is not assigned with value in
> mlx5_esw_bridge_port_obj_attr_set() and mlx5_esw_bridge_port_changeupper()
> functions after recent changes to support LAG. Initialize the variable with
> zero value in both cases.
> 
> [...]

Here is the summary with links:
  - [net,1/7] net/mlx5: Bridge, fix uninitialized variable usage
    https://git.kernel.org/netdev/net/c/8343268ec3cf
  - [net,2/7] net/mlx5: Fix rdma aux device on devlink reload
    https://git.kernel.org/netdev/net/c/897ae4b40e80
  - [net,3/7] net/mlx5: Lag, don't update lag if lag isn't supported
    https://git.kernel.org/netdev/net/c/da8252d5805d
  - [net,4/7] net/mlx5: FWTrace, cancel work on alloc pd error flow
    https://git.kernel.org/netdev/net/c/dfe6fd72b5f1
  - [net,5/7] net/mlx5: Fix potential sleeping in atomic context
    https://git.kernel.org/netdev/net/c/ee27e330a953
  - [net,6/7] net/mlx5e: Fix mutual exclusion between CQE compression and HW TS
    https://git.kernel.org/netdev/net/c/c91c1da72b47
  - [net,7/7] net/mlx5e: Fix condition when retrieving PTP-rqn
    https://git.kernel.org/netdev/net/c/8db6a54f3cae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


