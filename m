Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB941D9D4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350873AbhI3McB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350837AbhI3Mbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48557619E9;
        Thu, 30 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005008;
        bh=CcTc775U0Nnl+OC4Icy8y2oARW0X9UK7n7gImHsHo7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t2MXS/32kQUQa7M4cL/OtdYJd9vUUjpagPsgpASJdpvXcfUPWB5rAFHeFsAAnFrqX
         AxybwM8MxoN8XUFnTb1YFpv5Ro5drRl+374GyT/Uop7Ge62GW13gC3knxB9YlvEEZp
         nEuJNlVoBj784FM5SKSwZHBcGdQEkxxgguT4Bl9ywbttP3XSV8bmP1ljX5tyF68RJi
         KJ1GVMAQAO/7in158TH9lec7YsYL5ni7tQ04CiuRrNtaJ8pSP1yt67c0Q19vYtpVsm
         3P+w1UaeZclUC05jXfH6rLX30kCJDjU+aMTIue+zu7IBsNXpJzBHDolQiR/N75uoTg
         UI0u0n8jZJYlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F43D60AA5;
        Thu, 30 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Remove redundant initialization of
 variable pin
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300500825.24074.17246457961363839532.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:30:08 +0000
References: <20210929132753.216068-1-colin.king@canonical.com>
In-Reply-To: <20210929132753.216068-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 14:27:53 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable pin is being initialized with a value that is never
> read, it is being updated later on in only one case of a switch
> statement.  The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Remove redundant initialization of variable pin
    https://git.kernel.org/netdev/net-next/c/75f81afb27c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


