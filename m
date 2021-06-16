Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58C3A9465
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhFPHwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231476AbhFPHwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9DF4E613BF;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623829804;
        bh=Sxq3XIEcc5onKbwxW3dYV+EUjg8XPUQtvdPA7los0PM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k5+2TqkfWOllV8S846ZsGvjDPv88gLS5v8M/Pb41vPIi5kn8r05UqNJXhDzzRCd5f
         Zh5cYWbabGOeQ3eXQ27YSjOtnwNeDwIL6p+1k1URRM0coNlupbQ4AjFCDBltVDawib
         W6cMkffpxScghy2I0F4hYEAoCJhguTI4y2SoVhnQbLj0qamYdJkDFxS/xXkL52jMkh
         2PwCgB4YGG588KgAx9MA5raeWWerVzDmQP7ISCoZvYEWeEBysjNrhZsrhmhCxJGa8C
         rCczbDx6gmP3MJxvBAR62Q2wcjbuDqzXo6Uz7W9hJW0DN/XGixzbAAEI9lr+ZMkpxh
         0J2Xk6aK8p4gA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 918F660953;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] inet_diag: add support for tw_mark
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162382980459.6206.15151503411347265513.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 07:50:04 +0000
References: <20210616060604.3639340-1-zenczykowski@gmail.com>
In-Reply-To: <20210616060604.3639340-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        edumazet@google.com, jmaxwell37@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 23:06:04 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Timewait sockets have included mark since approx 4.18.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> 
> [...]

Here is the summary with links:
  - inet_diag: add support for tw_mark
    https://git.kernel.org/netdev/net-next/c/1b3fc771769c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


