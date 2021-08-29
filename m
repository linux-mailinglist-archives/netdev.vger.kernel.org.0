Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A23FAA85
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhH2JvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234984AbhH2Ju6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 05:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0449F60F45;
        Sun, 29 Aug 2021 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630230607;
        bh=ODkDrwb1ycfq4Uhnm1jokyYbjL0JHwQ9WuXLfsuwiRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nXmXNAqjn95mOeDKGMnimsLToRUVIapHoCTDnUgDXNiyO+oTb2GfM3UmsKG3NVJ/p
         3OTqKW9oFxN9XtQPErWB2urmxSaCNZvFcxdKFu1fpJtFNG/8p0mDxNIqqK3mtTe4Ae
         tJY7msr47esgcDn8T36YWhfksrAUwll4UqUYSCh7JE6K4qxM7zKYxaLRBJcu61SaE6
         ystwbBkE6Qi8iyHCJu2xt3fd6maK3hvz8SrTLDes3muIF3b2Xq/ZQ/WlBleJC+ULCw
         s9fwDSDSfml910R62Qlzfl9fUeFwiQzJgAh2GFjAaTGpkKGWB6+3Qn0qE68gMKl2rd
         1dLSZQnSm5gYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2ECD60A14;
        Sun, 29 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Fix inconsistent license text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023060699.19070.8717517572158736874.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 09:50:06 +0000
References: <1630064804-1368-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1630064804-1368-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 17:16:44 +0530 you wrote:
> Fixed inconsistent license text across the RVU admin
> function driver.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/Makefile      | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c         | 5 +----
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h         | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h   | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/common.h      | 8 ++------
>  drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.c        | 9 +++------
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h        | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/npc.h         | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/ptp.c         | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/ptp.h         | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.c         | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.h         | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h         | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c   | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c     | 6 +++++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.c     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c     | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h  | 7 ++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c  | 3 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c   | 5 +++--
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h   | 5 +++--
>  33 files changed, 63 insertions(+), 108 deletions(-)

Here is the summary with links:
  - octeontx2-af: Fix inconsistent license text
    https://git.kernel.org/netdev/net-next/c/c7cd6c5a460c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


