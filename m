Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907C64106B4
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 15:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhIRNVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 09:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhIRNVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 09:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2556B61351;
        Sat, 18 Sep 2021 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631971207;
        bh=cPfavhDDlVCV6/oOL8VsDSq259J0tOsgl+j38mCUITE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HicqcMmD394iE9EG2HzOgvxrU8mPrRE5V/XCEJfHq1LJjoFm/jtKAAi9Mvy7JXhaw
         A5SQXJ+OX0wKImRxHUn66op4MYoUuKc1Gr7vO8YIoneXOGDsKqLpD/PMWTpYreFY7v
         8R4U0FhbP1h31wfJ3Zfv6z9Tpvfov9Bni5RrrnNhNv05RfwQ62xFqzPlXehd/abvjH
         Od2nPqWbkcUT4tHqOt+JI580RYpG0eNPekeVQSX5iK4WsZKL+iUIIBZI/Jo49OWc+N
         wd0rKdExgk40K9Axa0htf5g2ObvcPwC17XyGjmAihtHoQYv4+jv0iE/844quUYJNLJ
         boMswSKi8l7qQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1965860A22;
        Sat, 18 Sep 2021 13:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] net: macb: add support for MII on RGMII interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163197120709.23724.2848449377172040478.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Sep 2021 13:20:07 +0000
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 16:26:11 +0300 you wrote:
> Hi,
> 
> This series adds support for MII mode on RGMII interface (patches 3/4,
> 4/4). Along with this the series also contains minor cleanups (patches 1/3,
> 2/3) on macb.h.
> 
> Thank you,
> Claudiu Beznea
> 
> [...]

Here is the summary with links:
  - [v2,1/4] net: macb: add description for SRTSM
    https://git.kernel.org/netdev/net-next/c/1dac0084d412
  - [v2,2/4] net: macb: align for OSSMODE offset
    https://git.kernel.org/netdev/net-next/c/d7b3485f1c2b
  - [v2,3/4] net: macb: add support for mii on rgmii
    https://git.kernel.org/netdev/net-next/c/1a9b5a26daf6
  - [v2,4/4] net: macb: enable mii on rgmii for sama7g5
    https://git.kernel.org/netdev/net-next/c/0f4f6d7332bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


