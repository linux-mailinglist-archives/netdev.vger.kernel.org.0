Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65331E2B5
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhBQWoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:44:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233192AbhBQWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C2D364E33;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613601607;
        bh=lIUTKaglPT8wurrZqMgRv3Hp6yZEXH2GYUyqCpREIag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U+KapueP+KgbfTy2KY3WH2xCaTlhtB+/tO0wVCeVpSc/qSGSvBWvxUjCweggvY7ji
         /k8aICPvv1vCCK+RPhXdOYEUL+AJgsfmt24PevKvnlBesqkbZa2EW70KssiFob+zaG
         g94QnQ8ZVPpBcdCja/PIoo9BYffTzOoKY42YApIiEuIaDzbtpLWcD+HDd8K5Z1TPxM
         ZMMnPFGl90WyXgXeqQkL/zKCm+1YJh0188eF+GnXj+XUPyh3pLX301aGKx98eVYb8L
         x/ZqUy0gRLNYK1xgL6evLucdgt/etNWrVRsXmMGF2dxB+LAM2TWYnD6kn8cfTUHsfS
         4gv1MB+xux/Yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C3CA60A24;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cteontx2-pf: cn10k: Prevent harmless double shift
 bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161360160743.1867.14294526201297817960.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 22:40:07 +0000
References: <YCy0tPmgaHL1U2Le@mwanda>
In-Reply-To: <YCy0tPmgaHL1U2Le@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 09:16:20 +0300 you wrote:
> These defines are used with set_bit() and test_bit() which take a bit
> number.  In other words, the code is doing:
> 
> 	if (BIT(BIT(1)) & pf->hw.cap_flag) {
> 
> This was done consistently so it did not cause a problem at runtime but
> it's still worth fixing.
> 
> [...]

Here is the summary with links:
  - [net-next] cteontx2-pf: cn10k: Prevent harmless double shift bugs
    https://git.kernel.org/netdev/net-next/c/c77662605d8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


