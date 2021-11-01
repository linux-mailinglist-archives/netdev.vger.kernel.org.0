Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE96441BCD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhKANjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhKANjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7832260551;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635773408;
        bh=pU2uZMzV1TvCBXUD2HwPGw/VKj+D2lRq2c8eBnoIqQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T2rgRJqfFZyYlYdz0lTsiZprOf39I0DPbaBGo8TuMP2pqIxxBuHVXwTCQIaJJZjSC
         d920+lyfgW4N+jvXecU1Bzi5U2UscAD8DSSeyF0q5kE0Y805M+dIgI6zIcJjgbieFg
         h8Tq3KJonG9UjVUWkhkMax0ds4xfqLYAbQc89apeEL45dEDpInAJ7ZXV7aSzG08sCK
         bApLTL+dw/vAfkqZNqkl9Zvmj6BLiryOoPCebCiYnclF6/IQKAZfgaWSmK037UTPMz
         vzrQ+erIFrqBjQSvl8URj/vV0BWTyiNI2J9aKw2bzW1caoGg/2aRi09A7hfcBjzj2o
         K+eaSOaxXuZMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E1C660A0F;
        Mon,  1 Nov 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: mana: some misc patches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577340844.3113.9934423294901348328.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:30:08 +0000
References: <20211030005408.13932-1-decui@microsoft.com>
In-Reply-To: <20211030005408.13932-1-decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 17:54:04 -0700 you wrote:
> Hi all,
> 
> Patch 1 is a small fix.
> 
> Patch 2 reports OS info to the PF driver.
> Before the patch, the req fields were all zeros.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mana: Fix the netdev_err()'s vPort argument in mana_init_port()
    https://git.kernel.org/netdev/net-next/c/6c7ea69653e4
  - [net-next,2/4] net: mana: Report OS info to the PF driver
    https://git.kernel.org/netdev/net-next/c/3c37f3573508
  - [net-next,3/4] net: mana: Improve the HWC error handling
    https://git.kernel.org/netdev/net-next/c/62ea8b77ed3b
  - [net-next,4/4] net: mana: Support hibernation and kexec
    https://git.kernel.org/netdev/net-next/c/635096a86edb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


