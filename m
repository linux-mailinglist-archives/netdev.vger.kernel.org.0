Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123254614F4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244883AbhK2MZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:25:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54394 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244694AbhK2MXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:23:30 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E189B8102C
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:20:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id E7A826056B;
        Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188410;
        bh=s1iFddB3hvtxZuoITifI+KEwgVYAHcP7aA2vVMr0nYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BimRd2F+99IcSROqO1BxvbA2ugXKqrsfNHC58hNTb9X/XiU2SxtTHFP+fHNIVr62b
         aweXOJLlFIhH5Ln+gCCHTW1bltTLYBGYXSbIp7gy738b7wxw/dobzowZh5D8l5L+8E
         Mizq0RKGpf8T8V44au1DG1xap2PuwDrRzci1Y83NUuENUeHTJdxc4fHmlsaTZXzJ25
         3zNtDDibL03Fs1UEy9TqHY2zdSDmR/jNni44bt61XTaGANdUUYbE5rhrYQTItf4Z9c
         nm7OlYx04rszL10GjqzjQCTZW2NqtXE5hb1qOlvWSFuQvZjGRMGB1NdAil62MmD92j
         qpuK17j7OddnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF43360A45;
        Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/l2tp: convert tunnel rwlock_t to rcu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818841091.20614.2648713424747155223.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:10 +0000
References: <20211126160903.14124-1-tparkin@katalix.com>
In-Reply-To: <20211126160903.14124-1-tparkin@katalix.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 16:09:03 +0000 you wrote:
> Previously commit e02d494d2c60 ("l2tp: Convert rwlock to RCU") converted
> most, but not all, rwlock instances in the l2tp subsystem to RCU.
> 
> The remaining rwlock protects the per-tunnel hashlist of sessions which
> is used for session lookups in the UDP-encap data path.
> 
> Convert the remaining rwlock to rcu to improve performance of UDP-encap
> tunnels.
> 
> [...]

Here is the summary with links:
  - [net-next] net/l2tp: convert tunnel rwlock_t to rcu
    https://git.kernel.org/netdev/net-next/c/07b8ca3792de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


