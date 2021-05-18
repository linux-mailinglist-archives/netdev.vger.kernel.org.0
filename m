Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A283881CC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352324AbhERVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhERVB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 17:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 409896135F;
        Tue, 18 May 2021 21:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371611;
        bh=YgnjXRr3zlInXJejH0AVMaGhaSzM+hidVCrj+Sk+6To=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TjapXRvW1crrVVrCLSJKMbK0qUeUrX4SH38FV+5bzOqrZmkUC6e0DD1rvRdgCP7GF
         3mJZ6niyogYjuE0AQPjkS82TEv72LP94BrDErupmDETQoqtNjzMw1F3tLPPu+FJmx2
         62SfrnIN6A6WJnoOXpgRzl6Lsyk5Y4wAmBYxR8o9D86fDcGeN+LT6HAOsWErVIsrGQ
         G2Az3A5zY9g632MSFAGIz+EwbwkydP68Ov2b0uJRVu499HjCJ3uvPY2EI+9ozLzbnz
         2nFxkf+BLTEjL4VI2YgOmKhhmDEw7DFswJAjdf9kztDPPdnb5WYlqFQQr+xQmg1AFc
         yx/rhAbDRDShQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A9EE60A4F;
        Tue, 18 May 2021 21:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: provide shim implementation of
 devm_of_mdiobus_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137161123.17137.10254644777060405490.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 21:00:11 +0000
References: <20210518174924.1808602-1-olteanv@gmail.com>
In-Reply-To: <20210518174924.1808602-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, sfr@canb.auug.org.au, ansuelsmth@gmail.com,
        john@phrozen.org, robh+dt@kernel.org, frowand.list@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 18 May 2021 20:49:24 +0300 you wrote:
> Similar to the way in which of_mdiobus_register() has a fallback to the
> non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
> a shim for the device-managed devm_of_mdiobus_register() which calls
> devm_mdiobus_register() and discards the struct device_node *.
> 
> In particular, this solves a build issue with the qca8k DSA driver which
> uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: provide shim implementation of devm_of_mdiobus_register
    https://git.kernel.org/netdev/net-next/c/86544c3de6a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


