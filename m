Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1434244621B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhKEKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhKEKWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 06:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 638AE6124F;
        Fri,  5 Nov 2021 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636107608;
        bh=v6/gMhly+W0Ou4xdbyamFWXa0/OMNV3Q9dIvqzgmRtg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eHeQIArVM0JBioR+xCStOfzB7b3pQ63CxfrS3xDQpq0lwXKW/Du67oDDgOzKW8Yql
         1RFcfc7p+5z+nIhWrSHPVVbotGoOa3X/jKSVYcCKSbed731u+TOak/UoaiT7KuJ4jy
         6RkNSJRFumK/J7vYFIOcD2Pjioy5QJmCqkp+BNTiVJe998MYzLdzDK+fV/JNbAA/Kw
         3/BKXtQhtW7F2Ldt6zxjQlMGchBhr/DMGNEIslQIGkEKtc8ehUK/lBQXH7XFFD4o3E
         Zz8sM3Zd7bGAef9GjTJb5HEr1XpjIUN0Qu7RcKx9JLqSYc93DS5vqOvk8JtoG6CLeE
         zzOQBwSJrzvdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52E2A609B8;
        Fri,  5 Nov 2021 10:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: select CONFIG_NET_DEVLINK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163610760833.10303.2855852393623176603.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 10:20:08 +0000
References: <20211104133449.1118457-1-arnd@kernel.org>
In-Reply-To: <20211104133449.1118457-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com, arnd@arndb.de, george.cherian@marvell.com,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 Nov 2021 14:34:42 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The octeontx2 pf nic driver failsz to link when the devlink support
> is not reachable:
> 
> aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_get':
> otx2_devlink.c:(.text+0x10): undefined reference to `devlink_priv'
> aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_validate':
> otx2_devlink.c:(.text+0x50): undefined reference to `devlink_priv'
> aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_dl_mcam_count_set':
> otx2_devlink.c:(.text+0xd0): undefined reference to `devlink_priv'
> aarch64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o: in function `otx2_devlink_info_get':
> otx2_devlink.c:(.text+0x150): undefined reference to `devlink_priv'
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: select CONFIG_NET_DEVLINK
    https://git.kernel.org/netdev/net/c/9cbc3367968d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


