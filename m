Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9BB35E8B3
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348575AbhDMWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347015AbhDMWAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E5A35613A9;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351212;
        bh=9YmO728e2XUmt2k8g14yvQq2gJSiym7VXJsZZsbeEnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HYh3r4lRTy05IluZtxAJx41dZ+mSFHQ1bEqers9WQPwUeH7i5cd11wJTf5SIhh0M2
         hndebissoFqxy7zMUplLNGrip1Q4B6X8hpEV4gwrGoHu4jOtMkxcw6JiB57/bQ/YrX
         o5G5M98fxI+luBYcC7MFGwN7n+5PtZXRm7gD+o+jm/55shRepCWYydR1+aihYwmcl3
         DpeMAXUAF3CQbJ0ZtQCU/p+ZVbN1gIA2SrMeQl1Jd1+CPMtw8l+3e5Jk8zKaJGDwur
         x2Ho99Sj6vM5fffaCoLMKZLkn1tEevArbel3HvNFIamFZYSv4RYBWrXhFakBv5K1U6
         +VhdZ6kSP0+JA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC1E560CD2;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rsi: remove unused including <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835121189.27588.8142881264651148953.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:00:11 +0000
References: <1618307172-70927-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1618307172-70927-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 17:46:12 +0800 you wrote:
> Fix the following versioncheck warning:
> ./drivers/net/wireless/rsi/rsi_91x_ps.c: 19 linux/version.h not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_ps.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - rsi: remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/46568170036d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


