Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2062B8539
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgKRUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgKRUAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:00:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605729607;
        bh=SOMW2RphGYD1r7heCHGjaz9o642YeDexk1IDN7Equ+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+s0m6VxXyKDg1dNS94CiTdYFC952bRdcNG22JaAGayi/gjedc1EFwG2nQ+m9gLUQ
         g0DRF+hvS/opITAEasxEaC1dOGFhLhzUp/3xmBO9N6OhfOvY29Y+/xUmVenQ3btw4u
         qp1MZvklp3Xoysrw1JgwWocsiPXYxvw0UqOnVLTI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: Remove the deleted "framerelay"
 document from the index
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160572960739.10823.2502761476406181265.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 20:00:07 +0000
References: <20201118124226.15588-1-xie.he.0141@gmail.com>
In-Reply-To: <20201118124226.15588-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 04:42:26 -0800 you wrote:
> commit f73659192b0b ("net: wan: Delete the DLCI / SDLA drivers")
> deleted "Documentation/networking/framerelay.rst". However, it is still
> referenced in "Documentation/networking/index.rst". We need to remove the
> reference, too.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: Remove the deleted "framerelay" document from the index
    https://git.kernel.org/netdev/net-next/c/2b8473d2fb22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


