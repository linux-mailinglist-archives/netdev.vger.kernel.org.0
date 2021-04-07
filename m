Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A04356036
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbhDGAUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhDGAUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7B8E613C4;
        Wed,  7 Apr 2021 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617754812;
        bh=xZrJfpgcalUvnz+BAz5i7n1IB9LNKt0Esyxcv9HUiPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWswDyCSMQJLiFxikaMps5/fe0n2Wc8bWzkALYrdtGl9CGCwrzHMqPUbgECKiitrn
         4YPKBPPGntY1OXAeHb6Ah4nLVg/B1+xigVqXXa4LGHrf4PkWDRzbRYl99XRIhVDaEB
         0RotHc6sL1BVv756i1k4QXhyJxZISo2PlqeUe7Pq+855JGAiiAWU30kCgLtkzYzAKY
         azYwtXH6zJo2/I8tySYvEGfu/yBq7EOvgs7N95kDDuuhrPM1FPC+tAbfxhmxEw3R67
         3cFmliy4/o7PmLXX5DPtA1jABw+ga9P0b3qjB+ifSrODrtvulYF3gQGAC7+ZbiWOL7
         J8ts8RlXZgpxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC09160A50;
        Wed,  7 Apr 2021 00:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: add support for packet-per-second
 policing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775481289.4854.9100624717549620302.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 00:20:12 +0000
References: <20210406155452.23974-1-simon.horman@netronome.com>
In-Reply-To: <20210406155452.23974-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, peng.zhang@corigine.com,
        baowen.zheng@corigine.com, louis.peens@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 17:54:52 +0200 you wrote:
> From: Peng Zhang <peng.zhang@corigine.com>
> 
> Allow hardware offload of a policer action attached to a matchall filter
> which enforces a packets-per-second rate-limit.
> 
> e.g.
> tc filter add dev tap1 parent ffff: u32 match \
>         u32 0 0 police pkts_rate 3000 pkts_burst 1000
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: add support for packet-per-second policing
    https://git.kernel.org/netdev/net-next/c/631a44ed2560

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


