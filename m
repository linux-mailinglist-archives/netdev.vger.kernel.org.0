Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2243F6268
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhHXQKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhHXQKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 12:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E948E61360;
        Tue, 24 Aug 2021 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629821407;
        bh=E1Ksxp+X+PPCUkhgVn4HQEignA8RTOMvWxmhWHUHBGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kkwnFzErtfFSq2FgGApZ4UjhomtJ6J9965oORL0YudALwXSc8oJcXNbU7S2Y+xnZZ
         5RL1cpZohxTUuTBjE9IVrwxacFUtkRahAY1JFp+ETsY/Q1rF9H7WZGIUWOqRLzC5w0
         HppKl0om6X0Q3zqDvkqrgFJHP+NBhbPaEzKeI4S0ohBwZ4bgY8W4h61EBxE3cGih+P
         rjM02H0XZDNlxnERJkWioQVgJAqVNTzfo4IgRp1W3yyXBN676fn29zb/KDDXNkjNLV
         hBz3p+sCWJH3g1G1FxPvQQdisi13GRs9w9EvL94RadhiFMZ2ivw6QN4EOsARdYvxt6
         xwEqKqQawzm8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB59A6097B;
        Tue, 24 Aug 2021 16:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevice: move xdp_rxq within netdev_rx_queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162982140689.5804.3511834694954723686.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 16:10:06 +0000
References: <20210823180135.1153608-1-kuba@kernel.org>
In-Reply-To: <20210823180135.1153608-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        hawk@kernel.org, magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Aug 2021 11:01:35 -0700 you wrote:
> Both struct netdev_rx_queue and struct xdp_rxq_info are cacheline
> aligned. This causes extra padding before and after the xdp_rxq
> member. Move the member upfront, so that it's naturally aligned.
> 
> Before:
> 	/* size: 256, cachelines: 4, members: 6 */
> 	/* sum members: 160, holes: 1, sum holes: 40 */
> 	/* padding: 56 */
> 	/* paddings: 1, sum paddings: 36 */
> 	/* forced alignments: 1, forced holes: 1, sum forced holes: 40 */
> 
> [...]

Here is the summary with links:
  - [net-next] netdevice: move xdp_rxq within netdev_rx_queue
    https://git.kernel.org/netdev/net-next/c/95d1d2490c27

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


