Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D518A43E299
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhJ1Nwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231172AbhJ1Nwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0430610A0;
        Thu, 28 Oct 2021 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429007;
        bh=OUflcvkpBQ0o0eDAys1YA75/wB+5mbvzvxLNDyt8fNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AzOHjFuD3jz32EI5yZfjiUdUdf7Vxgs9NGID1ownZj4M/doX0rM29/pmRkZx9RIc3
         0P84tl8zUkRdzc4eiohGVHHTrN1QZ6G4xWLt1hri2m35lgZ9zr/PIRf2HXSUUPHrXS
         r4BzSVT6g9Mu/LWLcxY4DDhRoWcEqKLOzem9fJYTx4+Fewc83A9KnOqOlq9gKWlT+S
         SXJGxnOAxebMj+i/A+psreLThN/hzMZjo7AeoRBqNJpmEUG7gwoO12Z4b9LFjmACJE
         yYIoLzMEwFTBQ69Li313y+ml+wHsawWhcf29jbNCPE01T8HPAw5Bworp08Wum+I2UT
         7flQpklUOmqyQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94B8060A25;
        Thu, 28 Oct 2021 13:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] net/tls: Fix flipped sign in tls_err_abort() calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542900760.8409.18287591469430006130.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:50:07 +0000
References: <20211027215921.1187090-1-daniel.m.jordan@oracle.com>
In-Reply-To: <20211027215921.1187090-1-daniel.m.jordan@oracle.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, davejwatson@fb.com,
        vakul.garg@nxp.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 17:59:20 -0400 you wrote:
> sk->sk_err appears to expect a positive value, a convention that ktls
> doesn't always follow and that leads to memory corruption in other code.
> For instance,
> 
>     [kworker]
>     tls_encrypt_done(..., err=<negative error from crypto request>)
>       tls_err_abort(.., err)
>         sk->sk_err = err;
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/tls: Fix flipped sign in tls_err_abort() calls
    https://git.kernel.org/netdev/net/c/da353fac65fe
  - [net,v2,2/2] net/tls: Fix flipped sign in async_wait.err assignment
    https://git.kernel.org/netdev/net/c/1d9d6fd21ad4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


