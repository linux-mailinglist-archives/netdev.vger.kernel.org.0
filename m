Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6EC3DDD77
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhHBQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhHBQUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 097F66100A;
        Mon,  2 Aug 2021 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627921206;
        bh=ZqdV5wI2dLqR78NrO0/PFRWn8h4oNXTph8g2qKrS3DE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Osn8Q6dDZQcLYCvz+HP5Bb443ZAoY9vxvPLnjDQ1qeB9FVeKbUM7DwwBwJQgT416y
         XRFlv5XSzP2AV+ir1DSJDRIOj1MrTSY/SSSij/3NTkqaOGiT9AfvHxGwW9v+nN6OCd
         BMwu40JqCAmjUZOf3RZJCTLln4qA+2JAt6KGkwuzBTFVa/+KSwRA0vmDZT+UlDJ79b
         9fuTVqen+OpwRAQOzpdmXLo/ugaQWaP9h5mEpwbkU+T6arNZBsCuYCPNR3/T+20fr7
         3xU4t7YD1OSYOQyXOxpVOpTdOerrKH9lv500FjNSsNySrLhklnQoiqF3kgTk24LdNn
         LVtzEgh7uaUcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1C14609D2;
        Mon,  2 Aug 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netdevsim: make array res_ids static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162792120598.11903.1834883765110373601.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 16:20:05 +0000
References: <20210801065328.138906-1-colin.king@canonical.com>
In-Reply-To: <20210801065328.138906-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 07:53:28 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array res_ids on the stack but instead it
> static const. Makes the object code smaller by 14 bytes.
> 
> Before:
>    text    data     bss     dec     hex filename
>   50833    8314     256   59403    e80b ./drivers/net/netdevsim/fib.o
> 
> [...]

Here is the summary with links:
  - netdevsim: make array res_ids static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/f36c82ac1b1b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


