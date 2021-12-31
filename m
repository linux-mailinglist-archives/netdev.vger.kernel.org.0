Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB83482187
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbhLaCaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:30:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36666 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhLaCaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:30:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8EB61780;
        Fri, 31 Dec 2021 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6BD5C36AED;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640917809;
        bh=RCpzyzS3ILw+y6MxDa5l/FMT14JOf73mkZPGYQQOKUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tkh4+o1XCLie5gm2k3XemLoIeWoYfkwTVsMUvqOCLmBtAESEogRPSkXdSdY9bfF0/
         VIjXN76s65ALkNsoQ5jFu/YWTbtcOf3ESm41zwK91YU1sGVVKrjDhueZYWSqCA4n6k
         ySWu1tUFzJWz8WeKOLrgc18Nd5Tv01s2NMlRhFUfhec85Gg/LomVz+G/efHj7saBlS
         aa4m74pMEFqonRNMduB5+PQeCc4FTO7qvSuyuJhinRQiBnCnD4h6Rh18VJlpI2IWJO
         yvfVJ0szjO8bB6WY2RNrM6yDbzBDom2450DsCSYXicrLqNJDoIYxypvjX8MzKmJrEq
         8tXFuxp7XQG1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87F49C395E7;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st21nfca: remove redundant assignment to variable i
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164091780955.19399.16011800400201040949.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 02:30:09 +0000
References: <20211230161230.428457-1-colin.i.king@gmail.com>
In-Reply-To: <20211230161230.428457-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Dec 2021 16:12:30 +0000 you wrote:
> Variable i is being assigned a value that is never read, the
> assignment is redundant and can be removed. Cleans up clang-scan
> build warning:
> 
> drivers/nfc/st21nfca/i2c.c:319:4: warning: Value stored to 'i'
> is never read [deadcode.DeadStores]
>                         i = 0;
> 
> [...]

Here is the summary with links:
  - nfc: st21nfca: remove redundant assignment to variable i
    https://git.kernel.org/netdev/net-next/c/314fbde95769

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


