Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B772352323
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhDAXAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235754AbhDAXAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0118961131;
        Thu,  1 Apr 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318009;
        bh=UAJFQxDC9fAyvefKwsU/8DU/tR04q/XgCs8YPeDUtEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gxk7tnoQDePKwRlp+xYaIH4NZBs0/p1Yy0JTxj+F2mZw6W9lAgDPXch1QEkchBURL
         GLYanmqCf7qHhWx7ogY3vG1fzoTlBj30G2+LNZRHLz83Pr09hvxZh2FSe5gbC6kxIA
         iFrC39/homgLLWnbJoXFj1igG3gqE4vZlUxpsXkZqDWF1+opbGj/hD+192lUIahJfc
         +ApS45yTRrWkwqL5hWN7qvLLPkOe5yM12TsYRbKGJbEFU5iC2KduoHmlr7LRZTgpnX
         7IJ6kJ5COwoImSpeIhLaofpzmyEX34hZuPBO78S7Q839jPQB2NDu/eIxNI3HtH4cMX
         sz3s2r8Fq/zXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA81C608FE;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: use managed PCI function on probe
 and resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731800895.8028.1455207086826594661.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:00:08 +0000
References: <20210401060250.24109-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210401060250.24109-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
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

On Thu,  1 Apr 2021 14:02:50 +0800 you wrote:
> Update dwmac-intel to use managed function, i.e. pcim_enable_device().
> 
> This will allow devres framework to call resource free function for us.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: use managed PCI function on probe and resume
    https://git.kernel.org/netdev/net-next/c/8accc467758e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


