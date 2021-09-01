Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308FE3FD82C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhIAKvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236609AbhIAKvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 06:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E5D661059;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493406;
        bh=naDSIKxr4BKrWLRkMwoA4du19u4VqyZkpgmdD7rSgLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OUBYO8WIUfvQt+OX3XlWWjbqudZhWjZ09xV6dIhgCgnpFSidO/sY4nP1RYeE5/DZk
         fli4LCrr5yEIiqvOnklJ0zBkHWmA8gqe31ek+wA1tiazWqOljSWVpFToGlw2phjMZJ
         ZGU4LDTh1sBOLAS6k1Id+UBa/uv/ZaIAQiVk/LsayOBz1Ma9a1ld9ynxuWNrsum2V7
         Aq/r5RbVntr9wL8W3g7jP24e6IjYf3oiXP7cjuB075EJBWZNsMIhFsiF5/gvhbhz9Q
         bqhw9/7plgjJNc6Vy8daVJd2G9dUGTq68Qus+lw9XC/za+MkdKL9The91kFrn50TGD
         5dqJLQPdolpmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 659F7600AB;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] bnxt_en: Fix 64-bit doorbell operation on 32-bit
 kernels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049340641.3899.2784210096565039659.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 10:50:06 +0000
References: <1630458923-14161-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1630458923-14161-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com,
        florian.fainelli@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 31 Aug 2021 21:15:23 -0400 you wrote:
> The driver requires 64-bit doorbell writes to be atomic on 32-bit
> architectures.  So we redefined writeq as a new macro with spinlock
> protection on 32-bit architectures.  This created a new warning when
> we added a new file in a recent patchset.  writeq is defined on many
> 32-bit architectures to do the memory write non-atomically and it
> generated a new macro redefined warning.  This warning was fixed
> incorrectly in the recent patch.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] bnxt_en: Fix 64-bit doorbell operation on 32-bit kernels
    https://git.kernel.org/netdev/net/c/c6132f6f2e68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


