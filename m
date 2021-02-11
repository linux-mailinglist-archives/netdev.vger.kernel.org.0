Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD563195B6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhBKWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhBKWUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CF3A764E38;
        Thu, 11 Feb 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613082006;
        bh=ZAHQk1ZF0KMg4HtqI/Ql5v/6zabzuMTFQ4oCOMhwFP8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WsTdu4UTaLfrxkjcyeAk1Ixq8hGbD+SbcB7g+AijpgaXIxnOJ4+ArzHe+etVPtcrm
         RNFPClFnUfLnzmCqVnisgt7LHFBr2x4BJOtwOu7DZ/fA4qcu4StMSgr+WHWFoqemOs
         8RoXmLyLQz0guX9FYY2jSN9XWTAtHsonivjKeRsCfS3P47y31zpVzQ9CrfwwLDV6nZ
         P4sWnKpgy1pjwEmpKnQycNIPCl16gM9nXLQ+nPbUxxqCHJWUTK79m9KbXGK4HtwYH4
         dRLG6/4aPO9fS1gxxwx26UFBntUn/ToHN7G2C9wE0oP9/hIG/WoE0MLIq/TT7FjxKw
         n/z48C8XzwelQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6BB960A0F;
        Thu, 11 Feb 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix tcp_rmem documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308200680.4488.14097049184083571087.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:20:06 +0000
References: <20210210171333.81355-1-eric.dumazet@gmail.com>
In-Reply-To: <20210210171333.81355-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, zhibinliu@google.com, ycheng@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Feb 2021 09:13:33 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tcp_rmem[1] has been changed to 131072, we should update the documentation
> to reflect this.
> 
> Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Zhibin Liu <zhibinliu@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix tcp_rmem documentation
    https://git.kernel.org/netdev/net/c/1d1be91254bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


