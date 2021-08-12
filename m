Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C58E3EA29E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhHLKAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235428AbhHLKAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 06:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3572610A8;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762406;
        bh=g7liFI0w1AXCBy0RQJDInux6r5n7YoWxWULCoNMnGIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nBZdm7g3X6RjWnit40kXze+1Wn0nfE9lYi6ifU+39Ft4ANZbY2Mk60YkzZv8BzHR2
         mpi1dVrYlojj48TeYqtKkIJzOMc2qwgPmt5XEY86PVnefeBRO9FTnn4fK1Ua4A9cZk
         pRd+KQTc9NWtlCLPfIuc4Aii7SWuvF889X7tD6NUe0gRngX5H6ex7fj/6COahnAQ03
         uw9f+ZoSrTbv/VXIGhZdPvEWVHA8yL4BesQLIPy81tWJs1ZeCKlwlRNP0bIygYcqgA
         CigfB04W3Y6GH1B/i1SZ7Pa04bGQpE65tdlaZFMN30rHkfBP4wix40/yqGjNManAvo
         enXMnHKM0RamA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D70D56096E;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix VLAN traffic leaks again
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876240687.6902.14605902617499288116.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 10:00:06 +0000
References: <20210811095043.1700061-1-dqfext@gmail.com>
In-Reply-To: <20210811095043.1700061-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 17:50:43 +0800 you wrote:
> When a port leaves a VLAN-aware bridge, the current code does not clear
> other ports' matrix field bit. If the bridge is later set to VLAN-unaware
> mode, traffic in the bridge may leak to that port.
> 
> Remove the VLAN filtering check in mt7530_port_bridge_leave.
> 
> Fixes: 474a2ddaa192 ("net: dsa: mt7530: fix VLAN traffic leaks")
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mt7530: fix VLAN traffic leaks again
    https://git.kernel.org/netdev/net-next/c/7428022b50d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


