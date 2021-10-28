Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28C43E298
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhJ1Nwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhJ1Nwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7A71561130;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429008;
        bh=A/T0XPAxpa/yPKnU1bRrLLGpo3m6FZ01NNxd4B+o5ME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KNEnz6nqaA7GxuafReYMV2DXyHza0NckmBwB0C7sZ/jR5NDUi5wFn2ZvBhocvn4TM
         xUT/UoI084wXjqpyhZ9PG2dx/QXG8D0PMPNKuxrYIHnvNKUUbV+qhFLcNOkMIzeBkV
         tphqtiQR/EBUb19MFOXRS0hTl39Ar3mp6E4a8DOtgHJUj/oYrLd+WyQISD/oZCJ4MC
         K67MtynDC8oBCjID37pmrg5nQKnrxhXiRA442Cb872bqPLmedFFwQ1tEVkk62w3+Hy
         EwG3MSTfCui+K5Cv2PyeY0ldOWLbIweh5gOlEX4dRKs6oEAMS4e0cp2ZmwzsbI32Xl
         PYUXv+4J5+ADA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74352609CC;
        Thu, 28 Oct 2021 13:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542900847.8409.9618567027144668985.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:50:08 +0000
References: <20211027182051.11922-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211027182051.11922-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nisar.sayed@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 14:20:51 -0400 you wrote:
> Add a basic cable test (diagnostic) support for lan87xx phy.
> Tested with LAN8770 for connected/open/short wires using ethtool.
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
> v1 -> v2
> 	Removed unused register defines
> 	Removed unnecessary register value check
> 	Added LAN87xx_CABLE_TEST defines
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: microchip_t1: add cable test support for lan87xx phy
    https://git.kernel.org/netdev/net-next/c/788050256c41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


