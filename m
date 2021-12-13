Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35220472FEF
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhLMPAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbhLMPAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10DF4B81138;
        Mon, 13 Dec 2021 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C48A5C34603;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407610;
        bh=eaxkQGC9ZBux4iZAcgboLwXqjRhTIRmt8X+ONlu9f70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tOLwnaoqduC5Lyn6afMoiGrm7E9aGXbJx1QnpSuOgjTPPQ4rRo8/Gfg1rBhxaXvRC
         406VEUa+TaFYbtM97B0IQcCDYGcay6vZsIu1qKWHf4tLtNkcbbhzqG19BT5l20Celb
         6NABDWyW0RSj4jW7+oIreVUgOSKqtCSyPnRd/8Mg+OyujsB1YnZvii9BA09rYT1QaM
         PA/LHqDCw9ea6Wj9Dd6De2Hi7n3po/CxQtXieMSCmnGIhEg81MMPGM9AbCvTFZq9T3
         9iB/qlOQi+G3rRxuhkoLxD+Kmaczqjx5H8xzpMnL6V4DuMp5bEh5KHtvKfQEuMLFwT
         a2xrAnGUuskgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0246609F5;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ocelot: use dma_unmap_addr to get tx buffer
 dma_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940761071.26947.514912105891386246.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:10 +0000
References: <20211213082651.443577-1-clement.leger@bootlin.com>
In-Reply-To: <20211213082651.443577-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        dkirjanov@suse.de, jwi@linux.ibm.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 09:26:51 +0100 you wrote:
> dma_addr was declared using DEFINE_DMA_UNMAP_ADDR() which requires to
> use dma_unmap_addr() to access it.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ocelot: use dma_unmap_addr to get tx buffer dma_addr
    https://git.kernel.org/netdev/net-next/c/3cfcda2aee94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


