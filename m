Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1E8415E62
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbhIWMbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhIWMbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A35736115A;
        Thu, 23 Sep 2021 12:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632400206;
        bh=anhnOF9pPnKxe0QygAOUv2n3tRSQ1UCUG3xg5yipuWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XaXCYY74kGL6YzaunxaU+Lk+VwWL0Zekrozdu3mnB182UXsV9Jf5fsyFc+/Jf/FN9
         C6fUnFet3oLoEYYyNDp/Q2f17A7Sz9M6e7oz91ncf5KXSLWMzoiwYPWH3g0i5Lmg0O
         F/V487w0kiZuFB1k76DTEqarxTdEmQqday9zmqPt0oa/sIbgHrfVV5lrKoy6+XLLyW
         Ceh9Wdv/6M/YHk9axBRAThL6Y0D6spSSzyQMlB2SgI4OThUM42BeDQ8lBAPB1uDOxU
         IW+FziiqmeHp/pM1nr3jcCiQkVlc3UsQKHZubiTQ1hIH6MuMlnqVXqWFdAXstn4YeS
         4bylXap2AL85A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9590960A88;
        Thu, 23 Sep 2021 12:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] atlantic: Fix issue in the pm resume flow.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163240020660.14451.10376369796494397152.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:30:06 +0000
References: <20210923101605.22739-1-skalluru@marvell.com>
In-Reply-To: <20210923101605.22739-1-skalluru@marvell.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, irusskikh@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 23 Sep 2021 03:16:05 -0700 you wrote:
> After fixing hibernation resume flow, another usecase was found which
> should be explicitly handled - resume when device is in "down" state.
> Invoke aq_nic_init jointly with aq_nic_start only if ndev was already
> up during suspend/hibernate. We still need to perform nic_deinit() if
> caller requests for it, to handle the freeze/resume scenarios.
> 
> Fixes: 57f780f1c433 ("atlantic: Fix driver resume flow.")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] atlantic: Fix issue in the pm resume flow.
    https://git.kernel.org/netdev/net/c/4d88c339c423

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


