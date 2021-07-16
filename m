Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7058E3CBBEF
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhGPSnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhGPSm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 14:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7365D613F3;
        Fri, 16 Jul 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626460804;
        bh=yxkP2+8maL2P5u+42r8Svn1uXNu5o9H/w9R8jCsekik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jzV6+ebPZnZco9brJzopkwyWjVMnbw6OVKt0nglm4GcKVOWkhi/34e16uCj5JL1rH
         1pa8ToUyeX0uEdd0/JrtyNl7yHRNYhAe+hZu/Xxig2CLwWw8o85K7MXcwyeHU55BxW
         Ab4u+eBlV0eH7V8ru61Y8Gx0IwzavRCxb8OwdMQ+T7+OprGk6b5uKbjKeC4vzRP2Dd
         99w1eWk1fuvQbf6qNmDF7nr0qnptuDHqsjMJIVauEPnoMaJq0sOuwSbmrOGS/owras
         Aexcbl6N+U+ve8aD8uI/m0I2wGhdy7BFJgmciLhnweyE9E7hlrfCK6lAojVmJwamtF
         XKXj+htbzC2zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64960609CD;
        Fri, 16 Jul 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: Add multi-queue support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646080440.26435.12261408359950246582.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 18:40:04 +0000
References: <20210716015246.7729-1-yepeilin.cs@gmail.com>
In-Reply-To: <20210716015246.7729-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, cong.wang@bytedance.com,
        peilin.ye@bytedance.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Jul 2021 18:52:45 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently netdevsim only supports a single queue per port, which is
> insufficient for testing multi-queue TC schedulers e.g. sch_mq.  Extend
> the current sysfs interface so that users can create ports with multiple
> queues:
> 
> [...]

Here is the summary with links:
  - [net-next] netdevsim: Add multi-queue support
    https://git.kernel.org/netdev/net-next/c/d4861fc6be58

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


