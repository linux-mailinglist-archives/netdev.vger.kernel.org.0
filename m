Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BF241143B
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhITMVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237697AbhITMVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 78F5160EB2;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632140407;
        bh=d653BbX798CqCCsxcOS911/csfDCH5pD8dSHyWHstq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O0X0v24AA0g87z5Zmv2ei2/Dpu3ThE67zU9bcGo2Co6ihgwQdFzuwof7do7c/cLCE
         vjRSH/8VdL4tLEfeJwU6TjOaDuiTLq0HErEPNVLCvL2i2ptl5M/sa/W7zE4Oto6WCO
         L3jpqdahLVD8puSAW5t3bTNz3VSGkRwL5xVmzsyLqRb6DKkhRlF6+liUt1RmoVdMtn
         ij0a/ohCTw1//dZsx1Ec+2qHmd7Ce1bqJZBUDSAEEX8QAyURE85/vUwwr7QFifnwb6
         YyXvUE8aWAe/XQVKn7IsKa3+hD0NCabjt74NmCTvFRE095MZ95BmAXjXHvsjnrphbW
         8E0ph+dW+I6pA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6818260A6C;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/tcp_minisocks.c: remove superfluous header
 files from tcp_minisocks.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163214040742.3439.2408616357186386917.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 12:20:07 +0000
References: <20210920115536.28250-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210920115536.28250-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 19:55:36 +0800 you wrote:
> tcp_minisocks.c hasn't use any macro or function declared in mm.h, module.h,
> slab.h, sysctl.h, workqueue.h, static_key.h and inet_common.h. Thus, these
> files can be removed from tcp_minisocks.c safely without affecting the
> compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/tcp_minisocks.c: remove superfluous header files from tcp_minisocks.c
    https://git.kernel.org/netdev/net-next/c/85c698863c15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


