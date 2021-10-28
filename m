Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E018843E2EC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhJ1OCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhJ1OCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A678A610F8;
        Thu, 28 Oct 2021 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429608;
        bh=S+O2mCD0Hw4XAeYYCvGnuB3sxqSdebOBqfU8mHTG3uU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hfEaj1MlOnTiu5wjRJdZg1IQEHutgX/tIuSajIjKZbFe3JU8vMxfCYw5hKdEdzxaV
         7/4TRZkJQZzyD6yXC5n87jEpli643qcwi39lvVQYB1g75ebTU+ioKQVBptI3VSaxl/
         2yQ8w8c4c/BDYQOxzLBD0AlNu/imUGUIkF8ssh8EGvs02VLLCuZNST9gPUPH0qwREW
         8WzUZWeUw3wxfgbJ9wLNv3AMDxJn37DHeudr0LeRLuf0fad/KS23xqJI2h+OPXlpvN
         hisgU+yqnpmtfk8FZFGPvAYd6a6y33vs/Wnd6fPzow2X4CPEyr5UD94DBNAN/xIMYc
         qF9CgukRZmpNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9997B609CC;
        Thu, 28 Oct 2021 14:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v3 0/3] RVU Debugfs fix updates.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542960862.12929.13276854563783815449.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 14:00:08 +0000
References: <20211027173234.23559-1-rsaladi2@marvell.com>
In-Reply-To: <20211027173234.23559-1-rsaladi2@marvell.com>
To:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 23:02:31 +0530 you wrote:
> The following patch series consists of the patch fixes done over
> rvu_debugfs.c and rvu_nix.c files.
> 
> Patch 1: Check and return if ipolicers do not exists.
> Patch 2: Fix rsrc_alloc to print all enabled PF/VF entries with list of LFs
> allocated for each functional block.
> Patch 3: Fix possible null pointer dereference.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] octeontx2-af: Check whether ipolicers exists
    https://git.kernel.org/netdev/net/c/cc45b96e2de7
  - [net,v3,2/3] octeontx2-af: Display all enabled PF VF rsrc_alloc entries.
    https://git.kernel.org/netdev/net/c/e77bcdd1f639
  - [net,v3,3/3] octeontx2-af: Fix possible null pointer dereference.
    https://git.kernel.org/netdev/net/c/c2d4c543f74c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


