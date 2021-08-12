Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364B03EA29A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhHLKAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235426AbhHLKAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 06:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D265A610A4;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762406;
        bh=VrvUqMHWdcdrjV5wM6b7j9LBo4n6gsvNU9C+COneL5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gypp6CkQcV9G/sWMh+HemR1/nkkszjwuwvq3OIPTHf9qBhs+SV5elfq0xGo6oSKFY
         g9uLWhouGd58L4KrnClhf8lg/LM287Q68ZxyLrZL2j4fZ26sdNKu9piBYnC0OrW9IX
         bAm3hfFmFtl4rm5TLFaMpEmrCXMXVTMk2YRg7shmOdb+Wi3+czCTqJaA02jqILqYiT
         wglJXPNEJmcj/BwH7eF7B8lpSz10Gv7CysdQlLBQJvuHgc6JI9NEyoMKcNJD5Rzeql
         BHH4iAFcLNrk19ZXsTZxdctBBBJB3hTRyK/fg61xt1oSDvI99vYwgaN+kueR3/K49s
         t+GZNGqCyz7tA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBA6960A69;
        Thu, 12 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 1/1] wwan: core: Unshadow error code returned by
 ida_alloc_range()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876240682.6902.14490001135963955593.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 10:00:06 +0000
References: <20210811133932.14334-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210811133932.14334-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 16:39:32 +0300 you wrote:
> ida_alloc_range() may return other than -ENOMEM error code.
> Unshadow it in the wwan_create_port().
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/1] wwan: core: Unshadow error code returned by ida_alloc_range()
    https://git.kernel.org/netdev/net-next/c/0de6fd5fd51c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


