Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7884E3F209A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhHSTao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234085AbhHSTan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CA84610D2;
        Thu, 19 Aug 2021 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629401406;
        bh=bEx6LXRrdT/hyT1DNn/TgFlDeBlztpjIpQNw6xGTcwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=unZQeAXtOhwfvGcyQVhVkZ0n2eoL1s3zwnduB3m4/PR1d7Unb0ryHFnVbLtcK6mMV
         3QO39IWeiHOtWIV2Lx1xCQZROMmYH0hvjJGLqoTVijsMgdtnAsUrVMs5mxOftyJw2C
         lSAkKd9TsGdZpJTzzpCDnCEn/f+u38SVGIFjIGJRc2aF+/ryF04+VxjY4Ct4DRy+jP
         PofpXzo+aUHJGMPKm3ZUUidbhLaY8bTWcRlNd19tjODH2QQ2fsCxy35CYzyahIkaRd
         ZSPv0sb3gok4bn3/n9ovGSq89XF1tdjgUVdZ0qCfrppcGmLZe2R8HVo1vclQHu+gWG
         46VEugkfyU4tA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94E8C60997;
        Thu, 19 Aug 2021 19:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: remove redudant second error check on
 variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162940140660.416.16309844801419100643.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 19:30:06 +0000
References: <20210818130927.33895-1-colin.king@canonical.com>
In-Reply-To: <20210818130927.33895-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Aug 2021 14:09:27 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A recent change added error checking messages and failed to remove one
> of the previous error checks. There are now two checks on variable err
> so the second one is redundant dead code and can be removed.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: a83bdada06bf ("octeontx2-af: Add debug messages for failures")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: remove redudant second error check on variable err
    https://git.kernel.org/netdev/net-next/c/9e5f10fe577b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


