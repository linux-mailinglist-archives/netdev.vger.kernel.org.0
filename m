Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B57419441
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbhI0Mbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234317AbhI0Mbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E82D6113A;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745808;
        bh=sdejic/sjKL8DRmb1CPxbh8x/GjimBy+mhFca2uc4yQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZJssV22oEhMr3uuQvILmbUMqPE7WyzILoFKEtL/y1dN/8CXisd7Hv4ZANXN21jgy
         jaGHD+mxg2dApBPujkmj5/1UUiesS+K1VAluKK/ENG0iBSwv+/J9LirB18EIgfa9ze
         drtn33/uLntf/N+7lQCHXMYvf1oBTJtp4EsyPhGaxEfldXxIPuCabpyjSuBliSw6uz
         8PRyb7CvSynHOcCmglelSPamhAV3qt/upw8JS2CswxCaJlUUg/UObBBGPcRot10a0e
         VHAfi9HQxas1WyCrT2cDOXLrqsMRaIfVpbkK/7NBFfzjxJ7qeicc3Kkvm3EqHdEfUm
         E9z2Q6HTN6WkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 381DB60A69;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: fix resource_size.cocci warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274580822.1790.3621305152396378475.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:30:08 +0000
References: <1632642132-79551-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1632642132-79551-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 26 Sep 2021 15:42:12 +0800 you wrote:
> Use resource_size function on resource object
> instead of explicit computation.
> 
> Clean up coccicheck warning:
> ./drivers/net/ethernet/microchip/sparx5/sparx5_main.c:237:19-22: ERROR:
> Missing resource_size with iores [ idx ]
> 
> [...]

Here is the summary with links:
  - net: sparx5: fix resource_size.cocci warnings
    https://git.kernel.org/netdev/net-next/c/867d1ac99f11

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


