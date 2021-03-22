Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697C33450FA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhCVUkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C840761993;
        Mon, 22 Mar 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616445607;
        bh=qCbkBoG70n2k2cyW0b3PNxNLDYV3aexJ6jnmMZCpwnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MVMuZwo3WaCRa4xDpDgjOz+BuTTJqp3qax0xOOCuDXYhbgfYcHckntxPDErH1usqq
         JU1vh4FCJvHMNo8U9BIiGnbAhOr6PJrLDOIrEJSpVb0opOkr/5mvXOa2n2ZlXtAo8l
         7DHrL4aliZP/YxeWvy1NJhlUBwFcdK9C5IcnrVln3Ortr6zmQbbXkxoKeat6usPBs9
         acHSXI/BZdLzPQx0gMFfQp822zGcLFDJPAer3z5EPQGrqAhevzJMN1nlUdynHpmaKP
         yDM+BPq6krhX735T3SKIBGQN96WY7yw+lfJ3us+Ut8smojMCwoR/n6Z2Z/DiXKntry
         u2p4cW9mkdDog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B67F9609F6;
        Mon, 22 Mar 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU
 read-side critical section
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644560774.2928.9044857778646310494.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:40:07 +0000
References: <20210322154329.340048-1-atenart@kernel.org>
In-Reply-To: <20210322154329.340048-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, oliver.sang@intel.com, willy@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 16:43:29 +0100 you wrote:
> xps_queue_show is mostly made of an RCU read-side critical section and
> calls bitmap_zalloc with GFP_KERNEL in the middle of it. That is not
> allowed as this call may sleep and such behaviours aren't allowed in RCU
> read-side critical sections. Fix this by using GFP_NOWAIT instead.
> 
> Fixes: 5478fcd0f483 ("net: embed nr_ids in the xps maps")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net-sysfs: remove possible sleep from an RCU read-side critical section
    https://git.kernel.org/netdev/net-next/c/7f08ec6e0426

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


