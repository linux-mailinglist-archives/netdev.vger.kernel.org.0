Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37F031984C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBLCUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhBLCUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 732F864E3D;
        Fri, 12 Feb 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613096408;
        bh=8R9Nc4AGIoHXuuXhow8eN9wEpeG82KWsudqAwPe0olM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCE6wKp8/M6Uys0Om7hGgnJ8FL5ChNZWkxnCtHdMIqxhJ9mzOgAiv/2+Xl+MHpKBn
         Smmpw+lYZwzt4rf5QNoV03UPrDue0FCt4PeYmXQri4Lnq95J3hzR+twLlmPNX0QiQ2
         MNNR0+dfuwt85aQEY9ISZG5yMEo2nS02Ty8I0PCvWgdmLXLk+VXWvnZRYNH1d2ZMNm
         FKGTwB5RNBwvGjGaE3B0nNKBZ0dIpxJTDnbvuaHfxk8kgUUrGNixkGhs4j+8BgmgUp
         jOh59Skl7D55+4mdRnA4th+okdidnCgFh6Vm/1qzl7gLwNmj5eBYkRfMnia3o+u8X8
         6ZgxIjT+HSWWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EB5D60A2B;
        Fri, 12 Feb 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: handle tx before rx in napi poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309640844.12988.4337283630692589622.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:20:08 +0000
References: <5ef5322d-cc83-747b-5995-2e60f2c39d93@gmail.com>
In-Reply-To: <5ef5322d-cc83-747b-5995-2e60f2c39d93@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 21:20:08 +0100 you wrote:
> Cleaning up tx descriptors first increases the chance that
> rtl_rx() can allocate new skb's from the cache.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] r8169: handle tx before rx in napi poll
    https://git.kernel.org/netdev/net-next/c/9fbb4a7ac463

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


