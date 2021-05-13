Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D1837FED1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhEMUVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232582AbhEMUVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 16:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3997613DE;
        Thu, 13 May 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620937209;
        bh=M7fff01UaM/PyNcz1Grxz5NiWZd8L0rRDZZzYnsMyZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K4YIk7ll4rSrbQqSOP8zq4uCh+YvRwDrkpXBPZ0W06HedZbh1f8rAn8ZEVbMWUuru
         jj/izkCMzpEdUNUjlejfUA+yoZ/HPcor0vnKi2IHDkvIWvGgfcQT0/TcUu1IzjUnWV
         uZMkzHenHMYzR4bXNaaP+QMV7eKzDZvV5TkQWNn2VyG0AlLdPb9b3PIypPuaNF6RZl
         roD86hGSTPI/J5xi987AOxuuafRuGXemhzLFPRqTkSl9GYljp0QhKA/osHlBLOFION
         c4OExDO3I5jAxL7GKJrhnjjS6DIUZj4UMfr8/NN0b/SSBn6BvWM7al6xSJED4sHn/V
         duC1OuKTtL3ig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D424060A4D;
        Thu, 13 May 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: mdio: thunder: Fix a double free issue in the .remove
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162093720986.5649.11608621968366387859.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 20:20:09 +0000
References: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, david.daney@cavium.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 13 May 2021 09:44:49 +0200 you wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the remove function.
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - [V2] net: mdio: thunder: Fix a double free issue in the .remove function
    https://git.kernel.org/netdev/net/c/a93a0a15876d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


