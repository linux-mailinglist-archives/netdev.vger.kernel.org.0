Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1846CD64
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhLHFxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:53:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38160 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhLHFxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:53:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3C6ACE200E;
        Wed,  8 Dec 2021 05:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3BEDC341C8;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638942611;
        bh=Qv5sBlcfvuvf3tCfH5rvSaimWR3EAyzabTCEIss5XgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GH9/FD7GbJ67ofLkECdm/i+mp4GcOAViaKvrLcbXK9EIXYhPMxVjf+wNSq5payaRY
         DW8ALv5aUG/FsLqGElKPkOAj7TcwqbZCBdbeNHpBf0CLCUKpW7gIasFOqK25EBtuIl
         bLkd9t18L+syQf760buUcQcHmY1y1GbNE3nS3ZAgeGB1tftWTM8jQtPCsBEuaTt8he
         QSQKHHaublrd+wvAk1tR2tGA8iNOum6qsmnwO4koPJfscnPTskIj7AeyxitAtqRB1N
         ONaaeQgzEwaBcNA5ydAMymEfaCh6ItSJygkjKipRTnWfY6xCDtxCxbBaprQfMft9h8
         1aOskPGMbqsoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC63D60BD0;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net: fec: only clear interrupt of handling queue in
 fec_enet_rx_queue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894261089.12550.12618093944925198862.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:50:10 +0000
References: <20211206135457.15946-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20211206135457.15946-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 21:54:57 +0800 you wrote:
> Background:
> We have a customer is running a Profinet stack on the 8MM which receives and
> responds PNIO packets every 4ms and PNIO-CM packets every 40ms. However, from
> time to time the received PNIO-CM package is "stock" and is only handled when
> receiving a new PNIO-CM or DCERPC-Ping packet (tcpdump shows the PNIO-CM and
> the DCERPC-Ping packet at the same time but the PNIO-CM HW timestamp is from
> the expected 40 ms and not the 2s delay of the DCERPC-Ping).
> 
> [...]

Here is the summary with links:
  - [net,V2] net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
    https://git.kernel.org/netdev/net/c/b5bd95d17102

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


