Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D54315765
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhBIUCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233763AbhBITv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5ECD064EC7;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612898407;
        bh=T96XR7IOolNsDH8DxeOV0AozUVdwGLMu7Lr3mlEr4rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gptYhXGsXizrJQP+xilvHSRl7lUGDIRfGt5R8p448Jm08SzahFMMiGhnYBvRWl6lX
         Xz9VrfpDhpPCuSnOUya+PYNGbILGsuAdVvIZIhgDID2CEDkwfkZrfKBoDBo1hrB808
         hkTTitSPUyzBMlNAV4ZfrHeFTPMQMQjpyewM1kmNg0D13CDHMKcq2ma8ARd4pL1Hra
         rMqw7BIo/LtRQbv9p10sceGIHrMMcYWmPz8ugNQxruFjBBd6o52Ym91OAxQzbiEX12
         06qvfAKXhSxosgdQyLGEb36xoklVyvQx3b7GNkQpirfU9SiK5BP4kpf4V7QeI4abxn
         rCOI+X9j/Y3TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C66260974;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: broadcom: remove BCM5482 1000Base-BX
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161289840730.9558.2644502369758440268.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 19:20:07 +0000
References: <20210208231706.31789-1-michael@walle.cc>
In-Reply-To: <20210208231706.31789-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 00:17:06 +0100 you wrote:
> It is nowhere used in the kernel. It also seems to be lacking the
> proper fiber advertise flags. Remove it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> changes since v1:
>  - added queue to subject
>  - reworded 1000BX to 1000Base-BX
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: broadcom: remove BCM5482 1000Base-BX support
    https://git.kernel.org/netdev/net-next/c/1e2e61af1996

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


