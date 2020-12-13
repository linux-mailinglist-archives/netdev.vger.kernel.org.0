Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A22D8AD3
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439962AbgLMBUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 20:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgLMBUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 20:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607822407;
        bh=kamsfLluyGJCkDdF8e3xmFsL1h7UPia0fZmevAtdGyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PUrh1E5tCQlgQdTS/o9V6tgjCQdE/3Gq/mHswnQHYlSDyBUDj9fxqZclZbyzJPVMV
         lxe8u/UR1NKiJ/RP4PCGGaOBhqOmQt30TY958jDjjwKq3jsWTrLVEchTrOdpgvsJOn
         pvfFO9l3Fljrl5smVyRkRZFOJ+Vf3C/pcN0K/Sp1tXT1voyClBqA9d60/SWiHaXqjT
         xxzdhEw6eoDxTvSb5PwnxH8Q+9y4qGGgEXkk+enywvJnIDtUzq3Hp6RMX7wD3Iac2y
         bbSvRHOvs9/CZPDnGtgtNEl6uNxmb1m+7KmX+rF1SxN91Xe6DXgZMw0AmyEiKCZlpR
         8AR9yB+xDuiqg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC code
 stubs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160782240712.6413.5405278375067438996.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Dec 2020 01:20:07 +0000
References: <20201209033346.83742-1-xie.he.0141@gmail.com>
In-Reply-To: <20201209033346.83742-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ms@dev.tdt.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Dec 2020 19:33:46 -0800 you wrote:
> According to the X.25 documentation, there was a plan to implement
> X.25-over-802.2-LLC. It never finished but left various code stubs in the
> X.25 code. At this time it is unlikely that it would ever finish so it
> may be better to remove those code stubs.
> 
> Also change the documentation to make it clear that this is not a ongoing
> plan anymore. Change words like "will" to "could", "would", etc.
> 
> [...]

Here is the summary with links:
  - [net-next] net: x25: Remove unimplemented X.25-over-LLC code stubs
    https://git.kernel.org/netdev/net-next/c/13458ffe0a95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


