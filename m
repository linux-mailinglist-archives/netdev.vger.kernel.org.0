Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2DE404854
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhIIKVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIIKVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8644E61179;
        Thu,  9 Sep 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631182806;
        bh=yOqjpLq81aL1iJ7wL+fljsZHNFHSnXlJXDmrJay09uE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FUPp1Sv+zQQOUaNIKzZnry+9jf9ManmdN4oPnzWE4Vog4uRcqfl0Cpvx/U/XwQhJP
         IbeWfA3AFfTYGb84urwKahQ9ELsFKhO7OONUwVzP6auepxp/ywKAP9w/ajl3xlc125
         4eFPPJvWTAeWlmGVFWxZHszXPlm847C9jX/Waw2nfWBgU26HX93eiFVHRbtSzX6vHT
         J4TKhzVPPhnXiQsc5AIt1i3A7xVPBfIiIRgDm4OV085tC8mhuIvSnUldxSqMvlxmpe
         ViEIan5Qoyvi9pJkgYmz6s3AoTvs1attG4poMpD2rqoKoChMpc0NtJhIUU1OI5zE1v
         x/iyT5objnWjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 799B8608FC;
        Thu,  9 Sep 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: platform: fix build warning when with
 !CONFIG_PM_SLEEP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118280649.11319.16154808916739272991.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:20:06 +0000
References: <20210909092322.19825-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210909092322.19825-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  9 Sep 2021 17:23:22 +0800 you wrote:
> Use __maybe_unused for noirq_suspend()/noirq_resume() hooks to avoid
> build warning with !CONFIG_PM_SLEEP:
> 
> >> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:796:12: error: 'stmmac_pltfr_noirq_resume' defined but not used [-Werror=unused-function]
>      796 | static int stmmac_pltfr_noirq_resume(struct device *dev)
>          |            ^~~~~~~~~~~~~~~~~~~~~~~~~
> >> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:775:12: error: 'stmmac_pltfr_noirq_suspend' defined but not used [-Werror=unused-function]
>      775 | static int stmmac_pltfr_noirq_suspend(struct device *dev)
>          |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
>    cc1: all warnings being treated as errors
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP
    https://git.kernel.org/netdev/net/c/2a48d96fd58a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


