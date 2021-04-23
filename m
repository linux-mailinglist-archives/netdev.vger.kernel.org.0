Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483C5369B39
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbhDWUUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWUUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 16:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 16AE061396;
        Fri, 23 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619209209;
        bh=Cpr3iJLCq3B4ez1UOmNaUNBIfNOOKNbyqZCwRteXx88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=agP7g3dQdK7msngwBZQ5zEseu02VLCdQzAA79aPZxL3Jvxwvv6zgylk9ZJB06/jon
         OHAiOF12RXEwgQbNY1qGd9J2BqgrCrGU6nUDWZ0BYqA0f2SpEQq25DMkZaOnI2ZFYa
         uUOburfY7/Hvi7cDglfh1h1bn4HbGtRHM3jyDJjlnbtrPl4W2AhlogQNBRx5v+S0wT
         ubwZ5obaF/bU9o5v47m9OF99qdrblE7uHItgTA1trUQWpfvIcyE3d3FHrFUD/Seu94
         jVrR4DTL5Os+j0R7oF8KQBedoATWCuGXcQl93/Il3Vm6JVqpMjZdpytCLgraM7uS1m
         aBwc3XGvVTRXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E6B960A53;
        Fri, 23 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sock: remove the unnecessary check in proto_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920920905.3258.13413289137138136442.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 20:20:09 +0000
References: <20210422134151.28905-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20210422134151.28905-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, linmiaohe@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 21:41:51 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> tw_prot_cleanup will check the twsk_prot.
> 
> Fixes: 0f5907af3913 ("net: Fix potential memory leak in proto_register()")
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: sock: remove the unnecessary check in proto_register
    https://git.kernel.org/netdev/net-next/c/ed744d819379

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


