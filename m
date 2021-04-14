Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D749635FCFB
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhDNVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhDNVKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CDB9A61177;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434609;
        bh=vd8fdfgjNEpXTc1oBvq3LAQJXXj9vVObtBUq5/fVQos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nNQo+owM7fuy/LbIvnNVqVndLQWjaef8GzZTO6aW1/rLLlB0+mh+dc2u7dXVZxYCw
         UBkqQO8UEPdV1X9UxVe8DzBW3hVNnxrQQNsLF90eE8oinX0CLjo8GUSBOcUgWDgkdf
         VNiX6c/OOUf4Es8kvtW6mWiA1hblL7t6sefoiKqmQxidRi8tZpEfbVb8LvJPjUpgXr
         GqgAekf+0QoyUtLDoSje4kqj5FCNlMqirpJXpJIbis7P6qy2K8iKZ2AundKDYBw8Uh
         W3AI1Ib/eAtXPY95rr58zw+hcloo9SCQkVRAHaIBLsDs7MVkPN+Hw7Ss5eriBo0Mln
         KT0/yvOtzEszw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCCDE60CD2;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "net: stmmac: re-init rx buffers when mac resume back"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843460976.4219.11833628435503987516.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:09 +0000
References: <20210414151007.563698-1-thierry.reding@gmail.com>
In-Reply-To: <20210414151007.563698-1-thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        qiangqing.zhang@nxp.com, jonathanh@nvidia.com,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 17:10:07 +0200 you wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This reverts commit 9c63faaa931e443e7abbbee9de0169f1d4710546, which
> introduces a suspend/resume regression on Jetson TX2 boards that can be
> reproduced every time. Given that the issue that this was supposed to
> fix only occurs very sporadically the safest course of action is to
> revert before v5.12 and then we can have another go at fixing the more
> rare issue in the next release (and perhaps backport it if necessary).
> 
> [...]

Here is the summary with links:
  - Revert "net: stmmac: re-init rx buffers when mac resume back"
    https://git.kernel.org/netdev/net/c/00423969d806

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


