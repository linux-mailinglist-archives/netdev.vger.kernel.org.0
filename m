Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2480945B2F0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhKXEDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240893AbhKXEDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 37A1860F6F;
        Wed, 24 Nov 2021 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637726409;
        bh=6SjxQhazqy68Z9WujR+DI1Loiomu1pU/+7mb9TERtu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u1QWusk9TILAM9XVrclGRGIYZe8F/V4h3d5QNm2XjXEq3hkIcz0F7D+4rjJ9I52Oc
         2XRgYDDPRsVj+//v0wdjPxRKTCNhM73+WdA6bcWVgH9yltMDD2ZEec3nFYvWlkqJOp
         cEBhar1tLgWPa7o7+M97wKysd+zvYj6rZwY5MGz1k4rgvmTApXAobQSgXUU8+M1I9z
         w3q1C9DIfSEDtKRLjwFHM8QKmC7usTG+KkLyyjixdg3RPEXvmQLobT583ugspCI6zd
         7qyMUPlv5+0TwNZ+gMCMmUl705qOBlJnQrzlmLiY0ry+9aLBlwXCDV2j3V4WnRQCoO
         53M5QhXgz4huA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A38B60A94;
        Wed, 24 Nov 2021 04:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tools: sync uapi/linux/if_link.h header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163772640916.5735.12522369021959198799.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 04:00:09 +0000
References: <20211122184810.769159-1-eric.dumazet@gmail.com>
In-Reply-To: <20211122184810.769159-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Nov 2021 10:48:10 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This file has not been updated for a while.
> 
> Sync it before BIG TCP patch series.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] tools: sync uapi/linux/if_link.h header
    https://git.kernel.org/netdev/net/c/710d5835b7ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


