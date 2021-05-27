Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E573923B2
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhE0AVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhE0AVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9035F613D2;
        Thu, 27 May 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622074809;
        bh=KdEX/zZ5PhEYQ2p0D4H29bNgyuiuPsYAIjdEukiybnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UB7Uu8sWpizmeqSl5TVCLPrOnIdQ61TUyqjDw1C87dtVySlEZnpltt5lVZDjpN/ds
         TmPZ6pAF6tsXcqFhb8cc71IXNRKaZqxd1fx7D/YCR6Cv6dF5njYXORlB8QPBnTtONT
         iEOtPs4dkO8/lp5ShBoFUEJU8dehoBd3Rbfk3w4pxdvpcLLTLgLocJb2pilmE199Cw
         e7djccDweyEXannLiAAcYhihPkO1BmBpJ6N4Jnl4J2o8gAmTyystMfxjUMq43WNsKp
         WVDnyDSAqoEF84tPNYvww2dlYbg6a2am3u0PDhHg3dYZ1TOxJb+MwsBReyLVwPLln9
         AnvQBACQH/9gQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 800F0609D6;
        Thu, 27 May 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/appletalk: Fix inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162207480951.7761.12419491819863033472.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 00:20:09 +0000
References: <1622024464-29896-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1622024464-29896-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 26 May 2021 18:21:04 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/appletalk/ltpc.c:588 idle() warn: inconsistent indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net/appletalk: Fix inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/18c8d3044d9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


