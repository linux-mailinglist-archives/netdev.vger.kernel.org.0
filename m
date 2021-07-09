Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9823C1D8A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhGICmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhGICmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 22:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA0F96145E;
        Fri,  9 Jul 2021 02:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625798403;
        bh=8XViQP1Oo27SkoCgDsLPL7l/IYwvW5NjIxTcdPAIBd0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=id/eb4aFIukdcZFatJI5XyykPTY1UMD7OnBkyhj/TcHC20S1PHYSG187e65iVBExU
         iVpbXSHDO8WDdWQ6aQQHZS0/TIO2NzMpLKcjw++DILEBgvJtLGiM7RyJpK927noudY
         e+tGTdXpeI478y5qy+sfMxiG2dICS7AzUGDTYSltrfxCOJ4uzJsOea50Hl/6O3yYtG
         Sy9esceYnSEuXvb6t1tldNSIPZNjr7USKpS0I5W0ej+9iFNYfVY1mpMPOGFlvCmVCS
         vQBpoPGtbMrxOTtz74iGJ7UEZqDkd9lNMPbBvz2hh2NehuL8eLLV5dFCTC690mz8Z0
         tK4xJNj7iEWCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C122609D6;
        Fri,  9 Jul 2021 02:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Ensure all TX/RX queues DMAs are disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162579840363.22257.13274984591900266324.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 02:40:03 +0000
References: <20210709015532.10590-1-f.fainelli@gmail.com>
In-Reply-To: <20210709015532.10590-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, maxime@cerno.tech, opendmb@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 18:55:32 -0700 you wrote:
> Make sure that we disable each of the TX and RX queues in the TDMA and
> RDMA control registers. This is a correctness change to be symmetrical
> with the code that enables the TX and RX queues.
> 
> Tested-by: Maxime Ripard <maxime@cerno.tech>
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Ensure all TX/RX queues DMAs are disabled
    https://git.kernel.org/netdev/net/c/2b452550a203

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


