Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AD93C290C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhGISct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGIScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1E5B613CC;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855404;
        bh=FkRo3QF+cGNRqT4Mcev0ihupzNm5LprNA+VyCDJQa/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dUXUkHHVBLv646O8x6phA8enDiQUuqouSaCuq0aTfGKgMWS+WIzyNLNtln59FsriZ
         Vip/9RHlBzUXhnd+OkmauruVcYYwFu9M3kPLkaEf5HMwVn8dRQgW7BnJCtJr0Li5gT
         4+wvyG7n87sgeen9gFViMLH6oSDFTwXpHYIF0nGOQNqE3pTuvmalplFAQ72X1bdolB
         9oT7Eyr7DAxu4+V3DpYrgtyArFET8hZIr1uimOJH3ph+lbawEnmlmggyjE7NQlLAJD
         vjqc55aPHcjsqd3WpczkDeT6D6myhlBT7qm+Tf7cjeFInFr/9OwFoEpz4UgZRIMtDS
         8JVUwiPBYzLLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2A10609B4;
        Fri,  9 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qcom/emac: fix UAF in emac_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540479.20680.287981602887197356.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:04 +0000
References: <20210709142418.453-1-paskripkin@gmail.com>
In-Reply-To: <20210709142418.453-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     timur@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 17:24:18 +0300 you wrote:
> adpt is netdev private data and it cannot be
> used after free_netdev() call. Using adpt after free_netdev()
> can cause UAF bug. Fix it by moving free_netdev() at the end of the
> function.
> 
> Fixes: 54e19bc74f33 ("net: qcom/emac: do not use devm on internal phy pdev")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: qcom/emac: fix UAF in emac_remove
    https://git.kernel.org/netdev/net/c/ad297cd2db89

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


