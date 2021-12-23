Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2234A47E22A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbhLWLUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243334AbhLWLUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6323AC061756;
        Thu, 23 Dec 2021 03:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32CEEB81FFE;
        Thu, 23 Dec 2021 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD12BC36AE5;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640258409;
        bh=ilasrjL/lVXYVChCV6fphnEIoqMOwmvKheSXutsxuNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SMXH663xOmxmjqLX1Aferg7dUTrmXB1UZaugPk0GKSvMZE+uj0vk4nnQz4O6ZWAi/
         sM5KbvGjrYwXaqAvhWHSKWzAsw+BDC/KRcc+1oWraUkHENeNwqb3LHx9QDedF0cSei
         SRVakjrTmu4RQhx0FQxeCVH5OmK8ff+8MQWiwK38XQ9kNF012Ltl+iQOFDqNmVEizI
         RoY4YY1OJTaWVdLyPe3jh6N3MdQwtwPLYcVlQewm6IsgEMuU+6Q7icx2+iiFJ+7bkz
         +U0U++Jx7wZIIDZok5LkN/Br9BvgvoVqJLRET8Es0Mn4SzTdVQusbNdIprnwxN8aOS
         pFLM0dBA4/chw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C38F6EAC069;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Add support for multiple bridge flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025840979.28761.13346033254282858520.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:20:09 +0000
References: <20211222110759.1404383-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211222110759.1404383-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 12:07:59 +0100 you wrote:
> This patch series extends the current supported bridge flags with the
> following flags: BR_FLOOD, BR_BCAST_FLOOD and BR_LEARNING.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_main.c |  7 ++
>  .../ethernet/microchip/lan966x/lan966x_main.h |  2 +
>  .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++
>  .../microchip/lan966x/lan966x_switchdev.c     | 69 ++++++++++++++++++-
>  4 files changed, 82 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: lan966x: Add support for multiple bridge flags
    https://git.kernel.org/netdev/net-next/c/2e49761e4fd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


