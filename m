Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF603F00EA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhHRJul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhHRJuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 24C8760EBD;
        Wed, 18 Aug 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629280206;
        bh=nPk6m8gVc4yQgj1atF2k+8YATLZH+Boe21wz3rbQ36w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BkjWZxWsdedRuVW1EQbTs8GYVNf5T6awS8SChUpoOVWJWN9qJrCOndmmSOyshpXxT
         5An+GwkCE6L9PCpPvii831IGV6ngDy7y2VsI4vNnTWS8QF6Anoq6mxwyQ56OeclCoM
         AjGnmktAc5vFiwyH6WSSQJFKvjeN+NDIU2cfQ4jz958IIjAYDqwGvYkJzPRCjZm9sV
         H+J462EU1cSNn9gJNqojEydJqV0h9VmUWNL9s+QwmzVzyT05jwa304qppsBkhZhGs1
         6tHIqNba9/Ofh2kHe7GWN/GeDLLE9Hf3mIBggplVakCJKRkw2rvL10e2H6CYZp9jKf
         UxYW6Y7QUYq7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 196EA60A2E;
        Wed, 18 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] Clean up and fix error handling in mdio_mux_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928020609.23266.3797943730217405111.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:50:06 +0000
References: <20210818033804.3281057-1-saravanak@google.com>
In-Reply-To: <20210818033804.3281057-1-saravanak@google.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, jon.mason@broadcom.com,
        david.daney@cavium.com, maz@kernel.org, narmstrong@baylibre.com,
        khilman@baylibre.com, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 20:38:00 -0700 you wrote:
> This patch series was started due to -EPROBE_DEFER not being handled
> correctly in mdio_mux_init() and causing issues [1]. While at it, I also
> did some more error handling fixes and clean ups. The -EPROBE_DEFER fix is
> the last patch.
> 
> Ideally, in the last patch we'd treat any error similar to -EPROBE_DEFER
> but I'm not sure if it'll break any board/platforms where some child
> mdiobus never successfully registers. If we treated all errors similar to
> -EPROBE_DEFER, then none of the child mdiobus will work and that might be a
> regression. If people are sure this is not a real case, then I can fix up
> the last patch to always fail the entire mdio-mux init if any of the child
> mdiobus registration fails.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] net: mdio-mux: Delete unnecessary devm_kfree
    https://git.kernel.org/netdev/net/c/663d946af5fb
  - [net,v3,2/3] net: mdio-mux: Don't ignore memory allocation errors
    https://git.kernel.org/netdev/net/c/99d81e942474
  - [net,v3,3/3] net: mdio-mux: Handle -EPROBE_DEFER correctly
    https://git.kernel.org/netdev/net/c/7bd0cef5dac6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


