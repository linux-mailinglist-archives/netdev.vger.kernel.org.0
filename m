Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420F13B7801
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhF2Smh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhF2Smc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 14:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B15C361DE5;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624992004;
        bh=a7JPoup5FrRMxLLJk7Al4eaabPYZqluDRE3OC+XwA00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tE5d4LTBfc+p5ap4sfYQ1PP7bqT4scJc+XBnD9YwFnoGu6gmvq+Fxy+QJ9z3ISURe
         PHHMtqJ2h104NgQlZilOhg0CntrW3KCUyc1+S/qsSwuMwVCWlDc7A7+DYYdTwW68oH
         ewENwlx3wrFnij7HmLzoJ1ubiQFvljcwRjnm4/yfm5Dn6OHnQupBG6Dn4sz4e/tsyg
         xB+oUDSrw6+E3VyEE0YOUUm9qT4Z8DvWAuQpN9kRkj9GkUrYhm8rkV9EUE9R3sxmyk
         XXKueyLH6qqETOj8Vl8xsll6F8EJtinBLAoeLw5wHGl2PEQ65UvptOv1GGblbEdHgu
         Bv4kdt0u3TWUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FBEF60ACA;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/3] Add option to enable PHY WOL with PMT enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499200464.24074.1612341263285192937.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 18:40:04 +0000
References: <20210629030859.1273157-1-pei.lee.ling@intel.com>
In-Reply-To: <20210629030859.1273157-1-pei.lee.ling@intel.com>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, michael.wei.hong.sit@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 11:08:56 +0800 you wrote:
> This patchset main objective is to provide an option to enable PHY WoL even the PMT is enabled by default in the HW features.
> 
> The current stmmac driver WOL implementation will enable MAC WOL if MAC HW PMT feature is on. Else, the driver will check for PHY WOL support.
> Intel EHL mgbe are designed to wake up through PHY WOL although the HW PMT is enabled.Hence, introduced use_phy_wol platform data to provide this PHY WOL option. Set use_phy_wol will disable the plat->pmt which currently used to determine the system to wake up by MAC WOL or PHY WOL.
> 
> This WOL patchset includes of setting the device power state to D3hot.
> This is because the EHL PSE will need to PSE mgbe to be in D3 state in order for the PSE to goes into suspend mode.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/3] net: stmmac: option to enable PHY WOL with PMT enabled
    https://git.kernel.org/netdev/net-next/c/5a9b876e9d76
  - [net-next,V2,2/3] stmmac: intel: Enable PHY WOL option in EHL
    https://git.kernel.org/netdev/net-next/c/945beb755633
  - [net-next,V2,3/3] stmmac: intel: set PCI_D3hot in suspend
    https://git.kernel.org/netdev/net-next/c/1dd53a61488d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


