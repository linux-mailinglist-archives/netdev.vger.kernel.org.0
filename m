Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FA433C749
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhCOUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhCOUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F0AE64F4A;
        Mon, 15 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615838409;
        bh=7N3RmC/cpuiiM1aIpdz7UBFGNwEKoT7n1Fr1M/oLKjo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CBXoYGQRXyEHQlswtO1RUqnfUFCuYlpWefvy7e8o1N1bd5Xx0gJEP457mSSDONv8k
         cpBCnEwj/Zy0ZqcU3ORFwmPwRzJSorqEXnaVP/nTOFMIOYj54KU8RN6wLR0okZgran
         RjbbGB0CGsxwofbwbpBIqLUz39GSTAQUdW4c6Umf571622mRcOolKfSrUrTSacqVRF
         N23IYVr+hRR88pPSfRcgRGfRwMG+ejnqGXS87yhjzFjHGa5wQXxlvYenxVIFtoSQYW
         68hT2P4Yzevkq0Nx17xb9zJ5fT+PlufdhhhFqUAi8dQaqRhPJRAlxoklKgrNMTX3cD
         Xia3LlT6Oifbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 788A1609C5;
        Mon, 15 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: pcs, stmmac: add C37 AN SGMII support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583840948.32082.9319106949177097567.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 20:00:09 +0000
References: <20210315052711.16728-1-boon.leong.ong@intel.com>
In-Reply-To: <20210315052711.16728-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        fugang.duan@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 13:27:05 +0800 you wrote:
> Hi all,
> 
> This patch series adds MAC-side SGMII support to stmmac driver and it is
> changed as follow:-
> 
> 1/6: Refactor the current C73 implementation in pcs-xpcs to prepare for
>      adding C37 AN later.
> 2/6: Add MAC-side SGMII C37 AN support to pcs-xpcs
> 3,4/6: make phylink_parse_mode() to work for non-DT platform so that
>        we can use stmmac platform_data to set it.
> 5/6: Make stmmac_open() to only skip PHY init if C73 is used, otherwise
>      C37 AN will need phydev to be connected to phylink.
> 6/6: Finally, add pcs-xpcs SGMII interface support to Intel mGbE
>      controller.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: pcs: rearrange C73 functions to prepare for C37 support later
    https://git.kernel.org/netdev/net-next/c/07a4bc51fc73
  - [net-next,2/6] net: pcs: add C37 SGMII AN support for intel mGbE controller
    https://git.kernel.org/netdev/net-next/c/b97b5331b8ab
  - [net-next,3/6] net: phylink: make phylink_parse_mode() support non-DT platform
    https://git.kernel.org/netdev/net-next/c/ab39385021d1
  - [net-next,4/6] net: stmmac: make in-band AN mode parsing is supported for non-DT
    https://git.kernel.org/netdev/net-next/c/e5e5b771f684
  - [net-next,5/6] net: stmmac: ensure phydev is attached to phylink for C37 AN
    https://git.kernel.org/netdev/net-next/c/c62808e8105f
  - [net-next,6/6] stmmac: intel: add pcs-xpcs for Intel mGbE controller
    https://git.kernel.org/netdev/net-next/c/7310fe538ea5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


