Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28E737995A
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhEJVlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhEJVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DA94361554;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682809;
        bh=qmzae5RDhxAGXBgWkM4vfe5aS+VIIPctYxsEzuBcBU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NwNEmt4akVvT9VIHcGanSnrAy5Rn/qKIQ/h9SBf7lVLxpC8WCYBQPr6smej83NgR3
         0e48UjfCRyqlTqiOg/r6ct/Y5joKk0/fxmZgLlyBfxMdwTMPO5RiNsXQKfKL460JJE
         hSqw1qzH8jqDkLZAre4l5VK1/o3F5Ywg6AbBBxa0QbNCihh0VUXp1i9gQl9E8SbNpM
         Pz2HI2EZhzvUbaHL/cpMCXwM9au5cJQaJLoHWAfxyXIgFCTxfH2m2T2EHYNJgYq4b8
         iTFrVIAKIUDsxwkjecj6jE7beXgxPZz7DofDSDGi+0OHDrcUu/no/GLwZz10kTOGTS
         XSziY9TeSFavA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFCE160A48;
        Mon, 10 May 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx4: Fix EEPROM dump support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068280984.31911.2262518475359938861.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:40:09 +0000
References: <20210509064318.13473-1-tariqt@nvidia.com>
In-Reply-To: <20210509064318.13473-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        moshe@nvidia.com, vladyslavt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 9 May 2021 09:43:18 +0300 you wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> Fix SFP and QSFP* EEPROM queries by setting i2c_address, offset and page
> number correctly. For SFP set the following params:
> - I2C address for offsets 0-255 is 0x50. For 256-511 - 0x51.
> - Page number is zero.
> - Offset is 0-255.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4: Fix EEPROM dump support
    https://git.kernel.org/netdev/net/c/db825feefc68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


