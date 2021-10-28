Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0D143E29B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhJ1Nwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhJ1Nwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACC7D61056;
        Thu, 28 Oct 2021 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429007;
        bh=Dlz4pDuUTy44puZze/yj/nmVpeSe7M33uScB2vm6smM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jB57/Z22ICseiNiep1wqHMXJujDIF8tp8BCmlJ1gu2C/VOUQzgsddS2n7bKMaUocj
         DBSdQ/P0yNJFWhynD/NmrKb/OKmkiw0Ts2rPhF8GBrLzVzitPDNSZCfJG54dw2S4Xi
         mEbkGZNBFIqmfUxWvRhA0n0v1nLrz+aJ3UG4mA/0zfFMgye++ElSHnjupZfa4DosPT
         1qUXRiRFwnkHgOx5jkg+nva6yqfjM+bliWjGIN/0lu7dsGUvkIpLpSAMRQ7yoR4dLd
         AH8YL59zonxXV9XaN75FdMh8Ai+VxebBnz6YMfTcTBpWnKDKXEGV0VCPathaL8T1Qn
         Fk5DN/GBcWHSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A060360972;
        Thu, 28 Oct 2021 13:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Fix skb allocation
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542900765.8409.15157964657656116698.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:50:07 +0000
References: <20211027182302.12010-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211027182302.12010-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 14:23:02 -0400 you wrote:
> The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
> GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] net: ethernet: microchip: lan743x: Fix skb allocation failure
    https://git.kernel.org/netdev/net/c/e8684db191e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


