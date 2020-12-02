Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCB2CB1F7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgLBBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgLBBBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:01:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net: freescale: ucc_geth: remove unused
 SKB_ALLOC_TIMEOUT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160687082349.9495.15068025024815430511.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Dec 2020 01:00:23 +0000
References: <20201130001010.28998-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20201130001010.28998-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     leoyang.li@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Nov 2020 13:10:10 +1300 you wrote:
> This was added in commit ce973b141dfa ("[PATCH] Freescale QE UCC gigabit
> ethernet driver") but doesn't appear to have been used. Remove it now.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
>  drivers/net/ethernet/freescale/ucc_geth.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: freescale: ucc_geth: remove unused SKB_ALLOC_TIMEOUT
    https://git.kernel.org/netdev/net-next/c/2bf7d3776b74

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


