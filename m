Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B28D3A35C7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhFJVWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFJVV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 23480613E3;
        Thu, 10 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623360003;
        bh=JlUuiy0dSYXdLEWK117F/lnnH4xvYeFiOC3d9f/6fQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CEmK/GcIaC9xAZi6HDM3h/jSdRddiEJKL1FpjTvr2UaE/GgMdLXH4etLIOVZwfIA2
         iipLUyFI1G7YbxyhwauTO/zbnlg5KZc2ULqect9y7Gr8F1jI8hmUCXNte7QbCSj3dG
         4eD8MDjtxXUeEV4QD/4670tOZnLQQ/CD6KJ2CYwgZlCEReDT8xbz9sKesOPPsLyLSR
         6+03HiU08k9wF3dmW4Wg2Weep21vGW8AOS1TBBz+SrzjBkVWIzk7C1oExCUNnofB9q
         ue1WBWHWQ/fqkTe3c96srb9m5XzTlIkzEUQ+ZebxevJZ8k3eLYu9CcrQbDyOUJ07mk
         wk/0bPV/I9DuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 180CC609E4;
        Thu, 10 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] soc: qcom: ipa: Remove superfluous error message around
 platform_get_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336000309.15640.6173731479535658968.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:20:03 +0000
References: <20210610140118.1437-1-hbut_tan@163.com>
In-Reply-To: <20210610140118.1437-1-hbut_tan@163.com>
To:     Zhongjun Tan <hbut_tan@163.com>
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tanzhongjun@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 22:01:18 +0800 you wrote:
> From: Tan Zhongjun <tanzhongjun@yulong.com>
> 
> The platform_get_irq() prints error message telling that interrupt is
> missing,hence there is no need to duplicated that message in the
> drivers.
> 
> Signed-off-by: Tan Zhongjun <tanzhongjun@yulong.com>
> 
> [...]

Here is the summary with links:
  - soc: qcom: ipa: Remove superfluous error message around platform_get_irq()
    https://git.kernel.org/netdev/net-next/c/950fd045d76c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


