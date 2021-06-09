Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB83A2013
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFIWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A90661405;
        Wed,  9 Jun 2021 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277806;
        bh=zIL9opB5+Cnb+9ZiAUJj51E8H3ewM4qqlao7rIihN7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7ACIOAalaEJWQCOvHdnf2CVwrZ4U1Gz9b4v2y0/mG4TyjNU3KTxXYxTdF9W1M02X
         isAEJaRMPCuRG00M8JA7EF6MNYvKZx91Y5YxWtxK5m/T0a1RlECC/zXYhdEPJ9QBgB
         neg4DugQ+YuO1kYZc4wrIpXRxK8pNKiitUHi3UF39eGAhYIMxkTQ207LjghtLjWv1X
         wMl9S+o3kfCmJpF1OUx58njGkDYucSxXnwGYDQb4NFyUCs7JLF45QdOHlSh08mGXQs
         zPX9lQin2NfVPtu6HDIP8xb2BIP/YA0Umpqk1bnVRyGALK+CRJoDgzwZqH0X0P4FJ/
         6bT3zgNHKyGog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F390A60CD8;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2][next][V2] net: usb: asix: Fix less than zero comparison
 of a u16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780599.20375.14960133934732052088.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609102448.182798-1-colin.king@canonical.com>
In-Reply-To: <20210609102448.182798-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 11:24:47 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u16 priv->phy_addr < 0 is always false because
> phy_addr is unsigned. Fix this by assigning the return from the call
> to function asix_read_phy_addr to int ret and using this for the
> less than zero error check comparison.
> 
> [...]

Here is the summary with links:
  - [1/2,next,V2] net: usb: asix: Fix less than zero comparison of a u16
    https://git.kernel.org/netdev/net-next/c/e67665946599
  - [2/2,next,V2] net: usb: asix: ax88772: Fix less than zero comparison of a u16
    https://git.kernel.org/netdev/net-next/c/c6be5a22fde5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


