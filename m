Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6D441AF64
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbhI1Mvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240685AbhI1Mvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:51:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10689610E5;
        Tue, 28 Sep 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833407;
        bh=J/caRSgwiECfRbdXLv/qphbD2xZmdQFEavRPuIhTwvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iHbJQTS8MjWB9rUuSymu4pSxiS7PXTfvh1NFpHwSIq9XsMeT8sVW6uER/lY+qNTOj
         zWAHj+o/lymLDxD8GkKDAzbAdwW0RZ25ukOvbkE907HQo6FJk8Y3shYFIvuhfJAzva
         zrPgU708oUFWinWZ3GfgvadIp7WHdl/zhGZVgQ9wH6hOEvbNzsEAfcGBNyKkO71pBb
         eXZUS4J9gDqnj4ij4y5fl0iJTxwzkBiiMmbkM1TBmqVcwG4YJ/2MxXq1zxoX+/MGRl
         keWU/tgKUTv1Fe3e6y9oY7wh3IzUqTuIwpaCogpomyVCCQpXVCZ1io2pJIqakHbDxn
         HhbPN0hA4vdRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0494E60A59;
        Tue, 28 Sep 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] net: hns3: fix hclge_dbg_dump_tm_pg() stack usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283340701.16226.1349215678242492151.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:50:07 +0000
References: <20210928085900.2394697-1-arnd@kernel.org>
In-Reply-To: <20210928085900.2394697-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        huangguangbin2@huawei.com, moyufeng@huawei.com,
        zhangjiaran@huawei.com, shenjian15@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 10:58:34 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This function copies strings around between multiple buffers
> including a large on-stack array that causes a build warning
> on 32-bit systems:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c: In function 'hclge_dbg_dump_tm_pg':
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:782:1: error: the frame size of 1424 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
> 
> [...]

Here is the summary with links:
  - [v2] net: hns3: fix hclge_dbg_dump_tm_pg() stack usage
    https://git.kernel.org/netdev/net/c/c894b51e2a23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


