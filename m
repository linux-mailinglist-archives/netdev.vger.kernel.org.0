Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171614545B0
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhKQLdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235151AbhKQLdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D91161C4F;
        Wed, 17 Nov 2021 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637148612;
        bh=VRwczVzpGy5tss363oKLYf6kb3Eh4K938dtjahRpEAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M2Hm81Sppya3ZSmWPZuUm5jwBgFD9GdmUHIQNfVmarvQbCoF/G3fX4SfOKoWfVzHX
         yodNWLOZTDa//L7lgEpgm6d36cCPazcQvZUdHgI6pz0CKNrHrQwSvhVWuZ7aOAd6Vm
         fXbbdf9/jNR5a9ki75CMuhcESCQesghpThcckT+LJPgELTtbrAVIVR4xhLICbR3QVx
         3A1SPOtESJU0EswnTq4crL+5bSsbvTu7j1C5QStInpDxaYwfqcxpWh2lr4pKcA6qaO
         iZ8iUhC1LNHFwrBYeJ7EFNXQuGU6KjToN4KfxSUGF5RN/ycmGlB6r6cJPg5bLzEf+b
         SQ3gng5smVArg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F15F260A54;
        Wed, 17 Nov 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: xilinx: phylink validate implementation
 updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714861198.14428.9238474415093979865.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:30:11 +0000
References: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
In-Reply-To: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 09:54:59 +0000 you wrote:
> Hi,
> 
> This series converts axienet to fill in the supported_interfaces member
> of phylink_config, cleans up the validate() implementation, and then
> converts to phylink_generic_validate().
> 
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 71 ++++-------------------
>  1 file changed, 11 insertions(+), 60 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: axienet: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/136a3fa28a9f
  - [net-next,2/3] net: axienet: remove interface checks in axienet_validate()
    https://git.kernel.org/netdev/net-next/c/5703a4b66456
  - [net-next,3/3] net: axienet: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/72a47e1aaf2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


