Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C53ADB81
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhFSTcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 15:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhFSTcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 15:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90B15611AC;
        Sat, 19 Jun 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624131003;
        bh=xKvd5XopXQVmSDm92ytN3q8hyKkdovNhrV9ujrc5KV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FavTmEG1/mQgk33pIQ/T0aAPmDcCG0CSlnh2NkOGjfQsM5CyIsm0O4Q1KBz7e/uJ8
         JVZ2QlZCovERgKKT9GwDyY8GGIqFIDmSJkK4HDEhDAJ+x3kGIyqtQxCc+fA2qVLIyI
         9fUtEE5Q++M6KzR5s553P/Q+8u2ntVhNPrKzqNupoaj0egR1Pda7XxAnTkLcyw2SOy
         GgKVqvLgLpUqmOT8Mh4Er8MOnU9+zFKwliBnbWN5b6ASnWWL/1mlZqQSydOGdDZdnh
         HRHTlJia7Rse/RHGS48MegTS/kka2jgY4F5Nu55hJvmqBs4rltYHlF4os0P5JA2aCN
         HLTkZPL1GVruw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84D6F60A6B;
        Sat, 19 Jun 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] net: ethernat: ezchip: bug fixing and code improvments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162413100353.3389.12147406077776982981.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Jun 2021 19:30:03 +0000
References: <cover.1624032669.git.paskripkin@gmail.com>
In-Reply-To: <cover.1624032669.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, abrodkin@synopsys.com, talz@ezchip.com,
        noamc@ezchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 19:14:23 +0300 you wrote:
> While manual code reviewing, I found some error in ezchip driver.
> Two of them looks very dangerous:
>   1. use-after-free in nps_enet_remove
>       Accessing netdev private data after free_netdev()
> 
>   2. wrong error handling of platform_get_irq()
>       It can cause passing negative irq to request_irq()
> 
> [...]

Here is the summary with links:
  - [1/3] net: ethernet: ezchip: fix UAF in nps_enet_remove
    https://git.kernel.org/netdev/net/c/e4b8700e07a8
  - [2/3] net: ethernet: ezchip: remove redundant check
    https://git.kernel.org/netdev/net/c/4ae85b23e1f0
  - [3/3] net: ethernet: ezchip: fix error handling
    https://git.kernel.org/netdev/net/c/0de449d59959

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


