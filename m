Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3A43674E6
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbhDUVun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241973AbhDUVum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 17:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 49CE86144A;
        Wed, 21 Apr 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619041809;
        bh=s4Zr5VtMEXqKZSuXiuRuKKYt1o+jeL2twZychiAT6w8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LdN3ZKc4pmtRJbyebCQ+i2LAlZzeo2A9qQepk/0Y+YpwZ6XuNHx9lkZ4S46dM488M
         x7asKsCT1Q+F2XUArCApmLYmHzdAOnqVbQc9eHKTCuPKRxARpkF13k3E8F+60FK9cF
         JGxP6WGbUNG5DY0DOr1KYfCrdtA1AR2vm05YsuxqFsagSZB5HGUn1UFB26OKflLEEd
         qgJpPFpYr2W33Bo2xzLl27N0ZM+uLfoakJEGYnD9PFroN/4y7U+90yftwU5aFPKs8d
         +IxmXA9c8WjZDUUuGgfC/jsk12ZOPgB9xxXl0AruDxlxe6E3FrLviNuyj8P6AZJiaK
         miUhViDdfF7UQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43F5960A3C;
        Wed, 21 Apr 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: marvell: don't use empty switch default
 case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161904180927.24605.504807085228864335.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 21:50:09 +0000
References: <20210421140803.17780-1-kabel@kernel.org>
In-Reply-To: <20210421140803.17780-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        kuba@kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 16:08:03 +0200 you wrote:
> This causes error reported by kernel test robot.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 41d26bf4aba0 ("net: phy: marvell: refactor HWMON OOP style")
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/net/phy/marvell.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: marvell: don't use empty switch default case
    https://git.kernel.org/netdev/net-next/c/5d869070569a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


