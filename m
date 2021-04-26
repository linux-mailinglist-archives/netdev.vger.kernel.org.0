Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2252C36AA5C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhDZBbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhDZBa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0ECB96134F;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619400616;
        bh=KP6kDbpx10pt+PuKnUydQHAhtmahiMlSK1Xmhru+o8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOfIa/676x5sIwKUu+B0ob2ZayJ0XVth1oaerEFzbLYve9zuGaT25yyT3BqgWGkug
         YXRU/5TZMB3LzxpXFILHDzgnWx7e9I5rH/nYUWvvbBtdbSRsHjFevig/U/uCqZlO23
         UIGaNp/MVAYaOBFTWN/bcGCqdowBD8SOsg6fZKHS6uxY/CHT1gBq0OS88Z8BJM2o3q
         bLXdWSN8Eg6NO4BeVgeSzYBPSBqveIko/oKQztLJmVv+lf0n2eQ7qPM++BBwFOBQLM
         mO4TyY8R/2T+peO3mitJ0ugzP1FalPINP2Nv4ogi4AYXG1B7LGBH8rsPczHytQOLyO
         mcFhrjOiqKFbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0381B60283;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ch_ktls: Remove redundant variable result
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940061601.7794.5958646471098121470.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:30:16 +0000
References: <1619171543-117550-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619171543-117550-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 17:52:23 +0800 you wrote:
> Variable result is being assigned a value from a calculation
> however the variable is never read, so this redundant variable
> can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1488:2:
> warning: Value stored to 'pos' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - ch_ktls: Remove redundant variable result
    https://git.kernel.org/netdev/net-next/c/bf7d20cd51d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


