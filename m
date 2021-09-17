Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8940FFED
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343783AbhIQTla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235944AbhIQTl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 15:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6ED656124B;
        Fri, 17 Sep 2021 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631907607;
        bh=wzRHjxYCN/4GHZmAMgf78sjNXMOockw16gW2hTPTBJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZS7yoS8bSyy7I0tVJDvx6dHZLZcKLavw8Y50Nm8l9H+dpZPzlueybWbeHtaI5Nrb2
         cEqnqnM5yEkF5YO7rPd0XKub33l5AhT8R5h2fiUF+b9i6uU2hGpBr6jfpXdeEcvVVu
         DiBqwe5pOvUg7GokfMnim6xUTWtPbZkxmAMgVEfCFylsBqmTJVHChMwppWhyKi5P0L
         YD9Eg5jmRQwzGjoyzoizMzHvulF2QGV06X/h1zLPzFG01s/Zv96PmgO/jfmq3zmEUo
         mouuLo5fFOkid9UiyYnO6o6AsOlYr7BoTNgVBiZLnBzzEgfS1/jmgRVwrn2/Fjq7lq
         pMMabyVcEMJ8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5360D609AD;
        Fri, 17 Sep 2021 19:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: bcm7xxx: Add EPHY entry for 72165
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163190760733.22479.5241027515857294065.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 19:40:07 +0000
References: <20210917181551.2836036-1-f.fainelli@gmail.com>
In-Reply-To: <20210917181551.2836036-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 11:15:50 -0700 you wrote:
> 72165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
> create a new macro and set of functions for this different process type.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: bcm7xxx: Add EPHY entry for 72165
    https://git.kernel.org/netdev/net-next/c/f68d08c437f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


