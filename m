Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8514131C33D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBOUvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:51:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhBOUus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 79DD364DF4;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613422207;
        bh=ZbVRoniy+F6CqyrHfhMJYE9GgnAPQy2n0jsNWFufrtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GSlg0SJrZvdnvqvUedmRR6Cyg+mCGVvoIPpzgX9s2s+n59fnOp6TQ+fTvINWVkWmR
         MYtYRUbzcMuC7NRRYRSud7BqanF5X1rGqa0R8E+QCImX4gsJz8lNE+VXa5tC9y5VT5
         7p8jau/TD2C+7Bnrc82Nw5ibd6+joGb/WxsacJR+6psx2Igh+TNQxT/qDuJny+wclk
         vcbjo+ze+Yr1+oZQC4ncpcqhedfaJ7PFRDRJm+7URwlPXIjqQBBadBOZQc3xul5neX
         KbbKX+TvdczOmx/zw65dAQIoiu+aWEPKbtzY3y9+NzsTfmdEvdM59SI9pi956DgCkN
         SpVq3eGg3w95g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69C0C609ED;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] b43: N-PHY: Fix the update of coef for the PHY revision >=
 3case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342220742.9745.8382671351408094694.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:50:07 +0000
References: <20210215120532.76889-1-colin.king@canonical.com>
In-Reply-To: <20210215120532.76889-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        zajec5@gmail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Feb 2021 12:05:32 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The documentation for the PHY update [1] states:
> 
> Loop 4 times with index i
> 
>     If PHY Revision >= 3
>         Copy table[i] to coef[i]
>     Otherwise
>         Set coef[i] to 0
> 
> [...]

Here is the summary with links:
  - b43: N-PHY: Fix the update of coef for the PHY revision >= 3case
    https://git.kernel.org/netdev/net/c/4773acf3d4b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


