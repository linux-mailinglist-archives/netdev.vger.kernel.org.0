Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1C31206C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBFXUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBFXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D52B64E8B;
        Sat,  6 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612653607;
        bh=Oe7F1ioZbST2N4PNn6E+U+ODkxbXn62DYsJQeXEuIes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HF2wgm6FO5ggXDC+8+wOm+w/04AITHlLV8oaJqQ0Smcr4e04u/WUlXM7+WxsvGeug
         h08vBbAaWSrkj4eLi5qWUg4kD3PqQa9frsChZlDqJE5rtWaD3ZPCYRbk2e+MN9lMMW
         h6bMxgIh1Y5CubZdhGpRlLrcUJSjQrhWDM2KJX53Vf0RNq3csgRvUe+kZ598MW3x0N
         6fG9FfsPu5IzlRdcyq13ZL+sBaH/rfOFUI/0n/ywO4ItaGLJwamv+o+9a+EBJnKkIR
         Aj5E3l9IHjnmYW0Vk3m3RQtHfbcRpVTaLmBdGSIrpyvb1BNqC8h5pWSygnzs2LvqXq
         KMAeU1wFSvo1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88B92609F7;
        Sat,  6 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: don't try to disable interrupts if NAPI is
 scheduled already
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265360755.24915.2733374616977574574.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 23:20:07 +0000
References: <78c7f2fb-9772-1015-8c1d-632cbdff253f@gmail.com>
In-Reply-To: <78c7f2fb-9772-1015-8c1d-632cbdff253f@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 5 Feb 2021 22:48:53 +0100 you wrote:
> There's no benefit in trying to disable interrupts if NAPI is
> scheduled already. This allows us to save a PCI write in this case.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] r8169: don't try to disable interrupts if NAPI is scheduled already
    https://git.kernel.org/netdev/net-next/c/7274c4147afb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


