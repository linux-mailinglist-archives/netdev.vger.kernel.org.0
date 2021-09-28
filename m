Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C871841AF11
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240781AbhI1Mb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240571AbhI1Mbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44232611F0;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632832208;
        bh=XNbhJ0Qs1GVCmMoLw+Q1yDMi3WDMwW1B9piNF+yvZJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GPlIqGr857ucQ9Wty2ycb3h6ZEgGLsTdbaqlpWrdLNhb6LrmS6/J3JhmGtZVhH1HT
         nnjiOocSqThHQ9eKpeZxTvaobNglzQcHDmV2pdENKYwvOuJADDMefvDhaDG18/dJIC
         7aZP/9OgDFB6XUqs5aqVPRj43mZsXxz9yZws29B4rjaS0Afj8cD8skCbrv81UtKf2I
         LrBb6m2DWIA0PZ8UdkfVTEkFoEVxrhewCAIO7I8MZupUVYAhEcS/6m3MwhpJMiaswc
         2ziEu8WA0xN0Qd3ENb8X8ls02gUM4rrFPU4KXy960QbbNy2ZrejECcUr2lMVxeThpW
         anONbL2DhYKdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 384CA60A7E;
        Tue, 28 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdio: mscc-miim: Fix the mdio controller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283220822.6805.11331370615132640445.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:30:08 +0000
References: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, caihuoqing@baidu.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 09:17:20 +0200 you wrote:
> According to the documentation the second resource is optional. But the
> blamed commit ignores that and if the resource is not there it just
> fails.
> 
> This patch reverts that to still allow the second resource to be
> optional because other SoC have the some MDIO controller and doesn't
> need to second resource.
> 
> [...]

Here is the summary with links:
  - [net] net: mdio: mscc-miim: Fix the mdio controller
    https://git.kernel.org/netdev/net/c/c6995117b60e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


