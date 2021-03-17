Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFCB33F977
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhCQTkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233212AbhCQTkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC30964EEC;
        Wed, 17 Mar 2021 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616010009;
        bh=FB5k+ZZzXnK7C+mKiH1XxPaFB7pI01W1MZFQYFd9rvk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TryhNf/4dPuCEwPrN0PcQG+CDAPf0SLQU/CJolGNcQj5emW7d4SujidQ4YgUKIbdO
         VBkIbwJs7mdl4V/VYPZnZNZl++4kdbWQRqk+ziQFgE6dcFeVL7BTFTyq/MCGwAKwCo
         1bvTX1rATFUCUDtmAMtolItInzM9xBXrrwN7IqtuHhq4rnPeLeExPTxblvm0F0sURy
         jAI1VasWSzwv1TMKkvsLXULj47eRJc/MCUa+w+bus/D5NDOAOfA6Ol5BiogsO4KWaX
         wf+i06pDNLnb0q1X76bYqUQPK4qsm21mXoAiQfkQJsduxSpEMcDp/5eCxlhM0lbspj
         yPgj2Ulde+Pjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BF7260A45;
        Wed, 17 Mar 2021 19:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] refactor code related to npc install flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601000963.22747.8413162936998174718.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:40:09 +0000
References: <20210317133538.15609-1-naveenm@marvell.com>
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        jerinj@marvell.com, lcherian@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 19:05:33 +0530 you wrote:
> This patchset refactors and cleans up the code associated with the
> npc install flow API, specifically to eliminate different code paths
> while installing MCAM rules by AF and PF. This makes the code easier
> to understand and maintain. Also added support for multi channel NIX
> promisc entry.
> 
> Nalla, Pradeep (1):
>   octeontx2-af: Add support for multi channel in NIX promisc entry
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] octeontx2-af: refactor function npc_install_flow for default entry
    https://git.kernel.org/netdev/net-next/c/63f925dc55b3
  - [net-next,2/5] octeontx2-af: Add support for multi channel in NIX promisc entry
    https://git.kernel.org/netdev/net-next/c/d450a23515e0
  - [net-next,3/5] octeontx2-af: Use npc_install_flow API for promisc and broadcast entries
    https://git.kernel.org/netdev/net-next/c/56bcef528bd8
  - [net-next,4/5] octeontx2-af: Avoid duplicate unicast rule in mcam_rules list
    https://git.kernel.org/netdev/net-next/c/b6b0e3667e1b
  - [net-next,5/5] octeontx2-af: Modify the return code for unsupported flow keys
    https://git.kernel.org/netdev/net-next/c/058fa3d915ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


