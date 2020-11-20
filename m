Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F9D2BBA2A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgKTXaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgKTXaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:30:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605915006;
        bh=OABLMbJpPxPRLSco09Ft8RHs1qpUo4Ahq/H95Um0Nsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bf5VJaqDgg0i2elCl0GcBYzKkYJTCG2kZwUYaXGwqJWIMjAiX0nHOM+1xbUi0RVtf
         pza7f/sPordIOfokx/GNW3/dYw76qAAAe6AXNWxpHxcXH88CmMfxY2KVT/K2ae5zXM
         /2w9AE5JTTnoGHbYdijyggacmz208D7kSV+flU5o=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: select XGMAC_MDIO for MDIO bus support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160591500599.24153.7416589870515839970.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 23:30:05 +0000
References: <20201119145106.712761-1-ciorneiioana@gmail.com>
In-Reply-To: <20201119145106.712761-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 19 Nov 2020 16:51:06 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Explicitly enable the FSL_XGMAC_MDIO Kconfig option in order to have
> MDIO access to internal and external PHYs.
> 
> Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: select XGMAC_MDIO for MDIO bus support
    https://git.kernel.org/netdev/net/c/d2624e70a2f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


