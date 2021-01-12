Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B432F2535
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbhALBAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbhALBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D44222D6D;
        Tue, 12 Jan 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610413209;
        bh=3eZOHq/Es3zefZlhcpUBdit+FARwD24CyoZ6hnfmDNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lyf3U0JNoKKinD2/zwarRBjVejk9J+an9JrZFb6/SFuph7KqQhHPuaMaeiN0dfwWJ
         tDhyBozoHN3Rnh2Vl+93lnAfm1BSYIPIO4zbWAvpJ8CFb0FMHK5/F8IMvZ6tUViwcv
         aOmjAzhWD8+mH4UeIpbGElmcNdvIUESk4QSB8Bqf+qysHrg6wKvREhrraJLO7xfW28
         KlAwdsXyukH/xaRYQpklO8AdLhb1bUJQhmnsKfLCsTjyACLqSXwpOdcHkXpTE45BQg
         YnAc5+4GjzSaklMkO4mkXSEJqxnhG5NO+RajqIUgvpHlmQXCc1NyKiNkl2poiesCrG
         0yCBDhBjFcCEw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1F2EC600E0;
        Tue, 12 Jan 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: make use of the unaligned access helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041320912.15587.7478873532753899302.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 01:00:09 +0000
References: <cfaf9176-e4f9-c32d-4d4d-e8fb52009f35@gmail.com>
In-Reply-To: <cfaf9176-e4f9-c32d-4d4d-e8fb52009f35@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 9 Jan 2021 23:53:26 +0100 you wrote:
> Instead of open-coding unaligned access let's use the predefined
> unaligned access helpers.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 35 +++++++++--------------
>  1 file changed, 13 insertions(+), 22 deletions(-)

Here is the summary with links:
  - [net-next] r8169: make use of the unaligned access helpers
    https://git.kernel.org/netdev/net-next/c/ae1e82c6b741

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


