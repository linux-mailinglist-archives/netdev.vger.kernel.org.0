Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16AE2EC74A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbhAGAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbhAGAUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0AEC222D75;
        Thu,  7 Jan 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609978808;
        bh=rEzIii5u44+A02/wCSbFAxSHnj8It6iZx/2Ip8dSeV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pHq0HIgJX+rK3YWn2+ksaZBOPLYwqVhUjOWE3leJJu9wB9um2j3fYz4N2SPKl6kAO
         q7YHSE/sQYk8me1dejKiJIYEaY5g3bPuPryHaYNKE/0VrzbJIl1qpgsoIPf/4mdIcS
         jKBsqSUgw9izt1CBnXyH3EREUrc28nsEd3JgLOU6VSvtwfHHksNrSvqvFdpOwBm/aY
         ejoSMq+/F7PC00XqwUnKLAxiEl9vkXko1BInhOidyHvsx9CnOGcFLzeZb7r5OJzioo
         y6M/Gf3kkg5cr4mkWaOgl5RBZwRffaU1Npd2b/1frTqGmS04OcmBTkF5dbS5xgOBnN
         qTZHoGtR0IEGw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EFE78600DA;
        Thu,  7 Jan 2021 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: ptp_ines: prevent build when HAS_IOMEM is not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160997880797.16542.16792817975972555671.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 00:20:07 +0000
References: <20210106042531.1351-1-rdunlap@infradead.org>
In-Reply-To: <20210106042531.1351-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, lkp@intel.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Jan 2021 20:25:31 -0800 you wrote:
> ptp_ines.c uses devm_platform_ioremap_resource(), which is only
> built/available when CONFIG_HAS_IOMEM is enabled.
> CONFIG_HAS_IOMEM is not enabled for arch/s390/, so builds on S390
> have a build error:
> 
> s390-linux-ld: drivers/ptp/ptp_ines.o: in function `ines_ptp_ctrl_probe':
> ptp_ines.c:(.text+0x17e6): undefined reference to `devm_platform_ioremap_resource'
> 
> [...]

Here is the summary with links:
  - ptp: ptp_ines: prevent build when HAS_IOMEM is not set
    https://git.kernel.org/netdev/net/c/1f685e6adbbe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


