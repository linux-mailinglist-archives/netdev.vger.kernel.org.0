Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BA649E3F9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbiA0OAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiA0OAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C3CCB82285;
        Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA906C340E4;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292010;
        bh=eAQ+ZorpGKfk4YxTRRSwqowyR4Lpeus8/2L3UKJOzZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nSMs0A6NL8HjicXZzgtpULYnN79C9GmBoywO4GZb/wVKQir7e7uBC42ZmI4pkrSMV
         OcjyQk3iiPu3I38X2Y18Gwlgrk/Gdbuhe/ce452/sWd87j0PWQJEzACKrhIdIV57oq
         jJZZvwQazUIqveW1TjnMdUiMUXiMxqMp8Ty+TUMcVoyEVF7IYpFKW8Sw9XIAje3D0I
         CwBdEIeynUwwePlKs5eX/af2Aj3D8WLwv6Mi61ISa3YdULBNl+4OYg7LjAtiCesXFw
         ov19CjGF59BDENZIGJqsxUbTHP9sQralxSPiZk0+C7cXLbM5bmIbvskTVlLp7ETd82
         8nJ7D0RjXOjtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3552E5D07E;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix PTP issue in stmmac
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201072.13469.12879802019146922568.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:10 +0000
References: <20220126094723.11849-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20220126094723.11849-1-mohammad.athari.ismail@intel.com>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        chenhuacai@kernel.org, alexandre.torgue@foss.st.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 17:47:21 +0800 you wrote:
> This patch series to fix PTP issue in stmmac related to:
> 1/ PTP clock source configuration during initialization.
> 2/ PTP initialization during resume from suspend.
> 
> Mohammad Athari Bin Ismail (2):
>   net: stmmac: configure PTP clock source prior to PTP initialization
>   net: stmmac: skip only stmmac_ptp_register when resume from suspend
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: stmmac: configure PTP clock source prior to PTP initialization
    https://git.kernel.org/netdev/net/c/94c82de43e01
  - [net,v3,2/2] net: stmmac: skip only stmmac_ptp_register when resume from suspend
    https://git.kernel.org/netdev/net/c/0735e639f129

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


