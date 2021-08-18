Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81113F004A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhHRJUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhHRJUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 713296109F;
        Wed, 18 Aug 2021 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629278406;
        bh=SVwsSla8QBWC+Vuw2hQ3Cs90NAIfZqEmtvXWQEFhzB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMbOQr5pQX7aCTUVH3wD4xkR2MPeG1MkN2aXcs/YfUF2bapJXuBJZvtdXEcVw0Qhc
         LVoMe2kjeOpmXfw+XmAz0DbYDHpGW9ztyl38u5VbNT8xm9a9tEPSKCrBQ0X3keX6Gz
         bb7AZINmMWNZdzfx3awVuAXMjdIA50L/UAf5MimhGSFe8pAQ62OXJssv7hDQalWBue
         Y+WaQE3YkIu3YTb1vAQyPptXHRLh1rvfY0oCGf/LTn4yU1ijKmEwws9fI2XsI3OhJr
         bSMbmIZN4y4MeGlVBGFFwiegiaTRChUfMk79nHgkf33K06xs+pHqXMgjBbLQsuV5Jh
         4XOpYm900TiLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DF1C60A25;
        Wed, 18 Aug 2021 09:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: procfs: add seq_puts() statement for dev_mcast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927840637.7428.6834799134600240229.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:20:06 +0000
References: <20210816085757.28166-1-yajun.deng@linux.dev>
In-Reply-To: <20210816085757.28166-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 16:57:57 +0800 you wrote:
> Add seq_puts() statement for dev_mcast, make it more readable.
> As also, keep vertical alignment for {dev, ptype, dev_mcast} that
> under /proc/net.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/net-procfs.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: procfs: add seq_puts() statement for dev_mcast
    https://git.kernel.org/netdev/net-next/c/ec18e8455484

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


