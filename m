Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CD41C257
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbhI2KL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245361AbhI2KLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39DD86140F;
        Wed, 29 Sep 2021 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632910210;
        bh=jrmRbKNPMFpcB18C3466rR2kz+lxEqlk6JTtgbV8kOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H2OD8w1K/KFLZLNvuSHeJlLhQSF2mxuKAbIZuH5kQ9jNs1CZ+lB5qVxtSRVABJ1/o
         +9SqC6E9G1V/K2WUAf03VDz+H5kLx0dPEjGNpNZtobCm462fFxg4ipriRkcl+InY5c
         cb24Te7vhrEgp/8vTsM7cu70n29MjXLAsjai4OJGsCSx8rCBXvlVflweeUdz0VMANA
         w7zWfo3mEXaNPviT5e1Z1ExrbBidBYIZkfcuNy06qlxXYzgkohLGlZ9oXYBXZ0gpKV
         uhm6qh1lhG8QDngB8nMisZ1FkhLo8zrRz/MoSwyARqUfzUnZfhRulLW0D98da235ri
         kqSHXkTEQT81w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E833609D6;
        Wed, 29 Sep 2021 10:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: micrel: Add support for LAN8804 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291021018.13642.14705205654674444145.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:10:10 +0000
References: <20210928184519.2315931-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210928184519.2315931-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 20:45:19 +0200 you wrote:
> The LAN8804 PHY has same features as that of LAN8814 PHY except that it
> doesn't support 1588, SyncE or Q-USGMII.
> 
> This PHY is found inside the LAN966X switches.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: micrel: Add support for LAN8804 PHY
    https://git.kernel.org/netdev/net-next/c/7c2dcfa295b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


