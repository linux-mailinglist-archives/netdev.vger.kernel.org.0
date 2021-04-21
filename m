Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03084367269
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbhDUSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242578AbhDUSUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 43AE861448;
        Wed, 21 Apr 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619029209;
        bh=E54TmFKp3Y20gYaeGiLf9VOBNkPefR+f5LS/nkCT56k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nqn5ax004SfszeP4Hxycgni0oLLLGDVR7pFg1oCA1UjmWZWdcsjGOu3isET3nkTGD
         aYJLf41NMoK2p+c3yIoYgCDlBnKZ5dsmN7TCZFLRZgYRWnPdjXZesiSKORs/UBSbYp
         nzOx0yJD9Cfrdaox8zXBC2XoZ/6Da1TGetDEc0WDNk9EY1Xn2CuSxCtkQMqqoo3cpi
         s2YTpmA1dogJEmkjMY+jMr+3n5qHRH/6IMX5ovPa+Bxme6SJEVdIRDA0glizrHnJd1
         8L4WD2mvIAn1GFeNJAROfMC1qez5uVjCbjwmiS9CeNv6IwK1hPvIhO882mCOqlrvPI
         bA+sdJlvef+mQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B61E60A3C;
        Wed, 21 Apr 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902920923.1057.702460765675498591.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:20:09 +0000
References: <20210421140505.30756-1-aford173@gmail.com>
In-Reply-To: <20210421140505.30756-1-aford173@gmail.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev@vger.kernel.org, aford@beaconembedded.com,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 09:05:05 -0500 you wrote:
> The call to clk_disable_unprepare() can happen before priv is
> initialized. This means moving clk_disable_unprepare out of
> out_release into a new label.
> 
> Fixes: 8ef7adc6beb2 ("net: ethernet: ravb: Enable optional refclk")
> Signed-off-by: Adam Ford <aford173@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ravb: Fix release of refclk
    https://git.kernel.org/netdev/net-next/c/36e69da892f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


