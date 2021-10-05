Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F924223B7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhJEKl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233449AbhJEKl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 06:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8B9D61381;
        Tue,  5 Oct 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633430406;
        bh=SKaIVl6QHQ+nK3Q80Og+HhZUEIBF3L1jsBFqxoTtSSs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aNBOYqPWmmbnHm8vwYPI/stFAcpPU3bQUVq7dXOIL5yygtiLx3dTybSmC21diXl7P
         WWlunj0w7lJCR8aNYoSRuyrTa1A0ZjxNjvVAmFEwZNw41KanOmovwD+LPgSCILVmQz
         vBRK6TIvKLp/XxfF+o/yxnEZewlpBzFjhfMmc03vOTxCa5nNzuaoUuMJ8edXe6ZjGP
         l8veQ3GgUFIdNZtmYhcw/e5Lc3F3L83giUfc05sNPr0ubtdrhhMg2ZbgTXE/tHymiG
         sgVOqCgEPuwJeWNaQEAMy2FX0WX6nDOTIWJPo+tLlZ7O3FbOwnncMhHnDY5/go4n84
         UTV4egAa2xkRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC5C360A39;
        Tue,  5 Oct 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: ehea: add missing cast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343040689.11951.8325918611000499478.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 10:40:06 +0000
References: <20211005011114.2906525-1-kuba@kernel.org>
In-Reply-To: <20211005011114.2906525-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sfr@canb.auug.org.au, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  4 Oct 2021 18:11:14 -0700 you wrote:
> We need to cast the pointer, unlike memcpy() eth_hw_addr_set()
> does not take void *. The driver already casts &port->mac_addr
> to u8 * in other places.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: ehea: add missing cast
    https://git.kernel.org/netdev/net-next/c/ceca777dabc6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


