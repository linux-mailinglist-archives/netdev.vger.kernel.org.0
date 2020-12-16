Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD32DC767
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLPTv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgLPTv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:51:28 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608148247;
        bh=xwp1vMWzBkKnuO+OphQCQ/8A6FTErJ0wiTEqtpUJUH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c7BhqCzEzzyU4P0q+Fvkrm8uGlaJQyDlN7+kL3dc0I2pL6EoScekqBuRVBdl/qaPV
         il0mPMg51t8z5OOXXmY3A0swW/o2RPzwwYsUlOXS9Yqgm7fiLAlJ7dSzWkTXJBHyIn
         WDQiPFWkCf4bs5SWfSz5l3cQojgORVPmOkAWLzMXvwrjyklSqEg9hLqMBwMSJQR0qO
         YNonf7fqUGAbQ0eafco+IeDtqGN52cPhIsLAonvCto4+1U6jv7rmlRXk3B8WaS1+Sm
         HmjO4Gt1W7NlxaH2ySW02k64rfYJJhzlacJnhu7OL1RfUu7SQRxcE+IS80Rec8hiTn
         2nHoE6cTVtTfA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error handling
 path of the probe and in the remove function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814824770.18857.16417410441229264372.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:50:47 +0000
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Dec 2020 21:21:17 +0100 you wrote:
> 'irq_of_parse_and_map()' should be balanced by a corresponding
> 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.
> 
> Add such a call in the error handling path of the probe function and in the
> remove function.
> 
> Fixes: 492205050d77 ("net: Add EMAC ethernet driver found on Allwinner A10 SoC's")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
    https://git.kernel.org/netdev/net/c/322e53d1e252

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


