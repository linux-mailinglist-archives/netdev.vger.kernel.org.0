Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9A83522E7
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhDAWuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234273AbhDAWuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 18:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48F98610CE;
        Thu,  1 Apr 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617317411;
        bh=YDJoICvtM/uZ7hfs7xS/BNKh2P2vfYo8kypa5JDd1Fo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OLce82KOulE+Xvhp4FpTgTCpBm0Qusu1QOD+MsYCpyDc3bK01t9gws+k5PFS5xDND
         j/WjI8v3uhUyhi4Z/3hhsatPofDqW4/CL8lZj7+EkeonR5XCYz3CGL4u8JTREvJFPe
         wl3B4GBRwZx5KYnqFijaDEjqrk3rwWTOGWiIt6bpNpWhY+cAzAiLRMAErwPNPcN5k7
         Ei/q7JQmlqxK9xQJHdx8uiASN0G/Be0a3hxtCNtnJ/mE4vkVD75l7GCBJs+CtjDO1K
         a/7xhvDUitjiuWblw+D8RY8BpjaWunJxTuJD5ZHPcfnQIaah4WAH36AOSzpB1mmwJX
         AVd+2+U5ehwcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43A69609CF;
        Thu,  1 Apr 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipv6: Refactor in rt6_age_examine_exception
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731741127.4407.7789098585873484240.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 22:50:11 +0000
References: <1617247343-48200-1-git-send-email-xujia39@huawei.com>
In-Reply-To: <1617247343-48200-1-git-send-email-xujia39@huawei.com>
To:     Xu Jia <xujia39@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 1 Apr 2021 11:22:23 +0800 you wrote:
> The logic in rt6_age_examine_exception is confusing. The commit is
> to refactor the code.
> 
> Signed-off-by: Xu Jia <xujia39@huawei.com>
> ---
>  net/ipv6/route.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: ipv6: Refactor in rt6_age_examine_exception
    https://git.kernel.org/netdev/net-next/c/b7a320c3a1ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


