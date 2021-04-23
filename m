Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3CD369BB8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244058AbhDWVA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232686AbhDWVAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4306861463;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619211613;
        bh=Kn8OxbTul1GfBwbgvgh1hJuYcjygWsnsjwncqXrzUno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B5/1TVHictfgytz+wb9pMw0iNFq+VjRkr3ELzoF1NDEcAthhGv3ke6u3zTUdtIUmG
         H0HEaZ0GqvqNjRhM1m4R9CybjI7uMPidEktXKQCZ1LyqlJ2BymRvcqPzMAjo2yWAtn
         iaABuEulyX4I7hgC8ieHBZ2dc/kmOvBQAfgW/7ld+1zyzS7krx347r5zxmbG71yJfR
         M8OG56RuOW+ryxhw2q+fk3xsBsHLvfDbqnRf0snoHRrYm/nJfVpoRABaaN1nPHKM6D
         EV6KjTwKeb1D1YvqK5dd6uIF+FQk/WQHWSfW5BBKb/Ro11/+ktsJaEzUtcWdaVVJgE
         Beh3Yt6k7HrWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 381B860C28;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next,
 v2] enetc: fix locking for one-step timestamping packet transfer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921161322.19917.12823767295470536369.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:00:13 +0000
References: <20210423093355.8665-1-yangbo.lu@nxp.com>
In-Reply-To: <20210423093355.8665-1-yangbo.lu@nxp.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        vladimir.oltean@nxp.com, davem@davemloft.net, kuba@kernel.org,
        claudiu.manoil@nxp.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 17:33:55 +0800 you wrote:
> The previous patch to support PTP Sync packet one-step timestamping
> described one-step timestamping packet handling logic as below in
> commit message:
> 
> - Trasmit packet immediately if no other one in transfer, or queue to
>   skb queue if there is already one in transfer.
>   The test_and_set_bit_lock() is used here to lock and check state.
> - Start a work when complete transfer on hardware, to release the bit
>   lock and to send one skb in skb queue if has.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] enetc: fix locking for one-step timestamping packet transfer
    https://git.kernel.org/netdev/net-next/c/7ce9c3d363ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


