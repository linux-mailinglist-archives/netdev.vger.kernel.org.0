Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07CA340FF9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhCRVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhCRVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E291064F30;
        Thu, 18 Mar 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616103607;
        bh=uLLbTUg6nb9xUvK3A7lED3ce04bTq7tFYnoahf2uRpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=czZoXUzhaezL1xZhOsYOdIUbG5sr+YHU/TcTTNNJeuyRgIbC70eddI+6+bRSWs5wP
         Q7eW6tjDCujcpp36WKZJSJS7+AnfvbpTKPUQvEzfAfrrnFcAv0EaOaxue7SGR3Snws
         8DlnL6pdpALyvbVaM6eAkeJi74a7YBqtzG6jXVpKwrMqAWi6FPY2/8Yt8SU1DCuVRP
         rpRin2OeZzlSxP9Jps15UOoa7U+CkYgpLGPUaQ3Rsm1Jhhy7S0BHozI/aOf0kiheU9
         dj2KFHkDPD5AHwARPWji1AvlDIkAh31/NwXbS1/cfNCFdoichhlvbVO/rPo4Wey5BL
         0Ij201Ni1wSCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D134E600E8;
        Thu, 18 Mar 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: stmmac: EST interrupts and ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610360785.19574.3330766596706160519.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:40:07 +0000
References: <20210318005053.31400-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210318005053.31400-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 08:50:51 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> This patchset adds support for handling EST interrupts and reporting EST
> errors. Additionally, the errors are added into ethtool statistic.
> 
> Ong Boon Leong (1):
>   net: stmmac: Add EST errors into ethtool statistic
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: stmmac: EST interrupts handling and error reporting
    https://git.kernel.org/netdev/net-next/c/e49aa315cb01
  - [net-next,2/2] net: stmmac: Add EST errors into ethtool statistic
    https://git.kernel.org/netdev/net-next/c/9f298959191b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


