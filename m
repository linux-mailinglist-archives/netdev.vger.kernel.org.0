Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0831E2B3
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhBQWoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233399AbhBQWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F97064E2E;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613601607;
        bh=h4GGmCDmodDTOfcOMQkHVeIRed8RvDWc90CgF6SA0HM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c/HdA/KW6OQP1U1BG9/G/gpNhbgo4UMSFY34Sb4UmJqCbSz5y+UljgD0C6Zg0u+2w
         4oHz3qrjM0XTh4xN2dfSMgkXDA7V1Q6BLpbk9+xo6aFPIpiqnj4mzvm886IPiAnyCy
         07Fq4kxjyUo3Xh391HRYb5eAWwKVuuFISX1Vgqu524kcwkwAurJi0hrwFAFQjJ+hbg
         9ODkUJ3UV7ffRt9gfQVvaMvCa0blsdbsdxw9WvjhgfBBR8+kuQbuCLMP3I15idmA43
         +oA1fti9kYyYTRPkvtkntd0enSV9VVgf5A0p+slYEBNJCJi/sClb50fPBJ+Rg+FyGt
         ZLuG3uchB97Mw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F10D6096D;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add PCI bus info to ethtool driver
 query output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161360160738.1867.9252976425152960129.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 22:40:07 +0000
References: <20210217095705.13806-1-vee.khee.wong@intel.com>
In-Reply-To: <20210217095705.13806-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 17:57:05 +0800 you wrote:
> This patch populates the PCI bus info in the ethtool driver query data.
> 
> Users will be able to view PCI bus info using 'ethtool -i <interface>'.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c    | 1 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 4 ++++
>  include/linux/stmmac.h                               | 1 +
>  3 files changed, 6 insertions(+)

Here is the summary with links:
  - [net-next,1/1] net: stmmac: Add PCI bus info to ethtool driver query output
    https://git.kernel.org/netdev/net-next/c/20e07e2c3cf3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


