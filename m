Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF73D05FB
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGTXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232678AbhGTXT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 19:19:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61BF561019;
        Wed, 21 Jul 2021 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626825604;
        bh=FcrnIFEXF/rbitskuoMbeow7tDokY+I/IO1rltasVQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HNXZTKFqnaIvP0b9+d0rJl+niaY1gHSLXs70sEmhFbBXgZ0MRCnNu5Rw2KLyJDc/t
         atYzra8nyAcYWAUWh0oBRWXxp2UfyeHcqzlIpmHj39goRYdh8WOg8C8VlhONBOXS9Z
         TaTBHz0VayqlZg6DQzd8Mc+oG3RNa5Z8QLbn/IxoCmC1VNAkQb5vflj2HnHWxyeS9U
         EOXtyZcLZEwe2h3xsE2gr8461b97gzlu+f0Nwn/JfA8E2f3UhvgasXHUGGPCSoG94d
         x8+DthLLzkE6aLIwU22dehpKG1Rr3OArTMS/KmMtmezp4O4zp6ZcVutzyeb4fzHbdS
         2aJFRfXHDIivg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53B1660C2A;
        Wed, 21 Jul 2021 00:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbe: Fix packet corruption due to missing DMA sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162682560433.6038.5001734504344039121.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 00:00:04 +0000
References: <20210720232619.3088791-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210720232619.3088791-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, markubo@amazon.com,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        tonyx.brelinski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 16:26:19 -0700 you wrote:
> From: Markus Boehme <markubo@amazon.com>
> 
> When receiving a packet with multiple fragments, hardware may still
> touch the first fragment until the entire packet has been received. The
> driver therefore keeps the first fragment mapped for DMA until end of
> packet has been asserted, and delays its dma_sync call until then.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbe: Fix packet corruption due to missing DMA sync
    https://git.kernel.org/netdev/net/c/09cfae9f13d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


