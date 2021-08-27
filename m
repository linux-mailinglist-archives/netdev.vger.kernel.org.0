Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859093F9BBA
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbhH0Paz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234149AbhH0Pay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 817D960FC4;
        Fri, 27 Aug 2021 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630078205;
        bh=ZnVxmvd8f1wwO3DVLpFDffnrgp7c+lp0zA30eZQe/L4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P6m6O1InlU4iV70FICXX9S1YILO8WOyq3u2Xlb//T82qeWDQ3gdZ20bKvTRBQWRve
         mNRz7e8LdWBqIr4GYYArcRPI9gM9gRWZ7is+AtBJnHMtXksR35gYne/pIa8rK21Kiz
         MtEY9J3mkHpJbtexgrA0iEqOkcRyOuEC1jtQ5dLxFtdwaqiCiFkxszgql56rzV12lX
         RcpoyOUun3u2krcUg7h7Czrcp46/CsC8XHYeniRUnh3hzPm92TNPzj0KyCJuJ2kvIH
         xkyc4jmmIsG+kg0/SooA+e55J/MIQu3r3b4Dw0SZMpYY+D8fCYwTlR01whITSTif9E
         nDFCiZX0WH1lQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75BC260A27;
        Fri, 27 Aug 2021 15:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] um: vector: adjust to coalesce API changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163007820547.21913.18376633815628407296.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 15:30:05 +0000
References: <20210827094759.f3ab06684bd0.I985181cc00fe017cfe6413d9e1bb720cbe852e6d@changeid>
In-Reply-To: <20210827094759.f3ab06684bd0.I985181cc00fe017cfe6413d9e1bb720cbe852e6d@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        moyufeng@huawei.com, tanhuazhong@huawei.com, kuba@kernel.org,
        johannes.berg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 09:48:04 +0200 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The API changes were propagated to most drivers, but clearly
> arch/um/drivers/ was missed, perhaps due to looking only at
> the drivers/ folder. Fix that.
> 
> Fixes: f3ccfda19319 ("ethtool: extend coalesce setting uAPI with CQE mode")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next] um: vector: adjust to coalesce API changes
    https://git.kernel.org/netdev/net-next/c/4baf0e0b3298

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


