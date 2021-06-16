Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525D53AA49E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhFPTwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232967AbhFPTwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8EDC613B9;
        Wed, 16 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873006;
        bh=39fzyq5UfFDbP8jh9ZQFXYlBn+yRG0GxzR5hLE8kbqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JsdoXyqQQWapW9ZCG84CSWDMxBWRubh/J0VLVvIUFzyAf5jaPkf0l2TR5JsTUbc6g
         nQSf+Y1xg+u3pHrFoLfdSG33PjWBeA+wXZ0Fy5KuQc6ZcWCG4r8ZmfUwD+P79EVxvq
         HKOO/k/cGZ0aTN0PMZTD6u01piIh9sEX4H1d76k6EFoUVkuuAhx+Pwmh+zpJqaSr8u
         Es2CdyU/tHMTzMfpO9Re9CQfbS4tnij6h8lk/jiZZViHB4OyHQkWMYXwpDbaF1juFv
         ZRhulaBAa8ar0sWFSh2yf0ibi96WtlRCmxCGNXJMzGjGhswnQ+GV5br5Rfkza97xuE
         Yh2dm3abwnZww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B304060A54;
        Wed, 16 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] Next set of conntrack patches for the nfp driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387300672.13042.6785100233637782028.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:50:06 +0000
References: <20210616100207.14415-1-simon.horman@corigine.com>
In-Reply-To: <20210616100207.14415-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com,
        yinjun.zhang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 12:01:58 +0200 you wrote:
> Louis Peens says:
> 
> This follows on from the previous series of a similar nature.
> Looking at the diagram as explained in the previous series
> this implements changes up to the point where the merged
> nft entries are saved. There are still bits of stubbed
> out code where offloading of the flows will be implemented.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] nfp: flower-ct: add delete flow handling for ct
    https://git.kernel.org/netdev/net-next/c/d33d24a7b450
  - [net-next,2/9] nfp: flower-ct: add nft callback stubs
    https://git.kernel.org/netdev/net-next/c/62268e78145f
  - [net-next,3/9] nfp: flower-ct: add nft flows to nft list
    https://git.kernel.org/netdev/net-next/c/95255017e0a8
  - [net-next,4/9] nfp: flower-ct: make a full copy of the rule when it is a NFT flow
    https://git.kernel.org/netdev/net-next/c/4772ad3f58d2
  - [net-next,5/9] nfp: flower-ct: add nft_merge table
    https://git.kernel.org/netdev/net-next/c/b5e30c61d8cb
  - [net-next,6/9] nfp: flower-ct: implement code to save merge of tc and nft flows
    https://git.kernel.org/netdev/net-next/c/a6ffdd3a0e47
  - [net-next,7/9] nfp: flower-ct: fill in ct merge check function
    https://git.kernel.org/netdev/net-next/c/c698e2adcc63
  - [net-next,8/9] nfp: flower-ct: fill ct metadata check function
    https://git.kernel.org/netdev/net-next/c/5e5f08168db4
  - [net-next,9/9] nfp: flower-ct: implement action_merge check
    https://git.kernel.org/netdev/net-next/c/30c4a9f4fe3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


