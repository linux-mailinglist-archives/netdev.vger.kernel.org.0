Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C4A3B2229
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFWVCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhFWVCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB2DE61220;
        Wed, 23 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624482004;
        bh=auHLJQjFrDf2PBjoVR10zMyWGYccZ+r2wT9T9bvCmb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bMZ/cBA1icYtNlbtxUROKP489ECqsLYlFgT8PIAXN31PTfiULWCtSpVVO7JEmjmep
         hxGNTM82kdyYYWUB4/DmCVnBen3vCpRCzz/P1MuFPqUJQCW8EcvV8yGKQoJqyQxgW7
         RCvY5KfEIC27tKWqXV/J5MEJkJ6g3KikiOnQTV4c0yUnK3dGYM2s5o2aBSTDg2akOX
         6ri/8NrBhmyHyFAS6m0M/ebKQ5gcpIacYy/d6/2dEhEDLcHDUswzF2SZojUE4oCHOw
         jysSzJi3WdqXnJwz1bopTK/CrXRHK9Kc2U74QjHoirkAoESqqLOQoitPm8p5ypwmC2
         KB3SmhgcrxVcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9F5860A2F;
        Wed, 23 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] virtio_net: Use virtio_find_vqs_ctx() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448200482.24119.5476263935602482130.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 21:00:04 +0000
References: <1624461382-8302-1-git-send-email-xianting_tian@126.com>
In-Reply-To: <1624461382-8302-1-git-send-email-xianting_tian@126.com>
To:     Xianting Tian <xianting_tian@126.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xianting.tian@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 11:16:22 -0400 you wrote:
> virtio_find_vqs_ctx() is defined but never be called currently,
> it is the right place to use it.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - virtio_net: Use virtio_find_vqs_ctx() helper
    https://git.kernel.org/netdev/net-next/c/a2f7dc00ea51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


