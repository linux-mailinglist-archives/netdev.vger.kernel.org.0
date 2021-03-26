Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5499A349D9C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCZAUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCZAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 375DE61A42;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718010;
        bh=RIoF0gduZ85PYFtY97gplgmDAE9frYxteb7UCQpYIW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yr4Lo+bt+A96EaoCvK7tlkoU98ap9aQc7F14HkLfBTtxn6Z2qyd7nEXaJtLK2HtP8
         7hELKCyL8qrZZAPcmYLgaQfZJuTSXPyHgPLxouLKBKABRlXUb+OxRPICVu/YD4FM/T
         353GL2a704aJA8FQX7ypSh8r4xY+mbmL35POGJCC/UlLW99lILrDJ/VviAdKmoDnUT
         77Yj+/01n3MTZRobd/Ts+ctr8FXr3oDfsYctcbhy9NJNdhkQFoQV199lwPsWaJaN6H
         pwwL4co2drmybxMX7li8rl2br7mePgFErvieKm2UBt+QdmTvhy43wgN3kYvBZc5ARa
         9/YwxS1l/5DYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 288BD60C25;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: b53: spi: add missing MODULE_DEVICE_TABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671801016.29431.1526883303866154107.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:10 +0000
References: <20210325091954.1920344-1-miaoqinglang@huawei.com>
In-Reply-To: <20210325091954.1920344-1-miaoqinglang@huawei.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 17:19:54 +0800 you wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: b53: spi: add missing MODULE_DEVICE_TABLE
    https://git.kernel.org/netdev/net-next/c/866f1577ba69

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


