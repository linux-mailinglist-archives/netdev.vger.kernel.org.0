Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D5F3F7421
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbhHYLK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239394AbhHYLKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 07:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AED6061151;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629889806;
        bh=IWeeqQC8mhRXg64iXoBVVayItC70+L5D7ijymfANNIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lpQzFzIzSQiBzWSW4R7tvpqxdht8da2nrPO4uNjsLdUYf7nhku3/HVCpRMeBERODr
         q8rAYZWW/MYg1W79TmMC6DScHq/Dcj72xaznADzfKIW6dP6lZ/AkdUkX++OV8FG48h
         o7TmNqZ5xG7Nb3VPxQpflKG27skcqW8EvFKrRcFv98hOu3pMKEU6POdE434xXSEM0N
         DqRRv0SdpNZ7Ni/OEwo+Fub0tT4pRl/c32sq2125ysENJ6LbQBrpcCCwh4+wIQTqVA
         97iy4ybw76h8HKXcr5WNIwiMiZJu7bvivgUedbvgIpD8tCSm9Eg7zD18DmS81ARZNs
         3MGMlwk8moA+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A24BC60A14;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: actions: Add helper dependency on COMPILE_TEST
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988980666.32654.13729647254299495727.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 11:10:06 +0000
References: <20210825062513.2384-1-caihuoqing@baidu.com>
In-Reply-To: <20210825062513.2384-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     afaerber@suse.de, mani@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 14:25:13 +0800 you wrote:
> it's helpful for complie test in other platform(e.g.X86)
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/actions/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: ethernet: actions: Add helper dependency on COMPILE_TEST
    https://git.kernel.org/netdev/net-next/c/fbcf8a340150

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


