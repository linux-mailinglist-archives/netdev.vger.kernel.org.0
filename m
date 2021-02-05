Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299DD310421
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhBEEkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhBEEks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8292864FB4;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612500007;
        bh=dPIn1nQWEcRUgSVOKSucNQMPYkOUoStY0x3nVPjsKP8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZRSDSceCd6gSLoh7zvSdFMCRk99AdpgY3JcUz+0BxQRla7EyGQyBDGAFFcFvn3XH+
         NlbXfQhxy4xGPSw7bgDNExCZUZN4JEoo4nXu9gvoNr2E0Phz2+f803/ZQnb5xjtBuW
         12VNKoYVsMEal7AF5JuuGBq1gCGTX0yHPq9oQrgkESMymB9t/sR+cklhQKAU4g/fvq
         Rxqzw8sCuMo18PiVz/GzrkYMv1b+lmJ/92i5A2BLRp63ZFExmnZaMjpHCmOWrlvLxQ
         jWgHUQ9qKRTJKeXhq1023H1r8EawUCUspTbpJU/XQBMiQE/x9feXUikyricRKrqLVP
         gIU6vS3Ef379A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69961609F2;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: initialize the RFS and RSS memories
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250000742.27819.3538406306953054880.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:40:07 +0000
References: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        michael@walle.cc, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Feb 2021 15:45:11 +0200 you wrote:
> Michael tried to enable Advanced Error Reporting through the ENETC's
> Root Complex Event Collector, and the system started spitting out single
> bit correctable ECC errors coming from the ENETC interfaces:
> 
> pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
> fsl_enetc 0000:00:00.0: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
> fsl_enetc 0000:00:00.0:   device [1957:e100] error status/mask=00004000/00000000
> fsl_enetc 0000:00:00.0:    [14] CorrIntErr
> fsl_enetc 0000:00:00.1: PCIe Bus Error: severity=Corrected, type=Transaction Layer, (Receiver ID)
> fsl_enetc 0000:00:00.1:   device [1957:e100] error status/mask=00004000/00000000
> fsl_enetc 0000:00:00.1:    [14] CorrIntErr
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: initialize the RFS and RSS memories
    https://git.kernel.org/netdev/net/c/07bf34a50e32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


