Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D833D4CAF
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 10:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhGYHtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhGYHtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 03:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 377DB60F26;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627201805;
        bh=ZM2RghcUg0K+C8jyrmH0ATqknAZmXN4mPrUfb+AremE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PgUwro6soNHgRoDhFLUum6J78OkxgqeIXGkFkQngL8S8Fwm70dt/YW2si0YGgnmJh
         DVSRQ5vugEuHE7SWGox1T/bGLeoUe//bVbQmbVaAsc/ESaZsvA78SiYGV9/n4RaBW3
         42tud8K/ewfGaqSmWxmIP6e0VFJMSWHQ4x6jUQl93INO1PkK/yQy125Vn2t7W6N6LL
         dZc1euqMlP70gyDnzANvqBfhnw+IyiNF84n4u7EmU4Mu80yCTnuvGD9q6Dj91BWnU0
         z5Lg4XU2ls5JHqxHvVpZTwt0mFT92TdleZznxiYZIAn8XJUcjuBxEtO9bk55EGDWGj
         ltvfq0VFdiz0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C76560A3E;
        Sun, 25 Jul 2021 08:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-af: Fix PKIND overlap between LBK and LMAC
 interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720180517.26018.16145315014171443488.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 08:30:05 +0000
References: <20210725075824.6378-1-gakula@marvell.com>
In-Reply-To: <20210725075824.6378-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, zyta@marvell.com, richardcochran@gmail.com,
        kuba@kernel.org, sbhatta@marvell.com, lcherian@marvell.com,
        sgoutham@marvell.com, jerinj@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 13:28:24 +0530 you wrote:
> Currently PKINDs are not assigned to LBK channels.
> The default value of LBK_CHX_PKIND (channel to PKIND mapping) register
> is zero, which is resulting in a overlap of pkind between LBK and CGX
> LMACs. When KPU1 parser config is modified when PTP timestamping is
> enabled on the CGX LMAC interface it is impacting traffic on LBK
> interfaces as well.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: Fix PKIND overlap between LBK and LMAC interfaces
    https://git.kernel.org/netdev/net/c/ac059d16442f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


