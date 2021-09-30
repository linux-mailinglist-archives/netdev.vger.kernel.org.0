Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD241D963
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350707AbhI3MLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348195AbhI3MLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84E2F619F5;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633003808;
        bh=RBJAWzE7uRKZwQDlqJnVN0YgUZz0t9tdvJT4b2aTAkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZyV/crVtQ4Z0uNMmEmYV0Y/0rMUW2W5sM2hMmF3iSLZqYeWSoC4vcLfMln7x2vTVw
         WUypdNqyM0lY12F79RZx8PdYs+X8Hdh9XUE+/hjcKblSfJeObzpi5ZkJ2yF4fOwPgu
         HjQtSd4tyLkPuNbqJfoUNgvL0+X+5CuHpQm7gJ6QT0dJyhheDTG7DpEkXVzcyV39QU
         FdzDR99WR4KLCCgex+GDED+6ZaNI2pkjBRVYvOwrupyjhZwJ8+y0NRQuKpJsR9hu7a
         Tb7I2+opnxDmnRVycSrckfCzj9TopJpxPn+GnEv3v9vY4OyuYE3Td3xSuBUn3SJaLP
         E/G7h6PG+HIRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 752EE60AA5;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 PATCH] octeontx2-pf: Add XDP support to netdev PF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300380847.14665.8148917603159979709.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:10:08 +0000
References: <20210929095456.16100-1-gakula@marvell.com>
In-Reply-To: <20210929095456.16100-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        sgoutham@marvell.com, hawk@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 15:24:56 +0530 you wrote:
> Adds XDP_PASS, XDP_TX, XDP_DROP and XDP_REDIRECT support
> for netdev PF.
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@cavium.com>
> ---
> v1-v2:
> -Fixed compilation warnings.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: Add XDP support to netdev PF
    https://git.kernel.org/netdev/net-next/c/06059a1a9a4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


