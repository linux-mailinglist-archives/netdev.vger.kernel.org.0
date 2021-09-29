Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16941C2D3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbhI2Klt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243618AbhI2Kls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 741BE613D3;
        Wed, 29 Sep 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632912007;
        bh=RtCMrrHMU+NRUg44oiwpoQhRnMnzTeMvAseqV8/5jg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q1skRFGiq4AOwLxnIDZqpCkC02FrBWA/Geumu2mPq7KxeQq4G6RouN3HFzyx5jlX9
         QN7Dgx5tG67sPYmePk1LCnGEt08Pfd7ocKlWgAkjfWfceCEj7pI5j5U/4F66ip3IcB
         kiyPl+sUxkNbZUB+6ItosCB5FsBqnz0Hj5jNIiRw7Pe15xhanj31XQj991IHY3C14K
         eKcg/0JvxJqrKQG5MdgvAEIqEDsNl083sT5L+GeS+krKcE57Y9gXrshiS7LXivLpc5
         40aSD5r+pMyHmKWZtTzvoRv9krgaoElOTZvmoq+Q14iP8Tgadt9hC/dWUqcUmbJnYW
         erj0e39vAkfLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E61E60A59;
        Wed, 29 Sep 2021 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: bcm7xxx: Fixed indirect MMD operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291200738.26498.15349301830950114160.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:40:07 +0000
References: <20210928203234.772724-1-f.fainelli@gmail.com>
In-Reply-To: <20210928203234.772724-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        opendmb@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 13:32:33 -0700 you wrote:
> When EEE support was added to the 28nm EPHY it was assumed that it would
> be able to support the standard clause 45 over clause 22 register access
> method. It turns out that the PHY does not support that, which is the
> very reason for using the indirect shadow mode 2 bank 3 access method.
> 
> Implement {read,write}_mmd to allow the standard PHY library routines
> pertaining to EEE querying and configuration to work correctly on these
> PHYs. This forces us to implement a __phy_set_clr_bits() function that
> does not grab the MDIO bus lock since the PHY driver's {read,write}_mmd
> functions are always called with that lock held.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: bcm7xxx: Fixed indirect MMD operations
    https://git.kernel.org/netdev/net/c/d88fd1b546ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


