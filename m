Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D47358E70
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhDHUat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhDHUak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 16:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2D3961165;
        Thu,  8 Apr 2021 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617913828;
        bh=/coQfJncdEoSyam78etzsk18La/J7bgmCn+mit2RdOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hqxi869lSvL1OFFQ7WNEm5i9DQlvI3iAfUO5+TE0hj4aI6ehL7venpykK2r4szW3j
         IDQ8g2h+3qSQiEjbT9SOWbnvfcb6oSBr9Q5ZEMcLOj5N2BssnCz2Pv0AIs3mBW1z8N
         S+eHfZFPZ0z1J1h2wpCY7jo/cVA8zRxkA3fZ5uMquUH9n3KdwaeP5fd543Xoi7gX/S
         RL67rSbSAamfEgDhnCDjnfUEZmEvSUftnX9u9Um1j9kiB4kBnz/M8WeahaA+hLp6qb
         +JzF4e8r8x5F2OwS/A2gtoLrFOKtTiQO74ZRQxCbafePkfqWttBUigjreTlWRc8ebg
         TExtwazVDpRog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF3B360A2A;
        Thu,  8 Apr 2021 20:30:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] ionic: hwstamp tweaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791382884.22924.1859438066604511196.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 20:30:28 +0000
References: <20210407232001.16670-1-snelson@pensando.io>
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 16:19:53 -0700 you wrote:
> A few little changes after review comments and
> additional internal testing.
> 
> Shannon Nelson (8):
>   ionic: fix up a couple of code style nits
>   ionic: remove unnecessary compat ifdef
>   ionic: check for valid tx_mode on SKBTX_HW_TSTAMP xmit
>   ionic: add SKBTX_IN_PROGRESS
>   ionic: re-start ptp after queues up
>   ionic: ignore EBUSY on queue start
>   ionic: add ts_config replay
>   ionic: extend ts_config set locking
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] ionic: fix up a couple of code style nits
    https://git.kernel.org/netdev/net-next/c/33c252e1ba8b
  - [net-next,2/8] ionic: remove unnecessary compat ifdef
    https://git.kernel.org/netdev/net-next/c/e1edcc966ae8
  - [net-next,3/8] ionic: check for valid tx_mode on SKBTX_HW_TSTAMP xmit
    https://git.kernel.org/netdev/net-next/c/e2ce148e948e
  - [net-next,4/8] ionic: add SKBTX_IN_PROGRESS
    https://git.kernel.org/netdev/net-next/c/bd7856bcd498
  - [net-next,5/8] ionic: re-start ptp after queues up
    https://git.kernel.org/netdev/net-next/c/51117874554d
  - [net-next,6/8] ionic: ignore EBUSY on queue start
    https://git.kernel.org/netdev/net-next/c/99b5bea04f0f
  - [net-next,7/8] ionic: add ts_config replay
    https://git.kernel.org/netdev/net-next/c/829600ce5e4e
  - [net-next,8/8] ionic: extend ts_config set locking
    https://git.kernel.org/netdev/net-next/c/f3318099658e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


