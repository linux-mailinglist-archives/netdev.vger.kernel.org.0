Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F843EBEFD
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhHNAae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhHNAad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 272E3610F7;
        Sat, 14 Aug 2021 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628901006;
        bh=wirT5WAFR1Q6sKUNj4wKMq3bx2Dlt3ZAB7V+wNt73qY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NaBqHW1lb/dqJIxOyNxtIz0R2nWp675MAGXoKt3BXCHsLnOw8iaWnJApj5tmjuyBP
         MU9zuvEbK8wPcVWYPB67rj+8l4kkM3D8ggaO8V4XwQVc/WZYqmKC7iIzLgJ004QEUV
         tIfTHNFQJzbrjEmk9Ko7FMRJCzp5HSAWaF3jlAPsgWansq5bFO9d8THAsZvW0COTGv
         56D4MhwXYnzKkr5HgZkY7FeD0CQNBn9gji8rR9DDr9H/PXaevBD25vwdV1eOISt+qB
         cfCuGsEIpV3EFtcN9MmhPjJSFKfbKN27+TVgrglDIj8vr+nZ209VDNsqltvfrRuwvV
         sP1MagV4/pX5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17DD4609AF;
        Sat, 14 Aug 2021 00:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: Fix perout start time rounding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162890100609.6872.3031346776903066927.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 00:30:06 +0000
References: <20210813165018.2196013-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210813165018.2196013-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, sunithax.d.mekala@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Aug 2021 09:50:18 -0700 you wrote:
> From: Maciej Machnikowski <maciej.machnikowski@intel.com>
> 
> Internal tests found out that the latest code doesn't bring up 1PPS out
> as expected. As a result of incorrect define used to round the time up
> the time was round down to the past second boundary.
> 
> Fix define used for rounding to properly round up to the next Top of
> second in ice_ptp_cfg_clkout to fix it.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: Fix perout start time rounding
    https://git.kernel.org/netdev/net/c/5f7735196390

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


