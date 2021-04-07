Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68513357764
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhDGWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhDGWKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0687C61246;
        Wed,  7 Apr 2021 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833412;
        bh=6URSbQ0HxHQgYcGG9yxRjsCPAW6i/nYmWNvpowpKs2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UvH6REGDx2r52lJfyld4J9++DrsSpVy6Q2dcbeuTr6bgTBcw+Xt9vUW351RZyO3pb
         x/4dELwnUFvqDOu2VEr+8KzbfrjEhzBWcC63Cvo5cbTcHBSo/DN4xu7NM2/O8f6H+L
         cPaqS0hi3HlxCg/2SVRhW5gCnpmbMNzRLmJmiIDchEKu/uh7nlKUlAmOor4rBeQNQB
         uoJPEzz1RbxFE9rnA3Upt+ryfpmVH8nw5LLcy22efofaAgQxQ+y1bMjBoRnwHwOMvh
         Qi8nPuCSwECdv6HRhHGGp3LK6HXPShsIMChogHsOpADEyAVEeclYqJrq6KGxqkKivC
         cvThetZAuTTOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0069A60ACA;
        Wed,  7 Apr 2021 22:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xircom: remove redundant error check on variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783341199.5631.9452380132960022895.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:11 +0000
References: <20210407093922.484571-1-colin.king@canonical.com>
In-Reply-To: <20210407093922.484571-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 10:39:22 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error check on err is always false as err is always 0 at the
> port_found label. The code is redundant and can be removed.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - xircom: remove redundant error check on variable err
    https://git.kernel.org/netdev/net-next/c/7b3ae17f0f68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


