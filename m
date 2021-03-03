Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F25B32C48D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392638AbhCDAPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235041AbhCCRBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 12:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F9DF64EDB;
        Wed,  3 Mar 2021 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614790807;
        bh=Mil5LgFuOfENcxXBygERChbAwjL72VEErPSFcEMtpQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TGQQzDQ2y5EmKRicBKCGuIVIX5HsB/y3DVursEK0MuFJT6GXxwWZiI33b32ZGOSk2
         jObZjUAi7RkrOwmdyRj8pinVpmP2WrQot6zoK+ijK4QN/rAArsSBNsuUTk1cvtw8Q4
         kE8NI5pH7g/s52C/CDgEe1MVx1vowNiFON4dqb/J3mi6NDvLzZbxvoGI6MLgBfKWRF
         VtwMZlu0ESq9fTthynzXJ3pkxbPLvG4943axAAcw+itCQKOX2B41MTdVQpmM+frhwf
         ejPeiZV3sBtM40Cf4C6AgXPVjsodlhmqtBPLiYwXfFYodssTi2F7a7cHWWP8pgkE+D
         GwdzvmlsF/FCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90E92609E2;
        Wed,  3 Mar 2021 17:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: fix incorrect DMA channel intr enable
 setting of EQoS v4.10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161479080758.4362.5083696684614235769.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 17:00:07 +0000
References: <20210303150840.30024-1-ramesh.babu.b@intel.com>
In-Reply-To: <20210303150840.30024-1-ramesh.babu.b@intel.com>
To:     None <ramesh.babu.b@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Mar 2021 20:38:40 +0530 you wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> We introduce dwmac410_dma_init_channel() here for both EQoS v4.10 and
> above which use different DMA_CH(n)_Interrupt_Enable bit definitions for
> NIE and AIE.
> 
> Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Ramesh Babu B <ramesh.babu.b@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10
    https://git.kernel.org/netdev/net/c/879c348c35bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


