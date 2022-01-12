Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3C548C673
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354286AbiALOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:50:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37844 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354289AbiALOuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1659618B0
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38666C36AEB;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641999010;
        bh=DU/Uk269Pe55uphB98E1gbj1fHv5u61c1V2/k7Ke+Gw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Za6aiDAazhuYM0OGvtWYh0J89ViPjITfivengguISdw0KVyN55T4EurHjtC7/ujrC
         nRYmc64PfLdg7aLAXkSoeww7SwTMWYZ+guFHECx8kWwg1dzZKV9ZNKbo3LlQUFanQv
         kG+b+f7xBnJofDTRmCvX1NKYrUIRWd5hYP677xR7qum9UEQeVwg2u68VsaumoaZt8G
         MIfBsg69dFRBb1ZQq/LOmGZUG2SE1cemEYaNdkrroS6JAJm8q47wyunS4djiVP296t
         fBqYBRpsqSH//QCTn9wdkExOzIngRGG3VKwmXW3wuQCXA5dQqoWrk/r8A1moQufpXU
         BKQ2dgeUgFxwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E32DF60796;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix possible NULL deref in smc_pnet_add_eth()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199901011.15011.15261646385982351981.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:50:10 +0000
References: <20220112125939.507195-1-eric.dumazet@gmail.com>
In-Reply-To: <20220112125939.507195-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 04:59:39 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I missed that @ndev value can be NULL.
> 
> I prefer not factorizing this NULL check, and instead
> clearly document where a NULL might be expected.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix possible NULL deref in smc_pnet_add_eth()
    https://git.kernel.org/netdev/net/c/7b9b1d449a7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


