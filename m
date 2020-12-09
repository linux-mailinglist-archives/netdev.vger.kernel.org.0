Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4EB2D4F0E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgLIXvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbgLIXuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:50:50 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607557809;
        bh=6oddy/+FICuvS8AKCKJYtcKhaUZoK14CoUjage/C0Q0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JD6ArBjRMNLfQVHkJuhribxOkQ/8nSHAqhU7wrUdwLWMy3/wmZCb/W8qS1x792Gy5
         EBT2aF4I7kzw9hQsH35yEdecWmIKWTMx/u74OEB5dpJfYXUhx9TOSufmSuIbm7nKOu
         D27Qs5o7C9VwRkzsn9eReB7QvmTnIrty0LV6LXjk+mMq6mF+WGtSa86wCbBz5zbrbd
         /ysdnGKDbaSI4gKefl22ORUR4L6TrvK70q8J8900AJICAO6pS6MvCQ0JG+ZyprXrmu
         ynRlS8K1YfYKavj2/5GLmg8Fu0xXl6WpWU6nTozhzzkGSUFTDZaBZL+j5JTT9pbDuK
         lfa+rTU/uoBew==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/9] XDP Redirect implementation for ENA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160755780949.1337.9921603526592047855.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Dec 2020 23:50:09 +0000
References: <20201208180208.26111-1-shayagr@amazon.com>
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, sameehj@amazon.com,
        ndagan@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Dec 2020 20:01:59 +0200 you wrote:
> Hi all,
> ENA is adding XDP Redirect support for its driver and some other
> small tweaks.
> 
> This series adds the following:
> 
> - Make log messages in the driver have a uniform format using
>   netdev_* function
> - Improve code readability
> - Add support for XDP Redirect
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/9] net: ena: use constant value for net_device allocation
    https://git.kernel.org/netdev/net-next/c/ce74496a1575
  - [net-next,v5,2/9] net: ena: add device distinct log prefix to files
    https://git.kernel.org/netdev/net-next/c/da580ca8de2c
  - [net-next,v5,3/9] net: ena: store values in their appropriate variables types
    https://git.kernel.org/netdev/net-next/c/e9548fdf93bc
  - [net-next,v5,4/9] net: ena: fix coding style nits
    https://git.kernel.org/netdev/net-next/c/1e5847395eeb
  - [net-next,v5,5/9] net: ena: aggregate stats increase into a function
    https://git.kernel.org/netdev/net-next/c/89dd735e8c1e
  - [net-next,v5,6/9] net: ena: use xdp_frame in XDP TX flow
    https://git.kernel.org/netdev/net-next/c/e8223eeff021
  - [net-next,v5,7/9] net: ena: introduce XDP redirect implementation
    https://git.kernel.org/netdev/net-next/c/a318c70ad152
  - [net-next,v5,8/9] net: ena: use xdp_return_frame() to free xdp frames
    https://git.kernel.org/netdev/net-next/c/f8b91f255a05
  - [net-next,v5,9/9] net: ena: introduce ndo_xdp_xmit() function for XDP_REDIRECT
    https://git.kernel.org/netdev/net-next/c/f1a255891303

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


