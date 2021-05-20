Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8079338B9AE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhETWvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhETWvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F10E7613AC;
        Thu, 20 May 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551010;
        bh=hr5MrQkmn1RCw59wG+RV0Z/R1+KGAtRMgCV81O2pmE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jCA481YNA/kie6CedBIfzJAotNsQNSxxVzTwh3y/zpVY+MdJHl1kpo54ulbKun4Uh
         c8arSH8KKAP2djXXtW0erwrqqIS9F7FE7nK2ppj9uQUl8I1JOFJ9Ob9gBnBN0fwLZW
         iziPx8BHnVUMjp+HqpDlrVnqagqvbOFm3QJBQJK6WOmGBCspj28AWT1Fi0j/u663Sf
         ytMG1d5OEym7LCd3cXWo4sV0uD5xzU+UjbuKmArORhKBsSWD+Br0YLl5wsFyXx6Z0y
         bfBH6s6ez6ce/x5FOPXjZq1k3u1EXRm6dXbZkUKLWTaeeJc3JayqKBkVncVENQQJWZ
         RMVIWrCICYx5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E671160997;
        Thu, 20 May 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/qla3xxx: fix schedule while atomic in ql_sem_spinlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155100993.27401.529271178627433178.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:50:09 +0000
References: <1621513956-23060-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1621513956-23060-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 20 May 2021 12:32:36 +0000 you wrote:
> When calling the 'ql_sem_spinlock', the driver has already acquired the
> spin lock, so the driver should not call 'ssleep' in atomic context.
> 
> This bug can be fixed by using 'mdelay' instead of 'ssleep'.
> 
> The KASAN's log reveals it:
> 
> [...]

Here is the summary with links:
  - [v2] net/qla3xxx: fix schedule while atomic in ql_sem_spinlock
    https://git.kernel.org/netdev/net/c/13a6f3153922

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


