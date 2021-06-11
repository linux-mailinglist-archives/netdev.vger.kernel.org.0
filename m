Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9DF3A49F7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFKUMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFKUMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3229B613DD;
        Fri, 11 Jun 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623442204;
        bh=WuTiQjeodNRfELT25Dm1Y4fiX/3qt6eu8otI/lMVgCg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b55JqRmt7oGR5agfroZso3l9BvILmGZyV90LbgPQqApDQtI5/JnPpLEKzB3bxRTHn
         syv3RIPBt8W5s+GzrKjfT5c+EMY4zRaKUzulvcyi2WVyO8SawDuD+uyvzVttvjkY6e
         2cGYH2jjuw1fz75s70yJHRuz/8pAi0xkbbPHfPPy90uvNBuwNal/FcTneXpaZgGfpv
         WJcrBQoWG/FKe9U8Pr5jSovNCeidchgaSjzGkf5giI/Woe5CRivtpC1he/8xeQn080
         F5hD+xFaQDLeP3/vQmHNbwRJ+WnZM1aBsBlwwDOirImQzOD1D4uR1kIiq9DWKLBT6w
         r8NLpZ7G5pHHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23B3560972;
        Fri, 11 Jun 2021 20:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: stmmac: Fix unused values warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344220414.8005.8449324972783579265.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:10:04 +0000
References: <20210611071143.987866-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210611071143.987866-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, qiangqing.zhang@nxp.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 15:11:43 +0800 you wrote:
> The commit 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines
> for mac, safety, RX & TX") introduced the converity warnings:-
> 
>   1. Unused value (UNUSED_VALUE)
>      assigned_value: Assigning value REQ_IRQ_ERR_MAC to irq_err here,
>      but that stored value is not used.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: stmmac: Fix unused values warnings
    https://git.kernel.org/netdev/net-next/c/3e6dc7b65025

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


