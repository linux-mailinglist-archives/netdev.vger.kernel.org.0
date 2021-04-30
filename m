Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED8370355
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhD3WK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhD3WK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB80F61477;
        Fri, 30 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619820609;
        bh=PLuDl7Rsk5BgPzsbgacI+N1Q5IF9T8i2IlDB2vVTBuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sU6OOY3pS06i8I0tTHQxmSaJoP3M8UfAKFaelgI+01ImVhf37HvQEQbV18+e6bPs1
         o3isYNnK4PYeJKbOElr7OkFNNaouxGgI0btjKiuxQ/fG6w5/DgonTpibiFMmkgYULW
         Nq0/TVCNsnL3KolFGqjlxqlJtdeFTwEDUMb3Jju+i5EZWDicdhX527iqYM4dzj7l8L
         BOforKBUpydkOjfHqs3F5TWjS+xHnUZTiiE+nwUEluY3iqQxo/DkITO983x7W2uWnR
         8MxYGAHiKCB/iCaCt9eR+7iwdWRpVAsPA74o1lD97oS5zUon8D9zlvWi1KgqVpddwu
         GmzRR//odEqgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C75BD60A3A;
        Fri, 30 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vsock/vmci: Remove redundant assignment to err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982060981.21725.11745298291348115356.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:10:09 +0000
References: <1619774854-121938-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1619774854-121938-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 17:27:34 +0800 you wrote:
> Variable 'err' is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> net/vmw_vsock/vmci_transport.c:948:2: warning: Value stored to 'err' is
> never read [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - vsock/vmci: Remove redundant assignment to err
    https://git.kernel.org/netdev/net/c/f0a5818b472c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


