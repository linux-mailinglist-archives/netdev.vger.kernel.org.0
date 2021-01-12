Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88272F256D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbhALBUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728675AbhALBUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 54ABA22DCC;
        Tue, 12 Jan 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610414408;
        bh=dCWL39hklgRHNaFesgaUUKQedVY8OUSnxjyVKTKzHuU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cKtlEoMxzU9WJc6NxU3ut4nT4U86UrjIj5NwdcLy3PJkOgBZQFzrd0I87w9kun5LX
         HZkFQAl6AINp23QQif4KDcySOOzTE3D6yrcm8ON8B3b1wDjSkLML6t+41v4RDbfUQs
         IX4c3ltxMtvrrRxwskmmg6+ZIAMO6YIquInFpf02LGsqYo4SpXEQrDbeP6abj1RdZ7
         iRCq3xK/X+J8x/BHpKi92oFGEFJjyU9hNaMmUiEAEW0dfY0VKSZOeGWOEymWHTE652
         e32KdPhhfJAvXwzCnhD3UVcaesaMD5DZYlq7QZDlHRY9reXeBww+wAr9igK3esDwHJ
         qkuU5RW1i+DXw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 459B26026B;
        Tue, 12 Jan 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] r8169: improve PLL power-down handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041440828.22670.14262729260778178052.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 01:20:08 +0000
References: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
In-Reply-To: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 10 Jan 2021 20:46:58 +0100 you wrote:
> This series includes improvements to handling of PLL power-down.
> 
> Heiner Kallweit (3):
>   r8169: enable PLL power-down for chip versions 34, 35, 36, 42
>   r8169: improve handling D3 PLL power-down
>   r8169: clean up rtl_pll_power_down/up functions
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] r8169: enable PLL power-down for chip versions 34, 35, 36, 42
    https://git.kernel.org/netdev/net-next/c/9224d97183d9
  - [net-next,2/3] r8169: improve handling D3 PLL power-down
    https://git.kernel.org/netdev/net-next/c/128735a1530e
  - [net-next,3/3] r8169: clean up rtl_pll_power_down/up functions
    https://git.kernel.org/netdev/net-next/c/7257c977c811

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


