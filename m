Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B493012AA
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbhAWDbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbhAWDax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:30:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 944A223B75;
        Sat, 23 Jan 2021 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372611;
        bh=h8imnSSMK6GPti2kX5PXnRTUJyvsiNnjOMjDfeXr1pM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPZHulUvpWsceQW7DZn0wLIAFkdvRsYXyhpfzHNzNO7PMGYfBRcwStSOniEc9icHS
         DG/i5nQn/wp0Frf3Nr0Vld1N9w4MWpvi3VwKpm7y0l1Jan/RT+CygC/906O82meKBT
         k/aNRi9AMwwtYkOlircv1yU/w3Tofw2y4ig0gEF/PsV1/G5nvEuF4gF7+1nyOO7gAU
         71ySXmZn2yw6hTwBSv8QWHigOaJqMYvvuc6mPvBF9dWQ9kflHwLibB2Xw26GX+dr0Z
         5NHm/4ZSowEh/XOrwST9wLmNUKXnMlE7FlsyGAI52j4M4qwy6ZMSIxM7yVJU2vFKSG
         mPlqQd7ieAi8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88B0E652DD;
        Sat, 23 Jan 2021 03:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137261155.31547.7512862793674483948.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 03:30:11 +0000
References: <20210120212759.81548-1-ivan@cloudflare.com>
In-Reply-To: <20210120212759.81548-1-ivan@cloudflare.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 13:27:59 -0800 you wrote:
> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: reduce the number of requested xdp ev queues
    https://git.kernel.org/netdev/net-next/c/e26ca4b53582

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


