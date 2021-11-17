Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB4A4545B1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbhKQLdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235042AbhKQLdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 05BA861BD3;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637148612;
        bh=1BT4DNYilZ69hcdgHhMIIzzMNKCVsxYlHpZYtuo+vLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ee7pygOlzg5FaSoCsW+JFjAo+LmfQZOyRmBPlxAiL8YO2/KEiVRJ8V2H9iHa2oDhX
         aRUdgZUX5c03Jt9jHsQy+zZ9X7TVnG/gniwx5RwkCiBa951pqFCKsrdULc022mjser
         yB/uCTu+t9/L9Ay4Xjip7vk1bwM/n/vE61U2cd926WKYH/kbc1TdztFqeF5ZVTm7t+
         sMP/cbJbnGmVDQKIgR9J6upjUs0G1vf3Mm7ERmVrhDrf+2EBkluvZgaT4I5CVxxIyH
         4XKiEJoGMhK0teNZOzAuSsYAY4HrE/Pfn03Ri1aZW54peDYQjAiUi91GxWgNzOQK5z
         r0Ox3o22f0XaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E76A660BE1;
        Wed, 17 Nov 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: sparx5: phylink validate implementation
 updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714861194.14428.1109730188143034454.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:30:11 +0000
References: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
In-Reply-To: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 10:01:44 +0000 you wrote:
> Hi,
> 
> This series converts sparx5 to fill in the supported_interfaces member
> of phylink_config, cleans up the validate() implementation, and then
> converts to phylink_generic_validate().
> 
>  .../net/ethernet/microchip/sparx5/sparx5_main.c    | 27 ++++++++
>  .../net/ethernet/microchip/sparx5/sparx5_phylink.c | 75 +---------------------
>  2 files changed, 28 insertions(+), 74 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: sparx5: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/ae089a819176
  - [net-next,2/3] net: sparx5: clean up sparx5_phylink_validate()
    https://git.kernel.org/netdev/net-next/c/9b5cc05fd91c
  - [net-next,3/3] net: sparx5: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/319faa90b724

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


