Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F65454928
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhKQOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhKQOxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:53:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 07D4361BAA;
        Wed, 17 Nov 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637160610;
        bh=4LRUd1jOUtDBuuZzyOEfdajmOfsCpWPB28K4HNI2MTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b+s7ZJ7D9/f9tUxTPKYZcieDB/jM2FUoynhsGIN3jrRk4KS7IuhSgCe59T3bMZQg9
         wB2TQ++c7yUhoFTUNuPIbTv9Xis/S0hSfbKbMnA8OAyAS0sA7SWSmEBd7aTa/ovQzB
         I/akuYnVF5u5GXeY8kZBn47eri4B53WcVcMRCLFpgNeDmD1AKH0H251TT/ImmuaQSd
         vtTJyuKcg3rQWkjTL2Wi9Y5OLKS/Q2iiOfK5X6XZ902wdr1pImz32TT3cXMazb3zo1
         Xi1x5R7g3NART4rsP932JTUhRiC3S7d8aeeBVEee78rPyT6gZ/uw3jqnptuxBf61ZH
         oVANiy98mEpvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02CB36095D;
        Wed, 17 Nov 2021 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716061000.12308.11700471249404021576.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 14:50:10 +0000
References: <20211116151712.14338-1-paskripkin@gmail.com>
In-Reply-To: <20211116151712.14338-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 18:17:12 +0300 you wrote:
> Access to netdev after free_netdev() will cause use-after-free bug.
> Move debug log before free_netdev() call to avoid it.
> 
> Fixes: 7472dd9f6499 ("staging: fsl-dpaa2/eth: Move print message")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v2] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
    https://git.kernel.org/netdev/net/c/9b5a333272a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


