Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADA32F521
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 108C465085;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=V2uqA/sr/GCzFs1Q1+s+pr6cqye/+w6MJ7zr3hsw+Zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VUx+pTi7ptAjG/FnNg+eIQqCPPMBDBFiZ13ji4TqX+nRZPKF+LYILMx0+pZNsIAK7
         lWVcD2EhA6e5/LlBNY56h7AUA4G4o5Yv8UGZZa8mMLyWeovRDc6DI3za7WBnnjgTIB
         QTQQbVR8St0ht/K+CLiQsW/1zAeMiPPdJCZqVCmP+iDcrsAONvaVOD1lwgMZWMPcRV
         nRzJw5ucDQ2mBjbfEU353NWKFVoG8aAAHMFhZ7LA3WvggONmwl/adlO10XkD/fS6GU
         dttUEuV7TZ9K4N03fhF7ULFMei2JzW0onSqFlWU9ELBVBuKrhWA4eyzOjBqtiP5pgr
         qYpmo/EMj3+NQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04FA060A13;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] stmmac: intel: Fixes clock registration error seen
 for multiple interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860901.24588.8524291949132206114.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305060342.23503-1-boon.leong.ong@intel.com>
In-Reply-To: <20210305060342.23503-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 14:03:42 +0800 you wrote:
> From: Wong Vee Khee <vee.khee.wong@intel.com>
> 
> Issue seen when enumerating multiple Intel mGbE interfaces in EHL.
> 
> [    6.898141] intel-eth-pci 0000:00:1d.2: enabling device (0000 -> 0002)
> [    6.900971] intel-eth-pci 0000:00:1d.2: Fail to register stmmac-clk
> [    6.906434] intel-eth-pci 0000:00:1d.2: User ID: 0x51, Synopsys ID: 0x52
> 
> [...]

Here is the summary with links:
  - [net,1/1] stmmac: intel: Fixes clock registration error seen for multiple interfaces
    https://git.kernel.org/netdev/net/c/8eb37ab7cc04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


