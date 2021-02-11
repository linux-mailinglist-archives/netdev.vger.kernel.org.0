Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AB83195DC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBKWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBKWas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D6D1E64E3C;
        Thu, 11 Feb 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613082607;
        bh=yP+q+PQ7gakRiUzdazDnO0gcL2vDgb3tk5Hl6m4dRHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r57ncIZ4Wt3oMdcWQC+Y3FTkPbUTlnZPwAjw2IzPlmw76csrUpZzqjx/wYdARB787
         WaHaTUH/vN53O8PXfZXdlDwcaVO78U/xb2DQRRRzMBZXFBTHptaAGuStvRfJ/m0yEL
         /qmWTjGOzLxoepWoFlIdQUwNZqdLO+W1I/rzGByYeb3StExGlKtAfTi6gZxYxy5DkM
         7Agcpumx/J0Hsb8o3w1oXawxAfNHqK0+VXW/T38KqyHJOda/fJA31NKuGJ/pl0QMuY
         aG4Lu24HJzBrHSW60cpCbf4K9aemcdTsZG+TJbDvr/GUUVUgY1xCn3DZudYaZUvG/L
         pyya60c/5l4dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5C42600E8;
        Thu, 11 Feb 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] qede: add netpoll and per-queue coalesce
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308260780.8386.18372647752053907231.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:30:07 +0000
References: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
In-Reply-To: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
To:     Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, aelior@marvell.com,
        irusskikh@marvell.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 12:28:28 -0800 you wrote:
> This is a followup implementation after series
> 
> https://patchwork.kernel.org/project/netdevbpf/cover/1610701570-29496-1-git-send-email-bupadhaya@marvell.com/
> 
> Patch 1: Add net poll controller support to transmit kernel printks
>          over UDP
> Patch 2: QLogic card support multiple queues and each queue can be
>          configured with respective coalescing parameters, this patch
>          add per queue rx-usecs, tx-usecs coalescing parameters
> Patch 3: set default per queue rx-usecs, tx-usecs coalescing parameters and
>          preserve coalesce parameters across interface up and down
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] qede: add netpoll support for qede driver
    https://git.kernel.org/netdev/net-next/c/961aa716235f
  - [v3,net-next,2/3] qede: add per queue coalesce support for qede driver
    https://git.kernel.org/netdev/net-next/c/a0d2d97d742c
  - [v3,net-next,3/3] qede: preserve per queue stats across up/down of interface
    https://git.kernel.org/netdev/net-next/c/b0ec5489c480

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


