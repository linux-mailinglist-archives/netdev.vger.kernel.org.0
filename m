Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DE0310313
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhBEDAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhBEDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A56764FB7;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494008;
        bh=fUR5wDI5UzxhOxkLaalOXN4vs7xHb1GYpZ7BV03OQKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g1fvTTdVLH2ilS+FKcZPXxILECfcwXBHYblzk3doVcD0RWlia96X5FchduN4jveKB
         UoCemZ5wfJOaLaMfo/G8sM4X6jAkzYEw5uBfDp6ajcjp4XiZ00hE+cFoEqGR6apBMo
         uLHVQDNy2qQtckkoc0u0Ek+ttHFxky1L2PG2JwX/3V0kbzNtI+nLRJfSUnswJffhww
         mOfX9b1WWAy+xI3fyassdV5FzkrsMdpSybjAfnr42+mfT5l63bmLuL5xm1ZrKrZnRt
         xryBeBHV87zbRBV9EVU3R0d5EOnF2S8CVbX6X5+SFgIgWyEDCNiQKziSafbCmqqNNp
         t51mmg48cRaNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58055609F4;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: remove redundant null check of an array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249400835.18283.15622720081111992226.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 03:00:08 +0000
References: <20210203131040.21656-1-colin.king@canonical.com>
In-Reply-To: <20210203131040.21656-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        huangguangbin2@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 13:10:40 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The null check of filp->f_path.dentry->d_iname is redundant because
> it is an array of DNAME_INLINE_LEN chars and cannot be a null. Fix
> this by removing the null check.
> 
> Addresses-Coverity: ("Array compared against 0")
> Fixes: 04987ca1b9b6 ("net: hns3: add debugfs support for tm nodes, priority and qset info")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] net: hns3: remove redundant null check of an array
    https://git.kernel.org/netdev/net-next/c/8f8a42ff003a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


