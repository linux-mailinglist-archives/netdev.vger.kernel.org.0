Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CF46CD6E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhLHGDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhLHGDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF99C061574;
        Tue,  7 Dec 2021 22:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F421B81D83;
        Wed,  8 Dec 2021 06:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11E1DC00446;
        Wed,  8 Dec 2021 06:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943210;
        bh=O8X4GNYxkBlSc0NjM9f4eIgI9ybQBBohbXSQbbtpLCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fi8JtVde2k7GHfWaXGT1Z0/EdqyPYHTkGaDZjS0tHl8yxDjT5ue/pIfrDc5kNTcaO
         prHACP7SZfVGUT1TCVN1jhBMh3HgVOSl+O+g3LxfnHfFqVurxabuUwEMZhbchmHQBc
         5MY+nhLq8kesfA5kt+9HHCS1z/Rhr76MzHZ0XuiAGw5r0bM/Iusyli/qmtOeoqW7y6
         a0g23BE+HbnWYuoQA5os+lEIuOKIBUpSMnjjt0tdt1NydYQOQh66fsvjlkkSjuhEjk
         9tN8qIpWAQmSV2NPoQx7WzR2cPd4bZ7UgMq82Ur9Ng2XbSDk4oFq0pgpnj6gFgkLYA
         OuNXARWCN6oaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E76B460A53;
        Wed,  8 Dec 2021 06:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/4] prepare ocelot for external interface control 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894320994.16121.3519671067437027854.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 06:00:09 +0000
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
In-Reply-To: <20211207170030.1406601-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 09:00:26 -0800 you wrote:
> This patch set is derived from an attempt to include external control
> for a VSC751[1234] chip via SPI. That patch set has grown large and is
> getting unwieldy for reviewers and the developers... me.
> 
> I'm breaking out the changes from that patch set. Some are trivial
>   net: dsa: ocelot: remove unnecessary pci_bar variables
>   net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/4] net: dsa: ocelot: remove unnecessary pci_bar variables
    https://git.kernel.org/netdev/net-next/c/c99104840a95
  - [v5,net-next,2/4] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
    https://git.kernel.org/netdev/net-next/c/49af6a7620c5
  - [v5,net-next,3/4] net: dsa: ocelot: felix: add interface for custom regmaps
    https://git.kernel.org/netdev/net-next/c/242bd0c10bbd
  - [v5,net-next,4/4] net: mscc: ocelot: split register definitions to a separate file
    https://git.kernel.org/netdev/net-next/c/32ecd22ba60b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


